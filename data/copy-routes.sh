#!/usr/bin/env bash

# === USER CONFIGURATION ===
SAMPLE_FILE="./example-empty-route.geojson"   # path to your sample file
TARGET_DIR="./"     # folder where you want copies to go

# === LIST OF PROJECT IDs ===
PROJECT_IDS=(
P5363 
      P6132 
      P6146 
      P6182 
      P6295 
      P6312 
      P6361
      P7352 
      P7366
      P7386 
      P7387 
      P7388 
      P7389 
      P7390 
      P7391 
      P7392 
      P7393 
      P7398 
)

# === CREATE TARGET DIR IF NOT EXISTS ===
mkdir -p "$TARGET_DIR"

# === LOOP AND COPY ===
for id in "${PROJECT_IDS[@]}"; do
    cp "$SAMPLE_FILE" "${TARGET_DIR}/${id}.geojson"
    echo "Created ${TARGET_DIR}/${id}.geojson"
done

echo "✅ All files created."