# tooie-tmux

A self-contained TPM plugin for Termux/tmux status widgets with optional Shizuku-powered data sourcing via `tooie`.

Designed to work best with the `shizuku-integration` branch of:

- https://github.com/PickleHik3/termux-launcher

## Features

- Left widgets: battery, CPU, RAM (toggleable)
- Right widgets: kew now-playing, Apps launcher label, weather (toggleable)
- Optional data source: `tooie resources` (Shizuku backend) with fallback to local `/proc` + `termux-battery-status`
- Native self-contained two-line status layout (no required split-statusbar/dotbar dependency)
- Dotbar-compatible variables are still exported if dotbar is installed
- Music ticker source: `kew` via MPRIS (https://github.com/ravachol/kew)
- Weather source: wttr.in

## Install (TPM)

Add to `.tmux.conf` before the TPM line:

```tmux
set -g @plugin 'PickleHik3/tooie-tmux'
```

Reload tmux and run `prefix + I`.

## Options

All enabled by default.

```tmux
# Master switch
set -g @tooie-tmux-enable 'on'

# Data source (on = use tooie resources when available)
set -g @tooie-tmux-enable-shizuku-data 'on'

# Widget toggles
set -g @tooie-tmux-widget-battery 'on'
set -g @tooie-tmux-widget-cpu 'on'
set -g @tooie-tmux-widget-ram 'on'
set -g @tooie-tmux-widget-kew 'on'
set -g @tooie-tmux-widget-apps 'on'
set -g @tooie-tmux-widget-weather 'on'

# Widths
set -g @tooie-tmux-status-left-length '600'
set -g @tooie-tmux-status-right-length '400'

# Force native two-line status layout managed by tooie-tmux
set -g @tooie-tmux-force-two-line 'on'
```

## Theme Overrides

Widget script supports env overrides. For persistent theme overrides create:

- `scripts/widgets/theme.conf` inside the plugin repo, or
- set `TMUX_TOOIE_WIDGET_THEME_FILE` to a custom file path.

Start from `scripts/widgets/theme.conf.example`.

## Notes

- Apps launcher binds `MouseDown1StatusRight` and `M-Enter`.
- If `tooie` is unavailable/disabled, CPU+RAM+battery use local fallback metrics.
- `@tooie-tmux-force-two-line` keeps line 1 for window list and line 2 for left/right widgets to avoid center contention truncation.

## Dependencies

- Required: `tmux`, `jq`
- Optional:
  - `tooie` (for Shizuku-backed resource snapshots)
  - `termux-api` (`termux-battery-status`) for fallback battery data
  - `kew` + dbus for now-playing widget
