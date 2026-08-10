#!/bin/zsh
# load Node global installed binaries
export PATH="$HOME/.node/bin:$PATH"

# use project specific binaries before global ones
export PATH="node_modules/.bin:vendor/bin:$PATH"
