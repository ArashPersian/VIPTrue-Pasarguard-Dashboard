#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/var/lib/viptrue/dashboard"
CURRENT_LINK="$BASE_DIR/current"
PREVIOUS_LINK="$BASE_DIR/previous"

[[ "$EUID" -eq 0 ]] || {
  echo "Run this rollback as root." >&2
  exit 1
}

[[ -L "$PREVIOUS_LINK" ]] || {
  echo "No previous dashboard release is available." >&2
  exit 1
}

PREVIOUS_TARGET="$(readlink -f "$PREVIOUS_LINK")"
[[ -d "$PREVIOUS_TARGET" ]] || {
  echo "Previous release directory is missing: $PREVIOUS_TARGET" >&2
  exit 1
}

CURRENT_TARGET=""
if [[ -L "$CURRENT_LINK" ]]; then
  CURRENT_TARGET="$(readlink -f "$CURRENT_LINK")"
fi

ln -s "$PREVIOUS_TARGET" "$BASE_DIR/.current-rollback"
mv -Tf "$BASE_DIR/.current-rollback" "$CURRENT_LINK"

if command -v nginx >/dev/null 2>&1 && ! nginx -t; then
  if [[ -n "$CURRENT_TARGET" ]]; then
    ln -sfn "$CURRENT_TARGET" "$CURRENT_LINK"
  fi
  echo "Nginx validation failed; rollback was reverted." >&2
  exit 1
fi

if command -v systemctl >/dev/null 2>&1 && systemctl is-active --quiet nginx; then
  systemctl reload nginx
fi

if [[ -n "$CURRENT_TARGET" ]]; then
  ln -sfn "$CURRENT_TARGET" "$PREVIOUS_LINK"
fi

echo "Dashboard rolled back to: $PREVIOUS_TARGET"
