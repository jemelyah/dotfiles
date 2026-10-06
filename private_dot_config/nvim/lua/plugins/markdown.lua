return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "codecompanion" },
    opts = {
      -- Show raw markdown on the line the cursor is on, rendered everywhere else.
      anti_conceal = { enabled = true },
      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "block",
        left_pad = 0,
        right_pad = 2,
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 2,
        border = "thin",
      },
      bullet = { icons = { "•", "◦", "▪", "▫" } },
      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        },
      },
      -- Obsidian vault: wiki links and callouts.
      link = {
        wiki = { enabled = true, icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
      },
      callout = {
        box = { raw = "[!BOX]", rendered = "📦 Box", highlight = "RenderMarkdownHint", category = "custom" },
      },
      pipe_table = { preset = "round" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { "markdown", "markdown_inline" })
    end,
  },
}
