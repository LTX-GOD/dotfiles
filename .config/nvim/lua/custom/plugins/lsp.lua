return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      ui = {
        border = 'single',
        width = 0.8,
        height = 0.8,
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('custom.lsp.attach').setup()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require('mason-lspconfig').setup {
        ensure_installed = {
          'rust_analyzer',
          'marksman',
          'intelephense',
          'gopls',
          'ruff',
          'lua_ls',
        },
        handlers = {
          function(server_name)
            local opts = {}

            local ok, custom_config = pcall(require, 'custom.lsp.servers.' .. server_name)
            if ok then
              opts = custom_config
            end

            opts.capabilities = vim.tbl_deep_extend('force', capabilities, opts.capabilities or {})
            require('lspconfig')[server_name].setup(opts)
          end,
        },
      }

      require('custom.ui.lsp_progress')
    end,
  },
}
