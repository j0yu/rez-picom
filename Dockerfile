ARG CENTOS_MAJOR=7
FROM centos:$CENTOS_MAJOR

# See https://github.com/yshui/picom#build
# libx11
# libx11-xcb
# libXext
# xproto
# xcb
# xcb-damage
# xcb-xfixes
# xcb-shape
# xcb-renderutil
# xcb-render
# xcb-randr
# xcb-composite
# xcb-image
# xcb-present
# xcb-xinerama
# xcb-glx
# pixman
# libdbus (optional, disable with the -Ddbus=false meson configure flag)
# libconfig (optional, disable with the -Dconfig_file=false meson configure flag)
# libGL (optional, disable with the -Dopengl=false meson configure flag)
# libpcre (optional, disable with the -Dregex=false meson configure flag)
# libev
# uthash
RUN yum install -y \
        epel-release \
        centos-release-scl \
    && yum install -y \
        git \
        meson \
        ninja-build \
        asciidoc \
        devtoolset-7 \
        glibc-devel \
        libX11-devel \
        libxcb-devel \
        libXext-devel \
        xorg-x11-proto-devel \
        xcb-util-devel \
        xcb-util-renderutil-devel \
        libXrandr-devel \
        libXcomposite-devel \
        xcb-util-image-devel \
        xcb-util-wm-devel \
        libXinerama-devel \
        glx-utils \
        libglvnd-glx \
        pixman-devel \
        dbus-devel \
        libconfig-devel \
        libglvnd-devel \
        mesa-libGL-devel \
        pcre-devel \
        libev-devel \
        uthash-devel

WORKDIR /usr/local/src
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "scl", "enable", "devtoolset-7", "bash /entrypoint.sh" ]
