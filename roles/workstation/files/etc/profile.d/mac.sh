#!/bin/bash

if [ $(command -v brew) ]; then
  source $(brew --prefix)/etc/bash_completion
  export HOMEBREW_NO_AUTO_UPDATE=1
fi
