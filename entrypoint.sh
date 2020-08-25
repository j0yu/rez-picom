set -euf -o pipefail

FORK="${FORK:-yshui/picom}"
VERSION="${VERSION:-v8}"
PREFIX="${INSTALL_PATH:-/picom}"

# Get sources
git clone -b "$VERSION" https://github.com/"$FORK".git .
git submodule update --init --recursive

meson --buildtype=release -Dprefix="$PREFIX" . build
ninja -C build install

# Copy over default configuration
mkdir -p "$PREFIX"/etc/xdg
cp picom.sample.conf "$PREFIX"/etc/xdg
cp picom.sample.conf "$PREFIX"/etc/xdg/picom.conf

# Copy all libs
mkdir -p "$PREFIX"/lib64
ldd "$PREFIX"/bin/picom \
| sed -n "s|.*=> /lib64|/lib64|p" \
| cut -f1 -d" " \
| xargs -i find {} -newer /etc/yum.repos.d \
| xargs cp -vL --target-directory="$PREFIX"/lib64
