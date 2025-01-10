#!/bin/bash

# Define the list of strings
filenames=(
  P6559
  P6560
  P7151
  P7152
  P7153
  P7154
  P7155
  P7156
  P7157
  P7158
  P7161
  P7164
  P7165
  P7166
  P7167
  P7168
  P7169
  P7170
  P7171
  P7172
  P7173
  P7174
  P7175
  P7176
  P7177
  P7178
  P7179
  P7180
  P7181
  P7182
  P7184
  P7185
  P7186
  P7188
  P7190
  P7191
  P7193
  P7194
)

# Loop through each filename in the list
for name in "${filenames[@]}"; do
  # Copy the file and rename it
  cp example-empty-route.geojson "${name}.geojson"
  echo "Created file: ${name}.geojson"
done

echo "All files created successfully!"
