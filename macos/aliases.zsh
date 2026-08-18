#!/bin/zsh
alias afk="sleep 1 && pmset displaysleepnow"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias killchrome="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"
alias killdocker="killall Docker && open /Applications/Docker.app"
# Godot is a .app bundle, so its binary is not on PATH
alias godot="/Applications/Godot.app/Contents/MacOS/Godot"

# directories
alias apps="cd /Applications"
alias lib="cd $HOME/Library"

# network. these moved out of system/aliases.zsh when it was made portable —
# ipconfig, dscacheutil and mDNSResponder are all macOS-only
alias flush="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias route="netstat -rn"
