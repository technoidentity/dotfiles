This repository configures your system for Clojure, Scala and Web development.

## Installation

Installer script will work only with the latest Ubuntu and Mac operating systems.

### Quick installation

Following command sets up your system for Scala development using Intellij Idea, Clojure using Emacs and Web Development using Visual Studio Code

On Mac

    curl -L http://bit.ly/srtpldf > ~/setup && bash ~/setup everything

On Ubuntu

    wget -qO- http://bit.ly/srtpldf > ~/setup && bash ~/setup everything

#### Web

On Mac

    curl -L http://bit.ly/srtpldf > ~/setup && bash ~/setup web

On Ubuntu

    wget -qO- http://bit.ly/srtpldf > ~/setup && bash ~/setup web

#### Clojure

On Mac

    curl -L http://bit.ly/srtpldf > ~/setup && bash ~/setup clojure

On Ubuntu

    wget -qO- http://bit.ly/srtpldf > ~/setup && bash ~/setup clojure

#### Scala

On Mac

    curl -L http://bit.ly/srtpldf > ~/setup && bash ~/setup scala

On Ubuntu

    wget -qO- http://bit.ly/srtpldf > ~/setup && bash ~/setup scala

### Installer details

The installer script supports the following options: `everything`, `scala`, `clojure`, `web`. You could select the options you want.

Once the setup is done, if a few things did not go as planned, this script prints a set of warnings at the end of the installation.

You could get diagnostic messages after installation anytime. For example for `clojure` installation use

    bash setup diagnostics clojure

You could check `~/.technoidentity-installer.log` for installation log, `~/.technoidentity-error.log` for `stderr` output and `~/.technoidentity-output.log` for `stdout` output.

You could run the installer as many times as you want. For example, if you installed `scala` and later decide to install `clojure`, you could run the installer again with `clojure` option. If you need to fix something, you could most probably run the installer again to fix it.

## Configuration details

This repository is cloned into `~/.technoidentity/dotfiles` directory.

### Shell

`~/.zshrc` and `~/.bashrc` sources `~/.technoidentity/dotfiles/shellrc`. All configuration exists in this file.

[slimzsh](https://github.com/changs/slimzsh) is used for a nice and simple [pure](https://github.com/sindresorhus/pure) prompt and [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting). It's cloned to ~/.slimzsh. It also provide some nice zsh defaults and a few [aliases](https://github.com/changs/slimzsh/blob/master/aliases.zsh).

#### aliases

Following aliases are included(Zsh).

**upa**: Upgrades system packages, pulls from this repository, upgrades `npm` global packages, emacs packages and atom packages.

**open** : Aliases for ubuntu, which works similar to commands with the same name in mac.

**ec**: emacsclient GUI

**et**: emacsclient terminal

### Emacs

`~/.emacs.d/init.el` is an alias of `~/.technoidentity/dotfiles/emacs-init.el`. All emacs configuration exists in this file.

You could create `~/.emacs-pre-local.el` and/or `~/.emacs-post-local.el` write your own elisp code.

This configuration includes configuration for the following awesome emacs packages using [use-package](https://github.com/jwiegley/use-package).

**essential packages**:

- [projectile](https://github.com/bbatsov/projectile) is a project manager. Use `Ctrl+c p` for a list of `projectile` commands.
- [avy](https://github.com/abo-abo/avy) for jumping to a position in visible text, Use `Ctrl+'` and type two characters to jump to that location.

**programming essentials**:

- [flycheck](https://github.com/flycheck/flycheck) is an on the fly syntax checker.
- [company](https://github.com/company-mode/company-mode) - intellisense for `emacs`.
- [magit](https://github.com/magit/magit) - awesome `git` support in `emacs`.
- [cider](https://github.com/clojure-emacs/cider) - IDE like features for `clojure`.
- [parinfer](https://github.com/DogLooksGood/parinfer-mode) - [parinfer](https://shaunlebron.github.io/parinfer) for parenthesis management in Clojure.

### Visual Studio Code

**Plugins installed**: debugger-for-chrome, tslint, vscode-eslint, vscode-jest.

### Programming languages and configurations

**scala** : `sbt` is installed.

**clojure** : `leiningen` is installed

**web** : `node` is installed using `nvm`. Few of the `npm` packages installed globally - eslint, tslint, typescript, yarn and parcel
