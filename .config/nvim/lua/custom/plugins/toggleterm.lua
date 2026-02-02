return {
    'akinsho/toggleterm.nvim',
    version = '*',
    cmd = {'ToggleTerm'},
    keys = { -- 统一以 <leader>t* 作为“切换类”操作前缀，避免与你现有 <leader>tt/<leader>tf 冲突
    {
        '<leader>tT',
        function()
            -- 切换一个默认的浮窗终端（编号 1）
            local Terminal = require('toggleterm.terminal').Terminal
            Terminal:new({
                id = 1,
                direction = 'float'
            }):toggle()
        end,
        desc = '切换浮窗终端（id=1）'
    }, {
        '<leader>t1',
        function()
            local Terminal = require('toggleterm.terminal').Terminal
            Terminal:new({
                id = 1,
                direction = 'float'
            }):toggle()
        end,
        desc = '切换浮窗终端（id=1）'
    }, {
        '<leader>t2',
        function()
            local Terminal = require('toggleterm.terminal').Terminal
            Terminal:new({
                id = 2,
                direction = 'horizontal'
            }):toggle()
        end,
        desc = '切换水平终端（id=2，高度固定）'
    }, {
        '<leader>t3',
        function()
            local Terminal = require('toggleterm.terminal').Terminal
            Terminal:new({
                id = 3,
                direction = 'vertical'
            }):toggle()
        end,
        desc = '切换垂直终端（id=3，宽度固定）'
    }, -- 关闭当前终端窗口（或默认终端）
    {
        '<leader>tq',
        function()
            if vim.bo.filetype == 'toggleterm' then
                vim.cmd('close')
            else
                -- 非终端缓冲下默认关闭/隐藏 id=1 的终端窗口
                local Terminal = require('toggleterm.terminal').Terminal
                Terminal:new({
                    id = 1
                }):close()
            end
        end,
        desc = '关闭终端窗口（当前/默认）'
    }, -- 终止 id=1 的终端进程并关闭窗口（“强退”）
    {
        '<leader>tQ',
        function()
            local Terminal = require('toggleterm.terminal').Terminal
            local t = Terminal:new({
                id = 1
            })
            -- shutdown 会终止 job 并关闭窗口
            t:shutdown()
        end,
        desc = '终止终端1并关闭窗口'
    }},
    opts = function()
        return require('custom.config.toggleterm')
    end
}
