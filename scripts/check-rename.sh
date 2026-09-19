#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source_dir=$PWD
check_dir=$(mktemp -d)
trap 'rm -rf "$check_dir"' EXIT

tar \
  --exclude .git \
  --exclude .elixir_ls \
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
  if rg --hidden -n 'ElixirAiStarter|elixir_ai_starter|elixir-ai-starter' .; then
    exit 1
  else
    status=$?
    test "$status" -eq 1
  fi

  MIX_ENV=test MIX_DEPS_PATH="$source_dir/deps" MIX_BUILD_PATH="$check_dir/_build/test" \
    mix compile --warnings-as-errors
  MIX_ENV=test MIX_DEPS_PATH="$source_dir/deps" MIX_BUILD_PATH="$check_dir/_build/test" \
    mix format --check-formatted
  MIX_ENV=test MIX_DEPS_PATH="$source_dir/deps" MIX_BUILD_PATH="$check_dir/_build/test" \
    mix test

  MIX_ENV=prod MIX_DEPS_PATH="$source_dir/deps" MIX_BUILD_PATH="$check_dir/_build/prod" \
    mix release.build
  _build/prod/rel/example_app/bin/example_app eval \
    '{:ok, _} = Application.ensure_all_started(:example_app); true = is_pid(Process.whereis(ExampleApp.Supervisor))'
)

echo "Project rename check passed"
