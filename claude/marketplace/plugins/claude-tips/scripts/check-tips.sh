#!/usr/bin/env bash
# Compare tips/tips.txt against the live Claude Code command reference and
# report drift, so the tips do not quietly rot as Claude Code changes.
#
# Reports three things:
#   new     — commands documented upstream that no tip mentions yet
#   removed — commands a tip still teaches that upstream marks as removed
#   gone    — commands a tip mentions that upstream no longer documents at all
#
# Exit codes: 0 no drift, 1 drift found, 2 could not check (offline, layout
# change upstream). A non-zero exit is information, not a failure.

set -u

DOCS_URL="${CLAUDE_TIPS_DOCS_URL:-https://code.claude.com/docs/en/commands.md}"
porcelain=0
[ "${1:-}" = "--porcelain" ] && porcelain=1

root="${CLAUDE_PLUGIN_ROOT:-}"
if [ -z "$root" ]; then
  root=$(cd "$(dirname "$0")/.." 2>/dev/null && pwd) || exit 2
fi

# same live-source preference as tip.sh: check the file you actually edit
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
[ -n "$tips_file" ] || { echo "check-tips: no tips file found" >&2; exit 2; }

tmp=$(mktemp -d) || exit 2
trap 'rm -rf "$tmp"' EXIT

if ! curl -sSL --max-time 20 -o "$tmp/commands.md" "$DOCS_URL" 2>"$tmp/err"; then
  echo "check-tips: could not fetch $DOCS_URL" >&2
  sed 's/^/  /' "$tmp/err" >&2
  exit 2
fi

# Every command that owns a row in the reference table.
grep -oE '^\| `/[a-z][a-z-]*' "$tmp/commands.md" \
  | sed 's/^| `//' | sort -u > "$tmp/documented"

# Rows whose description opens with "Removed" are documented tombstones.
grep -oE '^\| `/[a-z][a-z-]*[^|]*\| \*?\*?Removed' "$tmp/commands.md" \
  | grep -oE '^\| `/[a-z][a-z-]*' | sed 's/^| `//' | sort -u > "$tmp/tombstoned"

# Everything upstream knows about: table rows plus any bare backticked token,
# which picks up aliases such as `/cost` and `/bashes` that never get a row of
# their own. Backticks matter: they keep doc links like /docs/en/memory out.
# Rows are unioned in because a row's backticks usually wrap arguments too
# (`/loop [interval] [prompt]`), so the command never appears bare.
grep -oE '`/[a-z][a-z-]*`' "$tmp/commands.md" | tr -d '`' > "$tmp/mentioned_raw"
cat "$tmp/documented" "$tmp/mentioned_raw" | sort -u > "$tmp/mentioned"

# Commands our tips teach, ignoring comments.
grep -vE '^\s*#' "$tips_file" \
  | grep -oE '(^|[[:space:]])/[a-z][a-z-]*' \
  | sed 's/^[[:space:]]*//' | sort -u > "$tmp/tipped"

# Commands deliberately not tipped, so the report stays a short list of things
# to actually decide on rather than the same 59 rows every week.
# Sits next to the tips file when there is one, so a custom list can carry its
# own exclusions, but falls back to the checked-out list rather than silently
# reporting all ~50 deliberately untipped commands as drift.
: > "$tmp/ignored"
for ignore_file in \
  "$(dirname "$tips_file")/ignore.txt" \
  "$HOME/.dotfiles/claude/marketplace/plugins/claude-tips/tips/ignore.txt" \
  "$root/tips/ignore.txt"; do
  if [ -r "$ignore_file" ]; then
    grep -vE '^\s*($|#)' "$ignore_file" \
      | grep -oE '/[a-z][a-z-]*' | sort -u > "$tmp/ignored"
    break
  fi
done

comm -23 "$tmp/documented" "$tmp/tipped" > "$tmp/new_all"
comm -23 "$tmp/new_all" "$tmp/tombstoned" > "$tmp/new_kept"
comm -23 "$tmp/new_kept" "$tmp/ignored" > "$tmp/new"
comm -12 "$tmp/tipped" "$tmp/tombstoned" > "$tmp/removed"
comm -23 "$tmp/tipped" "$tmp/mentioned" > "$tmp/gone"

n_new=$(wc -l < "$tmp/new" | tr -d ' ')
n_removed=$(wc -l < "$tmp/removed" | tr -d ' ')
n_gone=$(wc -l < "$tmp/gone" | tr -d ' ')

# A layout change upstream would silently zero this out and make every tip look
# stale, so treat an empty command list as "could not check" rather than drift.
if [ ! -s "$tmp/documented" ]; then
  echo "check-tips: parsed no commands from $DOCS_URL — the page layout probably changed" >&2
  exit 2
fi

if [ "$porcelain" = "1" ]; then
  sed 's/^/new /' "$tmp/new"
  sed 's/^/removed /' "$tmp/removed"
  sed 's/^/gone /' "$tmp/gone"
else
  total=$(wc -l < "$tmp/documented" | tr -d ' ')
  tips_n=$(grep -vcE '^\s*($|#)' "$tips_file")
  echo "Checked $tips_n tips against $total documented commands."
  if [ "$n_new" -gt 0 ]; then
    echo
    echo "Not covered yet ($n_new):"
    sed 's/^/  /' "$tmp/new"
  fi
  if [ "$n_removed" -gt 0 ]; then
    echo
    echo "Tips teaching removed commands ($n_removed):"
    sed 's/^/  /' "$tmp/removed"
  fi
  if [ "$n_gone" -gt 0 ]; then
    echo
    echo "Tips naming undocumented commands ($n_gone):"
    sed 's/^/  /' "$tmp/gone"
  fi
  if [ "$((n_new + n_removed + n_gone))" -eq 0 ]; then
    echo "No drift."
  fi
fi

[ "$((n_new + n_removed + n_gone))" -eq 0 ] || exit 1
exit 0
