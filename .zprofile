# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Nvm
export NVM_DIR="$HOME/.nvm"

# Neovide

# if [ $__CFBundleIdentifier = "com.neovide.neovide" ]; then
#   # Node needs to be loaded before Neovim starts (else it won't recognize it).
#   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# fi

# MacPorts

export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
