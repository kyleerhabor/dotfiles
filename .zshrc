export ZSH=$HOME/.shell

. $ZSH/init.zsh

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/ffmpeg-full/bin:$PATH"

# Created by `pipx` on 2024-08-06 06:30:54
export PATH="$PATH:/Users/kyleerhabor/.local/bin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/opt/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/kyleerhabor/.opam/opam-init/init.zsh' ]] || source '/Users/kyleerhabor/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null END opam configuration

# Load Angular CLI autocompletion.
# source <(ng completion script)

export PSIRVER_HOME=$HOME/Psirver
