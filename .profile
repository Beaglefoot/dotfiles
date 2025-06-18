# macOS specific changes
if [[ "$OSTYPE" == "darwin"* ]]; then
    HOMEBREW_PREFIX=$(brew --prefix)

    export PATH="$HOMEBREW_PREFIX/bin/:$PATH"

    alias have='which'

    if [ -f "$HOMEBREW_PREFIX"/etc/bash_completion ]; then
		source "$HOMEBREW_PREFIX"/etc/bash_completion
    fi

    if [ -d "$HOMEBREW_PREFIX"/etc/bash_completion.d ]; then
		source "$HOMEBREW_PREFIX"/etc/bash_completion.d/*

		for COMPLETION in "$HOMEBREW_PREFIX"/etc/bash_completion.d/*
		do
			[[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
		done
    fi

    source ~/.bashrc

    alias ls='ls -G'
    alias tree='tree -C'
    alias grep='grep --color'
    alias date='gdate'
    alias awk='gawk'
    alias sed='gsed'

    export HOMEBREW_NO_AUTO_UPDATE=1
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
