return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    {
      "<leader>gv",
      function()
        if require("diffview.lib").get_current_view() then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "Diffview (staged + unstaged)",
    },
    {
      "<leader>gm",
      function()
        local base = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD"):match("refs/remotes/origin/(%S+)")
        vim.cmd("DiffviewOpen " .. (base or "main") .. "...HEAD")
      end,
      desc = "Diffview against default branch (PR review)",
    },
    {
      "<leader>gh",
      "<cmd>DiffviewFileHistory %<cr>",
      desc = "File history (current file)",
    },
  },
  -- Side-by-side file panel + diff, staging, and word-level highlighting are
  -- built in. This replaces the old snacks.nvim delta previewer override for
  -- <leader>gd/<leader>gD/<leader>gs, which only rendered a static diff —
  -- diffview gives a navigable, VSCode-Source-Control-style review UI.
  opts = {
    enhanced_diff_hl = true, -- word-level highlighting inside changed lines
  },
}
