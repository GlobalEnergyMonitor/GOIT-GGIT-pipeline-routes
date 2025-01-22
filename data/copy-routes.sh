#!/bin/bash

# Define the list of strings
filenames=(
P7269
P7271
P7273
P7274
P7275
)

# Loop through each filename in the list
for name in "${filenames[@]}"; do
  # Copy the file and rename it
  cp example-empty-route.geojson "${name}.geojson"
  echo "Created file: ${name}.geojson"
done

echo "All files created successfully!"
