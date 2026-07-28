#!/usr/bin/env bash
# Push branch saat ini ke remote (tanpa auto-create PR)
# PR hanya dibuat manual via scripts/create-pr.sh setelah di-approve
# Dipanggil setelah commit hijau

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

echo "=== [jcode-workflow] Push branch ke remote ==="

CURRENT_BRANCH=$(git branch --show-current)

# Pastikan ada remote
if ! git remote get-url origin >/dev/null 2>&1; then
  echo "→ Tidak ada remote 'origin'. Skip push."
  exit 0
fi

if is_default_branch "${CURRENT_BRANCH}"; then
  echo "→ Sedang di default branch. Push langsung."
  git push -u origin HEAD
  exit 0
fi

# Push branch non-default
echo "→ Push branch ${CURRENT_BRANCH}..."
git push -u origin HEAD

echo ""
echo "✓ Branch ${CURRENT_BRANCH} sudah di-push."
echo "  Untuk membuat PR (setelah di-approve): jalankan"
echo "    scripts/create-pr.sh"
echo ""
echo "=== [jcode-workflow] Push selesai ==="
