#!/usr/bin/env bash
# Run jnitrace from the repo without relying on the venv's installed script.
# Usage: ./scripts/jnitrace.sh [options] target
# Example: ./scripts/jnitrace.sh -l libcallme.so -b none com.example.myapplication
set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"
export PYTHONPATH="$REPO_ROOT${PYTHONPATH:+:$PYTHONPATH}"
# Unbuffered stdout so trace output appears in the terminal immediately (no adb logcat needed)
export PYTHONUNBUFFERED=1
if [ -x "$REPO_ROOT/.venv/bin/python3" ]; then
  exec "$REPO_ROOT/.venv/bin/python3" -m jnitrace.jnitrace "$@"
else
  exec python3 -m jnitrace.jnitrace "$@"
fi
