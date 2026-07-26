#!/usr/bin/env bash
# Membuat branch baru dari default branch (main/master) yang terbaru
# Usage: ./create-branch.sh <type> <nama-singkat>
# Contoh: ./create-branch.sh feat auth-migration-login

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

TYPE="${1:-feat}"
NAME="${2:-auto-task}"
BRANCH="${TYPE}/${NAME}"
DEFAULT_BRANCH=$(detect_default_branch)

echo "=== [jcode-workflow] Membuat branch bersih: ${BRANCH} (dari ${DEFAULT_BRANCH}) ==="

# Pastikan kita di git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: bukan git repository"
  exit 1
fi

# Simpan perubahan lokal jika ada (stash)
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "→ Ada perubahan lokal, melakukan stash sementara..."
  git stash push -m "jcode-workflow auto-stash before branch create" || true
fi

# Update default branch
git checkout "${DEFAULT_BRANCH}"
git pull origin "${DEFAULT_BRANCH}" 2>/dev/null || true

# Buat branch baru
git checkout -b "${BRANCH}"

echo "=== [jcode-workflow] Sekarang di branch: ${BRANCH} ==="
echo "DEFAULT_BRANCH=${DEFAULT_BRANCH}"
echo "BRANCH=${BRANCH}"
