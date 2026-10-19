-- CoffeeScript syntax check: the project's own compiler compiles the buffer and
-- reports only compile errors. It runs where node_modules/.bin/coffee exists.
local function project_coffee(path)
  local root = vim.fs.root(path, "node_modules")
  local coffee = root and (root .. "/node_modules/.bin/coffee")
  return coffee and vim.uv.fs_stat(coffee) and coffee or nil
end

return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      coffee = { "coffee" },
    },
    linters = {
      coffee = {
        cmd = function()
          return project_coffee(vim.api.nvim_buf_get_name(0))
        end,
        condition = function(ctx)
          return project_coffee(ctx.filename) ~= nil
        end,
        stdin = true,
        args = { "--stdio", "--print" },
        stream = "stderr",
        ignore_exitcode = true,
        parser = require("lint.parser").from_pattern(
          "^%[stdin%]:(%d+):(%d+): error: (.*)$",
          { "lnum", "col", "message" },
          nil,
          { severity = vim.diagnostic.severity.ERROR, source = "coffee" }
        ),
      },
    },
  },
}
