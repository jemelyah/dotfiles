-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.spelllang = { "en", "ru", "es", "lv" }

vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"

vim.opt.autoread = true
-- "yes": copy-then-overwrite preserves the file's inode, which matters for
-- iCloud's rename/replace-based sync detection (default "auto" can pick a
-- rename-based backup that confuses it). Safe globally, not vault-specific.
vim.opt.backupcopy = "yes"
