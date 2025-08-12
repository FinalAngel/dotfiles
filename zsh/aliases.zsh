#!/bin/zsh
DOTFILES_ROOT="$HOME/.dotfiles"

# this file is automatically loaded through oh-my-zsh
# the ideal place to load all the other aliases :)
typeset -U config_files
config_files=($DOTFILES_ROOT/**/aliases.zsh)

# load all aliases.zsh files expect for this one
for file in ${config_files:#*/zsh/aliases.zsh}; do
  source $file
done

function enhanced_command() {
    local temp_file=$(mktemp)
    { eval "$@"; } > "$temp_file" 2>&1
    cat "$temp_file"
    echo ""
    rm -f "$temp_file"
}

# alias for easy usage
alias enh="enhanced_command"
