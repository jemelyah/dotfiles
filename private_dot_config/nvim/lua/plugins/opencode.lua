return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = { "folke/snacks.nvim" },
  init = function()
    -- Set in `init` (before the plugin loads) since opts are read via a global
    -- var rather than a setup() call — see mrcjkb.dev/posts/2023-08-22-setup.html
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open("opencode --port", {
            win = { position = "right", enter = false },
          })
        end,
      },
    }
  end,
  keys = {
    { "<leader>ao", function() require("opencode.config").opts.server.start() end, desc = "Open OpenCode" },
    {
      "<C-.>",
      function()
        require("snacks.terminal").toggle("opencode --port", {
          win = { position = "right", enter = false },
        })
      end,
      -- Include terminal mode so it toggles closed from inside OpenCode too.
      -- Not bound under <leader> — that would add input delay while typing in the terminal.
      mode = { "n", "t" },
      desc = "Toggle OpenCode",
    },
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
    {
      "<S-C-u>",
      function() require("opencode").command("session.half.page.up") end,
      desc = "Scroll OpenCode up",
    },
    {
      "<S-C-d>",
      function() require("opencode").command("session.half.page.down") end,
      desc = "Scroll OpenCode down",
    },
  },
}
