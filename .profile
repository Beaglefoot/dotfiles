# macOS specific changes
if [[ "$OSTYPE" == "darwin"* ]]; then
    source ~/.bashrc

    if [ -f $(brew --prefix)/etc/bash_completion.d ]; then
       . $(brew --prefix)/etc/bash_completion.d
    fi

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
