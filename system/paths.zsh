#!/bin/zsh
export ARCHFLAGS="-arch $(uname -m)"

# required helpers
prepend_path() { [ -d $1 ] && PATH="$1:$PATH"; }
is_executable() { type "$1" > /dev/null 2>&1; }

# start with system path
# Retrieve it from getconf, otherwise it's just current $PATH
is_executable getconf && PATH=$($(command -v getconf) PATH)

# prepend new items to path (if directory exists)
prepend_path "/bin"
prepend_path "/usr/bin"
prepend_path "/usr/local/bin"
prepend_path "/sbin"
prepend_path "/usr/sbin"
prepend_path "/usr/local/sbin"
prepend_path "$HOME/.dotfiles/bin"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# remove duplicates (preserving prepended items)
# source: http://unix.stackexchange.com/a/40755
PATH=$(echo -n $PATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')

# export the path
export PATH

# get pyenv to work, needs to be declared here.
# the init output is cached — spawning pyenv twice plus its startup rehash
# costs ~300ms; the cache regenerates when pyenv is updated and the rehash
# happens in python/update instead of on every shell start
if is_executable pyenv; then
  _pyenv_init_cache="$HOME/.cache/pyenv-init.zsh"
  if [[ ! -s "$_pyenv_init_cache" || "$(command -v pyenv)" -nt "$_pyenv_init_cache" ]]; then
    mkdir -p "$HOME/.cache"
    { pyenv init -; pyenv virtualenv-init -; } | grep -v "command pyenv rehash" > "$_pyenv_init_cache"
  fi
  source "$_pyenv_init_cache"
fi
