# tmux-agent-sidebar local patches

Applied against `hiroppy/tmux-agent-sidebar` @ `e2474e4` (v0.13.0), installed
via TPM at `~/.tmux/plugins/tmux-agent-sidebar`.

TPM updates are manual (`prefix + U`), so these survive until you explicitly
update the plugin — at which point they need reapplying and rebuilding.

Apply **in order**: 0003 shares files with 0002 and expects it first.
Verified: the sequence applied to a clean clone reproduces the running `src/`
and `tests/` trees exactly (`diff -r`).

## `0001-upstream-pr118-session-name.patch`

[PR #118](https://github.com/hiroppy/tmux-agent-sidebar/pull/118) (open, not
merged), fixing issue #112: the row title flickered between the session name
and the default agent label (`claude`).

`apply_session_snapshot` rebuilds `repo_groups` every ~1s tick with an empty
`session_name`, but re-applying the cached `sessionId → name` map was gated
behind a `dirty` flag that only flipped on the 10s names poll. The patch
re-applies the names unconditionally and drops the flag.

**Drop this patch once PR #118 is merged upstream.**

## `0002-hide-header-rows.patch`

Local only. Adds `@sidebar_header` (default `on`). When `off`, the status
filter bar (`≡ ● ◎ ◐ ○ ✕` + counts) and the repo/notices row (`ⓘ … — ▾`) are
not rendered and the agent list occupies the full sidebar height.

Also gates mouse-click routing on the option: `handle_mouse_click` hardcoded
row 0 → filter bar and row 1 → repo/notices, and subtracted a fixed 2 rows to
map a click to a list line. With the header hidden those rows are list content,
so the offset comes from `AppState::header_rows()` instead.

Caveat: with the header hidden there is no visible indication of the active
status filter. If the sidebar ever looks empty, check it — phantom mouse events
during pane resizes can flip it:

```sh
tmux show -gv @sidebar_filter   # expect: all
tmux set -g @sidebar_filter all
```

## `0003-notification-sound.patch`

Local only. Adds `@sidebar_notification_sound` (default silent, preserving
current behaviour). macOS: any name from `/System/Library/Sounds` — Basso Blow
Bottle Frog Funk Glass Hero Morse Ping Pop Purr Sosumi Submarine Tink. Linux:
passed to `notify-send` as `--hint=string:sound-name:`. `off`/`none`/empty =
silent; an unknown name degrades to a silent banner rather than an error.

Unlike the sidebar options, this is read fresh on **every hook fire**
(`notification_settings()` → `from_tmux()` in a short-lived process), so
changes take effect immediately — no sidebar restart.

## `0004-auto-create-track.patch`

Local only. Adds a third value to `@sidebar_auto_create`: `track`. `on`
(upstream default) always opens a sidebar in a new window; `off` never does;
`track` follows the visibility you last chose explicitly.

The `after-new-window` hook runs `toggle --create-only`, which previously
consulted no state at all. Now `toggle` and `toggle-all` persist the last
explicit choice to `@sidebar_enabled` (`on`/`off`, unset = on so a fresh server
still opens one on the first window), and `--create-only` honours it under
`track`. Auto-creates deliberately do **not** write the flag — otherwise
opening a window would silently re-enable a sidebar you had turned off.

Semantics: **either** key records intent — `prefix + e` (this window) and
`prefix + E` (all windows). So hiding one window's sidebar with `prefix + e`
also stops new windows opening one, even if other windows still show theirs.
If you'd rather only `prefix + E` set the global default, drop the
`set_sidebar_enabled(false)` / `set_sidebar_enabled(true)` calls in
`cmd_toggle` and keep the ones in `cmd_toggle_all`.

Ordering note for anyone editing this: `cmd_toggle_all`'s open branch sets the
flag *before* its `--create-only` loop. Setting it afterwards makes "enable
everywhere" a no-op, since each call would still read `off`.

## `0005-multi-profile-sessions.patch`

Local only. Two fixes for running a second Claude Code profile
(`CLAUDE_CONFIG_DIR=~/.claude-divio claude`, the `claude-divio` alias).

**Session names across profiles.** `session.rs` hardcoded
`$HOME/.claude/sessions`, so agents from another profile fell back to the
default `claude` label. It now scans every `$HOME/.claude*/sessions` directory
(skipping non-directories like `~/.claude.json`), sorted for a stable result.
No config needed — a new profile is picked up automatically.

**Stray keys can no longer cycle a hidden filter.** `KeyCode::Tab` cycled the
status filter with no focus guard, unlike `h`/`l` which require `Focus::Filter`,
and the change is persisted to `@sidebar_filter` globally. Rapid pane
create/kill (restarting sidebars in a loop) produces phantom input — the same
class of event the existing filter-click debounce warns about — and landing on
`error` empties the sidebar with no visible cause once the header is hidden.
Filter cycling (`h`/`l`/`Tab`) is now disabled whenever `@sidebar_header` is
`off`. Set `@sidebar_filter` explicitly if you want a non-default filter there.

