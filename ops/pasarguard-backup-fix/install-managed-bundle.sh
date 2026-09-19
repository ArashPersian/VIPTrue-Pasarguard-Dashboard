#!/usr/bin/env bash
set -euo pipefail

# Installs a pinned PasarGuard scripts bundle whose backup library contains the
# VIPTrue TimescaleDB empty-catalog portability fix. The official system CLI is
# left untouched. Automated backups can call the managed bundle directly.

readonly UPSTREAM_COMMIT="1fce1b19aaa54449ec0abdc4098b49027a170705"
readonly UPSTREAM_BASE="https://raw.githubusercontent.com/PasarGuard/scripts/${UPSTREAM_COMMIT}"
readonly INSTALL_DIR="${VIPTRUE_PASARGUARD_SCRIPTS_DIR:-/opt/viptrue-pasarguard-scripts}"
readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly PATCH_FILE="${SCRIPT_DIR}/pasarguard-timescaledb-empty-catalog.patch"

if [ "${EUID}" -ne 0 ]; then
    printf 'Run as root.\n' >&2
    exit 1
fi

for command_name in curl patch sha256sum mktemp install; do
    command -v "$command_name" >/dev/null 2>&1 || {
        printf 'Missing required command: %s\n' "$command_name" >&2
        exit 1
    }
done

[ -s "$PATCH_FILE" ] || {
    printf 'Patch file not found: %s\n' "$PATCH_FILE" >&2
    exit 1
}

stage="$(mktemp -d /opt/.viptrue-pasarguard-scripts.XXXXXX)"
cleanup() { rm -rf "$stage"; }
trap cleanup EXIT
mkdir -p "$stage/lib"

download() {
    local source_path="$1" destination="$2" expected_sha="$3"
    curl -fsSL --connect-timeout 10 --retry 3 \
        "${UPSTREAM_BASE}/${source_path}" -o "$destination"
    printf '%s  %s\n' "$expected_sha" "$destination" | sha256sum -c - >/dev/null
}

download pasarguard.sh "$stage/pasarguard" \
    569307f27fbc06a5cc75fb6e79237b562582a737cd335e50aba2ae1f86eed2a2
download lib/common.sh "$stage/lib/common.sh" \
    5839701d94019f2e53d95eb76b68ca1d7e3e3c059c994c38c982e5eb74588d22
download lib/system.sh "$stage/lib/system.sh" \
    25a665482b42af1d4322f1b1d7dbd4954679eaf38416a75d167d07272fe49243
download lib/docker.sh "$stage/lib/docker.sh" \
    0de3b5d1ed4e26ba4097d82567a607436cdad57b50453d286d258dca2caffe31
download lib/github.sh "$stage/lib/github.sh" \
    3dff27cd5f869b12a9043084d9c023aec3718bde34b91e492a65fa28c668c7ec
download lib/env.sh "$stage/lib/env.sh" \
    c96ea2c045e9ad82acb612327a561c05b6420dbdb8dc04e7c466de63fcf55230
download lib/pasarguard-backup.sh "$stage/lib/pasarguard-backup.sh" \
    6e0216289c7e1f9d89ea064b71853f43e9a7af102ba8da59d9d9b45a0f477093
download lib/pasarguard-restore.sh "$stage/lib/pasarguard-restore.sh" \
    a1bea283017943b05b128ec44429ffeb1c55883c44779fccf1bd02706dff21df

patch --directory="$stage" -p1 <"$PATCH_FILE" >/dev/null
printf '%s  %s\n' \
    9289200ab28263016a8b4523346028773cefccf52336c3905d3368e19f070002 \
    "$stage/lib/pasarguard-backup.sh" | sha256sum -c - >/dev/null

chmod 0755 "$stage/pasarguard"
chmod 0644 "$stage/lib/"*.sh
bash -n "$stage/pasarguard" "$stage/lib/"*.sh

previous=""
if [ -e "$INSTALL_DIR" ]; then
    previous="${INSTALL_DIR}.pre-$(date -u +%Y%m%dT%H%M%SZ)"
    mv "$INSTALL_DIR" "$previous"
fi

if ! mv "$stage" "$INSTALL_DIR"; then
    [ -n "$previous" ] && [ -e "$previous" ] && mv "$previous" "$INSTALL_DIR"
    exit 1
fi
trap - EXIT

printf 'Installed managed PasarGuard scripts bundle at %s\n' "$INSTALL_DIR"
[ -z "$previous" ] || printf 'Previous bundle retained at %s\n' "$previous"
