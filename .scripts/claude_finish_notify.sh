#!/usr/bin/env bash
# Claude Code Stop hook: show a macOS notification when Claude Code goes idle,
# but only for sessions hosted in iTerm2 and only when iTerm2 is not focused.
#
# Stop fires at the end of every turn, and every finished background task
# (subagent, background command, monitor) opens a turn of its own, so a fan-out
# of N agents used to notify N+1 times. claude_pending_tasks.py pairs the
# launches in the transcript with their task-notifications and exits 1 while
# any is still unmatched: then this turn is not the idle one and we stay quiet.
#
# Gating on __CFBundleIdentifier (the owning GUI app) is deliberate: it survives
# tmux, whereas LC_TERMINAL/TERM_PROGRAM/VSCODE_* do not. This keeps the hook
# silent inside Cursor (com.todesktop.*), which emits its own notifications.
# A session that Claude Code has moved into one of its daemon workers runs its
# hooks with a stripped environment, so when the variable is missing it is read
# from the nearest ancestor process that still has it.

host_app() {
  if [ -n "$__CFBundleIdentifier" ]; then
    echo "$__CFBundleIdentifier"
    return
  fi
  local pid=$PPID cmd env id
  while [ "${pid:-1}" -gt 1 ]; do
    # ps -E appends the environment to the command line; drop the command
    # part so a stray KEY=VALUE token in some process's arguments cannot match.
    cmd=$(ps -ww -o command= -p "$pid" 2>/dev/null)
    env=$(ps -wwE -o command= -p "$pid" 2>/dev/null)
    id=$(printf '%s' "${env#"$cmd"}" | tr ' ' '\n' | grep -m1 '^__CFBundleIdentifier=')
    if [ -n "$id" ]; then
      echo "${id#*=}"
      return
    fi
    pid=$(ps -o ppid= -p "$pid" | tr -d ' ')
  done
}

log() { printf '%s %s\n' "$(date +%H:%M:%S)" "$*" >> "$HOME/.scripts/claude_finish_notify.log"; }

app=$(host_app)
[ "$app" = "com.googlecode.iterm2" ] || { log "silent: host app ${app:-unknown}"; exit 0; }

# The hook payload (transcript_path, session_id, ...) arrives on stdin and the
# helper reads it from there. Exit 1 = tasks pending; anything else (0, or the
# helper failing) falls through and notifies as before. Each Stop leaves one
# line in claude_finish_notify.log saying what was decided and why.
pending=$(python3 "$(dirname "$0")/claude_pending_tasks.py" 2>/dev/null)
[ $? -eq 1 ] && { log "silent: pending $(printf '%s' "$pending" | tr '\n' ' ')"; exit 0; }

frontmost=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
log "idle, frontmost ${frontmost:-unknown}"
if [ "$frontmost" != "iTerm2" ]; then
  osascript -e 'display notification "Claude has finished" with title "Claude Code"'
fi
