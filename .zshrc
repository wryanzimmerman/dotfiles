# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Dotfiles repo alias
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias lazydot="lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias setup_install="$HOME/.config/setup/install_all_osx.sh"

# General aliases
alias v='nvim'
alias ll='ls -al'

# Prevent zsh-vi-mode from overriding fzf ctrl-r:
zvm_after_init_commands+=('source <(fzf --zsh)')

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
source $(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $(brew --prefix)/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
