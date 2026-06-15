return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'milanglacier/minuet-ai.nvim',
  },
  event = 'VeryLazy',
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = ' '
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    return require('custom.ui.statusline')
  end,
}
