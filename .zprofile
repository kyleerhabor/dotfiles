export PATH="/opt/anaconda3/bin:$PATH"

## Pyenv

export PYENV_ROOT=$HOME/.pyenv
PYENV_BIN=$PYENV_ROOT/bin

[ -d "$PYENV_BIN" ] && export PATH=$PYENV_BIN:$PATH

eval "$(pyenv init - --no-rehash)"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Created by `pipx` on 2024-08-06 06:30:54
export PATH="$PATH:/Users/kyleerhabor/.local/bin"
