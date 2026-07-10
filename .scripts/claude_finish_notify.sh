#!/usr/bin/env bash
# Claude Code Stop hook: show a macOS notification when a turn finishes,
# but only for sessions hosted in iTerm2 and only when iTerm2 is not focused.
#
# Gating on __CFBundleIdentifier (the owning GUI app) is deliberate: it survives
# tmux, whereas LC_TERMINAL/TERM_PROGRAM/VSCODE_* do not. This keeps the hook
# silent inside Cursor (com.todesktop.*), which emits its own notifications.

[ "$__CFBundleIdentifier" = "com.googlecode.iterm2" ] || exit 0

frontmost=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
if [ "$frontmost" != "iTerm2" ]; then
  osascript -e 'display notification "Claude has finished" with title "Claude Code"'
fi
