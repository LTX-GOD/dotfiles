return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'saghen/blink.cmp',
    },
    event = { 'BufReadPost', 'BufNewFile', 'VimEnter' },
    config = function()       
        require('custom.lsp.attach').setup()
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        -- 3. 配置 Mason
        require('mason').setup {
            ui = {
                border = 'single',
                width = 0.8,
                height = 0.8
            }
        }

        require('mason-lspconfig').setup {
            ensure_installed = {
                'rust_analyzer',
                'marksman',
                'intelephense',
                'basedpyright',
                'clangd',
                'gopls',
                'ruff',
                'tinymist',
                'lua_ls',
            },
            handlers = {
                function(server_name)
                    local opts = {}
                    
                    local ok, custom_config = pcall(require, 'custom.lsp.servers.' .. server_name)
                    if ok then
                        opts = custom_config
                    end

                    -- 合并 capabilities
                    opts.capabilities = vim.tbl_deep_extend('force', capabilities, opts.capabilities or {})

                    -- 启动服务器
                    require('lspconfig')[server_name].setup(opts)
                end
            }
        }
        
        -- 加载 LSP 进度提示 UI
        require('custom.ui.lsp_progress')
    end
}
