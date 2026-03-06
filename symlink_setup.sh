#!/bin/zsh

# Backup function for next step
backup() {
  target=$1
  if [ -e "$target" ]; then           # Does the config file already exist?
    if [ ! -L "$target" ]; then       # as a pure file?
      mv "$target" "$target.backup"   # Then backup it
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}

# Create symlinks for dotfiles and backup if existing files
DOTFILES_DIR="$PWD/dotfiles"

for name in "$DOTFILES_DIR"/*; do
  basename_file=$(basename "$name")
  if [ -f "$name" ]; then
    target="$HOME/.$basename_file"
    if [[ ! "$basename_file" =~ '\.sh$' ]] && [[ ! "$basename_file" =~ '\.json$' ]] && [[ ! "$basename_file" =~ '\.md$' ]] && [ "$basename_file" != 'ghostty' ]; then
      backup "$target"

      if [ ! -e "$target" ]; then
        echo "-----> Symlinking your new $target"
        ln -s "$name" "$target"
      fi
    fi
  fi
done

# Ghostty
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
mkdir -p "$GHOSTTY_CONFIG_DIR"
backup "$GHOSTTY_CONFIG_DIR/config"
if [ ! -e "$GHOSTTY_CONFIG_DIR/config" ]; then
  echo "-----> Symlinking Ghostty config"
  ln -s "$DOTFILES_DIR/ghostty" "$GHOSTTY_CONFIG_DIR/config"
fi

# VS Code settings & keybindings
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER_DIR"
for vscode_file in settings.json keybindings.json; do
  vscode_target="$VSCODE_USER_DIR/$vscode_file"
  if [ -e "$DOTFILES_DIR/$vscode_file" ]; then
    backup "$vscode_target"
    if [ ! -e "$vscode_target" ]; then
      echo "------> Symlinking $vscode_file to VS Code User dir"
      ln -s "$DOTFILES_DIR/$vscode_file" "$vscode_target"
    fi
  fi
done

# Reload shell config without opening a blocking interactive shell
source ~/.zshrc || true

echo "👌"
