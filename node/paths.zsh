#!/bin/zsh

# load nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# load Node global installed binaries
export PATH="$HOME/.node/bin:$PATH"

# use project specific binaries before global ones
export PATH="node_modules/.bin:vendor/bin:$PATH"
