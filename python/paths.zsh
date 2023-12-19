#!/bin/zsh
export PYTHONPATH=$PYTHONPATH

# virtual environment
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Sites
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export PIP_REQUIRE_VIRTUALENV=true # to avoid global installs
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# pipx
# eval "$(register-python-argcomplete pipx)"
