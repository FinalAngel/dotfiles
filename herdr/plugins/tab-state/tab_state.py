#!/usr/bin/env python3
"""herdr plugin hook: publish each agent pane's tab label as $tab_idle or $tab_busy.

Modes:
  all    resync every pane that hosts an agent (startup, tab renames, pane moves)
  event  resync the pane named in HERDR_PLUGIN_EVENT_JSON (agent state changes)

State is always read fresh from the live snapshot, so concurrent hooks converge.
"""
import json
import os
import subprocess
import sys
import time

HERDR = os.environ.get("HERDR_BIN_PATH", "herdr")
SOURCE = "dotfiles.tab-state"


def herdr(*args):
    result = subprocess.run([HERDR, *args], capture_output=True, text=True, timeout=15)
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip() or "herdr failed")
    return result.stdout


def snapshot():
    data = json.loads(herdr("api", "snapshot"))
    data = data.get("result", data)
    return data.get("snapshot", data)


def event_pane_id():
    try:
        event = json.loads(os.environ.get("HERDR_PLUGIN_EVENT_JSON", "{}"))
    except json.JSONDecodeError:
        event = {}
    data = event.get("data", event)
    return data.get("pane_id") or os.environ.get("HERDR_PANE_ID")


def sync(pane, tabs, seq):
    label = tabs.get(pane["tab_id"], {}).get("label", "")
    busy = pane.get("agent_status") == "working"
    set_key, clear_key = ("tab_busy", "tab_idle") if busy else ("tab_idle", "tab_busy")
    herdr("pane", "report-metadata", pane["pane_id"],
          "--source", SOURCE,
          "--token", f"{set_key}={label}",
          "--clear-token", clear_key,
          "--seq", str(seq))


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "all"
    snap = snapshot()
    tabs = {tab["tab_id"]: tab for tab in snap.get("tabs", [])}
    panes = [pane for pane in snap.get("panes", []) if pane.get("agent")]
    if mode == "event":
        target = event_pane_id()
        if target:
            panes = [pane for pane in panes if pane["pane_id"] == target]
    seq = int(time.time() * 1000)
    failures = 0
    for pane in panes:
        try:
            sync(pane, tabs, seq)
        except Exception as err:  # keep going; one bad pane must not block the rest
            failures += 1
            print(f"{pane['pane_id']}: {err}", file=sys.stderr)
    print(f"synced {len(panes) - failures}/{len(panes)} agent panes ({mode})")
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
