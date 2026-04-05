#!/usr/bin/env zsh

# Opções do menu
lock="  Bloquear"
logout="󰗽  Sair"
reload="  Recarregar Hyprland"
reboot="  Reiniciar"
shutdown="  Desligar"

# Mostra o menu via wofi
selected=$(echo -e "$lock\n$logout\n$reload\n$reboot\n$shutdown" | wofi --dmenu \
    --prompt "Power Menu" \
    --width=300 \
    --height=280 \
    --cache-file /dev/null \
    -c "$HOME/.config/wofi/config" \
    -s "$HOME/.config/wofi/style.css")

# Executa a ação baseada na escolha
case "$selected" in
    "$lock")
        hyprlock
        ;;
    "$logout")
        hyprctl dispatch exit
        ;;
    "$reload")
        hyprctl reload
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$shutdown")
        systemctl poweroff
        ;;
esac
