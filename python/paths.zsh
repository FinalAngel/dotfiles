#!/bin/zsh
export PYTHONPATH=$PYTHONPATH

# virtual environment
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=${CODE_DIR:-$HOME/Sites}
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export PIP_REQUIRE_VIRTUALENV=true # to avoid global installs
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# pyenv. only the root and its bin are set up here — the actual `pyenv init`
# lives in system/paths.zsh, which caches it and also handles virtualenv-init.
# the unguarded `eval "$(pyenv init -)"` that used to sit here ran it a second
# time on every shell start, and printed "command not found" on any machine
# without pyenv, which is every linux box these dotfiles configure
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# pipx
# eval "$(register-python-argcomplete pipx)"
