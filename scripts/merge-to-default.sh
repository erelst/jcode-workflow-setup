#!/usr/bin/env bash
# Merge branch saat ini langsung ke default branch (tanpa PR)
# Usage: ./merge-to-default.sh
# Jalankan setelah branch di-push dan CI hijau
# Akan bertanya ke user sebelum push ke remote

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
  echo "→ Branch ${CURRENT_BRANCH} belum di-push. Push diperlukan untuk merge."
  echo "   Jalankan 'scripts/push.sh' dulu atau lanjutkan merge lokal saja."
  read -r -p "→ Push dulu? (y/N): " PUSH_FIRST
  if [[ "${PUSH_FIRST}" =~ ^[Yy]$ ]]; then
    git push -u origin HEAD
  fi
fi

echo "→ Checkout ${DEFAULT_BRANCH}..."
git fetch origin "${DEFAULT_BRANCH}" 2>/dev/null || true
git checkout "${DEFAULT_BRANCH}"
git pull origin "${DEFAULT_BRANCH}" 2>/dev/null || true

echo "→ Merge ${CURRENT_BRANCH} ke ${DEFAULT_BRANCH}..."
git merge "${CURRENT_BRANCH}" --no-ff -m "feat: merge ${CURRENT_BRANCH} to ${DEFAULT_BRANCH}"

# Tanya user untuk push
read -r -p "→ Push ${DEFAULT_BRANCH} ke remote? (y/N): " PUSH_ANSWER
if [[ "${PUSH_ANSWER}" =~ ^[Yy]$ ]]; then
  echo "→ Push ke remote..."
  git push origin "${DEFAULT_BRANCH}"
  echo "✓ Branch ${DEFAULT_BRANCH} ter-push."
else
  echo "→ Skip push. ${DEFAULT_BRANCH} hanya di lokal."
fi

echo "→ Hapus branch lokal ${CURRENT_BRANCH}..."
git branch -d "${CURRENT_BRANCH}" 2>/dev/null || true

if [[ "${PUSH_ANSWER}" =~ ^[Yy]$ ]]; then
  echo "→ Hapus branch remote ${CURRENT_BRANCH}..."
  git push origin --delete "${CURRENT_BRANCH}" 2>/dev/null || true
fi

echo "✓ Merge selesai. Sekarang di branch ${DEFAULT_BRANCH}."
echo "=== [jcode-workflow] Selesai ==="
