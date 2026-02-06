# termux-setup

Opinionated scripts to bootstrap an Termux environment.

This repository contains **my personal, opinionated setup** to configure a clean Termux installation from scratch using automated scripts.
It is designed to be **reproducible**, **scriptable**, and easy to re-run after a fresh install or device reset.

---

## ✨ Features

- Automated bootstrap from a clean Termux install
- Opinionated configuration (tools, defaults, preferences)
- Idempotent scripts (safe to re-run)
- Public and reusable
- Minimal manual steps

---

## 🚀 Installation

You can install the setup in one of the following ways.

### Option 1: One-command bootstrap (recommended)

```sh
curl -fsSL https://raw.githubusercontent.com/bladecoder/termux-setup/main/bootstrap.sh | sh
```

This will:

- Download the bootstrap script
- Install required dependencies
- Apply the configured setup automatically

### Option 2: Clone the repository

```
git clone https://github.com/bladecoder/termux-setup.git
cd termux-setup
./setup.sh
```

Use this option if you want to inspect or customize the scripts before running them.

## 🧠 Philosophy

This setup is intentionally opinionated.

It reflects:

- My preferred tools and defaults
- My workflow and priorities

What I personally want after a clean install

You are encouraged to fork it, adapt it, or use it as inspiration for your own setup.

## 📁 Repository Structure

```
.
├── bootstrap.sh      # Entry point for one-command install
├── setup.sh          # Main setup logic
├── scripts/          # Modular install/config scripts
├── configs/          # Configuration files
└── README.md
```

## 🔄 Re-running

All scripts are designed to be safely re-run.
If something changes or breaks, you should be able to run the setup again without issues.

```
termux-setup > source scripts/vim.sh
```