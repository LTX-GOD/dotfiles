return {
  "serhez/bento.nvim",
  event = "VeryLazy",
  keys = {
    { ";", desc = "Open Bento Buffer Menu" },
  },
  config = function()
    require("bento").setup({
      -- 核心键位配置
      main_keymap = ";", -- 覆盖 vim 原生的 ; 键
      lock_char = "🔒", -- 锁定文件前显示的字符
      
      -- UI 配置
      ui = {
        mode = "floating", -- 使用浮动窗口模式 (也可选 "tabline")
        floating = {
          position = "top-right", -- 菜单位置
          minimal_menu = "full", -- 折叠时显示完整列表 (原为 "dashed")
          width = "fit",
          height = "fit",
          border = "rounded", -- 圆角边框
          max_rendered_buffers = nil, -- 自动分页
        },
        tabline = {
            left_page_symbol = "❮",
            right_page_symbol = "❯",
            separator_symbol = "│",
        },
      },
      
      -- 缓冲区管理
      max_open_buffers = nil, -- 不限制最大打开数量
      buffer_deletion_metric = "frecency_access", -- 基于访问频率自动管理
      ordering_metric = "access", -- 按访问时间排序
      buffer_notify_on_delete = true, -- 删除时通知
      default_action = "open",

      -- 自定义动作 (Extensible Actions)
      actions = {
        -- 覆盖默认删除键位 (从 <BS> 改为 d)，解决 Mac/终端 键码兼容问题
        delete = {
            key = "d",
            hl = "DiagnosticVirtualTextError",
            action = function(buf_id, buf_name)
                vim.cmd("bdelete " .. buf_id)
                -- 保持菜单打开或关闭取决于个人喜好，这里默认可能需要刷新
                require("bento.ui").refresh_menu()
            end,
        },
        -- Git Stage: 将当前 buffer 添加到 git暂存区
        git_stage = {
            key = "g",
            hl = "DiffAdd", 
            action = function(buf_id, buf_name)
                vim.cmd("!git add " .. vim.fn.shellescape(buf_name))
                vim.notify("Git Staged: " .. buf_name)
            end,
        },
        -- Copy Path: 复制文件路径到剪贴板
        copy_path = {
            key = "y",
            action = function(_, buf_name)
                vim.fn.setreg("+", buf_name)
                vim.notify("Copied path: " .. buf_name)
            end,
        },
      },
    })
  end,
}
