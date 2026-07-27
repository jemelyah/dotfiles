-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- LazyVim already runs :checktime on FocusGained/TermClose/TermLeave; add
-- CursorHold too, scoped to the Obsidian vault, so a background rewrite by
-- the Obsidian app (iCloud sync) gets picked up even while Neovim stays
-- OS-focused.
local vault = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Emelianotes")
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = vault .. "/*",
  group = vim.api.nvim_create_augroup("obsidian_checktime", { clear = true }),
  command = "checktime",
})
