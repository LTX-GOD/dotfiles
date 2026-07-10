if vim.fn.has 'nvim-0.12' == 0 then
  vim.api.nvim_echo({ { '本配置依赖 Neovim 0.12+（vim.pack），请升级后再使用。', 'ErrorMsg' } }, true, {})
  return
end

require 'custom.options'
require 'custom.keymaps'
require 'custom.autocmds'
require 'custom.filetypes'
require('custom.pack').setup()
