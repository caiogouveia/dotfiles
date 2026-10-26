#!/usr/bin/env bash
# Sincroniza o tema do tmux, Ghostty e Alacritty com o do nvim via
# ~/.config/nvim/.colorscheme.
#   theme.sh          aplica o tema salvo
#   theme.sh <nome>   salva <nome> e aplica (o nvim acompanha ao ganhar foco)
#   theme.sh --pick   escolhe um tema com fzf

THEMES_DIR="$HOME/.config/tmux/themes"
STATE_FILE="$HOME/.config/nvim/.colorscheme"
FALLBACK="vesper"

if [ "$1" = "--pick" ]; then
    name=$(ls "$THEMES_DIR" | sed 's/\.conf$//' | fzf --prompt="tema> " --reverse) || exit 0
    exec "$0" "$name"
fi

if [ -n "$1" ]; then
    mkdir -p "$(dirname "$STATE_FILE")"
    printf '{"name":"%s"}\n' "$1" > "$STATE_FILE"
fi

name=$(sed -n 's/.*"name":"\([^"]*\)".*/\1/p' "$STATE_FILE" 2>/dev/null)
[ -f "$THEMES_DIR/$name.conf" ] || name="$FALLBACK"

# tmux (sem servidor rodando, só ignora)
tmux source-file "$THEMES_DIR/$name.conf" 2>/dev/null

# Ghostty: config inclui current-theme.conf; recarrega via AppleScript no macOS
GHOSTTY_DIR="$HOME/.config/ghostty"
if [ -f "$GHOSTTY_DIR/themes/nvim-$name" ]; then
    printf 'theme = nvim-%s\n' "$name" > "$GHOSTTY_DIR/current-theme.conf"
    if command -v osascript >/dev/null 2>&1; then
        osascript -e 'if application "Ghostty" is running then tell application "Ghostty" to perform action "reload_config" on terminal 1' >/dev/null 2>&1 &
    fi
fi

# Alacritty: importa current-theme.toml e recarrega sozinho ao detectar mudança
ALACRITTY_DIR="$HOME/.config/alacritty"
if [ -f "$ALACRITTY_DIR/nvim-themes/$name.toml" ]; then
    cp "$ALACRITTY_DIR/nvim-themes/$name.toml" "$ALACRITTY_DIR/current-theme.toml"
fi
