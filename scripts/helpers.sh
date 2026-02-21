#!/data/data/com.termux/files/usr/bin/sh

get_tmux_option() {
  key="$1"
  default="${2-}"
  v="$(tmux show-option -gqv "$key" 2>/dev/null || true)"
  if [ -n "$v" ]; then
    printf '%s' "$v"
  else
    printf '%s' "$default"
  fi
}

set_tmux_option_if_unset() {
  key="$1"
  val="$2"
  cur="$(tmux show-option -gqv "$key" 2>/dev/null || true)"
  if [ -z "$cur" ]; then
    tmux set-option -gq "$key" "$val"
  fi
}

is_on() {
  case "$1" in
    1|on|true|yes|enabled) return 0 ;;
    *) return 1 ;;
  esac
}
