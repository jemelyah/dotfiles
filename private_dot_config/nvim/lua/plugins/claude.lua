-- IDE bridge only: no built-in terminal/chat UI (that's the `planner`/`architect`
-- tmux panes from ~/.config/tmux/agent-layout.sh). This just runs the WebSocket
-- server + ~/.claude/ide/ lockfile so a `claude` running in a sibling tmux pane
-- auto-connects for selection context, diagnostics, and diff view.
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VeryLazy",
  opts = {
    terminal = { provider = "none" },
  },
}
