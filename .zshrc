# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/ryan/.zsh/completions:"* ]]; then export FPATH="/Users/ryan/.zsh/completions:$FPATH"; fi
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
# alias ll='ls -al'
# alias ls='eza --icons=always --git'
alias la='eza --icons=always --git'
alias ll='eza -al --icons=always --git'


# Prevent zsh-vi-mode from overriding fzf ctrl-r:
zvm_after_init_commands+=('source <(fzf --zsh)')

# Source zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
source $(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $(brew --prefix)/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

if command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# alias meterparse="~/code/metron/metron-product-repo/bin/-darwin"
#
# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /opt/homebrew/bin/terraform terraform
#
# # The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/ryan/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ryan/google-cloud-sdk/path.zsh.inc'; fi
#
# # The next line enables shell command completion for gcloud.
# if [ -f '/Users/ryan/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ryan/google-cloud-sdk/completion.zsh.inc'; fi
#
#
export PATH=$(go env GOPATH)/bin:$PATH
#
source /Users/ryan/.config/op/plugins.sh
. "/Users/ryan/.deno/env"
test -e "$HOME/.shellfishrc" && source "$HOME/.shellfishrc"

#
# # Add mosh server to firewall exceptions
# fix_mosh_server() {
#   local fw='/usr/libexec/ApplicationFirewall/socketfilterfw'
#   local mosh_sym="$(which mosh-server)"
#   local mosh_abs="$(readlink -f $mosh_sym)"
#
#   sudo "$fw" --setglobalstate off
#   sudo "$fw" --add "$mosh_sym"
#   sudo "$fw" --unblockapp "$mosh_sym"
#   sudo "$fw" --add "$mosh_abs"
#   sudo "$fw" --unblockapp "$mosh_abs"
#   sudo "$fw" --setglobalstate on
# }


# Created by `pipx` on 2025-08-27 23:24:24
export PATH="$PATH:/Users/ryan/.local/bin"
