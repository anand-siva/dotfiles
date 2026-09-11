# GPG needs to know the current TTY for signing
export GPG_TTY="$(tty)"

export PATH="$HOME/.local/bin:$PATH"
