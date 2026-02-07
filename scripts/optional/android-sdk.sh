#!/usr/bin/env bash
set -euo pipefail

### Termux SDK Installer
#

# Vars
install_dir="${HOME}"
manifest_url="https://raw.githubusercontent.com/AndroidIDEOfficial/androidide-tools/main/manifest.json"
manifest="${PWD}/manifest.json"
# DO NOT CHANGE THESE!
CURRENT_SHELL="${SHELL##*/}"
CURRENT_DIR="${PWD}"
arch="$(dpkg --print-architecture)"

# Color Codes
red="\e[0;31m"          # Red
green="\e[0;32m"        # Green
nocol="\033[0m"         # Default

# Functions
banner() {
  echo -e "
${green}------------------------------------------------

Termux Android SDK Installer${nocol}:
Based in https://github.com/Sohil876/termux-sdk-installer

${green}------------------------------------------------${nocol}
"
}

download_and_extract() {
  # Name shown in echo
  name="${1}"
  # URL to download from
  url="${2}"
  # Directory in which the downloaded archive will be extracted
  dir="${3}"
  # Destination path for downloading the file
  dest="${4}"

  cd "${dir}"
  do_download=true
  if [[ -f "${dest}" ]]; then
    name=$(basename "${dest}")
    echo -e "${green}File ${name} already exists.${nocol}"
    echo "Do you want to skip the download process? ([${green}y${nocol}]es/[${red}N${nocol}]o): "
    read -r skip
    if [[ "${skip}" = "y" || "${skip}" = "yes" || "${skip}" = "Y" || "${skip}" = "Yes" ]]; then
      do_download=false
    fi
    echo ""
  fi

  if [[ "${do_download}" = "true" ]]; then
    echo -e "${green}Downloading ${name}...${nocol}"
    curl -L -o "${dest}" "${url}"
    echo -e "${green}${name} has been downloaded.${nocol}"
    echo ""
  fi

  if [[ ! -f "${dest}" ]]; then
    echo -e "${red}The downloaded file ${name} does not exist! Aborting...${nocol}"
    exit 1
  fi
  # Extract the downloaded archive
  echo -e "${green}Extracting downloaded archive...${nocol}"
  tar xvJf "${dest}"
  echo -e "${green}Extracted successfully${nocol}"
  echo ""
  # Delete the downloaded file
  rm -vf "${dest}"
  # cd into the previous working directory
  cd "${CURRENT_DIR}"
}

gen_data() {
  if ! command -v curl &> /dev/null; then
    echo -e "${red}curl is not installed!${nocol}"
    echo "Install it with pkg install curl"
    echo ""
    exit 1
  fi
  curl --silent -L -o "${manifest}" "${manifest_url}"
  if ! [[ -s "${manifest}" ]]; then
    echo -e "${red}Problem fetching manifest!${nocol}"
    echo "Try again after some seconds"
    echo ""
    if [[ -f "${manifest}" ]]; then
      rm "${manifest}"
    fi
    exit 1
  fi
  sdk_url=$(jq -r '.android_sdk' "${manifest}")
  sdk_file="${sdk_url##*/}"
  sdk_m_version=$(jq -r --arg arch "${arch}" '.build_tools[$arch] | keys_unsorted[0]' "${manifest}")
  sdk_version=${sdk_m_version:1}
  sdk_version="${sdk_version//_/.}"
  build_tools_url=$(jq -r --arg arch "${arch}" --arg ver "${sdk_m_version}" '.build_tools[$arch][$ver]' "${manifest}")
  build_tools_file="${build_tools_url##*/}"
  cmdline_tools_url=$(jq -r '.cmdline_tools' "${manifest}")
  cmdline_tools_file="${cmdline_tools_url##*/}"
  platform_tools_url=$(jq -r --arg arch "${arch}" --arg ver "${sdk_m_version}" '.platform_tools[$arch][$ver]' "${manifest}")
  platform_tools_file="${platform_tools_url##*/}"
  rm "${manifest}"
}

help() {
  cat <<-_EOL_
${green}Usage:${nocol}
-h,  --help             Shows brief help
--info                  Show info about sdk, arch, etc
-i, --install           Start installation, installs jdk and android sdk with cmdline and build tools
_EOL_
}

