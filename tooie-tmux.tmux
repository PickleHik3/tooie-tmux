#!/usr/bin/env bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/scripts/helpers.sh"

backup_status_formats() {
  # Keep original values once so users can restore manually if needed.
  if [ -z "$(tmux show-option -gqv @tooie-tmux-backup-status-format-0)" ]; then
    tmux set-option -gq @tooie-tmux-backup-status-format-0 "$(tmux show-option -gqv status-format[0])"
    tmux set-option -gq @tooie-tmux-backup-status-format-1 "$(tmux show-option -gqv status-format[1])"
    tmux set-option -gq @tooie-tmux-backup-status-left "$(tmux show-option -gqv status-left)"
    tmux set-option -gq @tooie-tmux-backup-status-right "$(tmux show-option -gqv status-right)"
    tmux set-option -gq @tooie-tmux-backup-status "$(tmux show-option -gqv status)"
  fi
}

build_split_formats() {
  local base fmt_windows fmt_widgets
  base="$(tmux show-option -gqv @tooie-tmux-backup-status-format-0)"
  [ -n "$base" ] || base="$(tmux show-option -gqv status-format[0])"
  [ -n "$base" ] || base="$(tmux show-option -gqv status-format[6])"
  [ -n "$base" ] || base='#[align=left range=left #{E:status-left-style}]#[push-default]#{T;=/#{status-left-length}:status-left}#[pop-default]#[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{E:window-status-style}]#[push-default]#{T:window-status-format}#[pop-default]#[norange default]#{?loop_last_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{E:window-status-current-style},default},#{E:window-status-current-style},#{E:window-status-style}}]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange list=on default]#{?loop_last_flag,,#{window-status-separator}}}#[nolist align=right range=right #{E:status-right-style}]#[push-default]#{T;=/#{status-right-length}:status-right}#[pop-default]#[norange default]'

  # line 0: windows only
  fmt_windows="$(printf '%s' "$base" | sed 's/#{T;=\/#{status-left-length}:status-left}//g' | sed 's/#{T;=\/#{status-right-length}:status-right}//g')"
  # line 1: widgets only
  fmt_widgets="$(printf '%s' "$base" | sed 's/:window-status-current-format//g' | sed 's/:window-status-format//g')"

  tmux set-option -gq status-format[0] "$fmt_windows"
  tmux set-option -gq status-format[1] "$fmt_widgets"
}

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
set_tmux_option_if_unset "@tooie-tmux-status-justify" "centre"
set_tmux_option_if_unset "@tooie-tmux-force-two-line" "on"
set_tmux_option_if_unset "@tooie-tmux-color-prefix-bg" "#f9f972"
set_tmux_option_if_unset "@tooie-tmux-color-prefix-fg" "#241b30"
set_tmux_option_if_unset "@tooie-tmux-color-base-bg" "#241b30"
set_tmux_option_if_unset "@tooie-tmux-color-base-fg" "#55a8fb"
set_tmux_option_if_unset "@tooie-tmux-color-kew" "#36f9f6"
set_tmux_option_if_unset "@tooie-tmux-color-window-inactive" "#75715e"
set_tmux_option_if_unset "@tooie-tmux-color-window-active" "#f4bf75"
set_tmux_option_if_unset "@tooie-tmux-apps-label" "󰀻 Apps"
set_tmux_option_if_unset "@tooie-tmux-apps-menu-file" ""

if is_on "$(get_tmux_option "@tooie-tmux-enable" "on")"; then
  left_len="$(get_tmux_option "@tooie-tmux-status-left-length" "600")"
  right_len="$(get_tmux_option "@tooie-tmux-status-right-length" "400")"
  status_justify="$(get_tmux_option "@tooie-tmux-status-justify" "centre")"
  two_line="$(get_tmux_option "@tooie-tmux-force-two-line" "on")"
  prefix_bg="$(get_tmux_option "@tooie-tmux-color-prefix-bg" "#f9f972")"
  prefix_fg="$(get_tmux_option "@tooie-tmux-color-prefix-fg" "#241b30")"
  base_bg="$(get_tmux_option "@tooie-tmux-color-base-bg" "#241b30")"
  base_fg="$(get_tmux_option "@tooie-tmux-color-base-fg" "#55a8fb")"
  window_inactive_fg="$(get_tmux_option "@tooie-tmux-color-window-inactive" "#75715e")"
  window_active_fg="$(get_tmux_option "@tooie-tmux-color-window-active" "#f4bf75")"
  tmux set-option -gq status-left-length "$left_len"
  tmux set-option -gq status-right-length "$right_len"
  tmux set-option -gq status-justify "$status_justify"

  left_fmt="#[bg=#{?client_prefix,${prefix_bg},${base_bg}},fg=#{?client_prefix,${prefix_fg},#00fbfd},bold] #{?client_prefix,󰘳 PREFIX,}#[bg=${base_bg},fg=${base_fg}]#($CURRENT_DIR/scripts/render-left.sh) "
  right_fmt="#($CURRENT_DIR/scripts/render-right.sh)"

  # Native self-contained status widgets.
  tmux set-option -gq status-style "bg=${base_bg},fg=${base_fg}"
  tmux set-window-option -gq window-status-style "fg=${window_inactive_fg},bg=default"
  tmux set-window-option -gq window-status-current-style "fg=${window_active_fg},bg=default,bold"
  tmux set-window-option -gq window-status-format "#W#{?window_flags,#{window_flags}, }"
  tmux set-window-option -gq window-status-current-format "#W#{?window_flags,#{window_flags}, }"
  tmux set-option -gq status-left "$left_fmt"
  tmux set-option -gq status-right "$right_fmt"

  # Also set dotbar options for compatibility if dotbar is installed.
  tmux set-option -gq @tmux-dotbar-status-left "$left_fmt"
  tmux set-option -gq @tmux-dotbar-status-right "$right_fmt"

  if is_on "$two_line"; then
    backup_status_formats
    tmux set-option -gq status 2
    build_split_formats
  fi

  if is_on "$(get_tmux_option "@tooie-tmux-widget-apps" "on")"; then
    tmux bind-key -n MouseDown1StatusRight run-shell "$CURRENT_DIR/scripts/launch-apps-menu mouse"
    tmux bind-key -n M-Enter run-shell "$CURRENT_DIR/scripts/launch-apps-menu key"
  fi
fi
