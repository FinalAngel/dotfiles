#!/bin/zsh
DOTFILES_ROOT="$HOME/.dotfiles"

# this file is automatically loaded through oh-my-zsh
# the ideal place to load all the others paths :)
typeset -U config_files
config_files=($DOTFILES_ROOT/**/paths.zsh)

# load all paths.zsh files expect for this one
for file in ${config_files:#*/zsh/paths.zsh}; do
  source $file
done
