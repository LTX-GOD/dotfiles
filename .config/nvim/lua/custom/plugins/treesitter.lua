return {
  'neovim-treesitter/nvim-treesitter',
  dependencies = { 'neovim-treesitter/treesitter-parser-registry' },
  build = ':TSUpdate',
  lazy = false,
  config = function()
    require 'custom.config.treesitter'
  end,
}
