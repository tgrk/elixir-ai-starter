# CI and delivery

## Verification

CI runs on pull requests and pushes to `main`. It reads `.tool-versions`, fetches
locked dependencies, executes `mix verify`, compiles the development integrations,
and checks that the starter can be renamed cleanly. Development formatting is a
separate mutation; CI rejects unformatted code instead of rewriting it.

The dependency/build cache includes OS, architecture, runtime versions, and lock
hash. The Dialyzer cache is limited to `priv/plts`, with a runtime-specific fallback
so the tool can update an older PLT. Cache misses must remain safe.

Configure the `Verify` status as a required check in your repository rules before
relying on auto-merge. Template files cannot impose repository settings on projects
created from the template. Private repository rules may depend on your GitHub plan.

Dependabot opens weekly Mix and Actions updates. Minor/patch Mix updates are
grouped; major updates are separate. Automatic merging is off by default. To opt
in, first require the CI check and configure your review policy, enable repository
auto-merge, then set repository variable `DEPENDABOT_AUTO_MERGE=true`. The workflow
uses Dependabot metadata and never checks out or executes pull-request code with
its write token. Leave the variable unset if required checks cannot be enforced.

## Releases

```sh
MIX_ENV=prod mix deps.get --only prod
MIX_ENV=prod mix release.build
_build/prod/rel/elixir_ai_starter/bin/elixir_ai_starter start
```

`release.build` does not select the production environment for you.

Pushing a `v*` tag or manually dispatching the Release workflow first runs the same
verification, then packages and smoke-tests a Linux amd64 release and uploads it as a GitHub Actions
artifact. Set the version in `mix.exs` before tagging. This does not create a GitHub
Release entry or deploy the artifact. Release archives are OS/architecture-specific;
use a compatible runtime image or build on your target platform.

## Containers

```sh
docker build -t elixir-ai-starter .
docker run --rm --name elixir-ai-starter elixir-ai-starter
```

The container runs a release as `nobody` and needs no source tree, Mix installation,
quality dependencies, or AI server at runtime. It has no public network listener.
Add actual workers to the application supervisor as your service develops.

When upgrading, update the Docker build arguments to match `.tool-versions`, choose
an available Hex Elixir image, and keep builder/runner operating systems compatible.
For applications with runtime `priv` resources, copy those resources into the build
before `mix release`; never copy development data or secrets into the image.

## Hosting

Fittr's Fly.io configuration assumes an HTTP application, an application name,
and its own runtime settings. Those values are not portable to this headless OTP
starter. For Fly.io or another host, create configuration in your derived project,
select a region and resource size, and configure only the services your application
actually exposes. Add persistent volumes and backups only if the chosen storage
requires them. Store release cookies and other credentials in the host's secrets
mechanism, never in a committed configuration file.

For automated deployment, add a job after successful verification/package, choose
an explicit environment and approval policy, and supply the host token through
GitHub secrets. The template deliberately does not pretend to deploy successfully
to an unconfigured account.
