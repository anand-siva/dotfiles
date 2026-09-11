#!/usr/bin/env bash
set -e

export PATH="$HOME/.local/bin:$PATH"

log "Install Codex CLI"

if ! command -v codex >/dev/null 2>&1; then
  (
    set -e

    CODEX_INSTALLER="$(mktemp)"
    trap 'rm -f "$CODEX_INSTALLER"' EXIT

    curl -fsSL https://chatgpt.com/codex/install.sh -o "$CODEX_INSTALLER"
    sh "$CODEX_INSTALLER"
  )
else
  echo "Codex CLI already installed, skipping"
fi

log "Install Claude Code"

if ! command -v claude >/dev/null 2>&1; then
  (
    set -e

    CLAUDE_INSTALLER="$(mktemp)"
    trap 'rm -f "$CLAUDE_INSTALLER"' EXIT

    curl -fsSL https://claude.ai/install.sh -o "$CLAUDE_INSTALLER"
    bash "$CLAUDE_INSTALLER"
  )
else
  echo "Claude Code already installed, skipping"
fi

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
