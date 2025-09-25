---@brief
---
--- uv.nvim - uv Python包管理器的Neovim集成
--- https://github.com/benomahony/uv.nvim
---
--- 提供与uv Python包管理器的集成，为Neovim中的Python开发提供流畅的工作流程
---
return {
  "benomahony/uv.nvim",
  -- 仅在打开Python文件时懒加载
  ft = { "python" },
  -- 可选依赖，推荐使用
  dependencies = {
    "folke/snacks.nvim"
  },
  opts = {
    -- 自动激活虚拟环境
    auto_activate_venv = true,
    notify_activate_venv = true,

    -- 目录变化时的自动命令
    auto_commands = true,

    -- 与snacks picker的集成
    picker_integration = true,

    -- 快捷键配置
    keymaps = {
      prefix = "<leader>u",  -- 主前缀改为<leader>u以避免冲突
      commands = true,       -- 显示uv命令菜单 (<leader>u)
      run_file = true,       -- 运行当前文件 (<leader>ur)
      run_selection = true,  -- 运行选中代码 (<leader>us)
      run_function = true,   -- 运行函数 (<leader>uf)
      venv = true,           -- 环境管理 (<leader>ue)
      init = true,           -- 初始化uv项目 (<leader>ui)
      add = true,            -- 添加包 (<leader>ua)
      remove = true,         -- 移除包 (<leader>ud)
      sync = true,           -- 同步包 (<leader>uc)
    },

    -- 执行配置
    execution = {
      run_command = "uv run python",  -- 使用uv run python执行
    }
  },
  config = function(_, opts)
    require('uv').setup(opts)
    
    -- 添加一些自定义命令
    vim.api.nvim_create_user_command('UVStatus', function()
      vim.cmd('!uv --version')
    end, { desc = '显示uv版本信息' })
    
    vim.api.nvim_create_user_command('UVInfo', function()
      vim.cmd('!uv info')
    end, { desc = '显示uv项目信息' })
  end
}