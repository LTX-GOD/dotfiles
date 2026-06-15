-- 文件头部
local custom_utils = require 'custom.utils'
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'OverseerList',
    callback = function()
        vim.opt_local.winfixbuf = true
    end
})
local workdir = os.getenv 'WORKDIR' or ''
-- rr: Overseer 任务模板
-- rp: 使用 uv run python 运行当前 Python 文件
-- rs: 使用 sage -python 运行当前 Python 文件
-- rt: 切换 Overseer 任务面板

local overseer = require 'overseer'

-- 直接运行当前 Python 文件（可选用 sage -python 或 uv run python）
local function run_python_file(use_sage, use_uv)
    local file = vim.fn.expand '%:p'
    local dir = vim.fn.expand '%:p:h'
    local name = vim.fn.expand '%:t'

    -- 更稳健的 Python 文件判定：filetype=python 或后缀为 .py
    local is_py = (vim.bo.filetype == 'python') or (vim.fn.expand '%:e' == 'py')
    if not is_py then
        vim.notify('当前缓冲区不是 Python 文件', vim.log.levels.WARN)
        return
    end

    local cmd, args, title
    if use_sage then
        if vim.fn.executable 'sage' ~= 1 then
            vim.notify('未找到 sage，请安装或配置 PATH', vim.log.levels.ERROR)
            return
        end
        cmd, args, title = 'sage', {'-python', file}, ('Sage Python: %s'):format(name)
    elseif use_uv then
        if vim.fn.executable 'uv' ~= 1 then
            vim.notify('未找到 uv，请安装或配置 PATH', vim.log.levels.ERROR)
            return
        end
        cmd, args, title = 'uv', {'run', 'python', file}, ('UV Python: %s'):format(name)
    else
        cmd, args, title = 'uv', {'run', 'python', file}, ('UV Python: %s'):format(name)
    end

    local task = overseer.new_task({
        name = title,
        cmd = cmd,
        args = args,
        cwd = dir,
        components = {'display_duration', 'on_exit_set_status', 'on_complete_notify', {
            'open_output',
            on_start = 'always',
            direction = 'dock',
            focus = true
        }}
    })
    task:start()
end

-- 快捷键：rp -> uv run python（保持原来的overseer显示方式），rs -> sage -python
vim.keymap.set('n', '<leader>rp', function()
    -- 检查是否为Python文件
    local is_py = (vim.bo.filetype == 'python') or (vim.fn.expand '%:e' == 'py')
    if not is_py then
        vim.notify('当前缓冲区不是 Python 文件', vim.log.levels.WARN)
        return
    end
    
    -- 使用overseer运行uv run python，保持原来的显示方式
    run_python_file(false, true)  -- use_sage=false, use_uv=true
end, {
    desc = 'Run current Python (uv run python)'
})

vim.keymap.set('n', '<leader>rs', function()
    run_python_file(true, false)  -- use_sage=true, use_uv=false
end, {
    desc = 'Run current Python (sage -python)'
})

-- 退出保护：有运行中的任务且仅剩一个窗口时阻止退出
vim.api.nvim_create_augroup('PreventQuitWithRunningTasks', {
    clear = true
})
vim.api.nvim_create_autocmd('QuitPre', {
    group = 'PreventQuitWithRunningTasks',
    callback = function()
        local tasks = overseer.list_tasks({
            status = overseer.STATUS.RUNNING
        })
        local num_windows = vim.fn.winnr('$')
        if not vim.tbl_isempty(tasks) and num_windows == 1 then
            vim.notify('无法退出：仍有任务在运行中！', vim.log.levels.WARN)
            return true -- 阻止退出
        end
    end
})
vim.keymap.set('n', '<Leader>rr', '<cmd>OverseerRun<cr>', {
    desc = 'Overseer run templates'
})
vim.keymap.set('n', '<Leader>rt', function()
    vim.cmd 'OverseerToggle'
    custom_utils.func_on_window('dapui_stacks', function()
        require'dapui'.open({
            reset = true
        })

    end)
end, {
    desc = 'Overseer toggle task list'
})
vim.keymap.set('n', '<Leader>ra', '<cmd>OverseerQuickAction<cr>', {
    desc = 'Overseer quick action list'
})
overseer.setup {
    dap = true,
    strategy = 'terminal',
    templates = {'builtin', 'shell', 'make', 'condor', 'python', 'user.grun_option', 'user.run_script'},
    template_timeout = 5000,
    component_aliases = {
        default_vscode = {"default", "on_result_diagnostics", "unique"}
    },
    task_list = {
        direction = 'right',
        bindings = {
            ['?'] = 'ShowHelp',
            ['<CR>'] = 'RunAction',
            ['e'] = 'Edit',
            ['o'] = false,
            ['v'] = 'OpenVsplit',
            ['s'] = 'OpenSplit',
            ['f'] = 'OpenFloat',
            ['<C-q>'] = 'OpenQuickFix',
            ['p'] = 'TogglePreview',
            ['+'] = 'IncreaseDetail',
            ['_'] = 'DecreaseDetail',
            ['='] = 'IncreaseAllDetail',
            ['-'] = 'DecreaseAllDetail',
            ['['] = 'DecreaseWidth',
            [']'] = 'IncreaseWidth',
            ['k'] = 'PrevTask',
            ['j'] = 'NextTask',
            ['t'] = '<CMD>OverseerQuickAction open tab<CR>',
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<C-h>'] = false,
            ['<C-j>'] = false,
            ['<C-k>'] = false,
            ['<C-l>'] = false,
            ['q'] = 'Close'
        }
    }
}
overseer.add_template_hook({
    module = '^make$'
}, function(task_defn, util)
    util.add_component(task_defn, 'task_list_on_start')
    util.add_component(task_defn, {
        'on_output_write_file',
        filename = task_defn.cmd[1] .. '.log'
    })
    util.add_component(task_defn, {
        'on_output_quickfix',
        open_on_exit = 'failure'
    })
    util.add_component(task_defn, 'on_complete_notify')
    util.add_component(task_defn, {
        'display_duration',
        detail_level = 1
    })
    util.add_component(task_defn, 'unique')
    util.remove_component(task_defn, 'on_output_summarize')
end)

overseer.add_template_hook({
    module = '^remake Fit$'
}, function(task_defn, util)
    util.add_component(task_defn, 'unique')
end)

-- custom tasks
overseer.register_template {
    name = 'booleUT.qmt',
    priority = 0,
    builder = function()
        return {
            cmd = 'make',
            args = {'Boole', '&&', 'utils/run-env', 'Boole', 'gaudirun.py',
                    'Boole/Digi/Boole/tests/qmtest/boole.qms/boole-UT.qmt'},
            name = 'booleUT.qmt',
            cwd = vim.fn.getcwd(),
            components = {'task_list_on_start', 'on_complete_notify', 'display_duration', 'on_exit_set_status'}
        }
    end,
    condition = {
        callback = function()
            local cwd = vim.fn.expand '%:p'
            local result = string.find(cwd, workdir .. '/stack-master/Boole', 1, true)
            if result then
                return true
            end
            return false
        end
    }
}
