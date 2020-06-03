#!/bin/zsh
export PYTHONPATH=$PYTHONPATH

# virtual environment
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Sites
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export PIP_REQUIRE_VIRTUALENV=true # to avoid global installs
export VIRTUALENVWRAPPER_PYTHON=python # uses alias

# load virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh
