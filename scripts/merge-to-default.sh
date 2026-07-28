#!/usr/bin/env bash
# Merge branch saat ini langsung ke default branch (tanpa PR)
# Usage: ./merge-to-default.sh
# Jalankan setelah branch di-push dan CI hijau

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

DEFAULT_BRANCH=$(detect_default_branch)
CURRENT_BRANCH=$(git branch --show-current)

echo "=== [jcode-workflow] Merge langsung ke ${DEFAULT_BRANCH} ==="

# Validasi
if is_default_branch "${CURRENT_BRANCH}"; then
  echo "→ Sedang di default branch. Tidak perlu merge."
  exit 0
fi

# Cek apakah branch sudah di-push
if ! git ls-remote --exit-code origin "${CURRENT_BRANCH}" >/dev/null 2>&1; then
  echo "→ Branch ${CURRENT_BRANCH} belum di-push. Jalankan scripts/push.sh dulu."
  exit 1
fi

echo "→ Checkout ${DEFAULT_BRANCH}..."
git fetch origin "${DEFAULT_BRANCH}"
git checkout "${DEFAULT_BRANCH}"
git pull origin "${DEFAULT_BRANCH}"

echo "→ Merge ${CURRENT_BRANCH} ke ${DEFAULT_BRANCH}..."
git merge "${CURRENT_BRANCH}" --no-ff -m "feat: merge ${CURRENT_BRANCH} to ${DEFAULT_BRANCH}"

echo "→ Push ${DEFAULT_BRANCH} ke remote..."
git push origin "${DEFAULT_BRANCH}"

echo "→ Hapus branch ${CURRENT_BRANCH} (lokal & remote)..."
git branch -d "${CURRENT_BRANCH}" 2>/dev/null || true
git push origin --delete "${CURRENT_BRANCH}" 2>/dev/null || true

echo "✓ Merge selesai. Sekarang di branch ${DEFAULT_BRANCH}."
echo "=== [jcode-workflow] Selesai ==="
