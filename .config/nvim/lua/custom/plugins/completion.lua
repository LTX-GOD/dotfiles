return {
    'saghen/blink.cmp',
    -- 依赖项：代码片段支持
    
    -- 使用最新稳定版本
    version = '*',
    -- 懒加载：进入插入模式时加载
    event = 'InsertEnter',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 外观配置
        appearance = {
            -- 使用 nvim-cmp 的高亮组作为后备（主题兼容性）
            use_nvim_cmp_as_default = true,
            -- Nerd Font 变体：'mono' 用于等宽字体，'normal' 用于普通字体
            nerd_font_variant = 'mono'
        },

        -- 补全源配置
        sources = {
            -- 默认启用的补全源（按优先级排序）
            default = { 'lsp', 'path', 'snippets', 'buffer' },
            -- 各补全源的详细配置
            providers = {
                -- LSP 补全：最高优先级
                lsp = {
                    score_offset = 100,
                    -- 启用所有 LSP 功能
                    fallbacks = { 'buffer' }
                },
                -- 路径补全：高优先级
                path = {
                    score_offset = 50,
                    -- 路径补全的触发字符
                    opts = {
                        trailing_slash = false,
                        label_trailing_slash = true
                    }
                },
                -- 代码片段：中等优先级
                snippets = {
                    score_offset = 30,
                    -- 代码片段的最小关键词长度
                    min_keyword_length = 1
                },
                -- 缓冲区补全：最低优先级
                buffer = {
                    score_offset = 10,
                    -- 缓冲区补全的最小关键词长度
                    min_keyword_length = 1,
                    -- 最大补全项数量
                    max_items = 10
                }
            }
        },

        -- 命令行补全配置
        cmdline = {
            -- 启用命令行补全
            enabled = true,
            -- 命令行补全源
            sources = {
                default = { 'cmdline', 'path' }
            },
            -- 命令行按键映射
            keymap = {
                preset = 'default',
                ['<CR>'] = { 'select_and_accept', 'fallback' }
            }
        },

        -- 签名帮助配置
        signature = {
            enabled = true,
            -- 触发配置
            trigger = {
                -- 自动显示签名帮助
                enabled = true,
                -- 输入触发字符时显示签名帮助
                show_on_trigger_character = true,
                -- 触发字符列表
                blocked_trigger_characters = {},
                blocked_retrigger_characters = {}
            },
            -- 签名帮助窗口配置
            window = {
                border = 'rounded',
                scrollbar = false
            }
        },

        -- 补全行为配置
        completion = {
            -- 关键词匹配范围：'prefix' 匹配前缀，'full' 匹配整个单词
            keyword = {
                range = 'full'
            },

            -- 触发配置
            trigger = {
                -- 输入时自动显示补全
                show_on_keyword = true,
                -- 输入触发字符时显示补全
                show_on_trigger_character = true
            },

            -- 补全列表配置
            list = {
                -- 选择行为
                selection = {
                    -- 不预选第一项
                    preselect = false,
                    -- 选中时不自动插入
                    auto_insert = false
                },
                -- 循环选择配置
                cycle = {
                    from_bottom = true,
                    from_top = true
                }
            },

            -- 补全菜单配置
            menu = {
                -- 自动显示补全菜单
                auto_show = true,
                -- 菜单尺寸
                min_width = 15,
                max_height = 10,
                -- 菜单边框
                border = 'rounded',
                -- 菜单绘制配置
                draw = {
                    -- 对齐方式
                    align_to = 'label',
                    -- 左侧填充
                    padding = 1,
                    -- 列间距
                    gap = 1,
                    -- 列配置：图标 + 标签 + 描述
                    columns = {
                        { 'kind_icon' },
                        { 'label',    'label_description', gap = 1 }
                    }
                }
            },

            -- 文档窗口配置
            documentation = {
                -- 自动显示文档
                auto_show = true,
                -- 显示延迟（毫秒）
                auto_show_delay_ms = 100,
                -- 更新延迟（毫秒）
                update_delay_ms = 50,
                -- 文档窗口样式
                window = {
                    border = 'rounded',
                    scrollbar = true
                }
            },

            -- 幽灵文本配置（禁用以避免干扰）
            ghost_text = {
                enabled = false
            }
        },

        -- 按键映射配置
        keymap = {
            preset = 'default',
            -- 自定义按键映射
            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide', 'fallback' },
            ['<C-y>'] = { 'select_and_accept' },

            -- 上下选择
            ['<C-p>'] = { 'select_prev', 'fallback' },
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },

            -- 文档滚动
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

            -- Tab 键行为:补全选择
            ['<Tab>'] = { 'select_next', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'fallback' },

            -- 回车键：接受选中项
            ['<CR>'] = { 'accept', 'fallback' }
        },

        -- 文件类型特定配置
        enabled = function()
            -- 在特定缓冲区类型中禁用
            return vim.bo.buftype ~= 'prompt'
                and vim.bo.buftype ~= 'nofile'
                and vim.b.completion ~= false
        end,

        -- 代码片段配置
        snippets = {
        }
    },

    -- 扩展默认源配置
    opts_extend = { 'sources.default' }
}
