#!/usr/bin/env zsh

# Opções do menu
lock="  Bloquear"
logout="󰗽  Sair"
reload="  Recarregar Hyprland"
waybar_reload="  Recarregar Waybar"
reboot="  Reiniciar"
shutdown="  Desligar"

# Mostra o menu via fuzzel
selected=$(echo -e "$lock\n$logout\n$reload\n$waybar_reload\n$reboot\n$shutdown" | fuzzel --dmenu \
    --prompt "Power Menu: " \
    --lines=6 \
    --width=25)

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
    "$waybar_reload")
        killall waybar
        waybar & disown
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$shutdown")
        systemctl poweroff
        ;;
esac
