vim.lsp.config.ty = require 'custom.lsp.servers.ty'
vim.lsp.enable { 'ty' }
-- ruff 由 mason-lspconfig 统一管理，勿在此重复启动

-- 设置Python相关的选项
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
