# Global OpenCode Instructions

## tmux agent panes (coder / planner / architect)

You may be running inside a tmux pane created by `~/.config/tmux/agent-layout.sh` (bound to `prefix+D`). Layout: nvim + shell on top, three agent panes on the bottom row, each tagged with a `@agent_role` pane option:

- `coder` — Claude Code (sonnet)
- `planner` — Claude Code (sonnet)
- `architect` — Claude Code (opus)

Addressing is scoped to your own tmux **window**, not the whole session — two layouts running in different windows of the same session never collide, even if both have a `coder`. `agent-msg.sh` resolves this via `-t "$TMUX_PANE"`, so it must run from inside a tmux pane (fails loudly otherwise), and it refuses to guess if it somehow finds more than one pane with the same role in your window.

Message a sibling agent pane:

```bash
~/.config/tmux/agent-msg.sh <role> "your message"      # bracketed-pastes text and submits
~/.config/tmux/agent-msg.sh --no-submit <role> "text"  # leaves text in the input box
```

Read a sibling's recent output:

```bash
tmux list-panes -t "$TMUX_PANE" -F '#{pane_id} #{@agent_role}'   # panes in your own window only
tmux capture-pane -p -t <pane_id>          # add -S -100 for more scrollback
```

Your own role, if any: `tmux display-message -p '#{@agent_role}'`.
