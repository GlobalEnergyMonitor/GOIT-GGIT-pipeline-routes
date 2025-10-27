#!/bin/bash
# Usage: ./check_crs_4326.sh /path/to/folder

DIR="$1"

if [ -z "$DIR" ]; then
  echo "Usage: $0 <directory_with_geojson_files>"
  exit 1
fi

if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a directory."
  exit 1
fi

echo "Checking CRS for GeoJSON files in: $DIR"
echo "----------------------------------------"

# Counter
count_bad=0

# Loop through all .geojson files
for file in "$DIR"/*.geojson; do
  [ -e "$file" ] || continue  # skip if no matches

  # Try to extract EPSG code
  crs=$(ogrinfo -so -al "$file" 2>/dev/null | grep -oE "EPSG:[0-9]+" | head -n1 | cut -d: -f2)

  if [ -z "$crs" ]; then
    # echo "[NO CRS]  $(basename "$file")"
    count_bad=$((count_bad+1))
  elif [ "$crs" != "4326" ]; then
    echo "[NOT 4326] $(basename "$file") → EPSG:$crs"
    count_bad=$((count_bad+1))
  fi
done

if [ $count_bad -eq 0 ]; then
  echo "✅ All GeoJSON files use EPSG:4326 (WGS 84)"
else
  echo "⚠️  $count_bad file(s) not in EPSG:4326"
fi