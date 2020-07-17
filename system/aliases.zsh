#!/bin/zsh
# detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
	export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
else # macOS `ls`
	colorflag="-G"
	export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# utilities
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"
alias cd.='cd $(readlink -f .)' # go to real dir (i.e. if current dir is linked)

alias c="clear"
alias q="exit"
alias l="ls -lF ${colorflag}"
alias ll="/usr/local/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias la="ls -lAF ${colorflag}"
alias ls="command ls ${colorflag}"
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"
alias path="echo -e ${PATH//:/\\n}"
alias reload="source $HOME/.zshrc"
alias top="htop"

# directories
alias apps="cd /Applications"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias lib="cd $HOME/Library"
alias ws="cd $HOME/Sites"
alias dotfiles="cd $HOME/.dotfiles"

# development
alias dc="docker-compose"
alias dcrun="dc run --rm"
alias dclog="dc logs -f"
alias dclint="docker run --env-file=.lint -it -v $(pwd):/app divio/lint /bin/lint"

# helper
alias cleanup="find . | grep -E '(\.DS_STORE|__pycache__|\.pyc|\.pyo|\.eggs|\.egg-info|\.tox|\.coverage$)' | xargs rm -rf"
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias listgpg="gpg --list-secret-keys --keyid-format LONG"
alias copygpg="pbcopy < gpg --armor --export $1"
alias flush="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias urlencode="python -c 'import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);'"
alias update="sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup"
alias week="date +%V"
alias 8000="kill -9 $(lsof -i TCP:8000 | grep LISTEN | awk '{print $2}')"

# divio
alias ddivio="ALDRYN_HOST=dev.aldryn.net divio"
alias ldivio="ALDRYN_HOST=local.aldryn.net divio"

# fun stuff
alias meh="echo '¯\_(ツ)_/¯' | pbcopy"
