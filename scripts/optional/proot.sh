#!/usr/bin/env bash
set -euo pipefail

if ! command -v pkg >/dev/null 2>&1; then
    echo "This installer requires Termux (pkg)." >&2
    exit 1
fi

pkg install -y proot-distro

prefix_path="${PREFIX:-/data/data/com.termux/files/usr}"
debian_rootfs="${prefix_path}/var/lib/proot-distro/installed-rootfs/debian"

if [ ! -d "$debian_rootfs" ]; then
    proot-distro install debian
else
    echo "Debian is already installed in proot-distro. Skipping install."
fi

# Basic Debian bootstrap for day-to-day usage.
proot-distro login debian --shared-tmp -- /usr/bin/env DEBIAN_FRONTEND=noninteractive bash -lc '
set -euo pipefail
apt update
apt upgrade -y
apt install -y ca-certificates curl wget git sudo locales tzdata
if [ -f /etc/locale.gen ]; then
  sed -i "s/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen || true
  locale-gen en_US.UTF-8 || true
  update-locale LANG=en_US.UTF-8 || true
fi
'

mkdir -p "$HOME/.local/bin"
cat >"$HOME/.local/bin/debian" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
exec proot-distro login debian --shared-tmp -- /bin/bash -l "$@"
EOF
chmod +x "$HOME/.local/bin/debian"

echo "Debian proot is ready. Launch it with: debian"
