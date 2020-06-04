# Angelo's dotfiles

![Dotfiles preview](https://raw.githubusercontent.com/finalangel/dotfiles/master/preview.png)

These dotfiles help me to setup and maintain my macOS or linux installations.
They intend to automate the installation and update process of, well,
everything. Feel free to explore, copy and re-use the code to your liking 🤗.

- 📖 Read my [blog post](https://angelo.dini.dev/blog) about these files
- 🌐 Visit my [website](https://angelo.dini.dev)

## Installation

**Warning**: Please fork and review the code first, before giving these dotfiles
a try. In theory, they can be installed on an existing system as well but a
fresh installation is recommended. Use at your own risk 💥.

The following command will install the dotfiles into `~/.dotfiles` and runs the
installer automatically 🤖:

- `bash -c "curl -fsSL https://raw.githubusercontent.com/finalangel/dotfiles/master/bootstrap"`

Yeah that's it, really, I think...

## The `dot` command

Once installed, use the following command to manage the dotfiles:

    $ dot --help
    Usage: dot [options]

    Options:
      -i, --install  Runs installer
      -u, --update   Runs updater
      -e, --edit     Edit dotfiles
      -h, --help     Show this help message and exit

## What's included

Except for `utils/` and `scripts/` every folder is its self-containing
**topic/** providing an `install` and `update` script. You can easily disable
individual **topics/** by commenting the lines in `scripts/`.

`aliases.zsh` and `paths.zsh` files are automatically loaded. Every `.symlink`
file will be mapped to `~/.[filename]`. Everything in the `bin/` folder gets
automatically added to your `$PATH`.

The following package flavours are installed:

- [FiraCode](https://github.com/tonsky/FiraCode) with nice custom font management
- [Git with GPG signing](https://gnupg.org/) enabled
- [Homebrew](https://brew.sh/) with cask and manual installs (via scripts)
- [Mackup](https://github.com/lra/mackup) to backup macOS application settings
- [Neovim](https://neovim.io/)
- [Node with NVM](https://github.com/nvm-sh/nvm) manager
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Python with virtualenv](https://virtualenv.pypa.io/en/latest/) management
- [Starship](https://starship.rs/) 🚀
- [Tmux](https://github.com/tmux/tmux)
- [VSCode](https://code.visualstudio.com/) and plugins

## Contributions

Feel free to send me pull requests if something is misconfigured or could be
enhanced upon. These are very personal but if they work for others as well,
the more the merrier. I generally still want to improve on 🐛:

- Vim setup (plugin automation and better workflow)
- The dot command could be [improved](https://github.com/webpro/dotfiles/blob/master/bin/dotfiles)
- Adding [tests](https://github.com/webpro/dotfiles/tree/master/test) would be nice :)

## Credits

Many thanks to the [dotfiles](https://dotfiles.github.io/) community and
the excellent work from [dotphiles](https://github.com/dotphiles/dotphiles),
[holman](https://github.com/holman/dotfiles),
[mathiasbynens](https://github.com/mathiasbynens/dotfiles),
[pchampio](https://github.com/pchampio/dotfiles) and
[webpro](https://github.com/webpro/dotfiles). This work wouldn't be possible
without them ❤️.
