# macOS Setup & Dotfiles

This repository contains an automated installation script to set up a brand new macOS environment for development, along with personal configuration files. It covers all basic CLI & System Tools, Applications (IDE & Terminal) & languages (Ruby, Python, Node). No AI tools are setup here.


## 📋 Prerequisites

Before running the installation script, make sure to personalize your Git configuration. Open `dotfiles/gitconfig` and update the `[user]` section with your own details:

```ini
[user]
	email = your-email@example.com
	name = Your Name
```

## 🚀 Installation

To start the full installation process, simply open your terminal at the root of this folder and run:

```bash
zsh install.sh
```

To also configure mac_os_defaults, run

```bash
zsh mac_os_defaults.sh
```

To setup the dock automatically to a minimal and nice config, run
```bash
zsh default_dock_setup.sh
```

## 🏗 Architecture

The setup logic is cleanly separated into two main scripts and one configuration directory:

### 1. `install.sh` (The Orchestrator)
This is the main entry point. It handles all software installations and environment configurations securely:
- **System Tools**: Xcode Command Line Tools, Homebrew.
- **Applications (Casks)**: Visual Studio Code, Ghostty.
- **CLI Tools**: Git, GitHub CLI (gh), wget, jq, postgresql, etc.
- **Shell**: Oh My Zsh, custom Zsh plugins, and themes (Powerlevel10k).
- **Environments**: Installs `mise` to manage Ruby, Node.js, and Python versions in a single unified way.
- **Orchestration**: Automatically calls `symlink_setup.sh` to link your dotfiles once the software is installed.

### 2. `symlink_setup.sh` (The Linker)
A pure symlinking script securely creating cross-links. Its only job is to recursively link the configurations in `dotfiles/` to your system (e.g., `~/.zshrc`).
- **Idempotent**: It safely backs up existing configuration files (renaming them to `.backup`) before replacing them.
- Handles special paths automatically (like Ghostty configs and VS Code).

### 3. `dotfiles/` (Configuration Files)
This folder contains all the raw configuration files. Any new file added here will be automatically symlinked by the installer.

## --- NOTES ---

### mise

if ruby, node etc. are not installed in a project with a valid config file, the following command should be enough to install it

```bash
mise install
```

### macOs defaults

interesting macOs defaults can be found [here](https://github.com/mathiasbynens/dotfiles/blob/master/.macos). For instance :

```bash
# Expanding the save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save screenshots to the Desktop (or elsewhere)
defaults write com.apple.screencapture location "${HOME}/Desktop"

# etc..
```

### Keyboard speed

Keyboard speed can be changed in ` > System Settings... > Keyboard`. Set `Key repeat rate` to the fastest position (to the right) and `Delay until repeat` to the shortest position (also to the right).
