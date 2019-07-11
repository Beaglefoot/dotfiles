alias ding='notify-send "done"'

if [[ "$OSTYPE" == "cygwin" ]]; then
    alias killall='taskkill.exe /F /IM'
    alias grep='grep --color'
fi
