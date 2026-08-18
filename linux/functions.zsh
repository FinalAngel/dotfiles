#!/bin/zsh
# Linux counterparts to macos/functions.zsh. Only one of the two is loaded —
# see the skip_os filter in zsh/functions.zsh.

# write stdin to the system clipboard, the counterpart to pbcopy on macOS.
# wayland and X11 need different tools, and a headless box has neither — say so
# rather than failing with a bare "command not found"
function clipboard() {
  if command -v wl-copy > /dev/null && [[ -n "$WAYLAND_DISPLAY" ]]; then
    wl-copy
  elif command -v xclip > /dev/null && [[ -n "$DISPLAY" ]]; then
    xclip -selection clipboard
  elif command -v xsel > /dev/null && [[ -n "$DISPLAY" ]]; then
    xsel --clipboard --input
  else
    # still print what was piped in, so the value is at least selectable
    cat
    print -u2 "clipboard: no display and no clipboard tool, printed instead"
    return 1
  fi
}

# desktop notification, e.g. `long-task; notify "done"`. notify-send needs a
# session bus, which a headless box does not have — fall back to the terminal
# bell and a line of output so the call still means something over ssh
function notify() {
  local message="${1:-It is finished, whatever it is}"

  if command -v notify-send > /dev/null && [[ -n "$DBUS_SESSION_BUS_ADDRESS" ]]; then
    notify-send "${message}"
  else
    print "\a${message}"
  fi
}
