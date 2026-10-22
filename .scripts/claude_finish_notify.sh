#!/usr/bin/env bash
# Claude Code Stop hook: show a macOS notification when Claude Code goes idle,
# but only for sessions hosted in iTerm2 and only when the session is out of
# sight: iTerm2 is not focused, or the session runs in tmux and its pane is
# not on screen (one tmux window per project, so another window means another
# project is in front; a zoomed pane hides the rest of its window).
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
# hooks with a stripped environment, so when a variable (this one, TMUX_PANE)
# is missing it is read from the nearest ancestor process that still has it.

env_var() {
  if [ -n "${!1}" ]; then
    echo "${!1}"
    return
  fi
  local pid=$PPID cmd env kv
  while [ "${pid:-1}" -gt 1 ]; do
    # ps -E appends the environment to the command line; drop the command
    # part so a stray KEY=VALUE token in some process's arguments cannot match.
    cmd=$(ps -ww -o command= -p "$pid" 2>/dev/null)
    env=$(ps -wwE -o command= -p "$pid" 2>/dev/null)
    kv=$(printf '%s' "${env#"$cmd"}" | tr ' ' '\n' | grep -m1 "^$1=")
    if [ -n "$kv" ]; then
      echo "${kv#*=}"
      return
    fi
    pid=$(ps -o ppid= -p "$pid" | tr -d ' ')
  done
}

log() { printf '%s %s\n' "$(date +%H:%M:%S)" "$*" >> "$HOME/.scripts/claude_finish_notify.log"; }

app=$(env_var __CFBundleIdentifier)
[ "$app" = "com.googlecode.iterm2" ] || { log "silent: host app ${app:-unknown}"; exit 0; }

# The hook payload (transcript_path, session_id, cwd, ...) arrives on stdin.
# The project shown in the notification is the directory the session started
# in: the transcript's own cwd field, because the payload's cwd follows cd
# commands run by Bash tool calls. Several sessions share the log file, so
# the project is on every line from here on.
payload=$(cat)
transcript=$(printf '%s' "$payload" | sed -n 's/.*"transcript_path":"\([^"]*\)".*/\1/p')
project=$(grep -m1 -o '"cwd":"[^"]*"' "$transcript" 2>/dev/null | sed 's/^"cwd":"//; s/"$//')
[ -n "$project" ] || project=$(printf '%s' "$payload" | sed -n 's/.*"cwd":"\([^"]*\)".*/\1/p')
project=${project##*/}

# Exit 1 = tasks pending; anything else (0, or the helper failing) falls
# through and notifies as before. Each Stop leaves one line in the log saying
# what was decided and why.
pending=$(printf '%s' "$payload" | python3 "$(dirname "$0")/claude_pending_tasks.py" 2>/dev/null)
[ $? -eq 1 ] && { log "[$project] silent: pending $(printf '%s' "$pending" | tr '\n' ' ')"; exit 0; }

frontmost=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

# In tmux the session is on screen only while its window is the active window
# of an attached tmux session and no other pane of that window is zoomed.
# view stays empty outside tmux.
view=
pane=$(env_var TMUX_PANE)
if [ -n "$pane" ]; then
  view=$(tmux display-message -p -t "$pane" '#{?#{&&:#{&&:#{window_active},#{session_attached}},#{?window_zoomed_flag,#{pane_active},1}},shown,hidden}' 2>/dev/null)
fi

log "[$project] idle, frontmost ${frontmost:-unknown}${view:+, tmux pane $view}"
if [ "$frontmost" != "iTerm2" ] || [ "$view" = hidden ]; then
  subtitle=$(printf '%s' "$project" | sed 's/\\/\\\\/g; s/"/\\"/g')
  osascript -e "display notification \"Claude has finished\" with title \"Claude Code\" subtitle \"$subtitle\""
fi
