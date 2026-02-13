export ZSHP=$ZSH/packages

zmodload zsh/complist

autoload -U up-line-or-beginning-search down-line-or-beginning-search
autoload -Uz compinit

## Options

setopt autocd

# Enable command spellchecking.
setopt correct

# Disable exiting via Control-D.
setopt ignoreeof

# Allow inline comments.
setopt interactivecomments

# Support escaping quotes more simply (e.g. 'don''t' = don't).
setopt rcquotes

## Styling

# Use menu selection style for completion.
zstyle ':completion:*' menu select

# Use case-insensitive completion capable of matching anywhere in a string.
#
# FIXME: This includes protocols as completions.
#
# https://stackoverflow.com/a/22627273/14695788
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

KEY_UP=kcuu1
KEY_DOWN=kcud1
KEY_BACKTAB=kcbt

# https://github.com/ohmyzsh/ohmyzsh/blob/fff073b55defed72a0a1aac4e853b165f208735b/lib/key-bindings.zsh#L37
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }

  function zle-line-finish() {
    echoti rmkx
  }

  zle -N zle-line-init
  zle -N zle-line-finish
fi

## History

export HISTSIZE=8192 # 2^13
export SAVEHIST=$HISTSIZE

# Scroll up/down history by command (e.g. "yt-dlp ...")
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey $terminfo[$KEY_UP] up-line-or-beginning-search
bindkey $terminfo[$KEY_DOWN] down-line-or-beginning-search

# setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

## Completion

bindkey -M menuselect $terminfo[$KEY_BACKTAB] reverse-menu-complete

compinit

# Scripts
. $ZSH/aliases.zsh
. $ZSH/programs.zsh
. $ZSH/packages.zsh
