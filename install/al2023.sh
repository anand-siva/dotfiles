#!/usr/bin/env bash
set -e

log "Installing AL2023 specific files"

log "compile stow"

(
  cd "$HOME"
  git clone https://github.com/gitGNU/gnu_stow.git gnu_stow
  cd gnu_stow
  ./configure
  make
  sudo make install
)

stow --version
