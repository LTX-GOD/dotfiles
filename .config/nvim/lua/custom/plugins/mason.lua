return {
    'williamboman/mason.nvim',
    dependencies = { 'williamboman/mason-lspconfig.nvim', 'neovim/nvim-lspconfig' },
    event = { 'BufReadPost', 'BufNewFile', 'VimEnter' },
    config = function()
        -- 设置 mason
        require('mason').setup {
            pip = {
                upgrade_pip = false,
                install_args = pip_args
            },
            ui = {
                border = 'single',
                width = 0.7,
                height = 0.7
            }
        }

        -- 设置 mason-lspconfig，它会连接 mason 和 lspconfig
        require('mason-lspconfig').setup {
            -- 确保这些服务器被安装。您可以在这里添加更多服务器。
            ensure_installed = { 'gopls', 'lua_ls', 'ruff', 'omnisharp', 'rust_analyzer', 'marksman', 'intelephense' },
            handlers = { function(server_name)
                -- 尝试加载您在 lsp/ 目录下的自定义配置
                local custom_opts_path = 'lsp.' .. server_name
                local has_custom_opts, custom_opts = pcall(require, custom_opts_path)

                local opts = {}
                if has_custom_opts then
                    opts = custom_opts
                end

                -- 使用 lspconfig 启动服务器
                require('lspconfig')[server_name].setup(opts)
            end }
        }
        -- 额外通过 mason 安装 DAP/formatter（非 LSP）
        local mr = require('mason-registry')
        for _, pkg in ipairs({ 'netcoredbg', 'csharpier' }) do
            if not mr.is_installed(pkg) then
                mr.get_package(pkg):install()
            end
        end
    end
}
