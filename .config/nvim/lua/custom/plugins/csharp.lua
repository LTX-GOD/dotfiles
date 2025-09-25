-- C# 开发支持：csharp.nvim +（可选）OmniSharp 跳转增强
-- 说明：
-- 1) csharp.nvim 提供 C# 项目工作流的基础设施（后续可拓展测试/调试等）
-- 2) 这里禁用其内置 LSP，改用自定义 lsp/omnisharp.lua
return {{
    'iabdelkareem/csharp.nvim',
    ft = {'cs'}, -- 打开 .cs 文件时生效
    dependencies = {'williamboman/mason.nvim', -- 确保相关工具可通过 Mason 安装
    'mfussenegger/nvim-dap', -- 后续如需调试可直接启用
    'Tastyep/structlog.nvim' -- 日志（csharp.nvim 依赖）
    },
    config = function()
        -- 禁用内置 LSP 管理，避免与 lsp/omnisharp.lua 冲突
        require('csharp').setup({
            lsp = {
                omnisharp = {
                    enable = false -- 禁用内置 OmniSharp LSP
                },
                roslyn = {
                    enable = false -- 禁用 Roslyn LSP
                }
            }
        })
    end
}, -- 可选：增强 OmniSharp 的定义/引用/实现跳转
{
    'Hoffs/omnisharp-extended-lsp.nvim',
    ft = {'cs'}
}}
