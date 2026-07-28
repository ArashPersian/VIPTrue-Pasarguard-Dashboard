#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-}"
EXPECTED_SHA256="${2:-}"

if [[ "$EUID" -ne 0 ]]; then
  echo "Run this installer as root." >&2
  exit 1
fi

if [[ -z "$VERSION" || -z "$EXPECTED_SHA256" ]]; then
  echo "Usage: sudo $0 <version> <expected-sha256>" >&2
  exit 2
fi

case "$VERSION" in
  *[!A-Za-z0-9._-]*)
    echo "Invalid version: $VERSION" >&2
    exit 2
    ;;
esac

BASE_DIR="/var/lib/viptrue/dashboard"
RELEASES_DIR="$BASE_DIR/releases"
TARGET_DIR="$RELEASES_DIR/$VERSION"
CURRENT_LINK="$BASE_DIR/current"
PREVIOUS_LINK="$BASE_DIR/previous"
ARCHIVE_NAME="viptrue-dashboard-${VERSION}.tar.gz"
URL="https://github.com/ArashPersian/VIPTrue-Pasarguard-Dashboard/releases/download/${VERSION}/${ARCHIVE_NAME}"
TEMP_DIR="$(mktemp -d)"
PENDING_DIR=""

cleanup() {
  rm -rf "$TEMP_DIR"
  if [[ -n "$PENDING_DIR" && -d "$PENDING_DIR" ]]; then
    rm -rf "$PENDING_DIR"
  fi
}
trap cleanup EXIT

[[ ! -e "$TARGET_DIR" ]] || {
  echo "Release already exists: $TARGET_DIR" >&2
  exit 1
}

if [[ -e "$CURRENT_LINK" && ! -L "$CURRENT_LINK" ]]; then
  echo "$CURRENT_LINK exists but is not a symlink; refusing to overwrite it." >&2
  exit 1
fi

mkdir -p "$RELEASES_DIR"
curl -4fL --retry 3 --retry-delay 2 \
  --connect-timeout 15 --max-time 300 \
  "$URL" -o "$TEMP_DIR/$ARCHIVE_NAME"

ACTUAL_SHA256="$(sha256sum "$TEMP_DIR/$ARCHIVE_NAME" | awk '{print $1}')"
[[ "$ACTUAL_SHA256" == "$EXPECTED_SHA256" ]] || {
  echo "SHA256 verification failed." >&2
  echo "Expected: $EXPECTED_SHA256" >&2
  echo "Actual:   $ACTUAL_SHA256" >&2
  exit 1
}

if tar -tzf "$TEMP_DIR/$ARCHIVE_NAME" | grep -Eq '(^/|(^|/)\.\.(/|$))'; then
  echo "Archive contains an unsafe path." >&2
  exit 1
fi

PENDING_DIR="$(mktemp -d "$RELEASES_DIR/.${VERSION}.XXXXXX")"
tar -xzf "$TEMP_DIR/$ARCHIVE_NAME" -C "$PENDING_DIR"

[[ -f "$PENDING_DIR/dashboard/index.html" ]] || {
  echo "Archive is missing dashboard/index.html." >&2
  exit 1
}
[[ -d "$PENDING_DIR/statics" ]] || {
  echo "Archive is missing statics/." >&2
  exit 1
}

# mktemp creates the release root with mode 0700. Nginx needs to traverse it.
chmod 0755 "$PENDING_DIR"

mv "$PENDING_DIR" "$TARGET_DIR"
PENDING_DIR=""

OLD_TARGET=""
if [[ -L "$CURRENT_LINK" ]]; then
  OLD_TARGET="$(readlink -f "$CURRENT_LINK")"
  ln -sfn "$OLD_TARGET" "$PREVIOUS_LINK"
fi

ln -s "$TARGET_DIR" "$BASE_DIR/.current-${VERSION}"
mv -Tf "$BASE_DIR/.current-${VERSION}" "$CURRENT_LINK"

if command -v nginx >/dev/null 2>&1 && ! nginx -t; then
  if [[ -n "$OLD_TARGET" ]]; then
    ln -sfn "$OLD_TARGET" "$CURRENT_LINK"
  else
    unlink "$CURRENT_LINK"
  fi
  echo "Nginx validation failed; dashboard symlink rolled back." >&2
  exit 1
fi

if command -v systemctl >/dev/null 2>&1 && systemctl is-active --quiet nginx; then
  systemctl reload nginx
fi

echo "VIPTrue Dashboard installed: $VERSION"
echo "SHA256: $ACTUAL_SHA256"
echo "Current: $CURRENT_LINK -> $(readlink -f "$CURRENT_LINK")"
if [[ -L "$PREVIOUS_LINK" ]]; then
  echo "Rollback helper: scripts/rollback-dashboard.sh"
fi
