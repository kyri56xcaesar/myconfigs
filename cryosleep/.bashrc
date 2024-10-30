#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


export BROWSER=/usr/bin/firefox


# might delete, minikube kubectl
alias kubectl='minikube kubectl'

alias h='history'
alias f='find'
alias pi='ping'
alias n='nvim'
alias b='btop'
alias r='ranger'
alias cls='clear; neofetch'
alias sl='clear; ls'
alias ll='ls -la'
alias lah='ls -lah'
alias l='ls'
alias btc='brightnessctl'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
