name = "picom"

__version__ = "v8"
version = __version__.replace("v", "") + "+local.1.0.0"

variants = [["os-CentOS-7", "arch-x86_64"]]

build_command = r"""
set -euf -o pipefail

cp -v \
    "$REZ_BUILD_SOURCE_PATH"/Dockerfile \
    "$REZ_BUILD_SOURCE_PATH"/entrypoint.sh \
    "$REZ_BUILD_PATH"

IIDFILE=$(mktemp "$REZ_BUILD_PATH"/DockerImageXXXXXX)

# In rez resolved version:
# - REZ_OS_MAJOR_VERSION = centos
# - REZ_OS_MINOR_VERSION = 7
docker build --rm \
    --build-arg CENTOS_MAJOR="$REZ_OS_MINOR_VERSION" \
    --iidfile "$IIDFILE" \
    "$REZ_BUILD_PATH"

CONTAINER_ARGS=()
[ -t 1 ] && CONTAINER_ARGS+=("-it") || :
CONTAINER_ARGS+=("--env" "INSTALL_PATH={INSTALL_PATH}")
CONTAINER_ARGS+=("--env" "VERSION={version}")
CONTAINER_ARGS+=("$(cat $IIDFILE)")

if [ $REZ_BUILD_INSTALL -eq 1 ]
then
    CONTAINER_ID=$(docker create "{CONTAINER_ARGS}")
    docker start -ia "$CONTAINER_ID"
    docker cp "$CONTAINER_ID":"{INSTALL_PATH}"/. "{INSTALL_PATH}"
    docker rm "$CONTAINER_ID"
fi
""".format(
    CONTAINER_ARGS="${{CONTAINER_ARGS[@]}}",
    INSTALL_PATH="${{REZ_BUILD_INSTALL_PATH:-/usr/local}}",
    version=__version__,
)


def commands():
    import os.path

    env.PATH.append(os.path.join("{root}", "bin"))
    env.LD_LIBRARY_PATH.append(os.path.join("{root}", "lib64"))
    env.XDG_CONFIG_DIRS.append(os.path.join("{root}", "etc", "xdg"))
    env.XDG_DATA_DIRS.append(os.path.join("{root}", "share"))


@late()
def tools():
    import os

    bin_path = os.path.join(str(this.root), "bin")
    return os.listdir(bin_path)

