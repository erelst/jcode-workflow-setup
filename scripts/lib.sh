#!/usr/bin/env bash
# Shared helpers untuk semua script jcode-workflow

# Deteksi default branch (main atau master)
detect_default_branch() {
  local branch=""

  # 1. Coba dari remote HEAD
  branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || true)

  # 2. Jika kosong, cek lokal
  if [ -z "$branch" ]; then
    if git show-ref --verify --quiet refs/heads/main; then
      branch="main"
    elif git show-ref --verify --quiet refs/heads/master; then
      branch="master"
    else
      # Fallback: ambil branch saat ini atau main
      branch=$(git branch --show-current 2>/dev/null || echo "main")
    fi
  fi

  echo "$branch"
}

# Apakah branch ini default branch?
is_default_branch() {
  local current="$1"
  local default
  default=$(detect_default_branch)
  [ "$current" = "$default" ]
}
