#!/data/data/com.termux/files/usr/bin/sh
set -eu
CURRENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$CURRENT_DIR/scripts/helpers.sh"

show_battery="$(get_tmux_option '@tooie-tmux-widget-battery' 'on')"
show_cpu="$(get_tmux_option '@tooie-tmux-widget-cpu' 'on')"
show_ram="$(get_tmux_option '@tooie-tmux-widget-ram' 'on')"
use_shizuku="$(get_tmux_option '@tooie-tmux-enable-shizuku-data' 'on')"

TOOIE_TMUX_SHOW_BATTERY="$show_battery" \
TOOIE_TMUX_SHOW_CPU="$show_cpu" \
TOOIE_TMUX_SHOW_RAM="$show_ram" \
TOOIE_TMUX_ENABLE_SHIZUKU_DATA="$use_shizuku" \
"$CURRENT_DIR/scripts/widgets/tooie-system-widgets"
