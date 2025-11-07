-- WakaTime 编程时间统计插件
-- 自动跟踪您的编程活动并生成详细的时间报告

return {
    'wakatime/vim-wakatime',
    -- 不使用懒加载，确保插件在启动时就开始跟踪
    lazy = false,
    -- 在 VimEnter 事件时加载，确保及时开始跟踪
    event = 'VimEnter',
    
    config = function()
        -- WakaTime 配置
        -- API 密钥将通过 :WakaTimeApiKey 命令设置
        
        -- 可选：设置一些 WakaTime 变量
        -- vim.g.wakatime_PythonBinary = '/usr/bin/python3'  -- 指定 Python 路径（如果需要）
        -- vim.g.wakatime_CLIPath = '/usr/local/bin/wakatime-cli'  -- 指定 CLI 路径（如果需要）
        
        -- 显示配置提示
        vim.api.nvim_create_autocmd('VimEnter', {
            callback = function()
                -- 检查是否已配置 API 密钥
                local config_file = vim.fn.expand('~/.wakatime.cfg')
                if vim.fn.filereadable(config_file) == 0 then
                    vim.notify(
                        vim.log.levels.INFO,
                        { title = 'WakaTime 配置' }
                    )
                end
            end,
        })
    end,
    
    -- 插件命令说明
    -- :WakaTimeApiKey - 设置 API 密钥
    -- :WakaTimeDebugEnable - 启用调试模式
    -- :WakaTimeDebugDisable - 禁用调试模式
    -- :WakaTimeScreenRedrawEnable - 启用屏幕重绘
    -- :WakaTimeScreenRedrawDisable - 禁用屏幕重绘
    -- :WakaTimeToday - 显示今天的编程时间
}