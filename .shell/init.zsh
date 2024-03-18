export ZSHP=$ZSH/packages

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

key[up]=$terminfo[kcuu1]
key[down]=$terminfo[kcud1]

# History
export HISTSIZE=8192 # 2^13

# setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Completion
autoload -Uz compinit && compinit

# Scroll up/down history by command (e.g. "yt-dlp ...")
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey $key[up] up-line-or-beginning-search
bindkey $key[down] down-line-or-beginning-search

# Scripts
source $ZSH/aliases.zsh
source $ZSH/programs.zsh
source $ZSH/packages.zsh
