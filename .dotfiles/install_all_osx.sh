#!/bin/bash

if ! type brew
then
    # Install homebrew 
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install neovim
brew install tmux
brew install mosh
brew install lazygit
brew install gh

brew install --cask iterm2
brew install --cask 1password
brew install --cask 1password-cli
brew install --cask expressvpn
brew install --cask google-chrome
brew install --cask firefox@developer-edition
brew install --cask signal


