#!/usr/bin/env bash
# Ajusta o volume via wpctl e mostra um OSD (notificação com barra de progresso)
# usando o mako, que já tem progress-color configurado.

set -euo pipefail

action="${1:-}"
sink="@DEFAULT_AUDIO_SINK@"
label="Volume"

case "$action" in
    up)
        wpctl set-volume -l 1 "$sink" 5%+
        ;;
    down)
        wpctl set-volume "$sink" 5%-
        ;;
    mute)
        wpctl set-mute "$sink" toggle
        ;;
    mic-mute)
        sink="@DEFAULT_AUDIO_SOURCE@"
        label="Microfone"
        wpctl set-mute "$sink" toggle
        ;;
    *)
        echo "uso: $0 {up|down|mute|mic-mute}" >&2
        exit 1
        ;;
esac

vol_raw=$(wpctl get-volume "$sink")
volume=$(LC_ALL=C awk '{printf "%d", ($2 * 100) + 0.5}' <<< "$vol_raw")

if [[ "$vol_raw" == *MUTED* ]]; then
    icon="audio-volume-muted-symbolic"
    body="Mudo"
else
    if (( volume >= 66 )); then
        icon="audio-volume-high-symbolic"
    elif (( volume >= 33 )); then
        icon="audio-volume-low-symbolic"
    else
        icon="audio-volume-low-symbolic"
    fi
    body="${volume}%"
fi

[[ "$sink" == "@DEFAULT_AUDIO_SOURCE@" ]] && icon="microphone-sensitivity-high-symbolic"
[[ "$sink" == "@DEFAULT_AUDIO_SOURCE@" && "$vol_raw" == *MUTED* ]] && icon="microphone-sensitivity-muted-symbolic"

notify-send -h string:x-canonical-private-synchronous:volume-osd \
    -h int:value:"$volume" \
    -i "$icon" \
    "$label" "$body"
