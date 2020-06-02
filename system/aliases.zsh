#!/bin/zsh
alias reload!=". ~/.zshrc"

# add alias to start and adapt dotfiles
alias dot="cd ~/.dotfiles && code ."

# =====================================================
# MY OLD ALIASES

echo "Loaded ALIASES"

# PATH
# export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH
export PYTHONPATH=$PYTHONPATH
export MANPATH="/usr/local/man:$MANPATH"

# Virtual Environment
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Sites
export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2
source /usr/local/bin/virtualenvwrapper.sh

# Owner
export USER_NAME="Angelo Dini"
# eval "$(pyenv init -)"

# FileSearch
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

#mkdir and cd
function mkcd() { mkdir -p "$@" && cd "$_"; }

# Custom
alias ls="ls -FG"
alias ip="ifconfig | grep netmask | grep -v 127.0.0.1"
alias ws="cd ~/Sites/"
alias wsc="cd ~/Sites/_cloud/"
alias wsd="cd ~/Sites/_projects/"
alias venv="source env/bin/activate"
alias denv="deactivate"
alias coreshock="ssh finalangel@10.0.1.29"
alias python="python3"
alias pip="pip3"

# python
# export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
# export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

# productivity
alias rock="cd ~/Library/Application\ Support/Steam/steamapps/common/Rocksmith2014/dlc && open ."
alias wipe="find . | grep -E '(__pycache__|\.pyc|\.pyo|\.DS_STORE|\.eggs|\.egg-info$)' | xargs rm -rf"
alias lancet="/Users/finalangel/.virtualenvs/lancet/bin/lancet"
alias system="sudo htop"
alias youtube="youtube-dl -f bestvideo+bestaudio"
alias cat="ccat"
alias top="htop"
alias gt="gittower ."

# docker
alias dc="docker-compose"
alias dcrunserver="dc run --rm web python manage.py runserver 0.0.0.0:80"
alias dcpdb="dc run --rm --service-ports web"
alias dcrun="dc run --rm web"
alias dclog="dc logs -f"

function py() { python2 $1 }
# function dc() { docker-compose $1 }
function server () {
    local port="${1:-8000}"
    sleep 1 && open "http://localhost:${port}/" &
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

alias dclint="docker run --env-file=.lint -it -v $(pwd):/app divio/lint /bin/lint"

# custom Vadim shit
backup_cp() {
    local now=$(date +'%Y-%m-%d.%H.%M')
    local version=$(cat src/version.py | sed 's/.*"\(.*\)".*/\1/')
    docker exec control-panel_postgres_1 pg_dump postgres://control:cQyDbLGT3HrPmFqdY4hlVSitKA0ExXUg@postgres:5432/control --file /app/${now}.dump
    zip ${version}.${now}.zip -r data ${now}.dump
    mv ${version}.${now}.zip ~/Desktop
    rm ${now}.dump
}