Note this only covers agents *in the same tmux server*; the sidebar still finds
panes via tmux pane options written by hooks, so the other profile also needs
the plugin enabled — see below.

## `0006-waiting-rows-and-spinner.patch`

Local only. Two row-rendering changes.

**Blocked rows are flagged explicitly.** A pane blocked on the user gets a `▌`
marker in column 0 on *every* line of its block (painted
`@sidebar_color_waiting`) and a right-aligned `WAITING` tag in place of the
elapsed time. Previously the only cue was the status icon's colour, which is
easy to miss and invisible to anyone who can't distinguish it. The waiting
marker takes precedence over the active-pane `┃`: which pane tmux has focused
is already obvious from the screen.

**The running icon animates its glyph, not its colour.** `SPINNER_PULSE` cycled
eight hardcoded xterm colour indexes, so a running row strobed *and* ignored
`@sidebar_color_running` — the one status that didn't honour the theme. It now
advances through `SPINNER_FRAMES` (braille `⠋⠙⠹⠸⠼⠴⠦⠧`) at a constant themed
colour. Setting `@sidebar_icon_running` opts out of the animation entirely.

Known gap: "blocked" means `@pane_attention` set (permission prompts,
notifications) or status `waiting`. It does **not** include an agent that
finished its turn — `on_stop` clears attention and sets `idle`, so a completed
agent still renders as a plain `○`. Flagging those too would mean treating
`idle` as needs-user, which would put the marker on almost every row.

## `0007-ignore-headless-sessions.patch`

Local only. Makes the `hook` subcommand a no-op when it was fired by a headless
Claude session (`CLAUDE_CODE_ENTRYPOINT` starting with `sdk-`).

An agent that shells out to `claude -p` — a skill running a dry run, a
subprocess batch job — spawns a child that **inherits `$TMUX_PANE`**. The child
then writes `@pane_prompt` / `@pane_status` over the parent's for the duration
of its run, and on exit fires `SessionEnd`, whose `run_session_end_teardown`
unsets `@pane_agent`, `@pane_session_id`, `@pane_cwd`, `@pane_started_at`,
`@pane_prompt` … and deletes the pane's activity log. The interactive agent
sitting in that pane disappears from the sidebar until its next turn boundary
calls `set_agent_meta` again.

The existing guard does not cover this: `on_session_end` bails out only when
`@pane_subagents` is non-empty, which `SubagentStart` populates for Task-tool
subagents. A nested CLI process is not a Task subagent.

The entrypoint is the only usable discriminator, verified by dumping the hook
environment for both cases:

| launched as | `CLAUDE_CODE_ENTRYPOINT` seen by its hooks |
| --- | --- |
| interactive TUI (`claude`) | `cli` |
| headless (`claude -p`) | `sdk-cli` |

Two obvious alternatives are dead ends, so don't reach for them: each session
rewrites `CLAUDE_CODE_SESSION_ID` to its own id (a child cannot be spotted by an
inherited parent id), and `CLAUDE_CODE_CHILD_SESSION=1` is set for *every*
subprocess of *every* session, nested or top-level.

Fails open by design — only an explicitly headless value is suppressed.
`CLAUDE_CODE_ENTRYPOINT` is internal and undocumented, so a future rename
degrades to the clobbering behaviour above rather than hiding every agent.

Trade-off: a `claude -p` deliberately run in its own pane no longer appears in
the sidebar. If you ever want that back it is a one-line `@sidebar_track_headless`
option.

Takes effect immediately — hooks exec the on-disk binary on every fire, so no
sidebar restart is needed (unlike the display options).

## `0008-filter-only-with-header.patch`

Local only. `@sidebar_filter` is now honoured only while the filter bar is
actually rendered; with `@sidebar_header off` the sidebar always shows `all`.

0005 stopped `h`/`l`/`Tab` from cycling the filter with the header hidden, and
0002 already gated the mouse-click route — but neither does anything about a
value *already stored* in the global option. Because it persists, one stray
`error` keeps every sidebar started afterwards permanently empty, with no
visible cause and no way to fix it from the UI. This closes that off: the value
is simply not read in a mode where it cannot be seen or changed.

Supersedes the "if the sidebar looks empty, check `@sidebar_filter`" advice in
the 0002 section, which is now only relevant with the header switched on.

Costs the ability to set a static non-`all` filter while the header is hidden —
a capability the 0005 notes mention but which has only ever caused this bug.

Needs a sidebar restart (it is read by the TUI, not the hook path).

## `0009-notification-click-focus.patch`

Local only. Clicking a desktop notification jumps to the pane that raised it.

