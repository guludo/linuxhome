#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# less with colors!
alias less='less -R'

# info with vi keys
alias info='info --vi-keys'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# alias for pushd +1
alias nextdir='pushd +1'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

git_branch_get()
{
    branch=$(git symbolic-ref -q --short HEAD 2>/dev/null)
    if [ $? -eq 1 ]; then
        branch="no branch"
    fi
    echo -n ${branch:+" [${branch##*/}]"}
}

ps1_user_component()
{
    if [[ -z $SSH_CLIENT ]]; then
        return
    fi

    local u=$USER

    if [[ -z $u ]]; then
        u=$(whoami 2>/dev/null)
    fi

    if [[ -z $u ]]; then
        local u="?"
    fi

    echo $u
}

ps1_host_component()
{
    if [[ -z $SSH_CLIENT ]]; then
        return
    fi

    local h=$(hostname 2>/dev/null)

    if [[ -z $h ]] && [[ -f /etc/hostname ]]; then
        local h=$(< /etc/hostname)
    fi

    if [[ -z $h ]]; then
        local h="?"
    fi

    echo "@$h "
}

exit_status_prompt()
{
    local status=$1
    if [[ $1 == 0 ]]; then
        printf "\e[0;36m:)\e[0m"
    else
        printf "\e[0;31m:(\e[0m"
    fi
}

call_ps1_extra()
{
    [[ $(type -t ps1_extra) == function ]] && ps1_extra
}

PS1="\$(exit_status_prompt \$?) \[\e[0;34m\]\$(ps1_user_component)\[\e[m\e[0;32m\]\$(ps1_host_component)\[\e[m\]\W\[\e[0;33m\]\$(git_branch_get)\[\e[m\]\$(call_ps1_extra --exit-status \$?)\n\$ "

# PATHs
export PATH=$PATH:~/bin

# bc env vars
export BC_ENV_ARGS=~/.bcrc

# use vi editing mode
set -o vi

# Import custom aliases file
if [[ -f ~/.bash_aliases ]]; then source ~/.bash_aliases; fi

if [[ -f ~/.bashrc.local ]]; then source ~/.bashrc.local; fi

if [[ -d ~/.bashrc.d ]]; then
    for f in ~/.bashrc.d/*; do
        source ${f}
    done
fi
