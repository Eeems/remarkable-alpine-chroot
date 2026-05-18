set -e

config_file="/home/$USER/.config/alpine-chroot.conf"
if [ -f "$config_file" ]; then
  . "$config_file"
fi
repository="${repository:-"Eeems/remarkable-alpine-chroot"}"
branch="${branch:-master}"
bin_folder="${bin_folder:-"/home/$USER/.local/bin"}"
chroot_path="${chroot_path:-"/home/$USER/.local/share/alpine"}"
alpine_chroot_install_path="${alpine_chroot_install_path:-"/home/$USER/.local/share/alpine-chroot-install"}"
alpine_branch=${alpine_branch:-latest-stable}
machine_arch="$(uname -m)"
case "$machine_arch" in
x86_64)
  alpine_arch=${alpine_arch:-x86_64}
  ;;
aarch64)
  alpine_arch=${alpine_arch:-aarch64}
  ;;
armv7l)
  alpine_arch=${alpine_arch:-armv7}
  ;;
*)
  echo "Unknown architecture $machine_arch"
  exit 1
  ;;
esac
download() {
  if [ -f "$3" ]; then
    echo "Warning: ${3} already exists"
    return
  fi
  wget \
    "$2" \
    --output-document="$3"
  chmod "$1" "$3"
}
repo_download() {
  download "$1" "https://raw.githubusercontent.com/${repository}/${branch}/${2}" "$3"
}
SUDO=
if [[ "$USER" != "root" ]] && command -v sudo >/dev/null; then
  SUDO=sudo
fi

case "${1:-install}" in
install)
  if ! type perl &>/dev/null || ! type ar &>/dev/null; then
    if ! type opkg &>/dev/null; then
      echo "Perl and ar are required to run"
      exit 1
    fi
    echo "Installing perl and ar..."
    opkg update
    opkg install perl ar
  fi
  mkdir -p "$bin_folder"
  repo_download +x bin/alpine-chroot "${bin_folder}/alpine-chroot"
  download +x https://raw.githubusercontent.com/alpinelinux/alpine-chroot-install/v0.14.0/alpine-chroot-install \
    "${bin_folder}/alpine-chroot-install"
  echo "ccbf65f85cdc351851f8ad025bb3e65bae4d5b06  ${bin_folder}/alpine-chroot-install" | sha1sum -c
  mkdir -p "$(dirname "$config_file")"
  cat >"$config_file" <<EOF
repository="${repository}"
branch="${branch}"
bin_folder="${bin_folder}"
chroot_path="${chroot_path}"
alpine_chroot_install_path="${alpine_chroot_install_path}"
alpine_arch=${alpine_arch}
alpine_branch=${alpine_branch}
EOF
  "${bin_folder}/alpine-chroot" true
  ;;
uninstall)
  $SUDO rm -f "${bin_folder}/alpine-chroot"
  $SUDO rm -f "${bin_folder}/alpine-chroot-install"
  while grep -q "${chroot_path}" /proc/mounts; do
    grep "${chroot_path}" /proc/mounts |
      sort -r |
      cut -d' ' -f2 |
      xargs -rn1 $SUDO /bin/umount -lqR
  done
  $SUDO rm -rf "$chroot_path"
  $SUDO rm -f "$config_file"
  ;;
esac
