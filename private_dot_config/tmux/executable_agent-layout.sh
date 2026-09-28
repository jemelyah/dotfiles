#!/bin/bash
# Agent workspace layout — run in a fresh single-pane window (prefix+D).
#
#   top 60%:    nvim (85% width) + shell (15%)
#   bottom 40%: coder (claude sonnet) | planner (claude sonnet) | architect (claude opus)
#
# Agent panes are tagged with the @agent_role pane option — agent-msg.sh and
# the nvim agent-panes module resolve targets by it.
set -euo pipefail

if [ "$(tmux list-panes | wc -l)" -gt 1 ]; then
  tmux display-message "agent-layout: run in a single-pane window"
  exit 1
fi

nvim=$(tmux display-message -p '#{pane_id}')

# Split top/bottom first so the bottom row spans the full window width.
coder=$(tmux split-window -v -d -p 40 -P -F '#{pane_id}')

# Top row: 15% shell on the right; the left 85% keeps nvim.
shell=$(tmux split-window -h -d -p 15 -P -F '#{pane_id}')

# Bottom row into equal thirds: coder | planner | architect.
planner=$(tmux split-window -h -d -t "$coder" -p 66 -P -F '#{pane_id}')
architect=$(tmux split-window -h -d -t "$planner" -p 50 -P -F '#{pane_id}')

tmux set-option -p -t "$coder" @agent_role coder
tmux set-option -p -t "$planner" @agent_role planner
tmux set-option -p -t "$architect" @agent_role architect

tmux send-keys -t "$nvim" 'nvim' C-m
tmux send-keys -t "$coder" 'claude --model sonnet' C-m
tmux send-keys -t "$planner" 'claude --model sonnet' C-m
tmux send-keys -t "$architect" 'claude --model opus' C-m

tmux select-pane -t "$nvim"
