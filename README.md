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

## Todo

- add gpgsign
- add internal ssh infrastructure

# Manual steps

- Upload the new id_rsa key to github, gitlab
- Download aseprite manually
- Open -dmg files and install manually
- Test if font downloads works first

Cisco Webex Meetings
