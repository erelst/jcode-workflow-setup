#!/usr/bin/env bash
# Wait for CI to pass on the current branch's latest commit.
# Exit 0 if CI passes, exit 1 if CI fails or times out.
#
# Usage:
#   ./scripts/wait-ci.sh [timeout_minutes]
#
# Dependencies: gh (GitHub CLI), git

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh" 2>/dev/null || true

TIMEOUT_MIN="${1:-15}"
TIMEOUT_SEC=$((TIMEOUT_MIN * 60))
POLL_INTERVAL=10

CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
echo "=== [jcode-workflow] Wait for CI: branch=${CURRENT_BRANCH} timeout=${TIMEOUT_MIN}m ==="

if ! command -v gh &>/dev/null; then
  echo "ERROR: gh (GitHub CLI) tidak ditemukan. Install dulu: https://cli.github.com"
  exit 1
fi

# Cek apakah gh sudah login
if ! gh auth status 2>&1 | grep -q "Logged in"; then
  echo "ERROR: gh belum login. Jalankan 'gh auth login' dulu."
  exit 1
fi

echo "→ Menunggu CI selesai (timeout ${TIMEOUT_MIN} menit)..."
echo ""

ELAPSED=0
POLL_INTERVAL=10

while [ $ELAPSED -lt $TIMEOUT_SEC ]; do
  # Ambil run terakhir untuk branch ini
  RUN_JSON=$(gh run list --branch "${CURRENT_BRANCH}" --limit 1 --json databaseId,status,conclusion,headSha 2>/dev/null || echo "")

  if [ -z "${RUN_JSON}" ] || [ "${RUN_JSON}" = "[]" ]; then
    echo "→ Belum ada CI run untuk branch ini. Menunggu..."
    sleep "${POLL_INTERVAL}"
    ELAPSED=$((ELAPSED + POLL_INTERVAL))
    continue
  fi

  STATUS=$(echo "${RUN_JSON}" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d[0]['status'] if d else '')" 2>/dev/null || echo "")
  CONCLUSION=$(echo "${RUN_JSON}" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d[0].get('conclusion','') if d else '')" 2>/dev/null || echo "")

  if [ "${STATUS}" = "completed" ]; then
    if [ "${CONCLUSION}" = "success" ]; then
      echo ""
      echo "✅ CI PASSED! Semua check hijau."
      exit 0
    else
      echo ""
      echo "❌ CI FAILED! Conclusion: ${CONCLUSION}"
      echo "   Lihat detail: gh run view --web"
      exit 1
    fi
  fi

  # Status masih in_progress / waiting / queued
  printf "\r→ CI masih berjalan... (%dm:%ds)" $((ELAPSED / 60)) $((ELAPSED % 60))
  sleep "${POLL_INTERVAL}"
  ELAPSED=$((ELAPSED + POLL_INTERVAL))
done

echo ""
echo "⏰ TIMEOUT! CI belum selesai setelah ${TIMEOUT_MIN} menit."
echo "   Cek manual: gh run list --branch ${CURRENT_BRANCH}"
exit 1
