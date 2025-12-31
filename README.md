This dotfile repo was inspired by friend Seth Wright

https://github.com/sethawright/dotfiles

# Bootstrap

I keep setup automated with `bootstrap.sh`, and I recommend keeping this section near the top so new installs are obvious. Run it from the repo root:

```bash
./bootstrap.sh
```

What it does:

- Detects macOS vs Linux and runs the matching installer (`install/macos.sh` or `install/linux.sh`)
- macOS: runs `brew bundle` with `packages/Brewfile`, installs Oh My Zsh if needed, then stows configs and scripts
- Linux (AL2023): installs build deps, compiles GNU Stow if missing, then stows configs and scripts
- Runs `install/common.sh` to print out final manual steps (like `~/.gitconfig.local`)

Before running Stow, back up or remove any existing files that would conflict with these symlinks:

- `~/.gitconfig`
- `~/.zshrc`
- `~/.tmux.conf`
- `~/.config/ghostty`
- `~/.config/starship.toml`
- `~/.config/nvim`
- `~/tmux-scripts`
- `~/.bashrc.d` (Linux)

# Requirements

- macOS: Homebrew
- Linux: `dnf` plus build tools for compiling Stow

# Quick Install

```bash
git clone <this-repo>
cd <this-repo>
./bootstrap.sh
```

# Repo Layout

- `bootstrap.sh` and `install/` handle setup
- `packages/` contains the Brewfile
- `config/` is stowable dotfiles
- `scripts/` is stowable helper scripts

# Stow

I use GNU Stow to manage symlinks for these dotfiles. Each top-level folder is a Stow package (for example `config`, `tmux-scripts`, `iterm`), and I stow them from the repo root.

Typical usage:

```bash
stow -d config -t $HOME git zshrc tmux
stow -d config -t $HOME/.config ghostty starship nvim
stow -d scripts -t "$HOME" tmux

```

If I need to remove links, I use `stow -D <package>`. If I need to restow after changes, I run `stow -R <package>`.

# Oh My Zsh

Oh My Zsh is a Zsh framework that makes it easy to manage themes, plugins, and shell defaults. I use it to keep my Zsh setup consistent across machines, and my `.zshrc` and related config live in this repo so they can be symlinked into place with Stow.

# Starship

Starship is a fast, cross-shell prompt that is fully configurable. I use it to make the prompt look clean and informative with things like git status, language versions, and context-sensitive icons. The config lives in this repo and gets symlinked into `~/.config/starship.toml`, so I can tune colors, symbols, and layout to make the prompt look cool without bloating the shell.

# Ghostty

The bootstrap.sh will brew install Ghostty for you. I am not fully sold on it yet, but I like it so far since it is super snappy. 

config location - config/ghostty/ghostty/config

The magic that Ghostty can help you with is mapping Mac Super + commands to print out weird unicode characters

```bash
# keybind these to funky characters then I can use them in tmux
keybind = super+n=text:ç
keybind = super+r=text:÷
keybind = super+shift+bracket_left=text:˙
keybind = super+shift+bracket_right=text:¬
keybind = super+k=text:≈
keybind = super+z=text:⌟
keybind = super+p=text:▸
keybind = super+o=text:⌁
keybind = super+i=text:◈
```

I got this directly from Seth. At first I was so confused why he was doing this. But as I continued my journey I saw why. 

Mapping Super + in tmux becomes a weird problem, so instead we will make ghostty print out these weird characters and then bind those characters to tmux

# Tmux

In my .tmux.conf file you can see I use these characters for bindings

```bash
##### Fun popups
set -g @popup_w "95%"
set -g @popup_h "90%"


# Scratch pad popup
bind -n '◈' run-shell "~/tmux-scripts/scratch-popup.sh '#{pane_current_path}' '#{session_name}' '#{window_name}' 'scratch.md' '#{@popup_w}' '#{@popup_h}'"

# claude or codex popup 
set-environment -g LLM_ASSISTANT "codex"
bind -n '▸' run-shell "~/tmux-scripts/llm-popup-toggle.sh '#{pane_current_path}' '#{session_name}' '#{window_name}' '#{@popup_w}' '#{@popup_h}'"

# Run simple shell 
bind -n '⌁' run-shell "~/tmux-scripts/shell-popup.sh '#{pane_current_path}' '#{session_name}' '#{window_name}' '#{@popup_w}' '#{@popup_h}'"
```
This is the magic where you just hit Super + on Mac and one letter and a tmux popup happens. The beauty of this setup is that these popup- windos are specific to the directory you launched tmux from.

So for each directory you work on you have a seperate set of popup windows. 

Also since we are attaching to the windows, you do not lose the progress on any popup

Current mapping 

super+i: scratch pad neovim popup that writes to ~/scratch.md
super+o: seperate bash terminal to run commands
super+p: llm (codex in my case) popup

# Neovim

I use Neovim with LazyVim as my base configuration:

https://github.com/LazyVim/LazyVim

My leader key is space, and I use a few simple file/buffer actions:

- `space + w` saves the current file
- `space + q` quits the current window
- `space + r` closes the current buffer

Custom plugins I maintain in this repo:

| Plugin | What it does |
| --- | --- |
| Mofiqul/dracula.nvim | Dracula colorscheme for Neovim. |
| mason-org/mason-lspconfig.nvim | Ensures my go-to LSP servers are installed. |
| epwalsh/obsidian.nvim | Obsidian vault workflow inside Neovim with note and link helpers. |
| christoomey/vim-tmux-navigator | Seamless navigation between Neovim and tmux panes. |
| folke/which-key.nvim | Adds a WhichKey group label for Obsidian mappings. |

# Obsidian.nvim

I use `epwalsh/obsidian.nvim` to work in my Obsidian vault directly from Neovim. I keep the leader key as space and group Obsidian actions under `space + o`, with quick keys for daily notes and navigation:

- Vault location: `~/notes/obsidian`

- `space + o + d` today
- `space + o + y` yesterday
- `space + o + t` tomorrow
- `space + o + n` new note
- `space + o + q` quick switch
- `space + o + b` backlinks
- `space + o + l` outgoing links
- `space + o + o` open in Obsidian app
- `space + o + s` search vault
