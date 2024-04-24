## Pyenv

export PYENV_ROOT=$HOME/.pyenv
PYENV_BIN=$PYENV_ROOT/bin

[ -d "$PYENV_BIN" ] && export PATH=$PYENV_BIN:$PATH

eval "$(pyenv init - --no-rehash)"
