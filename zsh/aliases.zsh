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
# anything else under the divio tree) uses ~/.claude-divio
# --divio / --devguard force a config, otherwise it's picked from $PWD
#
# the divio branch deliberately sets no CLAUDE_CONFIG_DIR. Claude Code keeps
# its state file at ~/.claude.json when the var is unset, but at
# $CLAUDE_CONFIG_DIR/.claude.json when it is set — so pointing this branch at
# ~/.claude-divio would start a second, empty state file and split project
# trust, history and MCP config away from Zed and the desktop app, which never
# see this function. Instead ~/.claude is a symlink to ~/.claude-divio, so
# every entry point lands on the same profile. See claude/install.
# Claude Code re-sends every running subagent's whole transcript to the model
# every 30 s just to refresh the 3-word status in the agents panel, and has no
# switch for it (anthropics/claude-code#86879). claude/no-agent-summary.js is a
# Bun preload that disarms that timer. It matches the timer by source text, so
# an update can silently undo it: after one, spawn an agent and check
# `grep suppressed ~/.cache/no-agent-summary.log`. Only processes started
# through this function get the preload.
claude() {
    local hook=$HOME/.dotfiles/claude/no-agent-summary.js
    local -a hooked=(CC_AGENT_SUMMARY_LOG=$HOME/.cache/no-agent-summary.log)
    case " ${BUN_OPTIONS-} " in
        *" --preload $hook "*) ;;
        *) hooked+=(BUN_OPTIONS="${BUN_OPTIONS:+$BUN_OPTIONS }--preload $hook") ;;
    esac
    case "$1" in
        --divio)    shift; env "${hooked[@]}" claude "$@"; return ;;
        --devguard) shift; env "${hooked[@]}" CLAUDE_CONFIG_DIR=$HOME/.claude-devguard claude "$@"; return ;;
    esac
    if [[ "$PWD" == */divio/* || "$PWD" == */divio ]]; then
        env "${hooked[@]}" claude "$@"
    else
        env "${hooked[@]}" CLAUDE_CONFIG_DIR=$HOME/.claude-devguard claude "$@"
    fi
}

# alias for easy usage
alias enh="enhanced_command"
