# GEMINI.md

This file provides guidance to the Gemini code assistant when working with this repository.

## Repository Overview

This is a personal dotfiles repository containing shell configurations, editor settings, and development environment customizations. The repository is organized into modular components that can be sourced by different shells and environments, with a focus on cross-platform support (macOS and Linux).

## Architecture

The dotfiles are structured with a modular approach:

-   **Shell Configuration**: Common settings are split between `alias.sh` (aliases) and `exports.sh` (environment variables), which are sourced by both `bash` and `zsh` configurations.
-   **Cross-Platform Support**: Configurations use conditional logic (`if [[ "$OSTYPE" == "linux-gnu" ]]`) to handle specifics for macOS (`darwin`) and Linux environments.
-   **Multi-Shell Support**: Both bash (`bash/bashrc`) and zsh (`zsh/zshrc`) configurations are present, sharing the common alias and export files.
-   **Modern Tools**: The setup includes modern tools like Neovim (Lua-based), Zed, and Hyprland.

## Key Configuration Files

### Shell & Terminal
-   `alias.sh`: Shared aliases across shells (git, docker, common shortcuts).
-   `exports.sh`: Shared environment variables and PATH modifications.
-   `bash/bashrc`: Bash-specific configuration.
-   `zsh/zshrc`: Zsh configuration using oh-my-zsh.
-   `tmux/tmux.conf`: Tmux configuration with `Ctrl-A` prefix and vim-style navigation.
-   `config/starship.toml`: Configuration for the Starship cross-shell prompt.
-   `ghostty/config`: Configuration for the Ghostty terminal emulator.
-   `Xresources`: X11 color scheme and resource configuration.

### Editors
-   `nvim/init.lua`: Main entry point for the Neovim configuration, which is Lua-based and managed with `lazy.nvim`.
-   `vim/vimrc`: Legacy Vim configuration.
-   `config/zed/settings.json`: Settings for the Zed code editor.
-   `config/zed/keymap.json`: Keybindings for the Zed code editor.

### Desktop Environment (Linux)
-   `hyprland/hyprland.conf`: Configuration for the Hyprland Wayland compositor.
-   `hyprland/waybar/`: Configuration and styling for the Waybar status bar.
-   `hyprland/wofi/`: Styling for the Wofi application launcher.

### Miscellaneous
-   `surf/`: A simple, local HTML/CSS homepage, likely for the Surf browser.
-   `.gitignore`: Specifies files and directories to be ignored by Git, such as `lazy-lock.json` and `.nvimlog`.

## Development Workflow

### Making Changes
1.  Test any modifications in a new shell session or editor instance before committing.
2.  Ensure cross-platform compatibility by checking `$OSTYPE` conditions where applicable.
3.  Maintain the modular structure by keeping shared logic in `alias.sh` and `exports.sh`.

### Shell Integration
-   The setup relies on the `$DOTFILES_PATH` environment variable, which is set in `zshrc` to point to the repository's location.
-   Shells source `alias.sh` and `exports.sh` from their respective rc files.
-   Tools like `nvm`, `bun`, and `composer` have their paths and initialization scripts configured in `zshrc` and `exports.sh`.