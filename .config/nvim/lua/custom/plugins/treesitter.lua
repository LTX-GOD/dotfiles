return {
  'neovim-treesitter/nvim-treesitter',
  dependencies = { 'neovim-treesitter/treesitter-parser-registry' },
  build = ':TSUpdate',
  eager = true,
  config = function()
    require 'custom.config.treesitter'
  end,
}
