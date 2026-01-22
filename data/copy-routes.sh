#!/usr/bin/env bash

# === USER CONFIGURATION ===
SAMPLE_FILE="./example-empty-route.geojson"   # path to your sample file
TARGET_DIR="./"     # folder where you want copies to go

# === LIST OF PROJECT IDs ===
PROJECT_IDS=(
 P7869
 P7870
 P7880
 P7881
 P7883
 P7884
 P7885
 P7886
 P7887
 P7888
)

# === CREATE TARGET DIR IF NOT EXISTS ===
mkdir -p "$TARGET_DIR"

# === LOOP AND COPY ===
for id in "${PROJECT_IDS[@]}"; do
    cp "$SAMPLE_FILE" "${TARGET_DIR}/${id}.geojson"
    echo "Created ${TARGET_DIR}/${id}.geojson"
done

echo "✅ All files created."