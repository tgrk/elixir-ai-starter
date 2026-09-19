# Project instructions

Read README.md and RULES.md before changing this project. Read the implementation
and all callers of the boundary you intend to change; documentation can drift.

## Map

- `lib/elixir_ai_starter/`: domain modules and OTP application.
- `test/`: ExUnit behavior tests; `test/support/` is compiled only in test.
- `config/runtime.exs`: environment-specific runtime configuration.
- `scripts/tidewave.exs`: development-only, loopback MCP server.
- `.credo.exs`: standard, Forge, result consistency, reduce, and ExSlop checks.
- `docs/`: setup decisions, optional Phoenix integration, and delivery guidance.

## Commands

- `mix setup`: fetch dependencies.
- `mix rename.project MyApp`: rename the starter before adding application code.
- `iex -S mix`: explore the application locally.
- `mix tidewave`: expose development runtime tools on localhost:4000.
- `mix test path/to_test.exs`: focused feedback while iterating.
- `mix quality`: format files, then run the quality checks (does not run tests).
- `mix verify`: non-mutating final gate; compilation, tests, and all quality tools.
- `MIX_ENV=prod mix release.build`: build a production release.

## Working agreement

Reuse existing modules and standard library functions before adding dependencies
or abstractions. Keep domain transformations pure and side effects at explicit
boundaries. Use private functions for internal helpers. Explain non-obvious
constraints rather than narrating code in comments.

For a bug, reproduce the failure with a focused test before changing its cause.
For a feature, test observable behavior and a relevant failure path. Avoid tests
that merely repeat implementation details. Keep changes scoped and inspect the
final diff after formatting.

Use Tidewave for bounded runtime exploration when connected; it does not replace
ExUnit or static analysis. Never expose it to production or use it against live
customer data. Do not print secrets or copy local credentials into artifacts.

Instructions and required tools must work from a clean clone. Optional personal
skills can help, but do not introduce machine-specific paths or require an
uninstalled skill. Update docs when commands or architecture change.
