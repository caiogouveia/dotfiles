#!/usr/bin/env zsh

# Garante que a assinatura seja a mais recente (atual)
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/1000/hypr | head -n 1)

# Inicia o Quickshell (bar + sidebar) apontando para o diretorio unificado
quickshell -p ~/.config/quickshell
