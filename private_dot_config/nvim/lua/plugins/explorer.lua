local directions = {
  j = "TmuxNavigateDown",
  k = "TmuxNavigateUp",
  l = "TmuxNavigateRight",
}

-- The explorer's input/list windows bind <c-j>/<c-k> to list_down/list_up
-- (plain j/k already do this), which wins over the global tmux-navigator
-- window-nav maps from vim-tmux-navigator.lua — same root cause as the AI
-- pane fix there, just via a normal buffer-local keymap instead of terminal
-- capture. Free up ctrl-hjkl for window navigation.
local nav_keys = {}
for dir, cmd in pairs(directions) do
  nav_keys["<c-" .. dir .. ">"] = function()
    vim.cmd(cmd)
  end
end

-- <c-h> needs its own path: the explorer's list/input are floating windows
-- (relative="win") stacked inside a real split at the tab's true left edge.
-- Neovim's own `wincmd h` — which TmuxNavigateLeft relies on to detect "at
-- the edge" — mishandles that nesting and toggles focus back and forth
-- between the floating list and the main editor window instead of
-- recognizing there's nothing further left, so it never forwards to tmux.
-- Since the explorer is always docked left, going left from it always means
-- leaving to tmux — skip wincmd entirely and select the pane directly.
nav_keys["<c-h>"] = function()
  if vim.env.TMUX then
    vim.fn.system({ "tmux", "select-pane", "-t", vim.env.TMUX_PANE, "-L" })
  end
end

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        -- <leader>e (Snacks file explorer): show dotfiles by default.
        explorer = {
          hidden = true,
          win = {
            input = { keys = nav_keys },
            list = { keys = nav_keys },
          },
        },
      },
    },
  },
}
