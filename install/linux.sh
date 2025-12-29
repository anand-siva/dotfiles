#!/usr/bin/env bash
set -e

log "Installing AL2023 specific files"

sudo dnf install -y texinfo

if ! command -v tree-sitter >/dev/null 2>&1; then
  log "Install tree-sitter with rust"

  # LLVM / Clang deps (safe if already installed)
  sudo dnf install -y clang clang-devel llvm llvm-devel clang-libs

  # Install Rust if missing
  if ! command -v cargo >/dev/null 2>&1; then
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    source "$HOME/.cargo/env"
  fi

  # Install tree-sitter CLI
  cargo install tree-sitter-cli
fi

log "compile stow"

(
  set -e

  STOW_VERSION="2.4.1"
  STOW_TARBALL="stow-${STOW_VERSION}.tar.gz"
  STOW_URL="https://ftp.gnu.org/gnu/stow/${STOW_TARBALL}"

  # Build deps (minimal for tarball)
  sudo dnf install -y gcc make perl perl-core tar

  cd "$HOME"

  # Skip if already installed
  if command -v stow >/dev/null; then
    echo "stow already installed, skipping"
    exit 0
  fi

  # Download once
  if [[ ! -f "$STOW_TARBALL" ]]; then
    curl -LO "$STOW_URL"
  fi

  # Extract & build
  tar xzf "$STOW_TARBALL"
  cd "stow-${STOW_VERSION}"

  ./configure
  make
  sudo make install
)

stow --version

lb
log "stow symlinks"
lb

stow -d config -t "$HOME" git tmux bashrc
stow -d config -t "$HOME/.config" nvim
stow -d scripts -t "$HOME" tmux

log "current stow symlinks"

ls -ltr ~/.gitconfig
ls -ltr ~/.bashrc.d
ls -lts ~/.tmux.conf
ls -lts ~/tmux-scripts
lb
ls -lts ~/.config
