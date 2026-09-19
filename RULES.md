# Engineering rules

- Run `mix verify` before claiming completion. Report exact failures or checks
  not run; focused tests alone are not the final gate.
- Do not silence a check to finish a task. Investigate each warning; document
  narrowly scoped exceptions with a reason. The Dialyzer ignore list starts empty.
- Validate untrusted input at boundaries. Handle expected failures explicitly;
  avoid blanket rescue clauses and silently discarded errors.
- Preserve persisted data and public contracts when they exist. Never delete
  development or production storage from tests. Isolate test resources per run,
  especially when multiple worktrees or processes share a machine.
- Keep OTP process ownership, supervision, shutdown, and timeouts explicit. Do
  not introduce a process for work a pure function can perform.
- Keep secrets outside source control; read deployment settings at runtime.
- Review dependencies and lockfile changes. Do not add speculative frameworks.
- For Phoenix projects, also follow `docs/phoenix.md` for async, telemetry,
  accessibility, and asset coverage conventions.
