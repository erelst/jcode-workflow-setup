#!/usr/bin/env bash
# [DEPRECATED] Gunakan scripts/push.sh (push-only) + scripts/create-pr.sh (manual PR)
#
# Script ini dipertahankan untuk backward compatibility.
# Isi: push branch, TANPA auto-create PR.
# PR hanya dibuat manual setelah approval via scripts/create-pr.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "⚠ [DEPRECATED] push-and-pr.sh: Gunakan scripts/push.sh + scripts/create-pr.sh"
exec "${SCRIPT_DIR}/push.sh"
