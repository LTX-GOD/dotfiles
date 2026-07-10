vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false

local map = function(keys, cmd, desc)
	vim.keymap.set('n', keys, cmd, { buffer = true, silent = true, desc = 'Go: ' .. desc })
end

-- 运行当前文件的测试
map('<leader>rt', function()
	local file = vim.fn.expand '%:p:h'
	vim.cmd('split | terminal go test -v -race -count=1 ' .. vim.fn.shellescape(file))
end, 'Run tests (current package)')

-- 运行光标处的单个测试
map('<leader>rf', function()
	local func_name = vim.fn.search([[func \(Test\|Benchmark\)\w\+]], 'bcnW')
	if func_name == 0 then
		vim.notify('No test function found', vim.log.levels.WARN)
		return
	end
	local line = vim.fn.getline(func_name)
	local name = line:match('func (Test%w+)') or line:match('func (Benchmark%w+)')
	if name then
		local dir = vim.fn.expand '%:p:h'
		vim.cmd('split | terminal go test -v -race -run ^' .. name .. '$ ' .. vim.fn.shellescape(dir))
	end
end, 'Run test under cursor')

-- go build 检查
map('<leader>rb', function()
	vim.cmd 'split | terminal go build ./...'
end, 'Build project')
