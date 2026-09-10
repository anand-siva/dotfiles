#!/usr/bin/env bash
set -e

log "Install tmux plugins"

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ ! -d "$TPM_DIR" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "Tmux Plugin Manager already installed, skipping"
fi

"$TPM_DIR/bin/install_plugins"

log "You will need to manually add the following for you final config"
lb
log "Create ~/.gitconfig.local:"
cat <<'EOF'
[user]
  name = Anand Siva
  email = anand.siva27@gmail.com
  signingkey = <enter signing signingkey>
EOF

log "Make sure gpg is available"
