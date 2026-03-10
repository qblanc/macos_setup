#!/bin/zsh

# Stop execution at any failure
set -e

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
REGULAR="\033[0;39m"

info()    { echo "${BLUE}-----> $1${REGULAR}" }
success() { echo "${GREEN}  ✔ $1${REGULAR}" }
skip()    { echo "${YELLOW}  ↷ $1 (already installed, skipping)${REGULAR}" }


# ─────────────────────────────────────────────
# 1. Command Line Tools
# ─────────────────────────────────────────────
info "Checking Xcode Command Line Tools..."
if xcode-select -p &>/dev/null; then
  skip "Xcode Command Line Tools"
else
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
  # Wait for the installation to complete
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  success "Xcode Command Line Tools installed"
fi

# If the command `xcode-select --install` fails try again: sometimes the Apple servers are overloaded.
# If you see the message "Xcode is not currently available from the Software Update server", you need to update the software update catalog by running:
# sudo softwareupdate --clear-catalog

# ─────────────────────────────────────────────
# 2. Homebrew
# ─────────────────────────────────────────────
info "Checking Homebrew..."
if command -v brew &>/dev/null; then
  skip "Homebrew"
else
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon Macs
  if [ -f /opt/homebrew/bin/brew ]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  success "Homebrew installed"
fi

info "Updating Homebrew..."
# Cleanup deprecated or broken taps that cause brew update to fail/warn
if brew tap | grep -q "homebrew/cask-versions"; then
  info "Removing deprecated homebrew/cask-versions tap..."
  brew untap homebrew/cask-versions || true
fi

# If brew update fails with "/usr/local must be writable", fix permissions and retry
if ! brew update 2>&1; then
  info "brew update failed — trying to fix common issues..."
  # Only try sudo chown on Intel Macs or specific paths if needed
  if [ -d /usr/local/Homebrew ]; then
    sudo chown -R "$USER:admin" /usr/local /usr/local/Homebrew 2>/dev/null || true
  fi
  brew update
fi
success "Homebrew updated"

# ─────────────────────────────────────────────
# 3. Brew packages
# ─────────────────────────────────────────────
brew_install() {
  local pkg=$1
  info "Installing/upgrading $pkg..."
  brew upgrade "$pkg" 2>/dev/null || brew install "$pkg"
  success "$pkg installed/upgraded"
}

brew_install git
brew_install gh
brew_install gnupg
brew_install wget
brew_install jq
brew_install openssl
brew_install libyaml
brew_install gmp
brew_install rust
brew_install defaultbrowser



# ─────────────────────────────────────────────
# 4. Apps (Casks)
# ─────────────────────────────────────────────
cask_install() {
  local app_pkg=$1
  local app_name_display=$2

  info "Checking $app_name_display..."
  # Check if already installed via Homebrew Cask or if the .app exists in /Applications
  if brew list --cask "$app_pkg" &>/dev/null || [ -n "$(mdfind "kMDItemFSName == '${app_name_display}.app'")" ]; then
    skip "$app_name_display"
  else
    info "Installing $app_name_display..."
    brew install --cask "$app_pkg"
    success "$app_name_display installed"
  fi
}

cask_install visual-studio-code "Visual Studio Code"
cask_install ghostty "Ghostty"
cask_install google-chrome "Google Chrome"
cask_install firefox "Firefox"
cask_install zen "Zen"
cask_install caffeine "Caffeine"
cask_install spotify "Spotify"
cask_install vlc "VLC"
cask_install antigravity "Antigravity"
cask_install github "GitHub Desktop"
cask_install postman "Postman"
cask_install whatsapp "WhatsApp"
cask_install logi-options+ "Logi Options+"
cask_install the-unarchiver "The Unarchiver"

info "Setting Zen as default browser..."
defaultbrowser zen
success "Zen set as default browser"

# Note: Screenzen is not found in Homebrew Cask yet.

# Manual installation recommended: https://screenzen.co/


# ─────────────────────────────────────────────
# 4b. Fonts
# ─────────────────────────────────────────────
info "Checking Ghostty fonts (MesloLGS NF)..."
FONTS_DIR="$HOME/Library/Fonts"
mkdir -p "$FONTS_DIR"
BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
declare -a fonts=(
  "MesloLGS%20NF%20Regular.ttf"
  "MesloLGS%20NF%20Bold.ttf"
  "MesloLGS%20NF%20Italic.ttf"
  "MesloLGS%20NF%20Bold%20Italic.ttf"
)

