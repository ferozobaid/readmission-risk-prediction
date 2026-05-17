#!/usr/bin/env bash
# Download the UCI "Diabetes 130-US hospitals 1999-2008" dataset.
# https://archive.ics.uci.edu/dataset/296/diabetes+130-us+hospitals+for+years+1999-2008

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="$REPO_ROOT/data/raw"
mkdir -p "$DATA_DIR"

URL="https://archive.ics.uci.edu/static/public/296/diabetes+130+us+hospitals+for+years+1999+2008.zip"
ZIP="$DATA_DIR/diabetes_130_us_hospitals.zip"

echo "Downloading UCI dataset ..."
curl -L -o "$ZIP" "$URL"

echo "Unzipping ..."
unzip -o "$ZIP" -d "$DATA_DIR"

# The archive contains a nested dataset_diabetes/ folder with diabetic_data.csv
if [ -f "$DATA_DIR/dataset_diabetes/diabetic_data.csv" ]; then
  cp "$DATA_DIR/dataset_diabetes/diabetic_data.csv" "$DATA_DIR/diabetic_data.csv"
  cp "$DATA_DIR/dataset_diabetes/IDS_mapping.csv" "$DATA_DIR/IDS_mapping.csv" 2>/dev/null || true
fi

echo "Done. Expected files: $DATA_DIR/diabetic_data.csv, $DATA_DIR/IDS_mapping.csv"
