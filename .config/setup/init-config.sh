#!/usr/bin/env bash
#
# Bootstrap dotfiles on a fresh machine:
#   curl -fsSL https://raw.githubusercontent.com/wryanzimmerman/dotfiles/main/.config/setup/init-config.sh | bash
#
set -euo pipefail

REPO="https://github.com/wryanzimmerman/dotfiles.git"
GIT_DIR="$HOME/.dotfiles"
BACKUP="$HOME/.dotfiles-backup"

dotfiles() { git --git-dir="$GIT_DIR" --work-tree="$HOME" "$@"; }

if [ -d "$GIT_DIR" ]; then
	echo "==> $GIT_DIR already exists; skipping clone"
else
	echo "==> Cloning dotfiles (HTTPS)"
	git clone --bare "$REPO" "$GIT_DIR"
fi

echo "==> Backing up any pre-existing files to $BACKUP"
dotfiles ls-tree -r HEAD --name-only | while read -r f; do
	if [ -e "$HOME/$f" ]; then
		mkdir -p "$BACKUP/$(dirname "$f")"
		mv "$HOME/$f" "$BACKUP/$f"
	fi
done

echo "==> Checking out dotfiles"
dotfiles checkout
dotfiles config status.showUntrackedFiles no

if [ ! -f "$HOME/.gitconfig.local" ]; then
	echo "==> Scaffolding ~/.gitconfig.local (edit before committing)"
	cat > "$HOME/.gitconfig.local" <<'LOCAL'
[user]
	name = Your Name
	# Uncomment and set before git will let you commit:
	# email = you@example.com
	# signingkey = ~/.ssh/your_key.pub
LOCAL
fi

cat <<'NEXT'

==> Done. Next steps:
  1. Edit ~/.gitconfig.local with this machine's git identity
  2. brew bundle --file ~/.config/setup/Brewfile   (install packages)
  3. iTerm2: point "Load preferences from a custom folder" at ~/.config/iterm2/settings
  4. To push with a non-default GitHub account: gh auth switch -u <account>
NEXT
