return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      link = { wiki = { enabled = true } },
      callout = {
        box = { raw = "[!BOX]", rendered = "📦 Box", highlight = "RenderMarkdownHint", category = "custom" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { "markdown", "markdown_inline" })
    end,
  },
}
