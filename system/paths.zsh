#!/bin/zsh

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
prepend_path "/usr/local/opt/coreutils/libexec/gnubin"
prepend_path "/usr/local/opt/gnu-sed/libexec/gnubin"
prepend_path "/usr/local/opt/grep/libexec/gnubin"
prepend_path "/usr/local/opt/python/libexec/bin"
prepend_path "/usr/local/opt/ruby/bin"
prepend_path "$HOME/.dotfiles/bin"
prepend_path "$HOME/bin"
prepend_path "/sbin"
prepend_path "/usr/sbin"
prepend_path "/usr/local/sbin"

# remove duplicates (preserving prepended items)
# source: http://unix.stackexchange.com/a/40755
PATH=$(echo -n $PATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')

# export the path
export PATH
