#!/usr/bin/env bash
# Build source distribution and wheel for PyPI.
# Run from repo root. Then: twine upload dist/*
set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== npm install & build (Frida script) ==="
npm install
npm run build

echo "=== Ensure jnitrace.build package exists ==="
touch jnitrace/build/__init__.py

echo "=== Building sdist and wheel ==="
VENV="$REPO_ROOT/.venv"
if [[ ! -d "$VENV" ]] || [[ ! -x "$VENV/bin/python3" ]]; then
  rm -rf "$VENV"
  python3 -m venv "$VENV"
fi
"$VENV/bin/pip" install -q build
"$VENV/bin/python3" -m build

echo "=== Done. Upload with: twine upload dist/* ==="
