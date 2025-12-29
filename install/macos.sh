#!/usr/bin/env bash
set -e

BREWFILE="packages/Brewfile"

log "Installing MacOS specific files"

log "Install brewfile ${BREWFILE}"

log "packages to install:"
lb

cat $BREWFILE
lb
brew bundle install --file=$BREWFILE
lb

if [ -d "$HOME/.oh-my-zsh" ]; then
  log "Oh My Zsh is installed and active"
  lb
else
  log "Oh My Zsh is not installed or not active"
  log "Install OhMyZsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  lb
fi

log "stow symlinks"
lb
stow -d config -t $HOME git zshrc tmux
stow -d config -t $HOME/.config ghostty starship nvim
stow -d scripts -t "$HOME" tmux

log "final stow symlinks"
lb

ls -ltr ~/.gitconfig
ls -ltr ~/.zshrc
ls -lts ~/.tmux.conf
ls -lts ~/tmux-scripts
lb
ls -lts ~/.config
