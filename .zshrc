# Powerlevel10k instant prompt (keep near top; console-input code goes above).
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then
  export FPATH="$HOME/.zsh/completions:$FPATH"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Dotfiles repo
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias lazydot="lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias setup_install="$HOME/.config/setup/install_all_osx.sh"

# General
alias v='nvim'
alias la='eza --icons=always --git'
alias ll='eza -al --icons=always --git'
alias moshm4='mosh --server=/opt/homebrew/bin/mosh-server m4'

# Keep zsh-vi-mode from clobbering fzf ctrl-r
zvm_after_init_commands+=('source <(fzf --zsh)')

# zsh plugins (Homebrew)
BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
source "$BREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "$BREW_PREFIX/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && . "$BREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# 1Password CLI plugins
[ -f "$HOME/.config/op/plugins.sh" ] && source "$HOME/.config/op/plugins.sh"

# ShellFish (iOS SSH client helpers — active only under ShellFish)
[ -e "$HOME/.shellfishrc" ] && source "$HOME/.shellfishrc"
