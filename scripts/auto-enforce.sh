#!/usr/bin/env bash
# Auto-enforce ringan setelah turn
# Bisa dipanggil via jcode hook after_turn

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh" 2>/dev/null || true

echo "=== [jcode-workflow] Auto-enforce check ==="

DEFAULT_BRANCH=$(detect_default_branch 2>/dev/null || echo "main")

# Cek apakah ada perubahan yang belum di-commit
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "→ Ada perubahan unstaged/staged. Pastikan test hijau sebelum commit."
fi

# Cek apakah sedang di default branch (peringatan)
CURRENT=$(git branch --show-current 2>/dev/null || echo "unknown")
if [ "${CURRENT}" = "${DEFAULT_BRANCH}" ]; then
  echo "⚠ PERINGATAN: Sedang di default branch (${DEFAULT_BRANCH}). Sebaiknya pindah ke feature branch."
fi

# Cek keberadaan AGENTS.md
if [ ! -f "AGENTS.md" ]; then
  echo "⚠ AGENTS.md tidak ditemukan di root. Workflow strict belum aktif."
fi

# Cek apakah ada CI yang belum selesai (opsional — informatif)
DEFAULT_BRANCH=$(detect_default_branch 2>/dev/null || echo "main")
if [ "${CURRENT}" != "${DEFAULT_BRANCH}" ] && command -v gh &>/dev/null; then
  LAST_RUN=$(gh run list --branch "${CURRENT}" --limit 1 --json status,conclusion 2>/dev/null || echo "")
  if echo "${LAST_RUN}" | grep -q "in_progress"; then
    echo "⚠ CI masih berjalan di branch ini. Jalankan 'scripts/wait-ci.sh' untuk menunggu."
  fi
fi

echo "=== [jcode-workflow] Enforce check selesai ==="
