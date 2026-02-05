local custom_pickers = require 'custom.pickers'
local custom_utils = require 'custom.utils'

-- 映射辅助函数
local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- =============================================================================
-- 基础移动增强
-- =============================================================================
-- 映射 jk 为 <Esc>
map('i', 'jk', '<esc>', { noremap = true })

-- 处理自动换行后的上下移动
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Move cursor down' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Move cursor up' })

-- 行首行尾快捷键 (Alt+Left/Right)
map({ 'n', 'i' }, '<A-Left>', '<Esc>^i', { desc = 'Go to start of line' })
map({ 'n', 'i' }, '<A-Right>', '<Esc>$i', { desc = 'Go to end of line' })

-- =============================================================================
-- 窗口管理
-- =============================================================================
-- 清除搜索高亮
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- 分屏
map('n', '\\', '<CMD>:sp<CR>', { desc = 'Split window horizontally' })
map('n', '|', '<CMD>:vsp<CR>', { desc = 'Split window vertically' })

-- 窗口最大化/恢复
map('n', '+', '<C-w>|<C-w>_', { desc = 'Maximize nvim pane' })
map('n', '=', '<C-w>=', { desc = 'Restore nvim panes' })

-- =============================================================================
-- 导航与跳转
-- =============================================================================
-- 标签页切换
map('n', 'L', 'gt', { noremap = true, desc = 'Go to next tab' })
map('n', 'H', 'gT', { noremap = true, desc = 'Go to prev tab' })

-- 当前 buffer 在新 Tab 打开
map("n", "<C-w><C-t>", function()
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("tabnew")
    vim.api.nvim_set_current_buf(buf)
end, { desc = "Open current buffer in new tab" })

-- 快速滚动
map('n', '<C-d>', '5j', { desc = 'Scroll down by 5 lines' })
map('n', '<C-u>', '5k', { desc = 'Scroll up by 5 lines' })

-- Quickfix 列表
map('n', ']q', '<cmd>cnext<cr>', { desc = 'Go to next qf item' })
map('n', '[q', '<cmd>cprev<cr>', { desc = 'Go to prev qf item' })

-- =============================================================================
-- 剪贴板与编辑
-- =============================================================================
-- 粘贴时不替换剪贴板内容
map('v', 'p', '"_dP', { noremap = true })
map('v', '<leader>p', 'p', { noremap = true, desc = 'Paste regular' })

-- 代码执行
map('n', '<space>X', '<cmd>source %<cr>', { desc = 'Run this lua file' })
map('n', '<space>x', ':.lua<cr>', { desc = 'Run this line' })
map('v', '<space>x', ':lua<cr>', { desc = 'Run selection' })

-- =============================================================================
-- 自定义功能
-- =============================================================================
-- 专注模式
map('n', '<leader>tz', custom_utils.toggle_distraction_free, { desc = 'Toggle distraction free' })

-- 从所有窗口中跳转到 "file:line"
map('n', '<leader>fJ', custom_utils.jump_to_file_lnum_from_all_windows, { desc = 'Jump to file:line from any window' })

-- Git 仓库 Picker
map('n', '<leader>fg', custom_pickers.pick_repositories, { desc = 'Find git repositories' })

map('n', '<leader>tm', '<cmd>split | terminal<cr>', { desc = 'Open horizontal terminal (native)' })
map('n', '<leader>mt', '<cmd>close<cr>', { desc = 'Close terminal' })
