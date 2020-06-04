#!/bin/zsh
if [ ! $(uname -s) = 'Darwin' ]; then
  export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi
