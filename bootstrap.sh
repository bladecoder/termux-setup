#!/usr/bin/env sh
set -eu

REPO_URL="https://github.com/bladecoder/termux-setup.git"
WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/termux-setup.XXXXXX")"

cleanup() {
  if [ -n "${WORKDIR:-}" ] && [ -d "${WORKDIR}" ]; then
    rm -rf "${WORKDIR}"
  fi
}
trap cleanup EXIT INT TERM

if ! command -v git >/dev/null 2>&1; then
  echo "Installing git..."
  if command -v apt-get >/dev/null 2>&1; then
    if command -v sudo >/dev/null 2>&1; then
      sudo apt-get update -y
      sudo apt-get install -y git
    else
      apt-get update -y
      apt-get install -y git
    fi
  elif command -v pkg >/dev/null 2>&1; then
    pkg install -y git
  else
    echo "git is required but not installed; please install git and re-run." >&2
    exit 1
  fi
fi

git clone --depth 1 "${REPO_URL}" "${WORKDIR}"

cd "${WORKDIR}"
sh ./setup.sh
