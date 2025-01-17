#!/bin/bash

# Define the list of strings
filenames=(
P7201
P7202
P7203
P7214
P7215
P7216
P7217
P7218
P7221
P7222
P7223
P7224
P7225
P7226
P7227
P7228
P7229
P7230
P7231
P7232
P7233
P7234
P7235
P7236
P7237
P7238
P7239
P7240
P7241
P7242
P7243
P7244
P7245
P7246
P7247
P7248
P7249
P7250
P7251
P7252
P7253
P7254
P7255
P7256
P7257
P7258
P7259
P7260
P7261
P7262
P7264
P7265
)

# Loop through each filename in the list
for name in "${filenames[@]}"; do
  # Copy the file and rename it
  cp example-empty-route.geojson "${name}.geojson"
  echo "Created file: ${name}.geojson"
done

echo "All files created successfully!"
