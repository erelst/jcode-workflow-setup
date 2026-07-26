#!/usr/bin/env bash
# Gate: hanya boleh commit jika test hijau.
# Juga cek fmt & clippy untuk Rust (warning=allowed, error=ditolak).
# Dipanggil via jcode hook before_commit / before_push

set -euo pipefail

echo "=== [jcode-workflow] Gate: memeriksa apakah test hijau ==="

# ---------- Rust ----------
if [ -f "Cargo.toml" ]; then
  if command -v cargo >/dev/null 2>&1; then
    echo "→ cargo fmt --check..."
    cargo fmt --check

    echo "→ cargo clippy..."
    # Clippy: warning tidak ditolak, tapi error harus 0
    cargo clippy --quiet 2>&1 | grep -q "^error" && { echo "Clippy error!"; exit 1; } || true

    echo "→ cargo test..."
    cargo test --quiet
  fi
  exit 0
fi

# ---------- Node ----------
if [ -f "package.json" ]; then
  if command -v npm >/dev/null 2>&1; then
    echo "→ npm test..."
    npm test -- --passWithNoTests --watchAll=false 2>/dev/null || npm test -- --passWithNoTests
  elif command -v yarn >/dev/null 2>&1; then
    yarn test --passWithNoTests
  elif command -v pnpm >/dev/null 2>&1; then
    pnpm test -- --passWithNoTests
  fi
  exit 0
fi

# ---------- Python ----------
if [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -d "tests" ]; then
  if command -v pytest >/dev/null 2>&1; then
    echo "→ pytest..."
    pytest -q --tb=no
  elif python -m pytest --version >/dev/null 2>&1; then
    python -m pytest -q --tb=no
  fi
  exit 0
fi

# ---------- Go ----------
if [ -f "go.mod" ]; then
  echo "→ go test..."
  go test ./...
  exit 0
fi

# ---------- Java/Kotlin ----------
if [ -f "pom.xml" ] || [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
  echo "→ Stack Java/Kotlin. Jalankan test manual."
  exit 0
fi

echo "→ Tidak terdeteksi test runner. Lewati gate (tambahkan test segera)."
exit 0
