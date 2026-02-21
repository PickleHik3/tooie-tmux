#!/data/data/com.termux/files/usr/bin/sh
set -eu
CURRENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$CURRENT_DIR/scripts/helpers.sh"

show_kew="$(get_tmux_option '@tooie-tmux-widget-kew' 'on')"
show_apps="$(get_tmux_option '@tooie-tmux-widget-apps' 'on')"
show_weather="$(get_tmux_option '@tooie-tmux-widget-weather' 'on')"

out=""

if is_on "$show_kew"; then
  now="$("$CURRENT_DIR/scripts/widgets/kew-now-playing" 2>/dev/null || true)"
  if [ -n "$now" ]; then
    out="$out#[fg=#36f9f6]$now "
  fi
fi

if is_on "$show_apps"; then
  out="$out#[range=user|launch,bold] 󰀻 Apps #[norange default]"
fi

if is_on "$show_weather"; then
  wx="$("$CURRENT_DIR/scripts/widgets/weather-cache" 2>/dev/null || true)"
  if [ -n "$wx" ]; then
    out="$out$wx"
  fi
fi

printf '%s' "$out"
