# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=4000
HISTFILESIZE=4000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color|screen) color_prompt=yes;;
esac

[[ $COLORTERM ]] && color_prompt=yes

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi



# Some preparations for proper $PS1
if [ ! -e ~/.git-prompt.sh ]; then
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh\
        -O ~/.git-prompt.sh
fi
. ~/.git-prompt.sh



if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;30m\]$(__git_ps1 " (%s)")\[\033[00m\]\n\$ '
else
    PS1='\u@\h:\w$(__git_ps1 " (%s)")\n\$ '
fi
unset color_prompt force_color_prompt

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi



# 'touch' alternative with creation of intermediate dirs
mktouch() {
    if [ $# -lt 1 ]; then
        echo "Missing argument";
        return 1;
    fi

    for f in "$@"; do
        mkdir -p -- "$(dirname -- "$f")"
        touch -- "$f"
    done
}



# Bash completions
[[ -d ~/.bash_completions ]] || mkdir ~/.bash_completions


# Git
if [ ! -e ~/.bash_completions/git-completion.bash ]; then
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash\
        -O ~/.bash_completions/git-completion.bash
fi


# Yarn
if [ ! -e ~/.bash_completions/yarn-completion.bash ]; then
    wget https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash\
        -O ~/.bash_completions/yarn-completion.bash
fi


# NPM
if [ ! -e ~/.bash_completions/npm-completion.bash ]; then
    npm completion > ~/.bash_completions/npm-completion.bash
fi


# Pipenv
if [ $(which pipenv 2>/dev/null) ]; then
    if [ ! -e ~/.bash_completions/pipenv-completion.bash ]; then
        pipenv --completion > ~/.bash_completions/pipenv-completion.bash
    fi
fi


# Poetry
if [ $(which poetry 2>/dev/null) ]; then
    if [ ! -e ~/.bash_completions/poetry-completion.bash ]; then
        poetry completions -n --alias poetry bash > ~/.bash_completions/poetry-completion.bash
    fi
fi


# docker-compose
if [ ! -e ~/.bash_completions/docker-compose-completion.bash ]; then
    wget https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose\
        -O ~/.bash_completions/docker-compose-completion.bash
fi



# Init completions
for fn in ~/.bash_completions/*-completion.bash; do
    source "$fn"
done



# Stuff generated by some other tools
if [ -f ~/.bash_generated ]; then
    source ~/.bash_generated
fi



# Tmux
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
fi

