return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>e', '<cmd>Neotree focus<cr>',  desc = '聚焦文件树（未打开则打开）' },
    { '<leader>E', '<cmd>Neotree toggle<cr>', desc = '切换文件树' },
    { '<leader>fe', '<cmd>Neotree reveal<cr>', desc = '在文件树中定位当前文件' },
  },
  opts = function()
    return require('custom.config.neo-tree')
  end,
  config = function(_, opts)
    require('neo-tree').setup(opts)
  end,
}
