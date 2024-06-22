#!/user/bin/env bash

git clone --bare git@github.com:mrjones2014/dotfiles.git $HOME/.dotfiles

# define dotfiles alias locally since the dotfiles
# aren't installed on the system yet
function dotfiles {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# checkout dotfiles from repo
dotfiles checkout
dotfiles config status.showUntrackedFiles no
