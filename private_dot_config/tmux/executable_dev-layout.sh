#!/bin/bash
# Layout: [editor | claude code] on top, logs/tests pane below the editor.
tmux split-window -h -p 35
tmux send-keys "claude" C-m
tmux select-pane -L
tmux send-keys "${EDITOR:-nvim}" C-m
tmux split-window -v -p 25
tmux select-pane -U