for font in "${fonts[@]}"; do
  # Decode URL encoding for local filename check (%20 -> " ")
  font_filename=$(echo "$font" | sed 's/%20/ /g')
  if [ -f "$FONTS_DIR/$font_filename" ]; then
    skip "$font_filename"
  else
    info "Downloading $font_filename..."
    curl -fsSL "$BASE_URL/$font" -o "$FONTS_DIR/$font_filename"
    success "$font_filename installed"
  fi
done


# ─────────────────────────────────────────────
# 5. Oh My Zsh & Zsh Plugins
# ─────────────────────────────────────────────
info "Checking Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
  skip "Oh My Zsh"
else
  info "Installing Oh My Zsh..."
  # RUNZSH=no prevents the installer from launching a new shell and blocking the script
  RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  success "Oh My Zsh installed"
fi

info "Checking Zsh plugins and themes..."
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting
fi
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_PLUGINS_DIR}/zsh-autosuggestions
fi
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-you-should-use" ]; then
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_PLUGINS_DIR}/zsh-you-should-use
fi
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-history-substring-search" ]; then
  git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_PLUGINS_DIR}/zsh-history-substring-search
fi

ZSH_THEMES_DIR="$HOME/.oh-my-zsh/custom/themes"
mkdir -p "$ZSH_THEMES_DIR"
if [ ! -d "$ZSH_THEMES_DIR/powerlevel10k" ]; then
  git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_THEMES_DIR}/powerlevel10k
fi
success "Zsh plugins and themes checked/installed"


# ─────────────────────────────────────────────
# 6. GitHub CLI authentication
# ─────────────────────────────────────────────
info "Checking GitHub CLI authentication..."
if gh auth status &>/dev/null; then
  skip "GitHub CLI (already authenticated)"
else
  info "GitHub authentication required — launching interactive login..."
  gh auth login -s 'user:email' -w --git-protocol ssh
  success "GitHub CLI authenticated"
fi

# `gh` will ask you few questions:
# - `Generate a new SSH key to add to your GitHub account?` Press `Enter` to ask gh to generate the SSH keys for you.
#   If you already have SSH keys, you will see instead `Upload your SSH public key to your GitHub account?` With the arrows, select your public key file path and press `Enter`.
# - `Enter a passphrase for your new SSH key (Optional)`. Type something you want and that you'll remember. It's a password to protect your private key stored on your hard drive. Then press `Enter`.
# - `Title for your SSH key`. You can leave it at the proposed "GitHub CLI", press `Enter`.
# To check that you are properly connected, type:
# ```bash
# gh auth status
# ```


# ─────────────────────────────────────────────
# 7. Dotfiles installer
# ─────────────────────────────────────────────
info "Running dotfiles installer..."
# Get the directory where install.sh is located
ROOT_DIR="$(cd "$(dirname "${(%):-%N}")" && pwd)"
cd "$ROOT_DIR"
zsh symlink_setup.sh
success "Dotfiles installed/updated"

