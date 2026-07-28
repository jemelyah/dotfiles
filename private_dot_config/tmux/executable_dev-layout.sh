#!/bin/bash
# Layout: main pane (nvim, Claude Code lives inside it via claudecode.nvim,
# <leader>ac) + logs/tests pane below it; narrow pane on the right (~20%)
# free for parallel tasks.
tmux split-window -h -p 20
tmux select-pane -L
tmux send-keys "${EDITOR:-nvim}" C-m
tmux split-window -v -p 25
tmux select-pane -U
