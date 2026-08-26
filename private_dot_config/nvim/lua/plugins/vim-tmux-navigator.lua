local directions = {
  h = { cmd = "TmuxNavigateLeft", desc = "Go to Left Window" },
  j = { cmd = "TmuxNavigateDown", desc = "Go to Lower Window" },
  k = { cmd = "TmuxNavigateUp", desc = "Go to Upper Window" },
  l = { cmd = "TmuxNavigateRight", desc = "Go to Right Window" },
}

-- Mirrors LazyVim's own `term_nav` (lazyvim/plugins/util.lua), but hands off to
-- vim-tmux-navigator instead of a bare `wincmd`, so leaving the last Neovim
-- window in a direction crosses into the surrounding tmux pane. Floating
-- terminals still pass the key through to the running program — there is no
-- window to leave, and the AI TUIs use <C-l> etc. themselves.
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd(directions[dir].cmd)
    end)
  end
end

local keys = {
  -- Normal mode only: terminal mode needs <C-\><C-n> to escape.
  { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Go to Previous Window" },
}
for dir, spec in pairs(directions) do
  -- Terminal mode too, so plain `:terminal` buffers navigate like everything
  -- else; snacks terminals are handled by the buffer-local keys below.
  table.insert(keys, { "<c-" .. dir .. ">", "<cmd>" .. spec.cmd .. "<cr>", mode = { "n", "t" }, desc = spec.desc })
end

return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = keys,
  },

  -- claudecode.nvim and opencode.nvim both render their panel as a
  -- snacks.terminal, where LazyVim installs buffer-local <C-hjkl> maps that win
  -- over the global ones above. Replace them with the tmux-aware equivalents.
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          keys = {
            nav_h = { "<C-h>", term_nav("h"), desc = directions.h.desc, expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("j"), desc = directions.j.desc, expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("k"), desc = directions.k.desc, expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("l"), desc = directions.l.desc, expr = true, mode = "t" },
          },
        },
      },
    },
  },
}
