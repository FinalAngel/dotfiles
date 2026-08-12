# Angelo's dotfiles

![Dotfiles preview](https://raw.githubusercontent.com/finalangel/dotfiles/master/preview.png)

🤗 &nbsp;These dotfiles help me to set up and maintain my macOS or Linux installations.
They intend to automate the installation and update process of, well,
everything. Feel free to explore, copy and re-use the code to your liking.

- 📖 &nbsp;Read my [blog post](https://angelo.dini.dev/blog/dotfiles/) about these files
- 🌐 &nbsp;Visit my [website](https://angelo.dini.dev)

## Installation

💥 &nbsp;**Warning**: Please fork and review the code first, before giving these dotfiles
a try. In theory, they can be installed on an existing system as well, but a
fresh installation is recommended. Use at your own risk.

**macOS notes**: Make sure to install the Xcode Command Line Tools by running
`xcode-select --install` first, then log into iCloud and the Apple App Store.

The following command will install the dotfiles into `~/.dotfiles` and runs the
installer automatically 🤖:

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/finalangel/dotfiles/master/bootstrap)"

🤔 &nbsp;Yeah that's it, really, I think...

## The `dot` command

👉 &nbsp;Once installed, use the following command to manage the dotfiles:

    $ dotfiles --help
    Usage: dotfiles [options]

    Options:
      -e, --edit     Edit dotfiles
      -g, --go       Go to dotfiles directory
      -h, --help     Show help
      -i, --install  Runs installer
      -u, --update   Runs updater

## The `harvest` command

⏱ &nbsp;A terminal front-end for [Harvest](https://www.getharvest.com/) time tracking,
so retroactive fixes don't mean clicking around the desktop app. It speaks plain
language:

    $ harvest "finished a 15 min standup, now back on project"
    plan:
      split      0:15  Internal / Meetings  "standup"
      switch           project / Development
    apply? [Y/n]

    ⏸ Project / Development — api refactor  2:45 → 2:30 (-0:15)
    + Internal / Meetings — standup  0:15
    ▶ Project / Development  running

Under the hood it's plain verbs, which are worth knowing since they're faster
than a sentence:

| Command | What it does |
| --- | --- |
| `harvest` / `harvest status` | What's running, plus today's total |
| `harvest today [date]` | List a day's entries |
| `harvest start <alias> [notes]` | Start a timer, stopping any running one |
| `harvest stop` | Stop the running timer |
| `harvest split <duration> <alias>` | Move time **out** of the running timer into another project |
| `harvest trim <duration>` | Shorten the running timer, discarding the time |
| `harvest log <duration> <alias>` | Add a finished entry, leaving the timer alone |
| `harvest note <text>` | Rewrite the running timer's notes |
| `harvest resume [alias]` | Restart today's most recent matching entry |
| `harvest projects [query]` | Browse the indexed projects and tasks |
| `harvest alias <name> <project>` | Point a short name at a project/task |

`split` is the interesting one: it shortens the running entry and inserts the
carved-out time as a separate entry, which is what "that last 15 minutes was
actually a standup" really means. `trim` is its sibling for time that belongs
nowhere — a timer left running through lunch.

**Setup**: create a personal access token at
[id.getharvest.com/developers](https://id.getharvest.com/developers), store it in
the Keychain, then let it index your assigned projects:

    security add-generic-password -s harvest-cli -a "$USER" -U -w
    harvest setup --account-id <your account id>
    harvest alias project Project

Durations accept `15m`, `1h30`, `1.5h`, `0:45` or a bare `90`. The natural-language
layer uses `ANTHROPIC_API_KEY` when set and otherwise shells out to the `claude`
CLI, so it works with no extra credentials. The deterministic verbs never call a
model at all.

## What's included

Except for `utils/` and `scripts/` every folder is its self-containing
**topic/** providing an `install` and `update` script. You can easily disable
individual **topics/** by commenting the lines in `scripts/`. On top of that:

- every `aliases.zsh`, `paths.zsh` and `functions.zsh` file in **topics/** is automatically loaded
- every `.symlink` file in **topics/** will be mapped to `~/.[filename]`
- everything in the `bin/` folder gets automatically added to your `$PATH`

The following package flavours are installed:

- [FiraCode](https://github.com/tonsky/FiraCode) with nice custom font management
- [Git with GPG signing](https://gnupg.org/) enabled
- [Homebrew](https://brew.sh/) with cask and mas
- [Neovim](https://neovim.io/)
- [Node with fnm](https://github.com/Schniz/fnm) manager
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Python with pyenv](https://virtualenv.pypa.io/en/latest/) and virtualenv
- [Starship](https://starship.rs/) 🚀
- [VSCode](https://code.visualstudio.com/) and plugins

## Contributions

🐛 &nbsp;Feel free to send me pull requests if something is misconfigured or could be
enhanced upon. These are very personal, but if they work for others as well,
the more, the merrier. I generally still want to improve on:

- Adding [tests](https://github.com/webpro/dotfiles/tree/master/test) would be nice :)

## Credits

❤️ &nbsp;Many thanks to the [dotfiles](https://dotfiles.github.io/) community and
the excellent work from [dotphiles](https://github.com/dotphiles/dotphiles),
[holman](https://github.com/holman/dotfiles),
[mathiasbynens](https://github.com/mathiasbynens/dotfiles),
[pchampio](https://github.com/pchampio/dotfiles) and
[webpro](https://github.com/webpro/dotfiles). This work wouldn't be possible
without them.
