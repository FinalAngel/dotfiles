#!/bin/zsh

# macos functions #############################
# meet      [code]        start or join a google meet in chrome

# start an instant google meet, or join one with `meet abc-defg-hij`.
# set MEET_ACCOUNT in ~/.localrc (email or account index) to pick the google
# account when several are signed in
function meet() {
  # accept a bare code (abc-defg-hij) as well as a pasted meeting link
  local code="${1#*meet.google.com/}"
  code="${code%%\?*}"
  code="${code//[^a-zA-Z0-9-]/}"
  local url="https://meet.google.com/${code:-new}"

  if [ -n "$MEET_ACCOUNT" ]; then
    url="${url}?authuser=${MEET_ACCOUNT}"
  fi

  echo "Opening ${url}…"
  open -a "Google Chrome" "$url"
}

# write stdin to the system clipboard. the shared aliases (copyssh, copygpg,
# meh, table) call this rather than pbcopy directly, so they keep working on
# linux where the equivalent is xclip or wl-copy
function clipboard() {
  pbcopy
}

# desktop notification, e.g. `long-task; notify "done"`
function notify() {
  local message="${1:-It is finished, whatever it is}";
  terminal-notifier -sound default -message "${message}";
}
