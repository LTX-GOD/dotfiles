return {
    'mikavilpas/yazi.nvim',
    version = '*', -- 使用最新稳定版本
    event = 'VeryLazy',
    dependencies = {{
        'nvim-lua/plenary.nvim',
        lazy = true
    }},
    keys = { -- 自定义键映射
    {
        '<leader>=',
        mode = {'n', 'v'},
        '<cmd>Yazi<cr>',
        desc = '在当前文件打开 yazi'
    }, {
        '<leader>cw',
        '<cmd>Yazi cwd<cr>',
        desc = '在 nvim 当前工作目录打开 yazi'
    }, {
        '<c-up>',
        '<cmd>Yazi toggle<cr>',
        desc = '恢复上一个 yazi 会话'
    }},
    opts = {
        -- 如果想用 yazi 替换 netrw
        open_for_directories = false,
        keymaps = {
            show_help = '<f1>'
        }
    },
    init = function()
        -- 标记 netrw 已加载以避免加载
        vim.g.loaded_netrwPlugin = 1
    end
}
