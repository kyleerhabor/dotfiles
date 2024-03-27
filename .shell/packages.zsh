## Headline

source $ZSHP/headline/headline.zsh-theme

HEADLINE_USER_CMD='' # Superceded HEADLINE_DO_USER
HEADLINE_HOST_CMD='' # Superceded HEADLINE_DO_HOST
HEADLINE_GIT_STATUS_CMD='' # Superceded HEADLINE_DO_GIT_STATUS
HEADLINE_PATH_PREFIX=' '
HEADLINE_BRANCH_PREFIX=' '
HEADLINE_BRANCH_TO_STATUS=' ('
HEADLINE_STATUS_TO_STATUS='|'
HEADLINE_STATUS_END=')'

## zsh-syntax-highlighting

# Makes pasting not highlight by default
# autoload -Uz bracketed-paste-magic
# zle -N bracketed-paste bracketed-paste-magic

## zsh-autosuggestions

source $ZSHP/zsh-autosuggestions/zsh-autosuggestions.zsh

## fast-syntax-highlighting

# Use constant highlight for pasting to not make it super slow.
zle_highlight=("paste:fg=#000000,bg=#ffffff")

source $ZSHP/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
