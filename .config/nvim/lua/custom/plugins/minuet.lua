return {
	'milanglacier/minuet-ai.nvim',
	event = { 'BufReadPre', 'BufNewFile' },
	init = function()
		if not vim.env.DEEPSEEK_API_KEY or vim.env.DEEPSEEK_API_KEY == '' then
			local secrets_path = vim.fn.stdpath 'config' .. '/.secrets.lua'
			if vim.uv.fs_stat(secrets_path) then
				local ok, t = pcall(dofile, secrets_path)
				if ok and type(t) == 'table' and t.DEEPSEEK_API_KEY then
					vim.env.DEEPSEEK_API_KEY = t.DEEPSEEK_API_KEY
				end
			else
				vim.notify('minuet: DEEPSEEK_API_KEY 未设置，请创建 ~/.config/nvim/.secrets.lua', vim.log.levels.WARN)
			end
		end
	end,
	opts = {
		provider = 'openai_fim_compatible',
		request_timeout = 3,
		throttle = 1500,
		debounce = 600,
		provider_options = {
			openai_fim_compatible = {
				api_key = 'DEEPSEEK_API_KEY',
				name = 'deepseek',
				optional = {
					max_tokens = 256,
					top_p = 0.9,
				},
			},
		},
		lsp = {
			enabled_ft = {},
			completion = {
				enable = true,
				enabled_auto_trigger_ft = {},
				warn_on_blink_or_cmp = false,
			},
			inline_completion = {
				enable = false,
			},
		},
		virtualtext = {
			auto_trigger_ft = {},
			keymap = {
				accept = '<A-A>',
				accept_line = '<A-a>',
				accept_n_lines = '<A-z>',
				prev = '<A-[>',
				next = '<A-]>',
				dismiss = '<A-e>',
			},
		},
	},
	config = function(_, opts)
		require('minuet').setup(opts)
	end,
}
