# termux-setup

Opinionated scripts to bootstrap a Termux environment.

## Platform support

- Core flow (`./setup.sh`): **Termux only**
- Optional scripts under `scripts/optional/`: extra installers (Termux and Ubuntu/Debian)

If `pkg` is not available, `setup.sh` exits with an explicit message.

## Installation

### Option 1: One-command bootstrap

```sh
curl -fsSL https://raw.githubusercontent.com/bladecoder/termux-setup/main/bootstrap.sh | sh
```

### Option 2: Clone and run

```sh
git clone https://github.com/bladecoder/termux-setup.git
cd termux-setup
./setup.sh
```

Run commands from the repo root so paths like `./configs/...` resolve correctly.

## Environment controls

The core scripts support these environment variables:

- `TERMUX_SETUP_STORAGE=auto|always|never` (default: `auto`)
- `CHANGE_SHELL=auto|always|never` (default: `auto`)
- `VERIFY_DOWNLOADS=1|0` (default: `0`)

Examples:

```sh
TERMUX_SETUP_STORAGE=never CHANGE_SHELL=never ./setup.sh
```

```sh
VERIFY_DOWNLOADS=1 NVIM_TAR_SHA256="<sha256>" bash scripts/optional/neovim.sh
```

```sh
VERIFY_DOWNLOADS=1 ANDROID_CMDLINE_TOOLS_SHA256="<sha256>" bash scripts/optional/android-sdk.sh
```

## Optional scripts

- `scripts/optional/neovim.sh`
- `scripts/optional/android-sdk.sh`
- `scripts/optional/btop.sh`
- `scripts/optional/proot.sh`

These are not executed by `setup.sh`.

## Re-running

Scripts are designed to be re-runnable. You can execute a single module:

```sh
bash scripts/30_vim.sh
```
