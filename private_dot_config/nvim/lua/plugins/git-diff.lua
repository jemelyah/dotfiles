return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      previewers = {
        -- <leader>gd/<leader>gD (git_diff picker) pipe straight into this
        -- delta invocation. <leader>gs (git_status picker) instead shells out
        -- to real `git diff`/`git show` when style is "terminal", using
        -- whatever pager git is configured with (plain by default here,
        -- since ~/.gitconfig has no core.pager set).
        diff = {
          style = "terminal",
          cmd = { "delta", "--side-by-side" },
        },
      },
    },
  },
}
