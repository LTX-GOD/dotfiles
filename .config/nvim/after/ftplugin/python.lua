vim.lsp.config.ty = require 'custom.lsp.servers.ty'
vim.lsp.config.ruff = require 'custom.lsp.servers.ruff'

vim.lsp.enable { 'ty', 'ruff' }

-- 设置Python相关的选项
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
