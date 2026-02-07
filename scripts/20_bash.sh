#!/usr/bin/env bash
set -euo pipefail

backup_if_exists() {
    target="$1"
    if [ -f "$target" ]; then
        backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
        mv "$target" "$backup"
    fi
}

copy_if_changed() {
    source_path="$1"
    target_path="$2"
    if [ -f "$target_path" ] && cmp -s "$source_path" "$target_path"; then
        return
    fi
    backup_if_exists "$target_path"
    cp "$source_path" "$target_path"
}

mkdir -p "$HOME/.local/share/bash"

# Configure bash defaults only when local bash profiles do not exist yet.
if [ ! -d "$HOME/.local/share/bash" ] || [ -z "$(ls -A "$HOME/.local/share/bash" 2>/dev/null)" ]; then
    copy_if_changed "./configs/bashrc" "$HOME/.bashrc"
else
    echo "Bash configuration already exists, skipping .bashrc (user customizations preserved)."
fi

# Always keep inputrc current, preserving old versions.
copy_if_changed "./configs/inputrc" "$HOME/.inputrc"

# Copy bash configs to local share.
for file in ./configs/bash/*; do
    [ -f "$file" ] || continue
    copy_if_changed "$file" "$HOME/.local/share/bash/$(basename "$file")"
done

change_shell_mode="${CHANGE_SHELL:-auto}"
bash_path="$(command -v bash)"
current_shell="${SHELL:-}"

case "$change_shell_mode" in
    auto)
        if [ -t 0 ] && [ "$current_shell" != "$bash_path" ] && command -v chsh >/dev/null 2>&1; then
            chsh -s "$bash_path"
        fi
        ;;
    always)
        if command -v chsh >/dev/null 2>&1; then
            chsh -s "$bash_path"
        else
            echo "chsh not found; cannot update default shell." >&2
            exit 1
        fi
        ;;
    never)
        echo "Skipping shell change (CHANGE_SHELL=never)."
        ;;
    *)
        echo "Invalid CHANGE_SHELL: $change_shell_mode (use auto|always|never)." >&2
        exit 1
        ;;
esac
