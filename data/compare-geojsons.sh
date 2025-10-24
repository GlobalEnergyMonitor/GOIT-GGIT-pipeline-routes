#!/usr/bin/env bash
# compare-geojsons.sh
# Compare all .geojson files in subfolders of ROOT_DIR to a reference .geojson file.
# Usage:
#   compare-geojsons.sh [-c|--canonical] ROOT_DIR REFERENCE_FILE
# Example:
#   compare-geojsons.sh /path/to/dir reference.geojson
#   compare-geojsons.sh --canonical /path/to/dir reference.geojson

set -euo pipefail

canonical=false
if [[ "${1:-}" == "-c" || "${1:-}" == "--canonical" ]]; then
  canonical=true
  shift
fi

if [[ $# -ne 2 ]]; then
  echo "Usage: $(basename "$0") [-c|--canonical] ROOT_DIR REFERENCE_FILE" >&2
  exit 2
fi

ROOT_DIR="$1"
REF_PATH_INPUT="$2"

# Resolve absolute paths
ROOT_DIR="$(cd "$ROOT_DIR" && pwd)"
if [[ -f "$REF_PATH_INPUT" ]]; then
  REF_FILE="$(cd "$(dirname "$REF_PATH_INPUT")" && pwd)/$(basename "$REF_PATH_INPUT")"
else
  # If they passed just a filename, assume it’s in ROOT_DIR
  REF_FILE="$ROOT_DIR/$REF_PATH_INPUT"
fi

if [[ ! -f "$REF_FILE" ]]; then
  echo "Reference file not found: $REF_FILE" >&2
  exit 2
fi

# Hashing function that prefers shasum (macOS) then sha256sum, else Python fallback.
hash_cmd_available() {
  command -v "$1" >/dev/null 2>&1
}

hash_bytes() {
  # read bytes from stdin and output a sha256 hex
  if hash_cmd_available shasum; then
    shasum -a 256 | awk '{print $1}'
  elif hash_cmd_available sha256sum; then
    sha256sum | awk '{print $1}'
  else
    python3 - <<'PY'
import sys, hashlib
print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest())
PY
  fi
}

# Canonicalize JSON (sorted keys, compact) if requested
canonicalize() {
  if $canonical; then
    if ! command -v jq >/dev/null 2>&1; then
      echo "Error: --canonical requires 'jq' to be installed." >&2
      exit 2
    fi
    jq -S -c .
  else
    cat
  fi
}

# Compute reference hash
REF_HASH="$(canonicalize < "$REF_FILE" | hash_bytes)"

echo "Root directory: $ROOT_DIR"
echo "Reference file: $REF_FILE"
echo "Mode: $([[ $canonical == true ]] && echo 'canonical (jq -S -c)' || echo 'exact byte comparison')"
echo

matches=0
checked=0

# Find all .geojson files under subfolders only (exclude the root level)
# -mindepth 2 ensures we only look in subdirectories of ROOT_DIR
# Use -print0 to safely handle spaces/newlines in filenames
while IFS= read -r -d '' f; do
  # Skip the reference file itself if encountered in traversal
  if [[ "$f" == "$REF_FILE" ]]; then
    continue
  fi
  ((checked++))

  FILE_HASH="$(canonicalize < "$f" | hash_bytes)"
  if [[ "$FILE_HASH" == "$REF_HASH" ]]; then
    ((matches++))
    echo "MATCH: $f"
  fi
done < <(find "$ROOT_DIR" -mindepth 2 -type f -name '*.geojson' -print0)

echo
echo "Checked: $checked file(s)"
echo "Matches: $matches"

# Exit code 0 always (script completed), but you can change to `exit 1` when no matches if you prefer.
exit 0