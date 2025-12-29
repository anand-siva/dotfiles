#!/usr/bin/env bash
set -e

log "Installing AL2023 specific files"

sudo dnf install -y texinfo

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

log "current stow symlinks"

ls -ltr ~/.gitconfig
ls -ltr ~/.bashrc.d
ls -lts ~/.tmux.conf
lb
ls -lts ~/.config
