#!/data/data/com.termux/files/usr/bin/sh
set -eu
CURRENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$CURRENT_DIR/scripts/helpers.sh"

show_battery="$(get_tmux_option '@tooie-tmux-widget-battery' 'on')"
show_cpu="$(get_tmux_option '@tooie-tmux-widget-cpu' 'on')"
show_ram="$(get_tmux_option '@tooie-tmux-widget-ram' 'on')"
use_shizuku="$(get_tmux_option '@tooie-tmux-enable-shizuku-data' 'on')"
empty_color="$(get_tmux_option '@tooie-tmux-color-empty' '#5f5f87')"
ram_color="$(get_tmux_option '@tooie-tmux-color-ram' '#ffb86c')"
sep_color="$(get_tmux_option '@tooie-tmux-color-separator' '#6b7089')"
meter_1="$(get_tmux_option '@tooie-tmux-color-meter-1' '#ff5f5f')"
meter_2="$(get_tmux_option '@tooie-tmux-color-meter-2' '#ff875f')"
meter_3="$(get_tmux_option '@tooie-tmux-color-meter-3' '#ffd75f')"
meter_4="$(get_tmux_option '@tooie-tmux-color-meter-4' '#a4e84a')"
meter_5="$(get_tmux_option '@tooie-tmux-color-meter-5' '#6ee7a2')"
meter_6="$(get_tmux_option '@tooie-tmux-color-meter-6' '#34d399')"
charge_color="$(get_tmux_option '@tooie-tmux-color-charging' '#7dcfff')"
bat_full="$(get_tmux_option '@tooie-tmux-icon-battery-full' '')"
bat_empty="$(get_tmux_option '@tooie-tmux-icon-battery-empty' '')"
bat_charging="$(get_tmux_option '@tooie-tmux-icon-battery-charging' ' 󱈑')"

TOOIE_TMUX_SHOW_BATTERY="$show_battery" \
TOOIE_TMUX_SHOW_CPU="$show_cpu" \
TOOIE_TMUX_SHOW_RAM="$show_ram" \
TOOIE_TMUX_ENABLE_SHIZUKU_DATA="$use_shizuku" \
TMUX_TOOIE_EMPTY_COLOR="$empty_color" \
TMUX_TOOIE_RAM_COLOR="$ram_color" \
TMUX_TOOIE_SEP_COLOR="$sep_color" \
TMUX_TOOIE_METER_1_COLOR="$meter_1" \
TMUX_TOOIE_METER_2_COLOR="$meter_2" \
TMUX_TOOIE_METER_3_COLOR="$meter_3" \
TMUX_TOOIE_METER_4_COLOR="$meter_4" \
TMUX_TOOIE_METER_5_COLOR="$meter_5" \
TMUX_TOOIE_METER_6_COLOR="$meter_6" \
TMUX_TOOIE_CHARGE_COLOR="$charge_color" \
TMUX_TOOIE_BAT_FULL_ICON="$bat_full" \
TMUX_TOOIE_BAT_EMPTY_ICON="$bat_empty" \
TMUX_TOOIE_BAT_CHARGING_ICON="$bat_charging" \
"$CURRENT_DIR/scripts/widgets/tooie-system-widgets"
