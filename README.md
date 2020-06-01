# [dot]files

My personal dotfiles for macOS and Linux 👨‍💻

- 📖 Read my blog post about these files
-

you are able to run packages independently or run the installing script again

## Errors

If you get errors, read the prompt and solve them before running the script again.
this normally means that you need to install something manually, e.g. xcode-select.

## Component setup

In general every folder is self-contained, meaning they can be installed independently. Though this script borrows concepts from `holman's dotfiles <https://github.com/holman/dotfiles>`\_ for ease of use.

- **topic/\*.symlink**: Any file ending in \*.symlink gets symlinked into your \$HOME. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run script/bootstrap.

## Thanks to...

all the repos
https://github.com/kevinSuttle/macOS-Defaults/blob/master/.macos

## Todo

- add gpgsign
- add internal ssh infrastructure

# Manual steps

- Upload the new id_rsa key to github, gitlab
- Download aseprite manually
- Open -dmg files and install manually
- Test if font downloads works first

Cisco Webex Meetings

## Docs

.localrc for local environment variables

------------------------------------------------------------------------------
Oh My Zsh Distribution Notes
------------------------------------------------------------------------------

What you are looking at now is Oh My Zsh's repackaging of zsh-history-substring-search 
as an OMZ module inside the Oh My Zsh distribution.

The upstream repo, zsh-users/zsh-history-substring-search, can be found on GitHub at 
https://github.com/zsh-users/zsh-history-substring-search.

This downstream copy was last updated from the following upstream commit:

  SHA:          
  Commit date:  

Everything above this section is a copy of the original upstream's README, so things
may differ slightly when you're using this inside OMZ. In particular, you do not
need to set up key bindings for the up and down arrows yourself in `~/.zshrc`; the OMZ 
plugin does that for you. You may still want to set up additional emacs- or vi-specific
bindings as mentioned above.

