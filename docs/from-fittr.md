# What came from Fittr

Source: local Fittr repository, inspected September 19, 2026 at `9cc8747`. This is an extraction
of its engineering setup, not a fork of its fitness application.

| Fittr artifact | Starter adaptation |
| --- | --- |
| `mix.exs` quality dependencies | All nine quality dependencies retained with Fittr's constraints |
| `quality` alias | Retained formatting behavior; added non-mutating checks, Sobelow, and `verify` |
| `.credo.exs` | Same check selection; removed generated comments, enabled strict mode, removed Mnesia result tag |
| `.formatter.exs` | Styler retained; Phoenix import removed; scripts included |
| `.dialyzer_ignore.exs` | Empty; Fittr-specific suppressions do not apply |
| `.tool-versions` | Same Elixir/OTP pins, shared with CI |
| Tidewave dependency / endpoint plug | Same dependency constraint; standalone dev Bandit endpoint |
| Manual project renaming | Added `rename_project` with a wrapper that covers Docker and workflows |
| `.iex.exs` | Bounded pretty printing; no domain aliases |
| `AGENTS.md` / `RULES.md` | Portable project map and concrete rules without stale storage assumptions |
| Feature documentation | Replaced with starter adoption and delivery guides |
| Elixir and Dialyzer workflows | One full local/CI verification command with scoped caches |
| Dependabot | Weekly Mix and Actions updates; major Mix updates remain separate |
| Dependabot auto-merge | Explicit opt-in variable; requires repository merge protections |
| Release configuration | Native Mix release and archive, plus CI packaging |
| Dockerfile | Generic OTP release, no application secrets or copied runtime data |
| `fly.toml` | Hosting-specific instructions rather than an incorrect HTTP service for a headless app |
| Asset aliases and LiveView rules | Optional Phoenix guide; no frontend dependencies in the OTP base |
| Runtime configuration | Empty starting point; add actual settings when needed |

Not copied: fitness contexts, Mnesia data, OAuth integrations, tokens, AI-provider
settings, screenshots, generated assets, dependencies/build output, crash dumps,
or personal editor and skill paths. Phoenix, Ecto, Tailwind, and esbuild are
application choices rather than requirements for every Elixir project.

The starter deliberately closes Fittr's local/CI check gap. It also starts with
no warning suppressions, no shared test database, and no presumed deployment
credentials. Dependency constraints are inherited; the committed lockfile records
the resolved versions. Review both when upgrading.
