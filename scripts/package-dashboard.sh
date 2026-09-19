#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${1:-}"

if [[ -z "$VERSION" ]]; then
  echo "Usage: $0 <version>" >&2
  exit 2
fi

BUILD_DIR="$REPO_DIR/dashboard/build"
OUTPUT_DIR="$REPO_DIR/dist"
STAGE_DIR="$(mktemp -d)"
trap 'rm -rf "$STAGE_DIR"' EXIT

[[ -f "$BUILD_DIR/index.html" ]] || {
  echo "Missing dashboard build. Run ./build_dashboard.sh first." >&2
  exit 1
}

mkdir -p "$STAGE_DIR/dashboard" "$OUTPUT_DIR"
cp -a "$BUILD_DIR/index.html" "$STAGE_DIR/dashboard/index.html"
cp -a "$BUILD_DIR/404.html" "$STAGE_DIR/dashboard/404.html"
cp -a "$BUILD_DIR/statics" "$STAGE_DIR/statics"

find "$BUILD_DIR" -maxdepth 1 -type f \
  ! -name 'index.html' \
  ! -name '404.html' \
  -exec cp -a {} "$STAGE_DIR/" \;

ARCHIVE="$OUTPUT_DIR/viptrue-dashboard-${VERSION}.tar.gz"
tar -C "$STAGE_DIR" -czf "$ARCHIVE" .
(
  cd "$OUTPUT_DIR"
  sha256sum "$(basename "$ARCHIVE")" > "$(basename "$ARCHIVE").sha256"
)

echo "$ARCHIVE"
cat "$ARCHIVE.sha256"
