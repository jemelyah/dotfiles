return {
  "nvim-mini/mini.surround",
  opts = {
    custom_surroundings = {
      ["="] = {
        input = { "==().-()==" },
        output = { left = "==", right = "==" },
      },
    },
  },
  keys = {
    { "<leader>mh", "gsaiw=", desc = "Highlight word (==)", mode = "n", remap = true },
    { "<leader>mh", "gsa=", desc = "Highlight selection (==)", mode = "x", remap = true },
    { "<leader>mH", "gsd=", desc = "Remove highlight (==)", mode = "n", remap = true },
  },
}
