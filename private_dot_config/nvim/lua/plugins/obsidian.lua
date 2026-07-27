local vault = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Emelianotes")

return {
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown", -- vault paths have literal spaces, unsafe as an autocmd pattern;
    -- `workspaces` below still scopes real behavior to the vault itself
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- Only the space-separated `Obsidian <subcommand>` style is used below.
      legacy_commands = false,
      -- One entry today; add a second { name = "work", path = "..." } here
      -- once the work vault's real path exists — nothing else to restructure.
      workspaces = { { name = "Emelianotes", path = vault } },
      daily_notes = {
        folder = "Calendar/Notes/Daily",
        default_tags = {},
      },
      templates = { folder = "Atlas/Utilities/Templates" },
      -- The vault's real frontmatter (up/related/created/rank/status/in) is
      -- hand-maintained via periodic-notes' own Properties templates; letting
      -- obsidian.nvim manage id/aliases/tags here would fight that on every save.
      frontmatter = { enabled = false },
      completion = { min_chars = 2 },
      new_notes_location = "notes_subdir",
      notes_subdir = "+", -- matches app.json's newFileFolderPath
    },
    keys = {
      { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian quick switch" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Obsidian search" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian backlinks" },
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Obsidian today" },
    },
  },
}
