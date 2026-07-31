#!/usr/bin/env bash
# jcode-workflow-setup
# Setup otomatis strict workflow ke target proyek
# Usage:
#   ./setup.sh /path/to/target-project
#   ./setup.sh .          # setup di direktori saat ini

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-}"

if [ -z "${TARGET}" ]; then
  echo "Usage: $0 /path/to/target-project"
  echo "       $0 .     # setup di current directory"
  exit 1
fi

TARGET="$(cd "${TARGET}" && pwd)"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║       jcode-workflow-setup – Strict Zero-Thinking          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Target project : ${TARGET}"
echo "Source setup   : ${SCRIPT_DIR}"
echo ""

# Pastikan target adalah git repo (atau inisialisasi)
if [ ! -d "${TARGET}/.git" ]; then
  echo "→ Target belum git repo. Menginisialisasi..."
  (cd "${TARGET}" && git init)
fi

# 1. AGENTS.md
echo "→ Menyalin AGENTS.md ..."
cp "${SCRIPT_DIR}/AGENTS.md" "${TARGET}/AGENTS.md"
echo "  ✓ AGENTS.md"

# 2. Scripts
echo "→ Menyalin scripts/ ..."
mkdir -p "${TARGET}/scripts"
cp "${SCRIPT_DIR}/scripts/"*.sh "${TARGET}/scripts/" 2>/dev/null || true
cp "${SCRIPT_DIR}/scripts/"*.md "${TARGET}/scripts/" 2>/dev/null || true
chmod +x "${TARGET}/scripts/"*.sh 2>/dev/null || true
echo "  ✓ scripts/ (lib, gate-green, create-branch, push, create-pr, merge-to-default, wait-ci, auto-enforce, cleanup-branch, seed-memory-prompt)"

# 3. .jcode skill + config snippet
echo "→ Menyiapkan .jcode/ ..."
mkdir -p "${TARGET}/.jcode/skills/strict-workflow"
cp "${SCRIPT_DIR}/jcode/skills/strict-workflow/SKILL.md" "${TARGET}/.jcode/skills/strict-workflow/"
cp "${SCRIPT_DIR}/jcode/config-snippet.toml" "${TARGET}/.jcode/"
echo "  ✓ .jcode/skills/strict-workflow + config-snippet"

# 4. GitHub Actions template (opsional)
if [ ! -f "${TARGET}/.github/workflows/ci.yml" ]; then
  echo "→ Menambahkan template CI GitHub Actions ..."
  mkdir -p "${TARGET}/.github/workflows"
  cp "${SCRIPT_DIR}/templates/github-actions-ci.yml" "${TARGET}/.github/workflows/ci.yml"
  echo "  ✓ .github/workflows/ci.yml"
else
  echo "→ CI workflow sudah ada, dilewati."
fi

# 5. Deteksi stack utama untuk instruksi khusus
STACK="unknown"
if [ -f "${TARGET}/Cargo.toml" ]; then STACK="rust"; fi
if [ -f "${TARGET}/src-tauri/Cargo.toml" ]; then STACK="tauri"; fi
if [ -f "${TARGET}/package.json" ]; then STACK="node"; fi
if [ -f "${TARGET}/go.mod" ]; then STACK="go"; fi
if [ -f "${TARGET}/pyproject.toml" ] || [ -f "${TARGET}/requirements.txt" ]; then STACK="python"; fi

# 6. Instruksi akhir
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    SETUP SELESAI                           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Stack terdeteksi: ${STACK}"
echo ""
echo "Langkah selanjutnya (sekali saja):"
echo ""
echo "1. Aktifkan hooks di jcode (pilih salah satu):"
echo "   • Edit ~/.jcode/config.toml dan tambahkan:"
echo ""
echo "     [hooks]"
echo "     before_commit = [\"${TARGET}/scripts/gate-green.sh\"]"
echo "     after_turn    = [\"${TARGET}/scripts/auto-enforce.sh\"]"
echo ""
echo "   • Atau copy isi .jcode/config-snippet.toml ke config kamu."
echo ""
echo "2. Pastikan GitHub CLI (gh) terinstall jika ingin manual PR:"
echo "   brew install gh   # atau lihat https://cli.github.com"
echo ""
echo "3. (OPSIONAL) Setup CodeGraph & Ponytail — paste prompt ini ke chat jcode:"
echo ""
echo '   "Setup CodeGraph dan Ponytail untuk jcode:'
echo '    - CodeGraph: https://github.com/colbymchenry/codegraph'
echo '    - Ponytail: https://github.com/DietrichGebert/ponytail'
echo '    Baca kedua repo tersebut, lalu aktifkan CodeGraph MCP dan Ponytail skill'
echo '    sesuai rekomendasi penggunaannya masing-masing."'
echo ""
echo "4. Jalankan jcode di project ini:"
echo "   cd ${TARGET}"
echo "   jcode"
echo ""
echo "5. Coba prompt contoh:"
echo '   "Migrasi endpoint login ke framework baru"'
echo '   "Tambah fitur export CSV di balik feature flag"'
echo ""
echo "  • Deteksi default branch (main atau master)"
echo "  • Tentukan jalur: trivial atau non-trivial"
echo "  • Trivial: 2 opsi (commit langsung / review feedback)"
echo "  • Non-trivial: 3 opsi (merge langsung / PR / review feedback)"
echo "  • Loop review/feedback sampai user pilih commit/merge"
echo "  • Simpan memory setelah merge/commit ke main"
echo "  • Spawn swarm jika tugas besar"
echo ""
echo "Selamat coding tanpa mikir lagi 🚀"
echo ""
