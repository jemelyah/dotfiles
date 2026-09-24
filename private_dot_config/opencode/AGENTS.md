# Global OpenCode Instructions

## tmux agent panes (coder / planner / architect)

You may be running inside a tmux pane created by `~/.config/tmux/agent-layout.sh` (bound to `prefix+D`). Layout: nvim + shell on top, three agent panes on the bottom row, each tagged with a `@agent_role` pane option:

- `coder` — Claude Code (sonnet)
- `planner` — Claude Code (sonnet)
- `architect` — Claude Code (opus)

Message a sibling agent pane:

```bash
~/.config/tmux/agent-msg.sh <role> "your message"      # bracketed-pastes text and submits
~/.config/tmux/agent-msg.sh --no-submit <role> "text"  # leaves text in the input box
```

Read a sibling's recent output:

```bash
tmux list-panes -s -F '#{pane_id} #{@agent_role}'
tmux capture-pane -p -t <pane_id>          # add -S -100 for more scrollback
```

Your own role, if any: `tmux display-message -p '#{@agent_role}'`.
