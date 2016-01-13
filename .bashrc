#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

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

call_ps1_extra()
{
    [[ $(type -t ps1_extra) == function ]] && ps1_extra
}

PS1="[\[\e[0;34m\]\u\[\e[m\e[0;32m\]@\h\[\e[m\] \W\[\e[0;33m\]\$(git_branch_get)\[\e[m\]\$(call_ps1_extra --exit-status \$?)]\$ "

# PATHs
export PATH=$PATH:~/bin

# bc env vars
export BC_ENV_ARGS=~/.bcrc

# use vi editing mode
set -o vi

# Import custom aliases file
if [[ -f ~/.bash_aliases ]]; then source ~/.bash_aliases; fi

if [[ -f ~/.bashrc.local ]]; then source ~/.bashrc.local; fi
