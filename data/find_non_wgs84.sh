#!/bin/bash
# Usage: ./find_non_wgs84.sh /path/to/folder
# Accepts EPSG:4326, EPSG:84, and CRS:84 as WGS 84 (GeoJSON-friendly).
# Missing CRS is treated as 4326.

set -euo pipefail

DIR="${1:-}"
if [[ -z "$DIR" ]]; then
  echo "Usage: $0 <directory_with_geojson_files>"
  exit 1
fi
if [[ ! -d "$DIR" ]]; then
  echo "Error: '$DIR' is not a directory."
  exit 1
fi

have_ogrinfo=0
command -v ogrinfo >/dev/null 2>&1 && have_ogrinfo=1
have_jq=0
command -v jq >/dev/null 2>&1 && have_jq=1

echo "Scanning: $DIR"
echo "----------------------------------------"

bad_count=0
checked=0

is_ok_crs() {
  local code="${1:-}"
  local label="${2:-}"
  # Accept EPSG:4326, EPSG:84, CRS:84, and plain "4326"/"84"
  [[ "$code" == "4326" || "$code" == "84" ]] && return 0
  [[ "$label" =~ (^|[^0-9])4326([^0-9]|$) ]] && return 0
  [[ "$label" =~ (CRS:?84|EPSG:?84) ]] && return 0
  [[ "$label" =~ (WGS[ _-]?84) ]] && return 0
  return 1
}

while IFS= read -r -d '' file; do
  checked=$((checked+1))
  epsg=""
  label=""

  if [[ $have_ogrinfo -eq 1 ]]; then
    info="$(ogrinfo -so -al "$file" 2>/dev/null || true)"
    # Try to extract explicit EPSG number
    epsg="$(grep -oE 'EPSG:[0-9]+' <<<"$info" | head -n1 | cut -d: -f2 || true)"
    # Capture common CRS:84 label if present
    if [[ -z "$epsg" ]]; then
      if grep -qE 'CRS:?84' <<<"$info"; then
        epsg="84"
      fi
    fi
    # Keep a label string for fallback checks
    label="$(grep -E 'CRS|EPSG|WGS|Coordinate System|PROJ' <<<"$info" | head -n1 || true)"
  fi

  if [[ -z "$epsg" && $have_jq -eq 1 ]]; then
    # Parse deprecated/legacy GeoJSON 'crs' object if present
    name="$(jq -r '.crs.properties.name // empty' "$file" 2>/dev/null || true)"
    if [[ -n "$name" ]]; then
      # Pull a trailing code if any (covers urn:ogc:def:crs:EPSG::4326 and …:CRS84)
      if [[ "$name" =~ ([0-9]+)$ ]]; then
        epsg="${BASH_REMATCH[1]}"
      fi
      label="$name"
      # If no numeric code, but label contains CRS84, mark code as 84
      if [[ -z "$epsg" && "$name" =~ (CRS:?84) ]]; then
        epsg="84"
      fi
    fi
  fi

  # Treat missing CRS as 4326 per RFC 7946
  if [[ -z "$epsg" && -z "$label" ]]; then
    epsg="4326"
  fi

  if is_ok_crs "$epsg" "$label"; then
    : # OK — do nothing
  else
    # Show best-available tag for clarity
    tag="$epsg"
    [[ -z "$tag" && -n "$label" ]] && tag="$label"
    [[ -z "$tag" ]] && tag="(unknown)"
    echo "[NOT WGS84] $(basename "$file") → $tag"
    bad_count=$((bad_count+1))
  fi
done < <(find "$DIR" -maxdepth 1 -type f -iname "*.geojson" -print0)

if [[ $checked -eq 0 ]]; then
  echo "No .geojson files found."
  exit 0
fi

if [[ $bad_count -eq 0 ]]; then
  echo "✅ All $checked file(s) are WGS 84 (EPSG:4326/CRS:84) or have no CRS (treated as 4326)."
else
  echo "⚠️  $bad_count of $checked file(s) are not WGS 84."
fi