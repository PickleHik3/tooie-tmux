#!/usr/bin/env bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/scripts/helpers.sh"

set_tmux_option_if_unset "@tooie-tmux-enable" "on"
set_tmux_option_if_unset "@tooie-tmux-enable-shizuku-data" "on"
set_tmux_option_if_unset "@tooie-tmux-widget-battery" "on"
set_tmux_option_if_unset "@tooie-tmux-widget-cpu" "on"
set_tmux_option_if_unset "@tooie-tmux-widget-ram" "on"
set_tmux_option_if_unset "@tooie-tmux-widget-weather" "on"
set_tmux_option_if_unset "@tooie-tmux-widget-apps" "on"
set_tmux_option_if_unset "@tooie-tmux-widget-kew" "on"
set_tmux_option_if_unset "@tooie-tmux-status-left-length" "600"
set_tmux_option_if_unset "@tooie-tmux-status-right-length" "400"

if is_on "$(get_tmux_option "@tooie-tmux-enable" "on")"; then
  left_len="$(get_tmux_option "@tooie-tmux-status-left-length" "600")"
  right_len="$(get_tmux_option "@tooie-tmux-status-right-length" "400")"
  tmux set-option -gq status-left-length "$left_len"
  tmux set-option -gq status-right-length "$right_len"

  left_fmt="#\[bg=#{?client_prefix,#f9f972,#241b30},fg=#{?client_prefix,#241b30,#00fbfd},bold\] #{?client_prefix,󰘳 PREFIX,}#\[bg=#241b30,fg=#55a8fb\]#($CURRENT_DIR/scripts/render-left.sh) "
  right_fmt="#($CURRENT_DIR/scripts/render-right.sh)"

  tmux set-option -gq @tmux-dotbar-status-left "$left_fmt"
  tmux set-option -gq @tmux-dotbar-status-right "$right_fmt"

  # Optional fallback if dotbar isn't used.
  tmux set-option -gq status-left "$left_fmt"
  tmux set-option -gq status-right "$right_fmt"

  if is_on "$(get_tmux_option "@tooie-tmux-widget-apps" "on")"; then
    tmux bind-key -n MouseDown1StatusRight run-shell "$CURRENT_DIR/scripts/launch-apps-menu mouse"
    tmux bind-key -n M-Enter run-shell "$CURRENT_DIR/scripts/launch-apps-menu key"
  fi
fi
