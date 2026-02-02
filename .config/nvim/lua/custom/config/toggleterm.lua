return {
    -- 尺寸策略：水平终端固定高度，垂直/浮窗按比例
    size = function(term)
        if term.direction == 'horizontal' then
            return 12
        elseif term.direction == 'vertical' then
            -- nvim 0.10 起可用 vim.o.columns，兼容按比例控制
            return math.floor(vim.o.columns * 0.42)
        else
            return nil
        end
    end,

    -- 默认不设置全局 open_mapping，避免与你已有快捷键冲突
    open_mapping = nil,

    start_in_insert = true, -- 打开即进入插入模式
    persist_size = true, -- 记住终端窗口的大小
    persist_mode = true, -- 记住终端模式（插入/普通）
    shade_terminals = true,
    shading_factor = 2,

    direction = 'float', -- 默认使用浮窗
    float_opts = {
        border = 'rounded'
    }, -- 浮窗圆角边框
    close_on_exit = true, -- 命令结束后自动关闭
    shell = vim.o.shell, -- 默认使用当前 shell
    on_open = function(term)
        -- 仅对该终端缓冲区生效的键位
        local opts = {
            buffer = term.bufnr,
            silent = true,
            noremap = true
        }

        -- 终端内按 Esc 返回 Normal 模式（快捷“退出插入态”）
        vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], vim.tbl_extend('force', opts, {
            desc = '终端 -> Normal'
        }))

        -- Ctrl+q 关闭当前终端窗口（不杀进程）
        vim.keymap.set('t', '<C-q>', [[<C-\><C-n><cmd>close<cr>]], vim.tbl_extend('force', opts, {
            desc = '关闭终端窗口'
        }))

        -- 终端里也能用 Ctrl+h/j/k/l 在分屏间移动
        vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
        vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
        vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
        vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
    end
}
