#!/usr/bin/env bash
# Hapus branch lokal + remote setelah merge
# Usage: ./cleanup-branch.sh [nama-branch]
# Jika tidak diberi argumen, hapus branch saat ini (setelah pindah ke default branch)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

DEFAULT_BRANCH=$(detect_default_branch)
BRANCH_TO_DELETE="${1:-}"

if [ -z "${BRANCH_TO_DELETE}" ]; then
  BRANCH_TO_DELETE=$(git branch --show-current)
fi

if [ "${BRANCH_TO_DELETE}" = "${DEFAULT_BRANCH}" ]; then
  echo "Tidak boleh menghapus default branch (${DEFAULT_BRANCH})."
  exit 1
fi

echo "=== [jcode-workflow] Membersihkan branch: ${BRANCH_TO_DELETE} ==="

git checkout "${DEFAULT_BRANCH}"
git pull origin "${DEFAULT_BRANCH}" 2>/dev/null || true

# Hapus lokal
git branch -d "${BRANCH_TO_DELETE}" 2>/dev/null || git branch -D "${BRANCH_TO_DELETE}" || true

# Hapus remote
git push origin --delete "${BRANCH_TO_DELETE}" 2>/dev/null || echo "→ Branch remote sudah tidak ada atau gagal dihapus."

echo "=== [jcode-workflow] Branch ${BRANCH_TO_DELETE} sudah dibersihkan ==="
