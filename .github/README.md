# Dotfiles Repository

## 2024 Rewrite & Refactor Goals:

1. Consolidate all secrets into 1Password using `op` cli
1. Make environment setup portable and quick to build on new machines
1. Standardize installed package and application lists through `brew` and `brew --cask`
1. Consolidate config into one repository (no more separate `nvim` and `tmux` repos, separate `Iterm2` prefs, etc)
1. Simplify and reduce number of config files and package managers
    - Removed `oh-my-zsh`
    - Removed `antidote`
1. Improve startup times of `zsh`, `tmux`, and `neovim`
1. Leverage linux support in `brew` to make a compatible osx/ubuntu config
1. Just generally move more of my life under `git` control.
