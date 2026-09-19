#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export TIDEWAVE_PORT="${TIDEWAVE_PORT:-49173}"
check_dir=$(mktemp -d)
MIX_ENV=dev mix tidewave >"$check_dir/server.log" 2>&1 &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null || true; wait "$server_pid" 2>/dev/null || true; rm -rf "$check_dir"' EXIT
if ! curl --fail --silent --show-error --max-time 5 \
  --retry 10 --retry-connrefused --retry-delay 1 \
  "http://127.0.0.1:$TIDEWAVE_PORT/tidewave/mcp" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  --data '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"starter-check","version":"1.0"}}}' \
  >"$check_dir/response.json"; then
  cat "$check_dir/server.log"
  exit 1
fi
kill -0 "$server_pid"
grep -q '"serverInfo"' "$check_dir/response.json"
echo 'Tidewave MCP handshake passed'
