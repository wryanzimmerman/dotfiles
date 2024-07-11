#!/bin/bash

# Install homebrew if not already installed
if ! type brew
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# https://docs.brew.sh/Shell-Completion
chmod -R go-w "$(brew --prefix)/share"

brew install neovim
brew install tmux
brew install mosh
brew install fzf
brew install lazygit
brew install gh
brew install btop
brew install cmake
brew install nvm
brew install fsouza/prettierd/prettierd
brew install ripgrep
brew install gcc
brew install fd
brew install luarocks
brew install awscli

nvm install 20

brew install zsh-vi-mode
brew install zsh-autosuggestions
brew install powerlevel10k
brew install zsh-fast-syntax-highlighting

brew install --cask iterm2
brew install --cask 1password
brew install --cask 1password-cli
brew install --cask expressvpn
brew install --cask google-chrome
brew install --cask firefox@developer-edition
brew install --cask signal

brew install --cask font-jetbrains-mono-nerd-font

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

