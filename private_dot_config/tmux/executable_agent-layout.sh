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

# MCP scoping: --strict-mcp-config keeps only what --mcp-config lists,
# dropping Trello and any other project/user .mcp.json servers. It can't
# touch claude.ai connectors (Docs/Calendar/Drive/Gmail) or plugins
# (Playwright) — those live in separate scopes, so Playwright stays on in
# all three panes for free. Architect alone also gets Obsidian, pulled live
# from ~/.claude.json rather than duplicated into this (public) repo.
mcp_none=$(mktemp)
echo '{"mcpServers":{}}' >"$mcp_none"

mcp_architect=$(mktemp)
chmod 600 "$mcp_architect"
jq '{mcpServers: {"obsidian-mcp-server": .projects[$HOME].mcpServers["obsidian-mcp-server"]}}' \
  --arg HOME "$HOME" "$HOME/.claude.json" >"$mcp_architect"

tmux send-keys -t "$coder" "claude --model sonnet --strict-mcp-config --mcp-config $mcp_none" C-m
# Planner/architect hand work over via agent-msg.sh: keep replies short and pass file paths, not pasted content.
brief="Reply concisely. When handing work to another agent pane, reference file paths or plan files instead of pasting content."
tmux send-keys -t "$planner" "claude --model sonnet --strict-mcp-config --mcp-config $mcp_none --append-system-prompt '$brief'" C-m
tmux send-keys -t "$architect" "claude --model opus --permission-mode plan --strict-mcp-config --mcp-config $mcp_architect --append-system-prompt '$brief'" C-m

tmux select-pane -t "$nvim"
