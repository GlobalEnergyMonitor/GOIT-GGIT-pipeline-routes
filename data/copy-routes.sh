#!/bin/bash

# Define the list of strings
filenames=(
P7395
P7396
P7397
P7398
P7399
P7400
P7401
P7402
P7403
P7404
P7405
P7406
P7407
P7408
P7409
P7410
P7411
P7412
P7413
P7414
P7415
P7416
P7417
P7418
P7419
P7420
P7421
)

# Loop through each filename in the list
for name in "${filenames[@]}"; do
  # Copy the file and rename it
  cp example-empty-route.geojson "${name}.geojson"
  echo "Created file: ${name}.geojson"
done

echo "All files created successfully!"
