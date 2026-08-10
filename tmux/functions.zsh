#!/bin/zsh
# Keep tmux-agent-sidebar out of tmuxinator's window layouts.
#
# The sidebar's `after-new-window` hook splits a sidebar pane into every new
# window. tmuxinator then applies the project's layout with `select-layout`,
# which folds that sidebar pane into the arrangement — so the window comes up
# scrambled. The guard disables sidebar auto-creation while the layout is
# built, then restores it from a detached job (tmuxinator attaches and blocks
# until detach, so restoring inline would not work).
#
# NOTE: never name a loop variable `path` in auto-loaded zsh files — zsh ties
# it to $PATH and clobbering it breaks the shell.
function _sidebar_layout_guard() {
    command -v tmux >/dev/null 2>&1 || return 0

    # `tmux set -g` needs a server; starting one is a no-op if it already
    # exists and cheap if it doesn't (tmuxinator would start it regardless)
    command tmux start-server 2>/dev/null || return 0

    local sidebar_prev
    sidebar_prev="$(command tmux show -gv @sidebar_enabled 2>/dev/null)"
    command tmux set -g @sidebar_enabled off 2>/dev/null

    (
        command sleep 15
        command tmux set -g @sidebar_enabled "${sidebar_prev:-on}" 2>/dev/null
    ) &!
}

function tmuxinator() {
    _sidebar_layout_guard
    command tmuxinator "$@"
}

# predictable place for the ssh socket, so a detached tmux session keeps a
# working agent after you reconnect over ssh
SOCK="/tmp/ssh-agent-$USER-screen"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]; then
    rm -f $SOCK
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi
