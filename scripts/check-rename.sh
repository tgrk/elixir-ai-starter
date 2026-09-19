#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source_dir=$PWD
check_dir=$(mktemp -d)
trap 'rm -rf "$check_dir"' EXIT

tar \
  --exclude .git \
  --exclude _build \
  --exclude deps \
  --exclude priv/plts \
  -cf - . | tar -xf - -C "$check_dir"
(
  cd "$check_dir"
  MIX_DEPS_PATH="$source_dir/deps" MIX_BUILD_PATH="$check_dir/_build" \
    mix rename.project ExampleApp

  test -f lib/example_app.ex
  test -f lib/example_app/application.ex
  test -f test/example_app_test.exs
  ! rg -n 'ElixirAiStarter|elixir_ai_starter|elixir-ai-starter' .

  MIX_ENV=test MIX_DEPS_PATH="$source_dir/deps" MIX_BUILD_PATH="$check_dir/_build" \
    mix verify
)

echo "Project rename check passed"
