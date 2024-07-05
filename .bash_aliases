if [ -x /usr/bin/dircolors ] || [ COLORTERM ]; then
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi



if [[ "$OSTYPE" == "linux" ]]; then
    alias ding='notify-send "done"'
    alias clip='printf %s "$(cat -)" | xclip -i -selection clipboard'
fi



if [[ "$OSTYPE" == "cygwin" ]]; then
    alias killall='taskkill.exe /F /IM'
    alias dotnet='dotnet.exe'
fi



if [[ "$OSTYPE" == "darwin"* ]]; then
    alias clip='pbcopy'
fi
