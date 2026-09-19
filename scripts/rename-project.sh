#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! $1 =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
  echo "usage: mix rename.project NewModuleName" >&2
  exit 64
fi

mix rename ElixirAiStarter "$1" \
  --include-extensions .yml \
  --include-extensions .yaml \
  --include-extensions .sh \
  --include-files Dockerfile
