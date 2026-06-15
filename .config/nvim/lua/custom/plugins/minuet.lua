return {
	'milanglacier/minuet-ai.nvim',
	event = { 'BufReadPre', 'BufNewFile' },
	init = function()
		if not vim.env.DEEPSEEK_API_KEY or vim.env.DEEPSEEK_API_KEY == '' then
			vim.env.DEEPSEEK_API_KEY = ''
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
