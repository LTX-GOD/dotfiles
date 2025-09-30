return {
    'saghen/blink.cmp',
    -- 可选依赖，用于构建二进制文件
    dependencies = 'rafamadriz/friendly-snippets',
    -- 使用发布版本而不是主分支
    version = '1.*',
    -- 懒加载配置
    event = 'InsertEnter',

    opts = {
        -- 'default' 用于默认预设
        -- 'minimal' 用于最小预设
        -- 'super-tab' 用于super-tab预设
        keymap = {
            preset = 'default'
        },

        appearance = {
            -- 设置为 'mono' 用于 Nerd Font Mono 或 'normal' 用于 Nerd Font
            -- 调整为适合你的字体，大多数用户应该使用 'normal'
            nerd_font_variant = 'mono'
        },

        -- 默认补全源列表
        sources = {
            default = {'lsp', 'path', 'snippets', 'buffer'},
            -- 代码片段高优先级设置
            providers = {
                snippets = {
                    score_offset = 1000
                }
            }
        },

        -- 命令行补全配置
        cmdline = {
            sources = {}
        },

        -- 实验性签名帮助支持
        signature = {
            enabled = true
        },

        completion = {
            -- 'prefix' 用于传统补全匹配
            -- 'fuzzy' 用于模糊匹配
            keyword = {
                range = 'prefix'
            },

            -- 触发配置
            trigger = {
                -- 当为true时，将在每次按键时显示补全菜单
                -- 当为false时，只在触发字符或手动触发时显示
                show_on_keyword = true,
                -- 当为true时，将在插入模式进入时显示补全菜单
                show_on_insert_on_trigger_character = true
            },

            -- 补全菜单配置
            menu = {
                -- 控制补全菜单何时自动显示
                auto_show = true,

                -- 绘制配置
                draw = {
                    -- 对齐补全菜单列
                    align_to = 'label', -- 或 'none' 禁用，或 'cursor' 对齐到光标
                    -- 左侧填充，用于图标
                    padding = 1,
                    -- 间隙配置
                    gap = 1,
                    -- 组件配置
                    columns = {{"kind_icon"}, {
                        "label",
                        "label_description",
                        gap = 1
                    }}
                }
            },

            -- 文档窗口配置
            documentation = {
                -- 控制文档窗口何时自动显示
                auto_show = true,
                auto_show_delay_ms = 200,
                -- 更新延迟
                update_delay_ms = 50
            },

            -- 实验性ghost_text支持
            ghost_text = {
                enabled = false
            }
        },

        -- 按键映射配置
        keymap = {
            preset = 'default',
            -- 自定义按键映射
            ['<C-space>'] = {'show', 'show_documentation', 'hide_documentation'},
            ['<C-e>'] = {'hide'},
            ['<C-y>'] = {'select_and_accept'},

            ['<C-p>'] = {'select_prev', 'fallback'},
            ['<C-n>'] = {'select_next', 'fallback'},

            ['<C-b>'] = {'scroll_documentation_up', 'fallback'},
            ['<C-f>'] = {'scroll_documentation_down', 'fallback'},

            ['<Tab>'] = {'snippet_forward', 'select_next', 'fallback'},
            ['<S-Tab>'] = {'snippet_backward', 'select_prev', 'fallback'},

            ['<CR>'] = {'accept', 'fallback'}
        }
    },

    -- 允许覆盖默认配置
    opts_extend = {"sources.default"}
}
