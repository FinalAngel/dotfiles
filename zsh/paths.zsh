#!/bin/zsh
DOTFILES_ROOT="$HOME/.dotfiles"

# this file is automatically loaded through oh-my-zsh
# the ideal place to load all the other paths :)
typeset -U config_files
config_files=($DOTFILES_ROOT/**/paths.zsh)

# system/paths.zsh rebuilds $PATH from scratch, so it must load first
source "$DOTFILES_ROOT/system/paths.zsh"

# load all paths.zsh files except for this one and system
for file in ${${config_files:#*/zsh/paths.zsh}:#*/system/paths.zsh}; do
  source $file
done
