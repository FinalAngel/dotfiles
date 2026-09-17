---
description: Check the tip list against the current Claude Code docs and fix what drifted
---

Bring `claude-tips` back in line with the published Claude Code command
reference. The checker finds the drift; you supply the judgement it can't.

## 1. Find the drift

Run the checker and work from its output:

```sh
~/.dotfiles/claude/marketplace/plugins/claude-tips/scripts/check-tips.sh --porcelain
```

Each line is `<kind> <command>`:

- `new` — documented upstream, no tip mentions it yet
- `removed` — a tip teaches it, but upstream marks it removed
- `gone` — a tip names it, but upstream no longer documents it at all

Exit 0 means no drift: say so and stop. Exit 2 means the check itself failed
(offline, or the docs page changed shape) — report which and stop, rather than
editing tips on a guess.

## 2. Read the source before writing anything

Fetch `https://code.claude.com/docs/en/commands.md` and find each affected
command's row. Write tips from that row, never from memory — the whole value of
this plugin is that its tips are accurate, and a plausible-sounding tip for a
flag that does not exist is worse than no tip.

## 3. Apply the changes

Edit `~/.dotfiles/claude/marketplace/plugins/claude-tips/tips/tips.txt`.

For `new`, decide first whether it earns a tip. Plenty of commands do not: a
one-off setup step, a provider-specific wizard, something you would only reach
for when already debugging. If it does not, add it to `tips/ignore.txt` under
the fitting heading instead — that is a real answer, not a cop-out, and it keeps
future reports short. If it does, add one line under the section it belongs to,
matching the house style:

```
/command [args] — what it does, and the reason you would reach for it
```

Lower case after the dash, an em dash as the separator, one line, no trailing
period. Say what it is *for*, not just what it is named.

For `removed` and `gone`, delete the line. If the command was replaced rather
than dropped, the docs row usually says so — write a tip for the replacement in
the same spot.

## 4. Confirm

Re-run the checker; it should print `No drift.` Report what you added, what you
dropped, and anything you deliberately sent to `ignore.txt` and why.

Tips take effect on the next turn — `tip.sh` reads this file directly, so there
is nothing to reinstall.
