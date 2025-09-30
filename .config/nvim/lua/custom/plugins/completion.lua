return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', -- Snippet 引擎
                    'saadparwaiz1/cmp_luasnip', -- Snippet 源
    'hrsh7th/cmp-emoji' -- Emoji 补全
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false -- 改为false，不自动选择第一个补全项
                }),
                -- 添加Tab键来选择并确认第一个补全项（可选）
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, {'i', 's'})
            }),
            sources = cmp.config.sources({{
                name = 'nvim_lsp'
            }, {
                name = 'luasnip'
            }}, {{
                name = 'buffer'
            }, {
                name = 'path'
            }, {
                name = 'emoji'
            } -- Emoji 补全源
            })
        })

        -- Markdown 文件特定配置
        cmp.setup.filetype('markdown', {
            sources = cmp.config.sources({{
                name = 'nvim_lsp'
            }, {
                name = 'luasnip'
            }, {
                name = 'emoji'
            } -- Markdown 中优先显示 emoji
            }, {{
                name = 'buffer'
            }, {
                name = 'path'
            }})
        })
    end
}
