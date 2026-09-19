# Elixir AI Starter

A plain Elixir/OTP GitHub template with the quality and AI development workflow
extracted from Fittr. No database, web framework, external service, or API key is
required. Development tools stay out of the production release.

## Start here

Use GitHub's **Use this template** button to create your own repository, then clone
it. Install the versions in `.tool-versions` with mise or asdf:

```sh
mise install
mix setup
mix verify
iex -S mix
```

The baseline matches Fittr: Elixir 1.20.1 / OTP 28.3.2. Update `.tool-versions`
and Docker build arguments together when upgrading.

The first verification builds Dialyzer's PLT and takes longer. CI caches only
`priv/plts` for the PLT, not all of `priv`. Commit `mix.lock` updates.

## What's included

| Tool or artifact | Purpose |
| --- | --- |
| ExUnit | Behavior tests and an application startup smoke test |
| Styler + `mix format` | Shared formatting and style rewrites |
| Credo strict | Readability, complexity, and correctness checks |
| ExSlop | Recommended checks for redundant or misleading generated code |
| CredoResults | Consistent result shapes |
| CredoUnnecessaryReduce | Standard library operations instead of unnecessary reductions |
| ForgeCredoChecks | Fittr's selected collection and control-flow checks |
| ExDNA | AST-based duplication detection |
| Dialyxir / Dialyzer | Static analysis with an initially empty ignore list |
| Sobelow | Security analysis that fails verification on findings |
| RenameProject | One-command application, module, path, Docker, and workflow renaming |
| Tidewave + Bandit | Development-only MCP access on the loopback interface |
| `AGENTS.md` / `RULES.md` | Portable instructions and verification expectations |
| GitHub Actions | Full verification and gated release packaging |
| Dependabot | Weekly dependency updates; optional minor/patch auto-merge |
| Dockerfile | Multi-stage release image running as an unprivileged user |

Fittr's selected Credo checks are preserved, including its disabled checks. The
Mnesia-specific `:atomic` result tag is removed. Add it back only if your code
actually uses that contract. Read [the extraction notes](docs/from-fittr.md) for
what was carried over, adapted, or deliberately left application-specific.

## Commands

| Command | Behavior |
| --- | --- |
| `mix setup` | Fetch dependencies |
| `mix rename.project MyApp` | Rename the starter before development begins |
| `mix test` | Run ExUnit |
| `mix format` | Rewrite formatting and Styler suggestions |
| `mix quality` | Format, then check duplication, lint, Dialyzer, and security |
| `mix quality.check` | The same checks without formatting changes |
| `mix verify` | Compile with warnings as errors, test, then `quality.check` |
| `mix tidewave` | Start the development MCP endpoint on localhost:4000 |
| `MIX_ENV=prod mix release.build` | Assemble and archive a production release |

`quality`, `quality.check`, and `verify` default to `MIX_ENV=test` through Mix's
preferred CLI environments. Don't override them with `MIX_ENV=prod`: quality
dependencies are intentionally absent there. Use `mix format` before `mix verify`.

Sobelow reports a missing-router warning for this non-Phoenix application; its
source scan still runs. The locked CredoResults dependency also emits compiler
warnings on Elixir 1.20; these are upstream warnings, not suppressed project
warnings.

A green check is feedback, not proof of good design. Review domain behavior,
error paths, and unnecessary abstractions as well as tool output.

## Rename the application

GitHub names the repository, but does not rename the Elixir application inside it.
Run the rename immediately after creating and cloning your repository, while the
initial template commit is still easy to recover:

```sh
mix setup
mix rename.project MyApp
mix format
mix verify
MIX_ENV=prod mix release.build
```

`MyApp` must be an Elixir module name. The wrapper calls
[`rename_project`](https://hex.pm/packages/rename_project) with the starter's
module name and includes its Dockerfile, shell scripts, and GitHub workflow files.
The task changes files and paths in place; commit or stash later work before using
it. Inspect the resulting diff, then update this README with the real product,
setup, and deployment instructions. Rename the GitHub repository separately if
its name should also change.

For a library, remove the application callback and empty supervisor if they are
unneeded. The quality tooling works independently of the supervision tree.

## AI development

Run `mix tidewave`, then configure your MCP client with a streamable HTTP server:

```text
http://localhost:4000/tidewave/mcp
```

This starts the application and a development-only Bandit server bound to
`127.0.0.1`. It exposes runtime evaluation; use local development data only.
If port 4000 is occupied, run `TIDEWAVE_PORT=4001 mix tidewave` and use that port
in your client URL. An MCP-capable client is optional: the project builds and verifies without one.
Verify the connection locally with `bash scripts/check-tidewave.sh`; CI runs this
check too. It needs curl and uses port 49173 by default.
See [Tidewave's client setup documentation](https://github.com/tidewave-ai/tidewave_phoenix#2-add-the-tidewave-mcp-to-your-agenteditor).

Give an agent one observable task, ask it to inspect the relevant callers, and
require the final `mix verify` result. Keep project instructions current when
architecture changes. Personal skills are optional; the template does not rely
on a particular agent vendor or absolute paths on the author's computer.

## Phoenix and delivery

- [Adding this setup to Phoenix / LiveView](docs/phoenix.md)
- [CI, releases, containers, and optional deployment](docs/delivery.md)

The release workflow packages artifacts; it does not deploy to a hosting account.
Choose a deployment target and configure its secrets in your derived repository.
