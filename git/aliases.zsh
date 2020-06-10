#!/bin/zsh
alias g="git"
alias gt="gittower ."
alias gg="g pull && g push"

# use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
  function diff() {
    git diff --no-index --color-words "$@";
  }
fi;
