#!/bin/bash

FOLDER="/Users/baird/Google Drive/Shared drives/GEM Shared Drive/Programs/Oil & Gas Program/Global Oil and Gas Infrastructure Trackers (GOIT, GGIT)/GitHub routes repository/GOIT-GGIT-pipeline-routes/data/individual-routes/liquid-pipelines"

PROJECT_IDS=(
  P0629 P1092 P1209 P1210 P1211 P2722 P3380 P3681 P3874 P3875
  P3881 P5128 P5171 P5291 P5365 P6194 P6389 P6390 P6391 P6392
  P6393 P6394 P6395 P6396 P7373 P7406 P7421 P7868 P7886 P7896
  P7905 P7964
)

for id in "${PROJECT_IDS[@]}"; do
  filepath="$FOLDER/${id}.geojson"
  if [ -f "$filepath" ]; then
    rm "$filepath"
    echo "Deleted: $filepath"
  else
    echo "Not found: $filepath"
  fi
done
