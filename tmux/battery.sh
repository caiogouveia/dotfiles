#!/usr/bin/env bash

# Shell script to extract battery status & level for tmux status bar
# Inspired by gpakosz/.tmux battery plugin (cross-platform macOS & Linux support)

get_battery_info() {
  local os_type
  os_type="$(uname -s)"

  case "$os_type" in
    *Darwin*)
      if command -v pmset >/dev/null 2>&1; then
        local pm_output
        pm_output=$(pmset -g batt 2>/dev/null)
        if echo "$pm_output" | grep -q "InternalBattery"; then
          pct=$(echo "$pm_output" | grep -oE '[0-9]+%' | head -1 | tr -d '%')
          if echo "$pm_output" | grep -qi "discharging"; then
            charging=0
          else
            charging=1
          fi
        fi
      fi
      ;;
    *Linux*)
      for batpath in /sys/class/power_supply/*[Bb][Aa][Tt]* /sys/class/power_supply/battery; do
        [ -d "$batpath" ] || continue
        if [ -r "$batpath/scope" ]; then
          read -r scope < "$batpath/scope" 2>/dev/null || true
          [ "$scope" = "Device" ] && continue
        fi

        if [ -r "$batpath/capacity" ]; then
          read -r pct < "$batpath/capacity" 2>/dev/null || true
        elif [ -r "$batpath/energy_full" ] && [ -r "$batpath/energy_now" ]; then
          read -r now < "$batpath/energy_now" 2>/dev/null || true
          read -r full < "$batpath/energy_full" 2>/dev/null || true
          if [ -n "$full" ] && [ "$full" -gt 0 ]; then
            pct=$(( now * 100 / full ))
          fi
        fi

        if [ -r "$batpath/status" ]; then
          read -r st < "$batpath/status" 2>/dev/null || true
          if [ "$st" = "Discharging" ]; then
            charging=0
          else
            charging=1
          fi
        fi
        break
      done
      ;;
  esac

  if [ -z "$pct" ]; then
    return 1
  fi

  return 0
}

get_battery_info || exit 0

# Set status icon
if [ "$charging" -eq 1 ]; then
  status_icon="⚡"
else
  status_icon="🔋"
fi

# Generate progress bar (10 segments)
filled=$(( (pct + 5) / 10 ))
[ "$filled" -gt 10 ] && filled=10
empty=$(( 10 - filled ))

bar=""
for ((i=0; i<filled; i++)); do bar="${bar}█"; done
for ((i=0; i<empty; i++)); do bar="${bar}░"; done

# Output according to requested format
mode="${1:-full}"

case "$mode" in
  pct|percentage)
    echo "${pct}%"
    ;;
  status)
    echo "$status_icon"
    ;;
  bar)
    echo "$bar"
    ;;
  simple)
    echo "$status_icon ${pct}%"
    ;;
  full|*)
    echo "$status_icon ${pct}% $bar"
    ;;
esac
