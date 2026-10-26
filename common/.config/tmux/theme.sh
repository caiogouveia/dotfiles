#!/usr/bin/env bash
# Sincroniza o tema do tmux, Ghostty, Alacritty e dos nvim abertos com o
# tema salvo em ~/.config/nvim/.colorscheme.
#   theme.sh                  aplica o tema salvo
#   theme.sh <nome>           salva <nome> e aplica
#   theme.sh --preview <nome> aplica <nome> sem salvar
#   theme.sh --pick           escolhe com fzf, com preview ao navegar
# NVIM_SELF=<socket> evita notificar o nvim que chamou o script.

THEMES_DIR="$HOME/.config/tmux/themes"
STATE_FILE="$HOME/.config/nvim/.colorscheme"
NVIM_THEMES="$HOME/.config/nvim/lua/theprimeagen/lazy/colors.lua"
FALLBACK="vesper"

# Temas na ordem da tabela `themes` do nvim; os que só existem no tmux vão no fim.
list_themes() {
    {
        awk '/^local themes = \{/{f=1;next} f&&/^\}/{exit} f' "$NVIM_THEMES" 2>/dev/null |
            sed -n 's/.*name = "\([^"]*\)".*/\1/p'
        ls "$THEMES_DIR" | sed 's/\.conf$//'
    } | awk '!seen[$0]++' | while read -r t; do
        [ -f "$THEMES_DIR/$t.conf" ] && echo "$t"
    done
}

saved_theme() {
    sed -n 's/.*"name":"\([^"]*\)".*/\1/p' "$STATE_FILE" 2>/dev/null
}

# Pede para cada nvim aberto sincronizar: com nome faz preview, sem nome volta ao salvo.
notify_nvims() {
    local expr
    if [ -n "$1" ]; then expr="luaeval('ThemeSync(_A)', '$1')"; else expr="luaeval('ThemeSync()')"; fi
    local self
    self=$(printf '%s' "$NVIM_SELF" | tr -s /)
    find "${TMPDIR:-/tmp}" "${XDG_RUNTIME_DIR:-/tmp}" -type s -name 'nvim.*' 2>/dev/null | tr -s / | sort -u |
        while read -r sock; do
            [ "$sock" = "$self" ] && continue
            nvim --server "$sock" --remote-expr "$expr" >/dev/null 2>&1 &
        done
}

# Aplica <nome> no tmux e nos terminais.
apply() {
    local name="$1"
    [ -f "$THEMES_DIR/$name.conf" ] || name="$FALLBACK"

    # tmux (sem servidor rodando, só ignora)
    tmux source-file "$THEMES_DIR/$name.conf" 2>/dev/null

    # Ghostty: config inclui current-theme.conf; recarrega via AppleScript no macOS
    local ghostty_dir="$HOME/.config/ghostty"
    if [ -f "$ghostty_dir/themes/nvim-$name" ]; then
        printf 'theme = nvim-%s\n' "$name" > "$ghostty_dir/current-theme.conf"
        if command -v osascript >/dev/null 2>&1; then
            osascript -e 'if application "Ghostty" is running then tell application "Ghostty" to perform action "reload_config" on terminal 1' >/dev/null 2>&1 &
        fi
    fi

    # Alacritty: importa current-theme.toml e recarrega sozinho ao detectar mudança
    local alacritty_dir="$HOME/.config/alacritty"
    if [ -f "$alacritty_dir/nvim-themes/$name.toml" ]; then
        cp "$alacritty_dir/nvim-themes/$name.toml" "$alacritty_dir/current-theme.toml"
    fi
}

case "$1" in
    --pick)
        current=$(saved_theme)
        pos=$(list_themes | grep -nx "$current" | cut -d: -f1)
        name=$(list_themes | fzf --prompt="tema> " --reverse \
            --bind "start:pos(${pos:-1})" \
            --bind "focus:execute-silent($0 --preview {})") || { exec "$0"; }
        exec "$0" "$name"
        ;;
    --preview)
        apply "$2"
        notify_nvims "$2"
        ;;
    *)
        if [ -n "$1" ]; then
            mkdir -p "$(dirname "$STATE_FILE")"
            printf '{"name":"%s"}\n' "$1" > "$STATE_FILE"
        fi
        apply "$(saved_theme)"
        notify_nvims
        ;;
esac
