#!/usr/bin/env bash
set -euo pipefail

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
chmod -R go-w "$(brew --prefix)/share" # https://docs.brew.sh/Shell-Completion

# Curated packages
brew bundle --file "$HOME/.config/setup/Brewfile"

# Node via nvm
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
. "$(brew --prefix nvm)/nvm.sh"
nvm install 20

# tmux plugin manager
[ -d "$HOME/.tmux/plugins/tpm" ] || git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