AppleScript's `display notification` has no click action whatsoever, so the
macOS path now prefers [`terminal-notifier`](https://github.com/julienXX/terminal-notifier)
(`brew install terminal-notifier`) and passes:

```
-execute ''/opt/homebrew/bin/tmux' switch-client -t %21; /usr/bin/open -b com.mitchellh.ghostty'
```

**Both paths must be absolute.** terminal-notifier runs `-execute` from its own
app context, whose PATH is the bare `/usr/bin:/bin:/usr/sbin:/sbin` — Homebrew's
`/opt/homebrew/bin` is not on it, so a bare `tmux` is "command not found" and the
click does nothing at all, silently (no error surfaces anywhere). The path is
resolved from the *hook* process's PATH, which is the user's, and single-quoted.
Verified by running the generated string under `env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin`.

`switch-client -t` accepts a pane target — per the tmux manual, "As a special
case, -t may refer to a pane (a target that contains ':', '.' or '%'), to change
session, window and pane" — so a single command lands on the right pane wherever
it lives. Verified live: `switch-client -t %11` moved the session's active pane
from `%27` to `%11`.

terminal-notifier is optional. If it is missing or fails, the code falls through
to the original AppleScript banner — a banner without click-to-focus beats no
banner. Linux (`notify-send`) is untouched.

`@sidebar_notification_activate` sets the bundle identifier of the terminal to
bring forward on click. Unset it and the value is taken from
`$__CFBundleIdentifier`, which macOS sets on every process an app launches — so
an agent started in Ghostty gets `com.mitchellh.ghostty` with no configuration,
and each pane activates whichever terminal it was actually started in.
`off`/`none`/empty switches app activation off, leaving only the tmux jump
(matching how `@sidebar_notification_sound` treats those values).

Both the pane id and the bundle id are interpolated into a shell command, so
both are restricted to `[A-Za-z0-9._%-]` and dropped otherwise. A tmux option is
attacker-controllable in principle, and `-execute` runs through a shell.

Like 0003 this is on the hook path, so it takes effect immediately — no sidebar
restart.

## Enabling the sidebar for a second Claude profile

Each `CLAUDE_CONFIG_DIR` has its own plugin state, so installing the sidebar in
`~/.claude` does nothing for `~/.claude-divio` — no hooks fire, and the sidebar
never learns those panes are agents. Enable it per profile:

```sh
CLAUDE_CONFIG_DIR=~/.claude-divio claude plugin marketplace add ~/.tmux/plugins/tmux-agent-sidebar
CLAUDE_CONFIG_DIR=~/.claude-divio claude plugin install tmux-agent-sidebar@hiroppy
```

That creates *another* plugin cache with its own `bin/`, which `hook.sh`
prefers over the TPM directory — so symlink it to the patched build as well:

```sh
CACHE=~/.claude-divio/plugins/cache/hiroppy/tmux-agent-sidebar/0.13.0
rm -f "$CACHE/bin/tmux-agent-sidebar"
ln -s ~/.tmux/plugins/tmux-agent-sidebar/bin/tmux-agent-sidebar "$CACHE/bin/tmux-agent-sidebar"
```

## Reapplying after a plugin update

```sh
cd ~/.tmux/plugins/tmux-agent-sidebar
for p in ~/.dotfiles/patches/tmux-agent-sidebar/000*.patch; do git apply "$p"; done
cargo build --release
# bin/ takes precedence over target/release/ for both the tmux launcher and
# hook.sh, so the build has to be copied over it — and re-signed, or macOS
# SIGKILLs it (a linker-only signature is not honored on a file it didn't write).
cp target/release/tmux-agent-sidebar bin/tmux-agent-sidebar
codesign --force --sign - bin/tmux-agent-sidebar
```

Then restart the sidebars (`prefix + E` off, `prefix + E` on) — the binary and
all `@sidebar_*` display options are read once at sidebar startup.

## Claude Code plugin cache (matters for notifications)

**Correction (2026-07-29):** measured by logging `$CLAUDE_PLUGIN_ROOT` from
inside a real hook fire, both profiles resolve it to
`/Users/vadim/.tmux/plugins/tmux-agent-sidebar/` — the TPM directory — not to a
cache copy. Because the marketplace was added as a local path, Claude Code runs
the plugin from source. Neither cache's `hook.sh` fired at all. The symlinks
below are therefore currently redundant (harmless, and worth keeping in case a
future install resolves to the cache instead), and the section that follows
describes the general mechanism rather than what is happening on this machine.

Notifications fire from the **hook** path, not the TUI. Claude Code hooks run
`${CLAUDE_PLUGIN_ROOT}/hook.sh`, and `hook.sh` prefers `$PLUGIN_DIR/bin/` — the
cache's own copy — over the TPM directory. So a patched TPM binary alone does
**not** change notification behaviour.

Fixed by symlinking the cache's binary at
`~/.claude/plugins/cache/hiroppy/tmux-agent-sidebar/0.13.0/bin/tmux-agent-sidebar`
to the TPM one, so future rebuilds flow through automatically. The stock copy is
kept beside it as `tmux-agent-sidebar.orig-v0.13.0`.

Claude Code's plugin updater may replace the symlink on a plugin update — redo
it if notification changes stop taking effect. Note the version is in the path,
so an update also changes the directory name.

## Reverting

Stock v0.13.0 binaries are kept as `bin/tmux-agent-sidebar.orig-v0.13.0` in both
the TPM directory and the Claude plugin cache, so you can revert without
rebuilding.
