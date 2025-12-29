#!/usr/bin/env bash
set -e

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
