# claude-tips

Prints one Claude Code tip after every turn, rotating through `tips/tips.txt`.

## How it works

A `Stop` hook runs `scripts/tip.sh` when Claude finishes responding. The script
returns the tip as `systemMessage`, which Claude Code shows to you and does not
feed back into the conversation — so tips cost no context and never nudge Claude.

Rotation is sequential, not random, so every tip is seen once before any repeats.
The cursor lives in `${XDG_STATE_HOME:-~/.local/state}/claude-tips/index`, which
is machine-local on purpose: `~/.claude` syncs through iCloud, and a counter that
changes every turn does not belong in a synced directory.

## Adding tips

Edit `tips/tips.txt`, one tip per line. Blank lines and `#` comments are skipped.
Changes apply on the next turn — `tip.sh` reads this checked-out file in
preference to the copy made at install time, so no reinstall is needed.

Editing `tip.sh` itself does need a reinstall, since that file is read from the
install cache:

```sh
claude plugin uninstall claude-tips@finalangel
claude plugin install claude-tips@finalangel
```

## Keeping tips current

Claude Code changes fast: commands get added, and some get removed (`/vim` and
`/pr-comments` are already tombstones). `scripts/check-tips.sh` compares the tip
list against the published command reference and reports three kinds of drift:

- **new** — documented upstream, not tipped yet
- **removed** — a tip teaches something upstream marks as removed
- **gone** — a tip names a command upstream no longer documents

Exit codes are 0 for no drift, 1 for drift, 2 for could-not-check (offline, or
the docs page changed shape). It refuses to report drift when it parses zero
commands, so an upstream layout change can't make every tip look stale.

`claude/update` runs it, so `dotfiles update` tells you when the list has rotted.
To act on that, run `/claude-tips:refresh`: it re-runs the check, reads each
affected command's row from the docs, and rewrites the tips — writing from the
source rather than from memory, because a confident tip for a flag that doesn't
exist is worse than no tip.

Commands deliberately not tipped live in `tips/ignore.txt`, which keeps the
report down to things actually worth a decision instead of the same ~50 rows
every week.

## Turning it off

- One session: `CLAUDE_TIPS=0 claude`
- For good: `/plugin` → disable, or `claude plugin disable claude-tips@finalangel`

## Failure behavior

Every error path exits 0 with empty stdout. On `Stop`, Claude Code sends stdout
to the debug log and never to the transcript, so a missing or broken tips file
shows nothing rather than decorating your turns with hook-error notices.
