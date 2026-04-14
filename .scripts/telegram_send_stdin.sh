#!/usr/bin/env bash
# Read message from stdin; POST to Telegram sendMessage.
# If text exceeds a simple length cap, send a truncated prefix, write the full
# message to a file in $HOME, and append a footer with the path.
#
# Telegram's real limit is 4096 UTF-16 code units (non-BMP characters count as
# two units). We intentionally use bash ${#var} character count in a UTF-8
# locale and a conservative cap instead of measuring UTF-16—simpler, plenty for
# typical Latin/log output; very heavy non-BMP text could still hit API limits.
#
# Required env:
#   TELEGRAM_BOT_TOKEN  from @BotFather
#   TELEGRAM_CHAT_ID    numeric chat id
#
set -euo pipefail

TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:?set TELEGRAM_BOT_TOKEN}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:?set TELEGRAM_CHAT_ID}"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required" >&2
  exit 1
fi

# Conservative max length for the entire outgoing message (prefix + footer).
MAX_SEND_CHARS=3500

full=$(cat)
len=${#full}

if [[ "$len" -le $MAX_SEND_CHARS ]]; then
  text=$full
else
  path="${HOME}/telegram-stdin-full-$(date +%Y%m%d-%H%M%S)-$$.txt"
  printf '%s' "$full" >"$path"
  chmod 600 "$path"
  footer=$'\n\n'"… (truncated; full message saved to: ${path})"
  prefix_len=$((MAX_SEND_CHARS - ${#footer}))
  if [[ "$prefix_len" -lt 1 ]]; then
    prefix_len=1
  fi
  text="${full:0:prefix_len}${footer}"
fi

if ! curl -fsS -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
  --data-urlencode "text=${text}" >/dev/null; then
  echo "$(date -Iseconds) error: Telegram sendMessage failed" >&2
  exit 2
fi
