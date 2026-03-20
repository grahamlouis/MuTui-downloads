#!/bin/sh
set -eu

REPO="${REPO:-grahamlouis/MuTui-downloads}"
BIN_NAME="${BIN_NAME:-terminal-daw}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
VERSION="${VERSION:-latest}"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "missing required command: $1" >&2
    exit 1
  fi
}

need_cmd curl
need_cmd tar
need_cmd uname

os="$(uname -s)"
arch="$(uname -m)"

case "$os" in
  Darwin) platform="apple-darwin" ;;
  Linux) platform="unknown-linux-gnu" ;;
  *)
    echo "unsupported operating system: $os" >&2
    exit 1
    ;;
esac

case "$arch" in
  arm64|aarch64) cpu="aarch64" ;;
  x86_64|amd64) cpu="x86_64" ;;
  *)
    echo "unsupported architecture: $arch" >&2
    exit 1
    ;;
esac

target="${cpu}-${platform}"

if [ "$VERSION" = "latest" ]; then
  need_cmd sed
  VERSION="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | sed -n 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"
  if [ -z "$VERSION" ]; then
    echo "failed to determine latest release for ${REPO}" >&2
    exit 1
  fi
fi

archive="${BIN_NAME}-${VERSION}-${target}.tar.gz"
url="https://github.com/${REPO}/releases/download/${VERSION}/${archive}"

tmpdir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT INT TERM

echo "Downloading ${archive}..."
curl -fL "$url" -o "$tmpdir/$archive"

mkdir -p "$INSTALL_DIR"
tar -xzf "$tmpdir/$archive" -C "$tmpdir"

install -m 755 "$tmpdir/$BIN_NAME" "$INSTALL_DIR/$BIN_NAME"

echo
echo "Installed ${BIN_NAME} ${VERSION} to ${INSTALL_DIR}/${BIN_NAME}"
case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo "Note: ${INSTALL_DIR} is not currently on PATH."
    echo "Add this to your shell profile if needed:"
    echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
    ;;
esac
