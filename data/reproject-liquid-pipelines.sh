#!/bin/bash
# Usage: ./reproject_to_4326.sh /path/to/input /path/to/output

# --- Check inputs ---
SRC_DIR="$1"
DST_DIR="$2"

if [ -z "$SRC_DIR" ] || [ -z "$DST_DIR" ]; then
  echo "Usage: $0 <source_directory> <destination_directory>"
  exit 1
fi

# Create output folder if it doesn't exist
mkdir -p "$DST_DIR"

# --- List of file IDs ---
FILES=(
P1213
P2675
P2684
P3883
P6459
P6524
P7205
P7206
P7207
P7259
P7348
P0151
P0256
P1285
P1770
P5719
P7443
P7444
)

# --- Loop over each ID ---
for ID in "${FILES[@]}"; do
  INFILE="$SRC_DIR/${ID}.geojson"
  OUTFILE="$DST_DIR/${ID}.geojson"

  if [ ! -f "$INFILE" ]; then
    echo "[SKIP] $ID: File not found at $INFILE"
    continue
  fi

  # Detect source CRS
  SRC_CRS=$(ogrinfo -so -al "$INFILE" 2>/dev/null | grep "Coordinate System is:" -A1 | tail -n1 | grep -o "EPSG:[0-9]*" | cut -d: -f2)

  if [ -z "$SRC_CRS" ]; then
    echo "[WARN] $ID: Could not detect CRS, assuming EPSG:4326"
    SRC_CRS=4326
  fi

  if [ "$SRC_CRS" -ne 4326 ] 2>/dev/null; then
    echo "[INFO] $ID: Reprojecting from EPSG:$SRC_CRS → EPSG:4326"
  else
    echo "[INFO] $ID: Already EPSG:4326"
  fi

  # Reproject (even if already 4326, for consistency)
  ogr2ogr -f "GeoJSON" -t_srs "EPSG:4326" "$OUTFILE" "$INFILE" >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "[OK]   $ID: Saved to $OUTFILE"
  else
    echo "[ERR]  $ID: Failed to process."
  fi
done