info() {
  gen_data
  echo -e "${green}Active Shell:${nocol} ${CURRENT_SHELL}"
  echo -e "${green}Arch:${nocol} ${arch}"
  echo -e "${green}SDK/Tools version:${nocol} v${sdk_version}"
  echo -e "${green}SDK url:${nocol} ${sdk_url}"
  echo -e "${green}Build tools url:${nocol} ${build_tools_url}"
  echo -e "${green}Commandline tools url:${nocol} ${cmdline_tools_url}"
  echo -e "${green}Platform tools url:${nocol} ${platform_tools_url}"
  echo -e "${green}SDK from:${nocol} https://github.com/AndroidIDEOfficial/androidide-tools"
}

install() {
  echo ""
  gen_data
  unsupported_shell_used=false

  echo "Proceed with Android SDK installation? ([${green}y${nocol}]es/[${red}N${nocol}]o): "
  read -r proceed

  if [[ ! "${proceed}" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]; then
    echo -e "${red}Aborted!${nocol}"
    exit 1
  fi

  echo -e "${green}Downloading sdk files...${nocol}"
  # Download and extract the android SDK
  download_and_extract "Android SDK" "${sdk_url}" "${install_dir}" "${install_dir}/${sdk_file}"
  # Download and extract build tools
  download_and_extract "Build tools" "${build_tools_url}" "${install_dir}/android-sdk" "${install_dir}/${build_tools_file}"
  # Download and extract cmdline tools
  download_and_extract "Command line tools" "${cmdline_tools_url}" "${install_dir}/android-sdk" "${install_dir}/${cmdline_tools_file}"
  # Download and extract platform tools
  download_and_extract "Platform tools" "${platform_tools_url}" "${install_dir}/android-sdk" "${install_dir}/${platform_tools_file}"
  # Setting env vars
  echo -e "${green}Setting up env vars...${nocol}"
  if [[ "${CURRENT_SHELL}" == "bash" ]]; then
    shell_profile="${HOME}/.bashrc"
  elif [[ "${CURRENT_SHELL}" == "zsh" ]]; then
    shell_profile="${HOME}/.zshrc"
  else
    unsupported_shell_used=true
    echo -e "${red}Unsupported shell!${nocol}"
    echo -e "${green}You will need to manually export env vars JAVA_HOME, ANDROID_SDK_ROOT and ANDROID_HOME on every session to use sdk, or add them to your shell profile manually:${nocol}"
    echo "export ANDROID_SDK_ROOT=\${HOME}/android-sdk"
    echo "export ANDROID_HOME=\${HOME}/android-sdk"
    echo -e "${green}Also do the same for sdk and jdk bin locations:${nocol}"
    echo "export PATH=\${PREFIX}/opt/openjdk/bin:\${HOME}/android-sdk/cmdline-tools/latest/bin:\${PATH}"
  fi
  if [[ "${unsupported_shell_used}" = "false" ]]; then

    if [[ -z "${ANDROID_SDK_ROOT:-}" ]]; then
      printf "\nexport ANDROID_SDK_ROOT=\${HOME}/android-sdk\n\n" >> "${shell_profile}"
    else
      echo "ANDROID_SDK_ROOT is already set to: ${ANDROID_SDK_ROOT}"
      echo "Check if the path is correct, it should be: ${install_dir}/android-sdk"
    fi
    if [[ -z "${ANDROID_HOME:-}" ]]; then
      printf "\nexport ANDROID_HOME=\${HOME}/android-sdk\n\n" >> "${shell_profile}"
    else
      echo "ANDROID_HOME is already set to: ${ANDROID_HOME}"
      echo "Check if the path is correct, it should be: ${install_dir}/android-sdk"
    fi
    printf "\nexport PATH=\${ANDROID_HOME}/cmdline-tools/latest/bin:\${ANDROID_HOME}/platform-tools:\${PATH}\n\n" >> "${shell_profile}"
  fi
  apt clean
}


banner
if [[ ! -d "${install_dir}" ]]; then
  echo -e "${red}Your install directory doesn't exists!${nocol}"
  echo "If you didnt change in script then that means your home directory doesn't exist, in that case there's something wrong with your termux installation, please reinstall termux!"
  echo "Else if you've changed install directory var to something else make sure it exists!"
  exit 1
fi

case "${1:-}" in
  -h|--help)
    help
    ;;
  --info)
    info
    ;;
  -i|--install|"")
    install
    echo -e "${green}Installed Android SDK!${nocol}"
    echo -e "${green}Please restart termux${nocol}${red}!${nocol}"
    echo ""
    ;;
  *)
    echo -e "${red}Unknown option: ${1}${nocol}"
    help
    exit 1
    ;;
esac

exit 0
