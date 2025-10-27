#!/usr/bin/env bash
# delete_geojsons.sh
# Deletes .geojson files for a given list of IDs from a specified directory.
# After processing, reports files that were not found.

# === USER CONFIGURATION ===
TARGET_DIR="/Users/baird/Google Drive/Shared drives/GEM Shared Drive/Programs/Oil & Gas Program/Global Oil and Gas Infrastructure Trackers (GOIT, GGIT)/GitHub repositories/GOIT-GGIT-pipeline-routes/data/individual-routes/gas-pipelines/"  # <--- change this to the correct folder

# === LIST OF PROJECT IDs ===
PROJECT_IDS=(
    P2769 P2959 P2960 P3084 P0330 P2814 P2770 P2880 P1568 P1626
    P2764 P2768 P2771 P2787 P2788 P2792 P2798 P2799 P2800 P2813
    P2820 P2821 P2822 P2844 P2845 P2851 P2863 P2915 P2928 P2932
    P2947 P2952 P2967 P2982 P3025 P3026 P3027 P3051 P3052 P3060
    P4082 P4125 P4160 P4168 P4169 P4187 P4189 P4190 P4191 P4192
    P2929 P2930 P2931 P3080 P2875 P3629 P2786
    P2881 P4123 P4127 P2785 P2867 P2869 P2937 P2938 P2964 P3083
    P4113 P4114 P4115 P4116 P4117 P1204 P6882 P6883 P3281 P5492
    P0718 P7475 P0521 P2751 P6745 P7058 P7059 P5550 P5552 P6609
    P6143 P5698 P5713 P7446 P4363 P3209 P5822 P1253 P2713 P1226
    P2913 P2576 P7031 P7721 P0429
)

# === SCRIPT LOGIC ===
MISSING_FILES=()
DELETED_COUNT=0

echo "🗑️ Beginning deletion in: $TARGET_DIR"
echo "-----------------------------------"

for id in "${PROJECT_IDS[@]}"; do
    FILE="$TARGET_DIR/${id}.geojson"
    if [[ -f "$FILE" ]]; then
        rm "$FILE"
        echo "✅ Deleted: ${id}.geojson"
        ((DELETED_COUNT++))
    else
        MISSING_FILES+=("${id}.geojson")
    fi
done

echo "-----------------------------------"
echo "✅ Finished deleting."
echo "🧮 Total files deleted: $DELETED_COUNT"
echo

if [[ ${#MISSING_FILES[@]} -gt 0 ]]; then
    echo "⚠️ These files were NOT found:"
    printf '%s\n' "${MISSING_FILES[@]}"
else
    echo "🎉 All files were found and deleted."
fi

# -----------------------------------
# ✅ Deleted: P2769.geojson
# ✅ Deleted: P2959.geojson
# ✅ Deleted: P2960.geojson
# ✅ Deleted: P3084.geojson
# ✅ Deleted: P0330.geojson
# ✅ Deleted: P2814.geojson
# ✅ Deleted: P2770.geojson
# ✅ Deleted: P2880.geojson
# ✅ Deleted: P1568.geojson
# ✅ Deleted: P1626.geojson
# ✅ Deleted: P2764.geojson
# ✅ Deleted: P2768.geojson
# ✅ Deleted: P2771.geojson
# ✅ Deleted: P2787.geojson
# ✅ Deleted: P2788.geojson
# ✅ Deleted: P2792.geojson
# ✅ Deleted: P2798.geojson
# ✅ Deleted: P2799.geojson
# ✅ Deleted: P2800.geojson
# ✅ Deleted: P2813.geojson
# ✅ Deleted: P2820.geojson
# ✅ Deleted: P2821.geojson
# ✅ Deleted: P2822.geojson
# ✅ Deleted: P2844.geojson
# ✅ Deleted: P2845.geojson
# ✅ Deleted: P2851.geojson
# ✅ Deleted: P2863.geojson
# ✅ Deleted: P2915.geojson
# ✅ Deleted: P2928.geojson
# ✅ Deleted: P2932.geojson
# ✅ Deleted: P2947.geojson
# ✅ Deleted: P2952.geojson
# ✅ Deleted: P2967.geojson
# ✅ Deleted: P2982.geojson
# ✅ Deleted: P3025.geojson
# ✅ Deleted: P3026.geojson
# ✅ Deleted: P3027.geojson
# ✅ Deleted: P3051.geojson
# ✅ Deleted: P3052.geojson
# ✅ Deleted: P3060.geojson
# ✅ Deleted: P4082.geojson
# ✅ Deleted: P4125.geojson
# ✅ Deleted: P4160.geojson
# ✅ Deleted: P4168.geojson
# ✅ Deleted: P4169.geojson
# ✅ Deleted: P4187.geojson
# ✅ Deleted: P4189.geojson
# ✅ Deleted: P4190.geojson
# ✅ Deleted: P4191.geojson
# ✅ Deleted: P4192.geojson
# ✅ Deleted: P2929.geojson
# ✅ Deleted: P2930.geojson
# ✅ Deleted: P2931.geojson
# ✅ Deleted: P3080.geojson
# ✅ Deleted: P2875.geojson
# ✅ Deleted: P3629.geojson
# ✅ Deleted: P2786.geojson
# ✅ Deleted: P2881.geojson
# ✅ Deleted: P4123.geojson
# ✅ Deleted: P4127.geojson
# ✅ Deleted: P2785.geojson
# ✅ Deleted: P2867.geojson
# ✅ Deleted: P2869.geojson
# ✅ Deleted: P2937.geojson
# ✅ Deleted: P2938.geojson
# ✅ Deleted: P2964.geojson
# ✅ Deleted: P3083.geojson
# ✅ Deleted: P4113.geojson
# ✅ Deleted: P4114.geojson
# ✅ Deleted: P4115.geojson
# ✅ Deleted: P4116.geojson
# ✅ Deleted: P4117.geojson
# ✅ Deleted: P1204.geojson
# ✅ Deleted: P6882.geojson
# ✅ Deleted: P6883.geojson
# ✅ Deleted: P3281.geojson
# ✅ Deleted: P5492.geojson
# ✅ Deleted: P0718.geojson
# ✅ Deleted: P0521.geojson
# ✅ Deleted: P2751.geojson
# ✅ Deleted: P6745.geojson
# ✅ Deleted: P7058.geojson
# ✅ Deleted: P7059.geojson
# ✅ Deleted: P5550.geojson
# ✅ Deleted: P5552.geojson
# ✅ Deleted: P6609.geojson
# ✅ Deleted: P6143.geojson
# ✅ Deleted: P5698.geojson
# ✅ Deleted: P5713.geojson
# ✅ Deleted: P4363.geojson
# ✅ Deleted: P3209.geojson
# ✅ Deleted: P5822.geojson
# ✅ Deleted: P1253.geojson
# ✅ Deleted: P2713.geojson
# ✅ Deleted: P2913.geojson
# ✅ Deleted: P2576.geojson
# ✅ Deleted: P7031.geojson
# ✅ Deleted: P0429.geojson
# -----------------------------------
# ✅ Finished deleting.
# 🧮 Total files deleted: 98

# ⚠️ These files were NOT found:

# P7475.geojson - never created route in first place
# P7446.geojson - never created route in first place
# P1226.geojson - Gregor tried deleting
# P7721.geojson - never created route in first place