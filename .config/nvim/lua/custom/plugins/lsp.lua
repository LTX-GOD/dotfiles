return {
	{
		'williamboman/mason.nvim',
		cmd = 'Mason',
		opts = {
			ui = {
				border = 'single',
				width = 0.8,
				height = 0.8,
			},
		},
	},
	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		main = 'mason-tool-installer',
		dependencies = { 'williamboman/mason.nvim' },
		event = 'VeryLazy',
		opts = {
			ensure_installed = { 'google-java-format', 'java-debug-adapter', 'java-test' },
		},
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'saghen/blink.cmp',
		},
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			require('custom.lsp.attach').setup()

			-- 所有 server 统一注入 blink 的补全能力
			vim.lsp.config('*', {
				capabilities = require('blink.cmp').get_lsp_capabilities(),
			})

			-- 自定义 server 配置（vim.lsp.Config 格式，与 lspconfig 默认值合并）
			for _, name in ipairs { 'marksman', 'ruff', 'clangd', 'intelephense', 'gopls' } do
				vim.lsp.config(name, require('custom.lsp.servers.' .. name))
			end

			-- clangd 不经 mason 安装（系统/brew 提供），需手动启用
			if vim.fn.executable 'clangd' == 1 then
				vim.lsp.enable 'clangd'
			end

			-- mason-lspconfig v2：自动对已安装 server 调用 vim.lsp.enable
			require('mason-lspconfig').setup {
				ensure_installed = {
					'rust_analyzer',
					'marksman',
					'intelephense',
					'gopls',
					'ruff',
					'lua_ls',
					'lemminx',
				},
				-- jdtls 由 nvim-jdtls 单独管理
				automatic_enable = { exclude = { 'jdtls' } },
			}

			require('custom.ui.lsp_progress')
		end,
	},
}
