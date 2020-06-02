#!/bin/zsh
source "$HOME/.dotfiles/utils/index"

# this file is automatically loaded through oh-my-zsh
# the ideal place to load all the others aliases :)
typeset -U config_files
config_files=($DOTFILES_ROOT/**/aliases.zsh)

# load all aliases.zsh files expect for this one
for file in ${config_files:#*/zsh/aliases.zsh}; do
  source $file
done
