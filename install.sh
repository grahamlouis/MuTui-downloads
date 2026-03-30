#!/bin/sh
set -eu

REPO="${REPO:-grahamlouis/MuTui-downloads}"
BIN_NAME="${BIN_NAME:-terminal-daw}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
VERSION="${VERSION:-latest}"
APP_ROOT="${APP_ROOT:-}"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "missing required command: $1" >&2
    exit 1
  fi
}

need_cmd curl
need_cmd tar
need_cmd uname
need_cmd python3

os="$(uname -s)"
arch="$(uname -m)"

case "$os" in
  Darwin)
    platform="apple-darwin"
    : "${APP_ROOT:=$HOME/Library/Application Support/MuTui}"
    ;;
  Linux)
    platform="unknown-linux-gnu"
    : "${APP_ROOT:=${XDG_DATA_HOME:-$HOME/.local/share}/mutui}"
    ;;
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

resolve_latest_compatible_version() {
  archive_ext="$1"
  python3 - "$REPO" "$BIN_NAME" "$target" "$archive_ext" <<'PY'
import json
import sys
import urllib.request

repo, bin_name, target, archive_ext = sys.argv[1:]
url = f"https://api.github.com/repos/{repo}/releases?per_page=20"
with urllib.request.urlopen(url) as response:
    releases = json.load(response)

for release in releases:
    if release.get("draft"):
        continue
    tag = release.get("tag_name")
    expected = f"{bin_name}-{tag}-{target}{archive_ext}"
    if any(asset.get("name") == expected for asset in release.get("assets", [])):
        print(tag)
        break
PY
}

if [ "$VERSION" = "latest" ]; then
  VERSION="$(resolve_latest_compatible_version ".tar.gz")"
  if [ -z "$VERSION" ]; then
    echo "failed to determine latest compatible release for ${REPO}" >&2
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
if [ -f "$tmpdir/mutui-setup" ]; then
  install -m 755 "$tmpdir/mutui-setup" "$INSTALL_DIR/mutui-setup"
fi

copy_missing_assets() {
  src_dir="$1"
  dest_dir="$2"
  [ -d "$src_dir" ] || return 0
  mkdir -p "$dest_dir"
  for src in "$src_dir"/*.aif; do
    [ -e "$src" ] || continue
    dest="$dest_dir/$(basename "$src")"
    if [ ! -e "$dest" ]; then
      install -m 644 "$src" "$dest"
    fi
  done
}

copy_missing_assets "$tmpdir/assets/drum/user" "$APP_ROOT/drum/user"
copy_missing_assets "$tmpdir/assets/synth/user" "$APP_ROOT/synth/user"

echo
echo "Installed ${BIN_NAME} ${VERSION} to ${INSTALL_DIR}/${BIN_NAME}"
if [ -f "$INSTALL_DIR/mutui-setup" ]; then
  echo "Installed macOS setup helper to ${INSTALL_DIR}/mutui-setup"
fi
echo "Runtime data root: ${APP_ROOT}"
case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo "Note: ${INSTALL_DIR} is not currently on PATH."
    echo "Add this to your shell profile if needed:"
    echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
    ;;
esac
