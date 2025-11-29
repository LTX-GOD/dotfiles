local custom_pickers = require 'custom.pickers'
vim.keymap.set('i', 'jk', '<esc>', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", {
    expr = true,
    silent = true,
    desc = 'Move cursor down'
})
vim.keymap.set('x', 'j', "v:count == 0 ? 'gj' : 'j'", {
    expr = true,
    silent = true,
    desc = 'Move cursor down'
})
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", {
    expr = true,
    silent = true,
    desc = 'Move cursor up'
})
vim.keymap.set('x', 'k', "v:count == 0 ? 'gk' : 'k'", {
    expr = true,
    silent = true,
    desc = 'Move cursor up'
})
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '\\', '<CMD>:sp<CR>', {
    desc = 'Split window horizontally'
})
vim.keymap.set('n', '|', '<CMD>:vsp<CR>', {
    desc = 'Split window vertically'
})
vim.keymap.set('n', ']q', '<cmd>cnext<cr>', {
    desc = 'Go to next qf item'
})
vim.keymap.set('n', '[q', '<cmd>cprev<cr>', {
    desc = 'Go to prev qf item'
})
vim.keymap.set('n', '<C-d>', '5j', {
    desc = 'Scroll down by 5 lines'
})
vim.keymap.set('n', '<C-u>', '5k', {
    desc = 'Scroll up by 5 lines'
})
vim.keymap.set('n', 'L', 'gt', {
    noremap = true,
    desc = 'Go to next tab'
})
vim.keymap.set('n', 'H', 'gT', {
    noremap = true,
    desc = 'Go to prev tab'
})

-- 使用 Ctrl+h/l 快速切换缓冲区（类似浏览器标签页）
vim.keymap.set('n', '<C-h>', '<cmd>bprev<cr>', {
    desc = '上一个缓冲区'
})
vim.keymap.set('n', '<C-l>', '<cmd>bnext<cr>', {
    desc = '下一个缓冲区'
})

-- 缓冲区导航和管理
vim.keymap.set('n', '<leader>bf', function()
    -- 跳转到第一个缓冲区
    local buffers = vim.tbl_filter(function(bufnr)
        return vim.api.nvim_get_option_value('buflisted', { buf = bufnr })
    end, vim.api.nvim_list_bufs())
    
    if buffers[1] then
        vim.api.nvim_set_current_buf(buffers[1])
    end
end, {
    desc = '跳转到第一个缓冲区'
})

vim.keymap.set('n', '<leader>bl', function()
    -- 跳转到最后一个缓冲区
    local buffers = vim.tbl_filter(function(bufnr)
        return vim.api.nvim_get_option_value('buflisted', { buf = bufnr })
    end, vim.api.nvim_list_bufs())
    
    if buffers[#buffers] then
        vim.api.nvim_set_current_buf(buffers[#buffers])
    end
end, {
    desc = '跳转到最后一个缓冲区'
})

vim.keymap.set('n', '+', '<C-w>|<C-w>_', {
    desc = 'Maximize nvim pane'
})
vim.keymap.set('n', '=', '<C-w>=', {
    desc = 'Restore nvim panes'
})
vim.keymap.set('v', 'p', '"_dP', {
    noremap = true
})
vim.keymap.set('v', '<leader>p', 'p', {
    noremap = true
})
vim.keymap.set('n', '<space>X', '<cmd>source %<cr>', {
    desc = 'Run this lua file'
})
vim.keymap.set('n', '<space>x', ':.lua<cr>', {
    desc = 'Run this line'
})
vim.keymap.set('v', '<space>x', ':lua<cr>', {
    desc = 'Run selection'
})

local feedkeys = vim.api.nvim_feedkeys
local t = vim.api.nvim_replace_termcodes
vim.keymap.set('n', '<leader>tz', function()
    feedkeys(t('<leader>tg', true, true, true), 'm', false)
    feedkeys(t('<leader>th', true, true, true), 'm', false)
    feedkeys(t('<leader>td', true, true, true), 'm', false)
    feedkeys(t('<leader>tt', true, true, true), 'm', false)
end, {
    noremap = true,
    silent = true,
    desc = 'Toggle distraction free'
})

vim.keymap.set('n', '<leader>fg', custom_pickers.pick_repositories)
vim.keymap.set("n", "<C-w><C-t>", function()
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("tabnew")
    vim.api.nvim_set_current_buf(buf)
end, {
    desc = "Open current buffer in new tab"
})

local function jump_to_file_lnum_from_all_windows()
    local matches = {}
    local seen = {}

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)

        -- Avoid duplicates if multiple windows show the same buffer
        if not seen[buf] then
            seen[buf] = true
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

            for lnum, line in ipairs(lines) do
                for filepath, lno in string.gmatch(line, '([%w%./~_-]+):(%d+)') do
                    table.insert(matches, {
                        label = filepath .. ':' .. lno,
                        file = filepath,
                        lnum = tonumber(lno)
                    })
                end
            end
        end
    end

    if vim.tbl_isempty(matches) then
        vim.notify("No file:line patterns found in any window", vim.log.levels.INFO)
        return
    end

    vim.ui.select(matches, {
        prompt = "Jump to file:line",
        format_item = function(item)
            return item.label
        end
    }, function(choice)
        if choice then
            vim.cmd('edit ' .. choice.file)
            vim.api.nvim_win_set_cursor(0, {choice.lnum, 0})
        end
    end)
end

vim.keymap.set('n', '<leader>fJ', jump_to_file_lnum_from_all_windows, {
    desc = 'Jump to file:line from any window'
})

vim.keymap.set('n', '<leader>tm', function()
    vim.cmd('split | terminal')
end, {
    desc = 'Open horizontal terminal'
})
vim.keymap.set('n', '<leader>mt', '<cmd>close<cr>', {
    desc = 'Close terminal'
})

vim.keymap.set({'n','i'}, '<A-Left>', '<Esc>^i', {desc='行首'})
vim.keymap.set({'n','i'}, '<A-Right>', '<Esc>$i', {desc='行尾'})

