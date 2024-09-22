# The git configuration to use for managing dotfiles in version control. Information about the repository itself (for
# e.g. the README.md) is stored in ~/.dotfiles (at least, on my system). The design is mostly based on this article:
#
#   https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/
#
# When managing any dotfiles, use `dotfiles`. When managing the repository itself, go to the folder and use `git`. Both
# will list a number of "deleted" files, but this is due to the different working trees. Make sure to be careful so
# only relevant changes are committed.
alias dotfiles="$(command -v git) --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME"

DOWNLOADS=$HOME/Downloads

## Directories
alias cdd="cd $DOWNLOADS"
alias cdv="cd '$DOWNLOADS/[@] Videos'"
alias cddev="cd $HOME/Developer"

## History
alias h='history 1'
alias hs='h | grep'

## Safety
alias rem='rm -d -i'

## Lists
alias lst='ls -hartl'
