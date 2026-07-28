#!/bin/bash
# Layout: editor (Claude Code lives inside nvim via claudecode.nvim, <leader>ac)
# on top, logs/tests pane below.
tmux send-keys "${EDITOR:-nvim}" C-m
tmux split-window -v -p 25
tmux select-pane -U
