return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = function()
    return require('custom.config.gitsigns')
  end,
}
