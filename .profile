# macOS specific changes
if [[ "$OSTYPE" == "darwin"* ]]; then
    source ~/.bashrc

    if [ -f $(brew --prefix)/etc/bash_completion.d ]; then
       . $(brew --prefix)/etc/bash_completion.d
    fi

    alias ls='ls -G'
    alias tree='tree -C'
    alias grep='grep --color'
fi
