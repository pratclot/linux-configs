#!/bin/bash
if [[ $- =~ i ]]; then
   reset=$(tput sgr0)
   bold=$(tput bold)
   black=$(tput setaf 0)
   red=$(tput setaf 1)
   green=$(tput setaf 2)
   yellow=$(tput setaf 3)
   blue=$(tput setaf 4)
   magenta=$(tput setaf 5)
   cyan=$(tput setaf 6)
   white=$(tput setaf 7)
   user_color=$yellow
   root_color=$(tput setab 1)
   if [ "$(id -u)" -ne 0 ]; then
      PS1="\[$reset\][\[$user_color\]\u\[$reset\]@\[$reset\]\h \[$cyan\]\W\[$reset\]] [\$(EXITCODE=\$?; if [ \$EXITCODE -ne 0 ]; then echo ${red}\${EXITCODE}; else echo $green\${EXITCODE}; fi)\[$reset\]] \[$reset\]\[$reset\]\\$\[$reset\] "
   fi
fi
