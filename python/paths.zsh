export ARCHFLAGS="-arch x86_64"

# python
export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH
export PYTHONPATH=$PYTHONPATH

# virtual environment
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Sites
export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
