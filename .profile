# macOS specific changes
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/opt/homebrew/bin/:$PATH"

    prefix=$(brew --prefix)

    alias have='which'

    if [ -f "$prefix"/etc/bash_completion ]; then
       source "$prefix"/etc/bash_completion
    fi

    if [ -d "$prefix"/etc/bash_completion.d ]; then
       source "$prefix"/etc/bash_completion.d/*
    fi

    source ~/.bashrc

    alias ls='ls -G'
    alias tree='tree -C'
    alias grep='grep --color'
    alias ding='terminal-notifier -message "Done"'
fi


# Update PATH
npm_binaries="$HOME/.npm/bin"

if [[ -e "$npm_binaries" && ! $PATH =~ "$npm_binaries" ]]; then
    PATH="$npm_binaries:$PATH"
fi

pip_binaries="$HOME/.local/bin"

if [[ -e "$pip_binaries" && ! $PATH =~ "$pip_binaries" ]]; then
    PATH="$pip_binaries:$PATH"
fi

my_scripts="$HOME/.scripts"

if [[ -e "$my_scripts" && ! $PATH =~ "$my_scripts" ]]; then
    PATH="$my_scripts:$PATH"
fi
