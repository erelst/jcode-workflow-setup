#!/usr/bin/env bash
# Gate: hanya boleh commit jika test hijau.
# Meniru langkah-langkah CI (GitHub Actions) untuk deteksi dini kegagalan.
# Auto-detect stack dari file proyek (Cargo.toml, package.json, dll)

set -euo pipefail

echo "=== [jcode-workflow] Gate: memeriksa apakah test hijau ==="

# ---------- Rust (+ Tauri) ----------
if [ -f "Cargo.toml" ] || [ -f "src-tauri/Cargo.toml" ]; then
  if command -v cargo >/dev/null 2>&1; then
    # Root cargo check (jika ada Cargo.toml)
    if [ -f "Cargo.toml" ]; then
      echo "→ cargo check (--Dwarnings)..."
      RUSTFLAGS="-D warnings" cargo check 2>&1

      echo "→ cargo fmt --check..."
      cargo fmt --check

      echo "→ cargo clippy..."
      cargo clippy 2>&1

      echo "→ cargo test..."
      cargo test --quiet
    fi

    # Tauri backend check (jika ada src-tauri/Cargo.toml)
    if [ -f "src-tauri/Cargo.toml" ]; then
      echo "→ cargo check Tauri backend (--Dwarnings)..."
      RUSTFLAGS="-D warnings" cargo check --manifest-path src-tauri/Cargo.toml 2>&1
    fi
  fi
  exit 0
fi

# ---------- Node ----------
if [ -f "package.json" ]; then
  if command -v npm >/dev/null 2>&1; then
    echo "→ npm ci (atau npm install)..."
    npm ci 2>/dev/null || npm install

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
if [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ] || [ -d "tests" ]; then
  if command -v pytest >/dev/null 2>&1; then
    echo "→ pip install..."
    pip install -r requirements.txt 2>/dev/null || pip install -e . 2>/dev/null || true

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
