return {
  { "neovim/nvim-lspconfig", opts = { servers = { herb_ls = {} } } },
  {
    -- mason-lspconfig doesn't auto-bridge herb_ls -> herb-language-server,
    -- so it never gets queued for install; add it explicitly.
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "herb-language-server")
      return opts
    end,
  },
}
