-- nvim-treesitter has no CoffeeScript parser, so the Vim syntax plugin provides
-- highlighting and indentation for .coffee files.
return {
  "kchmck/vim-coffee-script",
  ft = "coffee",
  -- Neovim has no built-in .coffee detection, and the plugin's ftdetect runs only after the
  -- plugin loads. The plugin loads on the coffee filetype, so the filetype is registered here.
  init = function()
    vim.filetype.add({
      extension = { coffee = "coffee", cson = "coffee" },
      filename = { Cakefile = "coffee" },
    })
  end,
}
