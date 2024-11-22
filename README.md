# neovim config using lua for neovim >= 0.8 (should be 0.10)

### tmux config

```python3
set -g @almost-sensible 'on'

if-shell '[[ "$TERM" == "xterm-kitty" ]]' {
  set -g default-terminal "xterm-kitty"
} {
  set -g default-terminal "tmux-256color"
}

set-option -g focus-events on

set-option -sa terminal-overrides ",xterm*:Tc"

# make sure we always start at 1, even when invoked from a .tmux wrapper script
set-environment -g SHLVL 1

# toggle control between outer and nested session
bind -T root F12  \
  set prefix None \;\
  set key-table off \;\
  if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
  refresh-client -S \;\

bind -T off F12 \
  set -u prefix \;\
  set -u key-table \;\
  refresh-client -S

# configuration of the status line
bind '\' set -g status
if-shell "[[ $(tmux lsw | wc -l) -le 1 ]]" 'set -g status'
set -g status-left-length 32
set -g status-right-length 150
set -g status-fg '#737aa2'
set -g status-bg '#1D202F'

set -g pane-border-style fg=colour245
set -g pane-active-border-style 'fg=#7aa2f7'
set -g message-style fg=black,bg=brightwhite,bold

set -g base-index 1
setw -g pane-base-index 1

set -g status on

# visual notification of activity in other windows
setw -g monitor-activity on

# automatically renumber window numbers on closing a pane (tmux >= 1.7).
set -g renumber-windows on

# dynamically update window titles
setw -g allow-rename off
setw -g automatic-rename off
set -g set-titles on # set title with macOS term proxy-title instead
set -g set-titles-string '#W'  # program name

# increase history limit up from default of 2000
set -g history-limit 100000

bind '%' split-window -h -c "#{pane_current_path}"
bind '"' if-shell '[[ "$DISABLE_AUTO_TITLE" == true ]]' \
       'split-window -c "#{pane_current_path}" -e "DISABLE_AUTO_TITLE=true"' \
       'split-window -c "#{pane_current_path}"' # TODO condition doesn't work

# Vim style pane selection
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
bind 'C-h' select-pane -L
bind 'C-j' select-pane -D
bind 'C-k' select-pane -U
bind 'C-l' select-pane -R

bind -r l next-window
bind -r h previous-window
bind -r o select-pane -t :.+

bind 'a' last-window
bind 'w' choose-window -Z -F "#W #F"
bind 'C-Space' next-layout

# mouse control
set-option -g -q mouse on

# rotate panes while zoomed
bind 'C-o' if-shell 'test #{window_zoomed_flag} -eq 1' 'rotate-window; resize-pane -Z' 'rotate-window'

# move windows
bind '<' if-shell 'test #{window_index} -eq 1' 'new-window -d; swap-window -t -1; kill-window; select-window -t "\{end\}"' 'swap-window -d -t -1'
bind '>' if-shell 'test #{window_end_flag} -eq 1' 'move-window -t 0' 'swap-window -d -t +1'

# swap pane active pane with marked
bind '|' swap-pane

# incremental search up of buffer
bind-key -T copy-mode-vi / command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""
bind-key -T copy-mode-vi ? command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""
bind-key '/' copy-mode\; command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""
bind-key '?' copy-mode\; command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""

# search back to last prompt
bind-key 'b' copy-mode\; send -X search-backward "# $USER"

# setup 'v' to begin selection as in Vim
set-window-option -g mode-keys vi
unbind-key -T copy-mode-vi 'v'
# bind-key -T copy-mode-vi 'y' send -X copy-pipe "reattach-to-user-namespace pbcopy"  # macOS
bind-key -T copy-mode-vi 'y' send -X copy-pipe "xclip -i -f -selection primary | xclip -i -selection clipboard"  # Linux
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'V' send -X select-line
bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle

# clear selection on click; makes for nicer consecutive drags.
# bind-key -T copy-mode-vi MouseDown1Pane send-keys -X clear-selection

# Stay in copy mode on drag end.
# (Would use `bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X
# stop-selection` but it is a bit glitchy.)
unbind-key -T copy-mode-vi MouseDragEnd1Pane

# Scroll 1 lines at a time instead of default 5; don't extend dragged selections.
bind-key -T copy-mode-vi WheelUpPane select-pane\; send-keys -t'{mouse}' -X clear-selection\; send-keys -t'{mouse}' -X -N 1 scroll-up
bind-key -T copy-mode-vi WheelDownPane select-pane\; send-keys -t'{mouse}' -X clear-selection\; send-keys -t'{mouse}' -X -N 1 scroll-down

# Make double and triple click work outside of copy mode (already works inside it with default bindings).
bind-key -T root DoubleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-word"
bind-key -T root TripleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-line"

# Don't exit copy mode on double or triple click.
bind-key -T copy-mode-vi DoubleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-word"
bind-key -T copy-mode-vi TripleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-line"

# For those times when C-c and q are not enough.
bind-key -T copy-mode-vi Escape send-keys -X cancel

# decide whether we're in a Vim process
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'

if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

bind-key -n 'C-Space' if-shell "$is_vim" 'send-keys C-Space' 'select-pane -t:.+'

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l
bind-key -T copy-mode-vi 'C-Space' select-pane -t:.+

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @resurrect-strategy-nvim 'session'

run -b '~/.tmux/plugins/tpm/tpm'
```
