#!/bin/zsh
# Invoked by the dark-notify launchd agent (installed by tmux/install)
# whenever macOS switches appearance; re-themes a running tmux server.
# NOT auto-loaded by the shell — only aliases/paths/functions.zsh are.

# launchd uses a minimal PATH
export PATH="/opt/homebrew/bin:$PATH"

function change_background() {
    local mode="light"

    if defaults read -g AppleInterfaceStyle &> /dev/null; then
        mode="dark"
    fi

    command -v tmux &>/dev/null || return 0
    tmux list-sessions &>/dev/null || return 0

    # @theme_mode is set by the sidebar conf files; skip when nothing changed
    local applied="$(tmux show -gv @theme_mode 2>/dev/null)"
    [[ "$applied" == "$mode" ]] && return 0

    tmux source-file ~/.dotfiles/tmux/tmux-statusline-$mode.conf
    tmux source-file ~/.dotfiles/tmux/tmux-sidebar-$mode.conf

    # tmux-agent-sidebar reads its palette once, at sidebar startup, so every
    # running sidebar is restarted per-window to pick up the new colors.
    # Restart per-window rather than via `toggle-all`, which would also open
    # a sidebar in windows that deliberately don't have one.
    local sidebar_bin="$(tmux show -gv @agent_sidebar_bin 2>/dev/null)"
    if [[ -x "$sidebar_bin" ]]; then
        local sb_role sb_win sb_dir
        tmux list-panes -a -F '#{@pane_role}|#{window_id}|#{pane_current_path}' \
            2>/dev/null | while IFS='|' read -r sb_role sb_win sb_dir; do
            [[ "$sb_role" == "sidebar" ]] || continue
            "$sidebar_bin" toggle "$sb_win" "$sb_dir"  # close
            "$sidebar_bin" toggle "$sb_win" "$sb_dir"  # reopen w/ new palette
        done
    fi
}

change_background
