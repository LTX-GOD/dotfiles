-- lua/plugins/lualine.lua (用您的新配置替换整个 return 块)
---@type LazyPluginSpec
return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- set an empty statusline till lualine loads
            vim.o.statusline = ' '
        else
            -- hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,
    opts = {
        options = {
            theme = 'auto',
            component_separators = { left = '', right = '' },
            section_separators = { left = ' ', right = ' '},
            globalstatus = true,
            disabled_filetypes = {
                statusline = {
                    -- 'alpha',
                },
                winbar = {
                    'alpha',
                },
            },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = {
                'branch',
                'diff',
                'diagnostics',
            },
            lualine_c = {
                {
                    'filename',
                    file_status = true,
                    icon_only = true,
                    separator = '',
                    padding = { left = 1, right = 0 },
                    path = 1,
                    shorting_target = 40,
                },
            },
            lualine_x = {
                require('custom.config.indent').indent,
                {
                    name = 'overseer-placeholder',
                    function()
                        return ''
                    end,
                },
                'encoding',
                'filetype',
            },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {},
        },
        extensions = {
            'man', 'quickfix', 'nvim-tree', 'neo-tree', 'lazy',
            'toggleterm', 'symbols-outline', 'aerial', 'nvim-dap-ui', 'mundo',
        },
    },
}
