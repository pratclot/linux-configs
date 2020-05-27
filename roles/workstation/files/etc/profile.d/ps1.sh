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
      KCC=$(LC_ALL=C awk -F": " '/current-context/ {print $2}' ~/.kube/config)
      KNS=$(yq -r --arg KCC "${KCC}" '.contexts[] | select(.name==$KCC) | .context.namespace' ~/.kube/config)
      PS1="[\\[$user_color\\]\u\\[$reset\\]@\h \\[$cyan\\]\W\\[$reset\\] \\[$bold\\]${KNS}\\[$reset\\]] [\$(EXITCODE=\$?; if [ \${EXITCODE} -ne 0 ]; then echo \\[$red\\]\${EXITCODE}; else echo \\[$green\\]\${EXITCODE}; fi)\\[$reset\\]] "
   fi
fi
