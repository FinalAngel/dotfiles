#!/usr/bin/env bash
# Stop hook: print one Claude Code tip per turn.
#
# Tips are surfaced as `systemMessage`, which Claude Code shows to you and does
# not feed back into the conversation — so the tip never costs context and never
# nudges Claude. Rotation is sequential rather than random, so every tip in the
# list is seen once before any repeats.
#
# Failure is always silent: every error path exits 0 with empty stdout. On Stop,
# Claude Code sends stdout to the debug log and never to the transcript, so a
# broken tip file can't decorate your turns with hook-error notices.

set -u

# opt out for a session without uninstalling: CLAUDE_TIPS=0
if [ "${CLAUDE_TIPS:-1}" = "0" ]; then
  exit 0
fi

# hooks run with no controlling terminal and no shell profile, so derive the
# plugin root from the script itself when CLAUDE_PLUGIN_ROOT isn't exported
root="${CLAUDE_PLUGIN_ROOT:-}"
if [ -z "$root" ]; then
  root=$(cd "$(dirname "$0")/.." 2>/dev/null && pwd) || exit 0
fi

# Installing copies the plugin into a per-profile cache, so the bundled tips
# file is a snapshot taken at install time. Prefer the checked-out source when
# it is present, so editing tips.txt takes effect on the very next turn instead
# of after a reinstall. Falls back to the bundled copy everywhere else, which is
# what a machine that only has the installed plugin will use.
tips_file=""
for candidate in \
  "${CLAUDE_TIPS_FILE:-}" \
  "$HOME/.dotfiles/claude/marketplace/plugins/claude-tips/tips/tips.txt" \
  "$root/tips/tips.txt"; do
  if [ -n "$candidate" ] && [ -r "$candidate" ]; then
    tips_file="$candidate"
    break
  fi
done
[ -n "$tips_file" ] || exit 0

# skip blank lines and # comments
tips=()
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    '' | '#'*) continue ;;
  esac
  tips[${#tips[@]}]="$line"
done < "$tips_file"

count=${#tips[@]}
[ "$count" -gt 0 ] || exit 0

# state is machine-local on purpose: ~/.claude is synced through iCloud, and a
# cursor that churns on every turn does not belong in a synced directory
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/claude-tips"
state_file="$state_dir/index"

idx=0
if [ -r "$state_file" ]; then
  read -r idx < "$state_file" 2>/dev/null || idx=0
fi
case "$idx" in
  '' | *[!0-9]*) idx=0 ;;
esac

tip="${tips[$((idx % count))]}"

# advance the cursor; if this fails you simply see the same tip again
if mkdir -p "$state_dir" 2>/dev/null; then
  printf '%s\n' "$(((idx + 1) % count))" > "$state_file" 2>/dev/null || :
fi

# JSON-escape: backslash first, then double quote
esc=${tip//\\/\\\\}
esc=${esc//\"/\\\"}

printf '{"systemMessage":"💡 %s"}\n' "$esc"