# ─────────────────────────────────────────────
# 8 Reload Shell Configuration
# ─────────────────────────────────────────────
info "Reloading shell configuration..."
# We source instead of exec to keep the script running with new settings
[ -f "$HOME/.zprofile" ] && source "$HOME/.zprofile" || true
# Note: sourcing .zshrc in a script can be noisy due to OMZ/p10k, but it ensures PATH is updated
[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc" || true
success "Shell environment reloaded"


# ─────────────────────────────────────────────
# 9. mise
# ─────────────────────────────────────────────
# Let's install [`mise`](https://mise.jdx.dev/), a modern tool to manage environments and runtimes (Ruby, Node, etc.).
# Mise will replace `rbenv`, `nvm`, `conda`, etc.

info "Checking mise..."
if command -v mise &>/dev/null; then
  skip "mise"
else
  info "Cleaning up old version managers..."
  # Clean up rvm, rbenv, nvm if they exist
  rvm implode --force || true
  sudo rm -rf ~/.rvm $HOME/.rbenv /usr/local/rbenv $HOME/.nvm $HOME/.pyenv $HOME/anaconda3 /anaconda3 || true

  info "Installing mise..."
  curl https://mise.run | sh

  # Activate for current script
  export PATH="$HOME/.local/bin:$PATH"
  eval "$(mise activate zsh)"

  # Persist for future sessions
  if ! grep -q "mise activate" ~/.zprofile; then
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zprofile
  fi
  success "mise installed"
fi


# ─────────────────────────────────────────────
# 10. Ruby (via mise)
# ─────────────────────────────────────────────
info "Checking Ruby (via mise)..."
if mise ls ruby | grep -q "$(mise latest ruby)"; then
  skip "Ruby"
else
  info "Installing latest Ruby..."
  mise use -g ruby@latest
  success "Ruby installed"
fi

info "Installing Ruby gems..."
gem update --system
gem update bundler
gem install --no-document rake rails rspec activerecord ruby-lsp rubocop-performance colored faker faraday pry-byebug
success "Gems installed"

# If the following error is displayed:

# ```bash
# ERROR: While executing gem ... (TypeError)
# incompatible marshal file format (can't be read)
# format version 4.8 required; 60.33 given
# ```

# The following command will fix it:
# ```bash
# rm -rf ~/.gemrc
# ```

# Then rerun the command to install the gems.


# ─────────────────────────────────────────────
# 11. Python (via mise)
# ─────────────────────────────────────────────
info "Checking Python (via mise)..."
if mise ls python | grep -q "$(mise latest python)"; then
  skip "Python"
else
  info "Installing latest Python..."
  mise use -g python@latest
  success "Python installed"
fi


# ─────────────────────────────────────────────
# 12. Node.js (via mise)
# ─────────────────────────────────────────────
info "Checking Node.js (via mise)..."
if mise ls node | grep -q "$(mise latest node@lts)"; then
  skip "Node.js (LTS)"
else
  info "Installing Node.js (LTS)..."
  mise use -g node@lts
  success "Node.js installed"
fi

info "Updating npm to latest..."
npm install -g npm@latest
success "npm updated"

info "Cleaning caches..."
mise cache clean
npm cache clean --force
success "Caches cleaned"


# ─────────────────────────────────────────────
# 13. yarn
# ─────────────────────────────────────────────
info "Checking yarn..."
if command -v yarn &>/dev/null; then
  skip "yarn"
else
  info "Installing yarn..."
  corepack enable
  yarn set version stable
  success "yarn installed"
fi


# ─────────────────────────────────────────────
# 14. TypeScript
# ─────────────────────────────────────────────
info "Checking TypeScript..."
if command -v tsc &>/dev/null; then
  skip "TypeScript"
else
  info "Installing TypeScript..."
  # Note: Même si on utilise Yarn pour nos projets, "npm install -g" reste la
  # méthode standard pour installer des exécutables globaux sur la machine.
  # Les versions modernes de Yarn (v2+) ont d'ailleurs supprimé l'option 'yarn global'.
  npm install -g typescript ts-node
  success "TypeScript installed"
fi


# ─────────────────────────────────────────────
# 15. PostgreSQL
# ─────────────────────────────────────────────
info "Checking PostgreSQL..."
brew_install postgresql
brew services start postgresql
success "PostgreSQL checked and started"


# ─────────────────────────────────────────────
# 16. DevDocs
# ─────────────────────────────────────────────
info "Checking DevDocs..."
# Spotlight searching via `mdfind` allows finding the app anywhere on the Mac
if [ -n "$(mdfind "kMDItemFSName == 'DevDocs.app'")" ]; then
  skip "DevDocs"
else
  info "Installing DevDocs dans /Applications..."
  # On s'assure que nativefier est bien installé globalement
  if ! command -v nativefier &>/dev/null; then
    npm install -g nativefier
  fi

  # Génération dans un dossier temporaire pour rester propre
  TMP_DIR=$(mktemp -d)
  nativefier --name "DevDocs" "https://devdocs.io" "$TMP_DIR"

  # Déplacement de l'app générée vers le répertoire des applications
  # (Sudo est utilisé en fallback si les permissions standards ne suffisent pas)
  if ! cp -R "$TMP_DIR"/*/*.app "/Applications/" 2>/dev/null; then
    sudo cp -R "$TMP_DIR"/*/*.app "/Applications/"
  fi
  rm -rf "$TMP_DIR"

  success "DevDocs installé dans /Applications"
fi


# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────
echo ""
echo "${GREEN}✔ All steps are complete!${REGULAR}"
echo "${RED}🛑 Please restart your terminal to apply all changes.${REGULAR}"
echo ""
