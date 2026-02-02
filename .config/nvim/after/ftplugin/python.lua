vim.lsp.config.basedpyright = require 'custom.lsp.servers.basedpyright'
vim.lsp.config.ruff = require 'custom.lsp.servers.ruff'

vim.lsp.enable { 'basedpyright', 'ruff' }

-- 设置Python相关的选项
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
