#!/bin/bash
HISTTIMEFORMAT="$PWD - "
HISTFILESIZE=
HISTSIZE=
HISTCONTROL=ignoredups
HISTIGNORE=?:??
#shopt -s histappend                 # append to history, don't overwrite it
## attempt to save all lines of a multiple-line command in the same history entry
#shopt -s cmdhist
## save multi-line commands to the history with embedded newlines
#shopt -s lithist
#if [ $(id -u) -ne 0 ]; then
# export PS1="\[\e[32m\][\u\[\e[m\]@\[\e[36m\]\H\[\e[m\] \[\e[32;40m\]\W]\[\e[m\]\[\e[32m\]\$\[\e[m\] "
# tmux a -d || tmux new
#fi
#if [ "$(whoami)" == "chief" ]; then
# sudo -i
#fi
#PATH=/opt/utils:$PATH
