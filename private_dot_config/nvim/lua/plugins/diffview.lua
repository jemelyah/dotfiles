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
  -- persistence.nvim saves diffview:// buffers into the session; on restore
  -- they come back as empty ordinary buffers, and diffview reuses an existing
  -- buffer by name instead of reloading it, so the left (old) side shows
  -- blank. Close the view and wipe its buffers before every session save.
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      group = vim.api.nvim_create_augroup("diffview_no_session", { clear = true }),
      callback = function()
        if package.loaded["diffview"] and require("diffview.lib").get_current_view() then
          vim.cmd("DiffviewClose")
        end
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_get_name(buf):match("^diffview://") then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
      end,
    })
  end,
  -- Side-by-side file panel + diff, staging, and word-level highlighting are
  -- built in. This replaces the old snacks.nvim delta previewer override for
  -- <leader>gd/<leader>gD/<leader>gs, which only rendered a static diff —
  -- diffview gives a navigable, VSCode-Source-Control-style review UI.
  opts = {
    enhanced_diff_hl = true, -- word-level highlighting inside changed lines
  },
}
