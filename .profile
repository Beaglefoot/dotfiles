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
if [[ -e "$HOME/.npm/bin" ]]; then
    PATH="$HOME/.npm/bin:$PATH"
fi
