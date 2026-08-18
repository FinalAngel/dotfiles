#!/bin/zsh
DOTFILES_ROOT="$HOME/.dotfiles"

# this file is automatically loaded through oh-my-zsh
# the ideal place to load all the other functions :)
typeset -U config_files
config_files=($DOTFILES_ROOT/**/functions.zsh)

# skip the other platform's topic — see zsh/aliases.zsh
if [[ "$(uname -s)" == "Darwin" ]]; then
  local skip_os="linux"
else
  local skip_os="macos"
fi

# load all functions.zsh files expect for this one and the other platform's
for file in ${${config_files:#*/zsh/functions.zsh}:#*/$skip_os/*}; do
  source $file
done
