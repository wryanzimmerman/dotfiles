#!/bin/bash

# Install homebrew if not already installed
if ! type brew
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install neovim
brew install tmux
brew install mosh
brew install fzf
brew install lazygit
brew install gh

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


