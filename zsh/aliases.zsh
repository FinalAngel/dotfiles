#!/bin/zsh
DOTFILES_ROOT="$HOME/.dotfiles"

# this file is automatically loaded through oh-my-zsh
# the ideal place to load all the other aliases :)
typeset -U config_files
config_files=($DOTFILES_ROOT/**/aliases.zsh)

# the platform topics are mutually exclusive: macos/aliases.zsh is `defaults`
# and `pbcopy` all the way down, linux/aliases.zsh is its counterpart. loading
# the wrong one would shadow the working aliases with broken ones
if [[ "$(uname -s)" == "Darwin" ]]; then
  local skip_os="linux"
else
  local skip_os="macos"
fi

# load all aliases.zsh files expect for this one and the other platform's
for file in ${${config_files:#*/zsh/aliases.zsh}:#*/$skip_os/*}; do
  source $file
done

function enhanced_command() {
    local temp_file=$(mktemp)
    { eval "$@"; } > "$temp_file" 2>&1
    cat "$temp_file"
    echo ""
    rm -f "$temp_file"
}

# for claude switching. devguard is the default config; divio work (and
# anything else under the divio tree) uses the plain ~/.claude config
claude() {
    if [[ "$PWD" == */divio/* || "$PWD" == */divio ]]; then
        command claude "$@"
    else
        CLAUDE_CONFIG_DIR=~/.claude-devguard command claude "$@"
    fi
}

# alias for easy usage
alias enh="enhanced_command"

# Harvest time tracking (bin/harvest)
alias hv="harvest"
