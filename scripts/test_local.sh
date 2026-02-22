#!/usr/bin/env bash
# Quick local test (no Android device): build, install, run --version and --help.
set -e
cd "$(dirname "$0")/.."

echo "=== Building JS bundle ==="
npm run build

echo ""
echo "=== Creating venv and installing ==="
python3 -m venv .venv
.venv/bin/pip install -q -e .
.venv/bin/pip install -q -r requirements.txt

echo ""
echo "=== jnitrace --version ==="
.venv/bin/jnitrace --version

echo ""
echo "=== jnitrace --help (first 20 lines) ==="
.venv/bin/jnitrace --help | head -20

echo ""
echo "=== Done (local tests passed) ==="
