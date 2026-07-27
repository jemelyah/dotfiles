-- Mason ships its own ruby-lsp/rubocop gems and prepends its bin/ to Neovim's
-- PATH, which would silently shadow the mise-resolved, project-correct
-- binaries. Disable Mason for these two so mise's shell-activated PATH wins.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = { mason = false },
        rubocop = { mason = false },
      },
    },
  },
  {
    -- erb-formatter/erb-lint are also gems, but Mason installs its
    -- ensure_installed tools via a gem call that runs outside any
    -- mise-pinned project directory, so it always hits macOS's ancient
    -- system Ruby (2.6.10) and fails. Drop them rather than fight Mason's
    -- installer context; herb_ls (below) covers ERB diagnostics instead.
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "erb-formatter" and tool ~= "erb-lint"
      end, opts.ensure_installed or {})
      return opts
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.eruby = nil
      return opts
    end,
  },
}
