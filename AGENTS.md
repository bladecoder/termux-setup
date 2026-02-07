# Repository Guidelines

## Project Structure & Module Organization
This is a shell-based Termux bootstrap repo.

- `bootstrap.sh`: remote/bootstrap entrypoint.
- `setup.sh`: local setup entrypoint.
- `scripts/*.sh`: ordered core installers (`00_`, `10_`, `20_`, ...).
- `scripts/optional/*.sh`: optional installers (Neovim, Android SDK, btop).
- `configs/`: tracked config files copied by installers.

Prefer small, single-purpose installers and keep numeric prefixes so execution order is obvious.

## Build, Test, and Development Commands
There is no compile step; development is script editing plus manual validation.

- `sh bootstrap.sh`: clone-and-run setup.
- `bash scripts/00_required.sh`: run one module while iterating.
- `bash -n scripts/20_bash.sh`: syntax-check script changes.
- `rg "pattern" scripts configs`: search scripts and configs quickly.

Run modules from repo root so relative paths like `./configs/...` resolve correctly.

## Coding Style & Naming Conventions
Use POSIX `sh` only when needed; otherwise use `bash` and follow existing style:

- 4-space indentation.
- Quote variable expansions (`"$HOME"`).
- Use `set -eu` in non-trivial scripts.
- Keep steps short and idempotent when possible.

Name scripts as `<order>_<action>.sh` (example: `30_dev-languages.sh`).

## Testing Guidelines
No formal test framework is configured. Validate with:

- Syntax checks: `bash -n scripts/<script>.sh`.
- Targeted dry runs on Termux.
- Re-run checks to confirm idempotent behavior.

Document any manual verification steps in PR descriptions.

## Commit & Pull Request Guidelines
Use Conventional Commit style (as in current history), for example:

- `feat(termux): add optional android sdk installer`
- `fix(bash): quote HOME paths in installer`

For PRs, include:

- What changed and why.
- Which scripts were executed for validation.
- User-impacting changes (new packages, shell defaults, overwritten files).

## Security & Configuration Tips
Do not commit secrets or machine-specific credentials. Keep sensitive values out of tracked `configs/` files. Review `curl | sh` and remote downloads carefully, and pin versions when practical.
