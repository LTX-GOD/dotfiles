return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = { 'ToggleTerm' },
  keys = {
    {
      '<leader>tT',
      function()
        local Terminal = require('toggleterm.terminal').Terminal
        Terminal:new({
          id = 1,
          direction = 'float',
        }):toggle()
      end,
      desc = '切换浮窗终端（id=1）',
    },
    {
      '<leader>t1',
      function()
        local Terminal = require('toggleterm.terminal').Terminal
        Terminal:new({
          id = 1,
          direction = 'float',
        }):toggle()
      end,
      desc = '切换浮窗终端（id=1）',
    },
    {
      '<leader>t2',
      function()
        local Terminal = require('toggleterm.terminal').Terminal
        Terminal:new({
          id = 2,
          direction = 'horizontal',
        }):toggle()
      end,
      desc = '切换水平终端（id=2，高度固定）',
    },
    {
      '<leader>t3',
      function()
        local Terminal = require('toggleterm.terminal').Terminal
        Terminal:new({
          id = 3,
          direction = 'vertical',
        }):toggle()
      end,
      desc = '切换垂直终端（id=3，宽度固定）',
    },
    {
      '<leader>tq',
      function()
        if vim.bo.filetype == 'toggleterm' then
          vim.cmd 'close'
        else
          local Terminal = require('toggleterm.terminal').Terminal
          Terminal:new({ id = 1 }):close()
        end
      end,
      desc = '关闭终端窗口（当前/默认）',
    },
    {
      '<leader>tQ',
      function()
        local Terminal = require('toggleterm.terminal').Terminal
        local t = Terminal:new({ id = 1 })
        t:shutdown()
      end,
      desc = '终止终端1并关闭窗口',
    },
  },
  opts = function()
    return require('custom.config.toggleterm')
  end,
}
