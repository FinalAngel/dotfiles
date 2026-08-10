#!/usr/bin/env bash

# general functions ###########################
# dataurl   $source
# f         $name         file search
# fs        [options]     show dir/file sizes
# mkd       $path         make dir
# o         $path         open path
# r         $name         quick grep
# server                  start server from dir
# targz     $source       create .tar.gz
# tre                     open nice tree view
# custom functions ############################
# backup_cp               backup cp database

# shorthand for file search
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

# determine size of a file or total size of a directory
function fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh;
  else
    local arg=-sh;
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@";
  else
    du $arg .[^.]* ./*;
  fi;
}

# dreate a new directory and enter it
function mkd() { mkdir -p "$@" && cd "$_"; }

# create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
  local tmpFile="${@%/}.tar";
  tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

  size=$(
    stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
    stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
  );

  local cmd="";
  if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
    # the .tar file is smaller than 50 MB and Zopfli is available; use it
    cmd="zopfli";
  else
    if hash pigz 2> /dev/null; then
      cmd="pigz";
    else
      cmd="gzip";
    fi;
  fi;

  echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
  "${cmd}" -v "${tmpFile}" || return 1;
  [ -f "${tmpFile}" ] && rm "${tmpFile}";

  zippedSize=$(
    stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
    stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
  );

  echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}

# create a data URL from a file
function dataurl() {
  local mimeType=$(file -b --mime-type "$1");
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8";
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}";
  sleep 1 && open "http://localhost:${port}/" &
  python3 -m http.server "$port";
}

# one command to unpack any archive format
function extract() {
  if [[ -f $1 ]]; then
    case $1 in
      *.tar.bz2) tar xvjf $1;;
      *.tar.gz) tar xvzf $1;;
      *.tar.xz) tar xvJf $1;;
      *.tar.lzma) tar --lzma xvf $1;;
      *.bz2) bunzip2 $1;;
      *.rar) unrar $1;;
      *.gz) gunzip $1;;
      *.tar) tar xvf $1;;
      *.tbz2) tar xvjf $1;;
      *.tgz) tar xvzf $1;;
      *.zip) unzip $1;;
      *.Z) uncompress $1;;
      *.7z) 7z x $1;;
      *.dmg) hdiutil mount $1;;
      *) echo "'$1' cannot be extracted via extract()";;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# desktop notification, e.g. `long-task; notify "done"`
function notify() {
  local message="${1:-It is finished, whatever it is}";
  terminal-notifier -sound default -message "${message}";
}

# deploy a divio app and get notified about the outcome
function deploy() {
  local server="${1:-test}";
  local folder="$(basename "$(pwd)")";
  divio app deploy ${server} && notify "deployed ${folder}" || notify "failed to deploy ${folder}";
}

# normalize `open` across Linux, macOS, and Windows.
# this is needed to make the `o` function (see below) cross-platform.
if [ ! $(uname -s) = 'Darwin' ]; then
  if grep -q Microsoft /proc/version; then
    # Ubuntu on Windows using the Linux subsystem
    alias open='explorer.exe';
  else
    alias open='xdg-open';
  fi
fi

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
  if [ $# -eq 0 ]; then
    open .;
  else
    open "$@";
  fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
  tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}
