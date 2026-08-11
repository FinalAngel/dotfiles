#!/bin/zsh
DOTFILES_ROOT="$HOME/.dotfiles"

# this file is automatically loaded through oh-my-zsh
# the ideal place to load all the other aliases :)
typeset -U config_files
config_files=($DOTFILES_ROOT/**/aliases.zsh)

# load all aliases.zsh files expect for this one
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

# for claude switching
claude() {
    if [[ "$PWD" == */devguard/* || "$PWD" == */devguard
       || "$PWD" == */flow/* || "$PWD" == */flow
       || "$PWD" == */hammerfest/* || "$PWD" == */hammerfest
       || "$PWD" == */seo/* || "$PWD" == */seo ]]; then
        CLAUDE_CONFIG_DIR=~/.claude-devguard command claude "$@"
    else
        command claude "$@"
    fi
}

# alias for easy usage
alias enh="enhanced_command"

# Godot is a .app bundle, so its binary is not on PATH
alias godot="/Applications/Godot.app/Contents/MacOS/Godot"
