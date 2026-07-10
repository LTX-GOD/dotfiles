-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

local function augroup(name)
	return vim.api.nvim_create_augroup('custom-' .. name, { clear = true })
end

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = augroup 'highlight-yank',
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
	pattern = { '*' },
	callback = function()
		vim.api.nvim_exec2('silent! normal! g`"zv', { output = false })
	end,
})

-- Big file
vim.filetype.add {
	pattern = {
		['.*'] = {
			function(path, buf)
				if vim.bo[buf].filetype ~= 'bigfile' and path and vim.fn.getfsize(path) > vim.g.bigfile_size then
					return 'bigfile'
				else
					return nil
				end
			end,
		},
	},
}

vim.api.nvim_create_autocmd({ 'FileType' }, {
	group = augroup 'bigfile',
	pattern = 'bigfile',
	callback = function(ev)
		vim.b.minianimate_disable = true
		vim.schedule(function()
			vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ''
		end)
		vim.bo[ev.buf].swapfile = false
		vim.wo.cursorline = false
		vim.wo.wrap = false
		vim.wo.linebreak = false
	end,
})

vim.api.nvim_create_autocmd('TermOpen', {
	pattern = '*',
	callback = function(ev)
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		local opts = { buffer = true, silent = true, noremap = true }
		-- lazygit / claude / pi 等全屏 TUI 自己要用 Esc，不劫持
		local cmd = vim.api.nvim_buf_get_name(ev.buf):match 'term://.-//%d+:(.*)' or ''
		local is_tui = cmd:find('lazygit', 1, true) or cmd:find('claude', 1, true) or cmd:match '%f[%w]pi%f[%W]'
		if not is_tui then
			vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], vim.tbl_extend('force', opts, { desc = '终端 -> Normal' }))
		end
		vim.keymap.set('t', '<C-q>', [[<C-\><C-n><cmd>close<cr>]], vim.tbl_extend('force', opts, { desc = '关闭终端窗口' }))
		vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
		vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
		vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
		vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
	end,
})


vim.api.nvim_create_autocmd('VimResized', {
	pattern = '*',
	callback = function()
		vim.cmd 'wincmd ='
	end,
})
-- Override <CR> in quickfix: prevent global fold-toggle from intercepting it
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'qf',
	callback = function()
		vim.keymap.set('n', '<CR>', '<CR>', { buffer = true, noremap = true, desc = 'Jump to quickfix entry' })
	end,
})
