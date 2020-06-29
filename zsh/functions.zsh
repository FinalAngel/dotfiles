#!/bin/zsh
DOTFILES_ROOT="$HOME/.dotfiles"

# this file is automatically loaded through oh-my-zsh
# the ideal place to load all the other functions :)
typeset -U config_files
config_files=($DOTFILES_ROOT/**/functions.zsh)

# load all functions.zsh files expect for this one
for file in ${config_files:#*/zsh/functions.zsh}; do
  source $file
done
