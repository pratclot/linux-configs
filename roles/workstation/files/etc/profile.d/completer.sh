#!/bin/bash
_docker_completer() {
       local cur prev opts
       COMPREPLY=()
       cur="${COMP_WORDS[COMP_CWORD]}"
       prev="${COMP_WORDS[COMPW_CWORD-1]}"
       opts="$(docker ps --format '{{.Names}}')"
       #if [[ ${cur} == -* ]]; then
               COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
               return 0
       #fi
}
for i in $(awk -F'[()]' '/\(\) \{/ {print $1}' /etc/profile.d/docker_functions.sh); do
 complete -F _docker_completer $i
done
