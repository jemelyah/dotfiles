-- IDE bridge only: no `server.start` override, so this never spawns its own
-- terminal. It finds the `opencode` already running in the `coder` tmux pane
-- (~/.config/tmux/agent-layout.sh) via its API, matched on cwd, and connects
-- to it for context sharing (ask/select/operator below).
return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<C-a>", function() require("opencode").ask("@this: ") end, mode = { "n", "x" }, desc = "Ask OpenCode…" },
    { "<C-x>", function() require("opencode").select() end, mode = { "n", "x" }, desc = "Select OpenCode…" },
    {
      "go",
      function() return require("opencode").operator("@this ") end,
      mode = { "n", "x" },
      expr = true,
      desc = "Append range to OpenCode",
    },
    {
      "goo",
      function() return require("opencode").operator("@this ") .. "_" end,
      mode = "n",
      expr = true,
      desc = "Append line to OpenCode",
    },
  },
}
