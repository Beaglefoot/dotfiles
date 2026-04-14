#!/usr/bin/env bash
# Poll Jupyter Server /api/kernels until all kernels are idle; print a notification
# message to stdout (pipe to telegram_send_stdin.sh to deliver via Telegram).
#
# Example:
#   JUPYTER_BASE_URL=... JUPYTER_TOKEN=... TELEGRAM_BOT_TOKEN=... TELEGRAM_CHAT_ID=... \
#     ./jupyter_kernels_idle_message.sh | ./telegram_send_stdin.sh
#
# Required env:
#   JUPYTER_BASE_URL   e.g. http://localhost:8889
#   JUPYTER_TOKEN      notebook/server token (query param)
#
# Optional env:
#   POLL_INTERVAL        seconds between checks (default: 60)
#   NOTIFY_AFTER_BUSY    if 1, only emit after a kernel was "busy" at least once this run
#
set -euo pipefail

JUPYTER_BASE_URL="${JUPYTER_BASE_URL:?set JUPYTER_BASE_URL (e.g. http://host:8889)}"
JUPYTER_TOKEN="${JUPYTER_TOKEN:?set JUPYTER_TOKEN}"

POLL_INTERVAL="${POLL_INTERVAL:-60}"
NOTIFY_AFTER_BUSY="${NOTIFY_AFTER_BUSY:-0}"

JUPYTER_BASE_URL="${JUPYTER_BASE_URL%/}"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required" >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required (e.g. brew install jq)" >&2
  exit 1
fi

kernels_url="${JUPYTER_BASE_URL}/api/kernels?token=${JUPYTER_TOKEN}"

saw_busy=0

while true; do
  if ! kernels_json="$(curl -fsS "$kernels_url")"; then
    echo "$(date -Iseconds) warn: failed to fetch kernels, retry in ${POLL_INTERVAL}s" >&2
    sleep "$POLL_INTERVAL"
    continue
  fi

  if ! echo "$kernels_json" | jq -e 'type == "array"' >/dev/null 2>&1; then
    echo "$(date -Iseconds) warn: unexpected JSON (not an array), retry in ${POLL_INTERVAL}s" >&2
    sleep "$POLL_INTERVAL"
    continue
  fi

  non_idle="$(
    echo "$kernels_json" | jq '[.[] | select(.execution_state != "idle")] | length'
  )"
  busy_now="$(
    echo "$kernels_json" | jq '[.[] | select(.execution_state == "busy")] | length'
  )"

  if [[ "$busy_now" -gt 0 ]]; then
    saw_busy=1
  fi

  kernel_count="$(echo "$kernels_json" | jq 'length')"
  summary="$(
    echo "$kernels_json" | jq -r '
      [.[] | "\(.id[0:8])… \(.name // "?") → \(.execution_state)"]
      | join("; ")
    '
  )"
  ts="$(date -Iseconds)"

  if [[ "$non_idle" -eq 0 ]]; then
    if [[ "$NOTIFY_AFTER_BUSY" == "1" && "$saw_busy" -eq 0 ]]; then
      echo "${ts} all idle (${kernel_count} kernel(s)) but waiting until a busy state was seen (NOTIFY_AFTER_BUSY=1)" >&2
      sleep "$POLL_INTERVAL"
      continue
    fi

    printf '%s\n%s\n%s\n%s' \
      "Jupyter: all ${kernel_count} kernel(s) idle." \
      "Server: ${JUPYTER_BASE_URL}" \
      "kernels: ${summary:-none}" \
      "Checked at: ${ts}"
    exit 0
  fi

  echo "${ts} ${non_idle} non-idle (of ${kernel_count}): ${summary}" >&2
  sleep "$POLL_INTERVAL"
done
