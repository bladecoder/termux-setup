#!/usr/bin/env bash
set -euo pipefail

if command -v pkg >/dev/null 2>&1; then
    echo "This optional installer targets Ubuntu/Debian, not Termux." >&2
    exit 1
fi

android_home="$HOME/apps/android-sdk"
cmdline_tools_zip="commandlinetools-linux-8092744_latest.zip"
cmdline_tools_url="https://dl.google.com/android/repository/${cmdline_tools_zip}"
zip_path="/tmp/${cmdline_tools_zip}"

mkdir -p "$android_home"
wget -O "$zip_path" "$cmdline_tools_url"
if [ "${VERIFY_DOWNLOADS:-0}" = "1" ]; then
    expected_sha="${ANDROID_CMDLINE_TOOLS_SHA256:-}"
    if [ -z "$expected_sha" ]; then
        echo "Set ANDROID_CMDLINE_TOOLS_SHA256 when VERIFY_DOWNLOADS=1." >&2
        exit 1
    fi
    echo "${expected_sha}  ${zip_path}" | sha256sum -c -
fi
unzip -o "$zip_path" -d "$android_home"
rm -f "$zip_path"

# Avoid warning from sdkmanager.
mkdir -p "$HOME/.android"
touch "$HOME/.android/repositories.cfg"

# Move cmdline-tools to proper location.
mv "$android_home/cmdline-tools" "$android_home/latest"
mkdir -p "$android_home/cmdline-tools"
mv "$android_home/latest" "$android_home/cmdline-tools/"

# Accept all licenses and update tools.
yes | "$android_home/cmdline-tools/latest/bin/sdkmanager" --licenses
"$android_home/cmdline-tools/latest/bin/sdkmanager" --update
"$android_home/cmdline-tools/latest/bin/sdkmanager" \
    "build-tools;35.0.1" \
    "platforms;android-35" \
    "emulator" \
    "platform-tools" \
    "system-images;android-29;default;x86_64"

mkdir -p "$HOME/.local/bin"
ln -sf "$android_home/platform-tools/adb" "$HOME/.local/bin/adb"
