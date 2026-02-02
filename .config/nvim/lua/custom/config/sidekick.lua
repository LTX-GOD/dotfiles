return {
  cli = {
    -- 界面美化配置
    win = {
      -- 使用右侧浮动窗口
      layout = "float",
      float = {
        -- 窗口大小：宽度占 30%-40% (0.35)，高度尽可能大 (0.9)
        width = 0.35,
        height = 0.9,
        -- 位置：右侧中部
        row = 2, -- 稍微留点顶部空间
        col = vim.o.columns, -- 尽可能靠右 (会自动吸附边缘)
        
        -- 圆角边框
        border = "rounded",
        -- 窗口标题
        title = " 🤖 Claude Code ",
        title_pos = "center",
        style = "minimal",
      },
      -- 窗口选项 (Window Options)
      wo = {
        -- 半透明磨砂 (0-100)，适配透明主题
        winblend = 10,
        
        -- 纯净终端体验
        number = false,
        relativenumber = false,
        signcolumn = "no",
        cursorline = false,
        foldcolumn = "0",
        list = false,
        spell = false,
        
        -- 适配 Catppuccin Mocha 主题
        -- NormalFloat: 浮窗背景
        -- FloatBorder: 边框颜色 (使用 Blue 或 Mauve 增加科技感)
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual",
      },
      
      -- 键位绑定：实现快速插入代码
      keys = {
        -- 选中 AI 输出的代码并按 <C-i> (Insert) 插入到主窗口的光标处
        -- 这需要配合 sidekick 的功能或终端特性
        insert_code = { 
            "<C-i>", 
            function(term)
                -- 简单的实现：复制选区到寄存器并粘贴到主窗口
                -- 注意：这需要处于终端的 Visual 模式下选中代码
                vim.cmd('noau normal! "+y') -- 复制到系统剪贴板
                vim.cmd('wincmd p') -- 跳回上一个窗口 (编辑器)
                vim.cmd('normal! "+p') -- 粘贴
                vim.cmd('wincmd p') -- 跳回终端
            end,
            mode = "t", -- 终端模式
            desc = "Insert selected code to editor"
        },
      },
    },
    
    -- 工具特定配置
    tools = {
      claude = {
        -- Claude Code 启动命令
        -- 强制使用深色主题适配 Catppuccin
        cmd = { "claude"},
      },
      codex = {
        cmd = { "codex" },
      },
    },
  },
}
