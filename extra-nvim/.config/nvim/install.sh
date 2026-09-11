#!/usr/bin/env bash

# Neovim Configuration Install Script
# Creates symlink from ~/.config/nvim to this directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

echo "Installing Neovim configuration..."
echo "Source: $SCRIPT_DIR"
echo "Target: $NVIM_CONFIG_DIR"

# Create ~/.config directory if it doesn't exist
if [[ ! -d "$HOME/.config" ]]; then
    echo "Creating ~/.config directory..."
    mkdir -p "$HOME/.config"
fi

# Handle existing nvim config
if [[ -L "$NVIM_CONFIG_DIR" ]]; then
    echo "Symlink already exists at $NVIM_CONFIG_DIR"
    CURRENT_TARGET=$(readlink "$NVIM_CONFIG_DIR")
    # Resolve both paths to absolute paths for comparison
    CURRENT_TARGET_RESOLVED=$(cd "$CURRENT_TARGET" 2>/dev/null && pwd || echo "$CURRENT_TARGET")
    if [[ "$CURRENT_TARGET_RESOLVED" == "$SCRIPT_DIR" ]]; then
        echo "✅ Symlink is already correctly pointing to $SCRIPT_DIR"
        echo "No action needed."
        exit 0
    fi
elif [[ -d "$NVIM_CONFIG_DIR" ]]; then
    echo "⚠️  Directory already exists at $NVIM_CONFIG_DIR"
    echo "Backing up existing config to ${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
elif [[ -f "$NVIM_CONFIG_DIR" ]]; then
    echo "⚠️  File exists at $NVIM_CONFIG_DIR (expected directory or symlink)"
    echo "Moving to ${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Create the symlink
echo "Creating symlink: $NVIM_CONFIG_DIR -> $SCRIPT_DIR"
ln -sf "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"

echo "✅ Neovim configuration installed successfully!"
echo ""
echo "Next steps:"
echo "1. Open Neovim: nvim"
echo "2. Plugins will be automatically installed by lazy.nvim"
echo "3. LSP servers can be installed via :Mason"
