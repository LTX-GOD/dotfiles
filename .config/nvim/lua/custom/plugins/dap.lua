return {
	{
		'mfussenegger/nvim-dap',
		keys = {
			{ '<F5>',       function() require('dap').continue() end,          desc = 'DAP: Continue' },
			{ '<F10>',      function() require('dap').step_over() end,         desc = 'DAP: Step Over' },
			{ '<F11>',      function() require('dap').step_into() end,         desc = 'DAP: Step Into' },
			{ '<F12>',      function() require('dap').step_out() end,          desc = 'DAP: Step Out' },
			{ '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'DAP: Toggle Breakpoint' },
			{ '<leader>dB', function()
				require('dap').set_breakpoint(vim.fn.input('Condition: '))
			end, desc = 'DAP: Conditional Breakpoint' },
			{ '<leader>dr', function() require('dap').restart() end,           desc = 'DAP: Restart' },
			{ '<leader>dq', function() require('dap').terminate() end,         desc = 'DAP: Terminate' },
		},
	},
	{
		'rcarriga/nvim-dap-ui',
		dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
		keys = {
			{ '<leader>du', function() require('dapui').toggle() end, desc = 'DAP: Toggle UI' },
		},
		config = function()
			local dap, dapui = require('dap'), require('dapui')
			dapui.setup()
			-- 调试/测试开始时自动打开 UI
			dap.listeners.after.event_initialized['dapui'] = dapui.open
			-- 不在结束时自动关闭，保留结果供查看；看完用 <leader>du 手动关闭
		end,
	},
}
