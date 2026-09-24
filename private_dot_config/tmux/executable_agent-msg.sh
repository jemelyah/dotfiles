#!/bin/bash
# Send a message to an agent pane in the current tmux session.
#
#   agent-msg.sh [--no-submit] <role> [text...]
#   echo "text" | agent-msg.sh [--no-submit] <role>
#
# Roles come from the @agent_role pane option (see agent-layout.sh):
# coder | planner | architect. Text is delivered via bracketed paste, so
# multiline content lands in the agent's input box safely; Enter submits
# unless --no-submit is given (useful for dropping an @file mention the
# user wants to complete into a question).
set -euo pipefail

submit=1
if [ "${1:-}" = "--no-submit" ]; then
  submit=0
  shift
fi

role=${1:?"usage: agent-msg.sh [--no-submit] <role> [text...]"}
shift || true

if [ "$#" -gt 0 ]; then
  text="$*"
else
  text=$(cat)
fi

if [ -z "$text" ]; then
  echo "agent-msg: empty message" >&2
  exit 1
fi

pane=$(tmux list-panes -s -F '#{pane_id} #{@agent_role}' | awk -v r="$role" '$2 == r { print $1; exit }')
if [ -z "$pane" ]; then
  echo "agent-msg: no pane with @agent_role=$role in this session" >&2
  exit 1
fi

buf="agent-msg-$$"
printf '%s' "$text" | tmux load-buffer -b "$buf" -
tmux paste-buffer -p -t "$pane" -b "$buf"
tmux delete-buffer -b "$buf"
if [ "$submit" -eq 1 ]; then
  tmux send-keys -t "$pane" Enter
fi
