#!/bin/zsh
# Linux counterparts to the macOS-only aliases in macos/aliases.zsh. Only one of
# the two files is ever loaded — see the skip_os filter in zsh/aliases.zsh.

# network. deliberately no `ip` alias here: on linux that is iproute2's own
# command, and shadowing it would break far more than it helps
alias ips="ip -brief address"
alias route="ip route"

# systemd-resolved owns the dns cache on anything modern; resolvectl is the
# supported way to drop it
alias flush="sudo resolvectl flush-caches"

# debian ships these under different binary names to avoid clashes
command -v batcat > /dev/null && alias bat="batcat"
command -v fdfind > /dev/null && alias fd="fdfind"
