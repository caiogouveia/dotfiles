# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing shell configurations, editor settings, and development environment customizations. The repository is organized into modular components that can be sourced by different shells and environments.

## Architecture

The dotfiles are structured with a modular approach:

- **Shell Configuration**: Split between `alias.sh` and `exports.sh` that are sourced by both bash and zsh
- **Cross-Platform Support**: Configurations handle both macOS (`darwin`) and Linux environments
- **Environment Variables**: Centralized in `exports.sh` with conditional paths for different development tools
- **Multi-Shell Support**: Both bash (`bash/bashrc`) and zsh (`zsh/zshrc`) configurations that share common aliases and exports

## Key Configuration Files

### Shell Setup
- `alias.sh`: Shared aliases across shells (git, docker, laravel, rails shortcuts)
- `exports.sh`: Environment variables and PATH modifications
- `bash/bashrc`: Bash-specific configuration with custom git prompt
- `zsh/zshrc`: Zsh configuration using oh-my-zsh with simple theme

### Development Tools
- `vim/vimrc`: Vim configuration with vim-plug and CoC extensions for web development
- `tmux/tmux.conf`: Tmux configuration with Ctrl-A prefix and vim-style navigation
- `config/starship.toml`: Starship prompt configuration
- `config/ghostty/config`: Ghostty terminal emulator settings

## Development Workflow

### Making Changes
When modifying dotfiles:
1. Test changes in a new shell session before committing
2. Consider cross-platform compatibility (check `$OSTYPE` conditions)
3. Maintain the modular structure by keeping shared configurations in `alias.sh` and `exports.sh`

### Shell Integration
The configuration relies on:
- `$DOTFILES_PATH` environment variable (set to `$HOME/DEV/dotfiles` in zsh)
- Sourcing pattern: shells source `alias.sh` and `exports.sh` from their respective rc files
- Conditional loading based on OS type and available tools

### Development Tools Integration
- **NVM**: Node version management (conditionally loaded)
- **Composer**: PHP package manager (path in zsh config)
- **Android SDK**: Linux-specific path configuration
- **Docker**: User/Group ID exports for container compatibility
- **Git**: Custom prompt functions in bash, oh-my-zsh git plugin in zsh

## Platform-Specific Considerations

### macOS
- Uses `brew` for zsh-autosuggestions
- Bun completion support
- Native `open` command

### Linux
- Uses `nautilus` for file manager
- Android SDK path configuration
- WSL-specific display settings in bashrc

## Common Aliases

Key aliases to be aware of:
- `c`, `cls`: clear screen
- `ll`, `la`: enhanced ls commands
- `rs`, `rc`: Rails server/console
- `art`: Laravel artisan shortcut
- Docker shortcuts: `dll`, `dstop`, `dockerrun`, `dockerexec`
- Git: `giff` for diff of specific commit