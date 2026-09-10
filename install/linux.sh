#!/usr/bin/env bash
set -e

log "Installing AL2023 specific files"

sudo dnf install -y texinfo

log "Install Neovim"

if ! command -v nvim >/dev/null 2>&1; then
  (
    set -e

    case "$(uname -m)" in
      x86_64)
        NVIM_ARCH="x86_64"
        ;;
      aarch64 | arm64)
        NVIM_ARCH="arm64"
        ;;
      *)
        echo "Unsupported architecture for Neovim: $(uname -m)" >&2
        exit 1
        ;;
    esac

    NVIM_DIR="nvim-linux-${NVIM_ARCH}"
    NVIM_TARBALL="${NVIM_DIR}.tar.gz"
    NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/${NVIM_TARBALL}"
    NVIM_TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$NVIM_TMP_DIR"' EXIT

    curl -fL "$NVIM_URL" -o "$NVIM_TMP_DIR/$NVIM_TARBALL"
    sudo mkdir -p /opt /usr/local/bin
    sudo tar xzf "$NVIM_TMP_DIR/$NVIM_TARBALL" -C /opt
    sudo ln -sfn "/opt/$NVIM_DIR/bin/nvim" /usr/local/bin/nvim
  )
else
  echo "Neovim already installed, skipping"
fi

nvim --version

log "Install tmux"

TMUX_VERSION="3.7c"

if ! command -v tmux >/dev/null 2>&1 || [[ "$(tmux -V)" != "tmux $TMUX_VERSION" ]]; then
  sudo dnf install -y \
    bison \
    gcc \
    libevent-devel \
    make \
    ncurses-devel \
    pkgconf-pkg-config \
    tar

  (
    set -e

    TMUX_TARBALL="tmux-${TMUX_VERSION}.tar.gz"
    TMUX_URL="https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/${TMUX_TARBALL}"
    TMUX_TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TMUX_TMP_DIR"' EXIT

    curl -fL "$TMUX_URL" -o "$TMUX_TMP_DIR/$TMUX_TARBALL"
    tar xzf "$TMUX_TMP_DIR/$TMUX_TARBALL" -C "$TMUX_TMP_DIR"
    cd "$TMUX_TMP_DIR/tmux-${TMUX_VERSION}"
    ./configure --prefix=/usr/local
    make -j"$(nproc)"
    sudo make install
  )

  hash -r
else
  echo "tmux $TMUX_VERSION already installed, skipping"
fi

tmux -V

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

mkdir -p "$HOME/.config"

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
