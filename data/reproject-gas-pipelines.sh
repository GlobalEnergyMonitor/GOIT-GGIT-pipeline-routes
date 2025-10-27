#!/bin/bash
# Usage: ./reproject_to_4326.sh /path/to/input /path/to/output
# Requires: GDAL (ogrinfo/ogr2ogr). jq strongly recommended (but script falls back if missing).

set -euo pipefail

SRC_DIR="${1:-}"
DST_DIR="${2:-}"

if [[ -z "$SRC_DIR" || -z "$DST_DIR" ]]; then
  echo "Usage: $0 <source_directory> <destination_directory>"
  exit 1
fi

mkdir -p "$DST_DIR"

# --- File IDs to process ---
FILES=(
P7444
P0256
P0151
P1770
P7443
P5719
)

have_jq=0
command -v jq >/dev/null 2>&1 && have_jq=1

get_crs_code() {
  # Echo a CRS code or label:
  #   "4326", "84", or another EPSG number like "4283"
  #   If unknown, echo empty string.
  local f="$1"
  local epsg=""
  local info=""
  if command -v ogrinfo >/dev/null 2>&1; then
    if [[ $have_jq -eq 1 ]]; then
      # JSON (GDAL 3+) → look for id.code, else WKT EPSG:, else CRS84
      info="$(ogrinfo -ro -al -so -json "$f" 2>/dev/null || true)"
      if [[ -n "$info" ]]; then
        epsg="$(jq -r '
          # Prefer numeric id.code in SRS / coordinateSystem
          first(.layers[0].coordinateSystem.id.code?,
                .layers[0].srs.id.code?) // empty
        ' <<<"$info")"
        if [[ -z "$epsg" ]]; then
          # Try to extract from WKT
          wkt="$(jq -r 'first(.layers[0].coordinateSystem.wkt?,
                               .layers[0].srs.wkt?) // empty' <<<"$info")"
          if [[ -n "$wkt" ]]; then
            epsg="$(grep -oE "EPSG[: ]+[0-9]+" <<<"$wkt" | head -n1 | grep -oE '[0-9]+' || true)"
          fi
        fi
        if [[ -z "$epsg" ]]; then
          # Some files only expose CRS84 label
          if jq -e '(.layers[0].coordinateSystem.id.authority? // .layers[0].srs.id.authority? // "") | test("OGC|CRS"; "i")' <<<"$info" >/dev/null 2>&1 &&
             jq -r 'first(.layers[0].coordinateSystem.id.value?,
                           .layers[0].srs.id.value?) // empty' <<<"$info" | grep -qi 'CRS:?84'; then
            epsg="84"
          fi
        fi
      fi
    fi

    # Text fallback (no jq or JSON didn’t contain it)
    if [[ -z "$epsg" ]]; then
      info="$(ogrinfo -so -al "$f" 2>/dev/null || true)"
      epsg="$(grep -oE 'EPSG[: ]+[0-9]+' <<<"$info" | head -n1 | grep -oE '[0-9]+' || true)"
      if [[ -z "$epsg" ]] && grep -qi 'CRS:?84' <<<"$info"; then
        epsg="84"
      fi
    fi
  fi

  # Final fallback: legacy GeoJSON "crs" object
  if [[ -z "$epsg" && $have_jq -eq 1 ]]; then
    local name
    name="$(jq -r '.crs.properties.name // empty' "$f" 2>/dev/null || true)"
    if [[ -n "$name" ]]; then
      if grep -qi 'CRS:?84' <<<"$name"; then
        epsg="84"
      else
        epsg="$(grep -oE '[0-9]+' <<<"$name" | tail -n1 || true)"
      fi
    fi
  fi

  echo "$epsg"
}

is_wgs84_like() {
  # Accept EPSG:4326 and CRS/EPSG:84 as WGS 84 for GeoJSON
  local code="$1"
  [[ "$code" == "4326" || "$code" == "84" ]]
}

for ID in "${FILES[@]}"; do
  INFILE="$SRC_DIR/${ID}.geojson"
  OUTFILE="$DST_DIR/${ID}.geojson"

  if [[ ! -f "$INFILE" ]]; then
    echo "[SKIP] $ID: File not found at $INFILE"
    continue
  fi

  SRC_CRS="$(get_crs_code "$INFILE")"

  if [[ -z "$SRC_CRS" ]]; then
    echo "[INFO] $ID: CRS not found in metadata; treating as WGS 84 (per RFC 7946)."
    SRC_CRS="4326"
  fi

  if is_wgs84_like "$SRC_CRS"; then
    echo "[INFO] $ID: Source is WGS 84 (EPSG:${SRC_CRS}). Rewriting as GeoJSON 4326."
  else
    echo "[INFO] $ID: Reprojecting from EPSG:${SRC_CRS} → EPSG:4326"
  fi

  # Reproject (or normalize) to 4326
  if ogr2ogr -f "GeoJSON" -t_srs "EPSG:4326" "$OUTFILE" "$INFILE" >/dev/null 2>&1; then
    echo "[OK]   $ID: Saved to $OUTFILE"
  else
    echo "[ERR]  $ID: Failed to process."
  fi
done