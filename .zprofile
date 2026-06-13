# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export EDITOR="nvim"
export VISUAL="nvim"
export CLICOLOR=1

export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"
[ -d "$HOMEBREW_PREFIX/opt/libpq/bin" ] && export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"
command -v go >/dev/null 2>&1 && export PATH="$(go env GOPATH)/bin:$PATH"
[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"
