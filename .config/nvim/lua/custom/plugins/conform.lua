return {
  'stevearc/conform.nvim',
  init = function()
    vim.g.disable_autoformat = false
    vim.keymap.set('n', '<leader>tf', function()
      if vim.g.disable_autoformat then
        vim.g.disable_autoformat = false
        vim.notify('Autoformat is enabled', vim.log.levels.INFO)
      else
        vim.g.disable_autoformat = true
        vim.notify('Autoformat is disabled', vim.log.levels.WARN)
      end
    end, { desc = 'Toggle autoformatting' })
    
    -- 用户命令
    vim.api.nvim_create_user_command('ConformDisable', function(args)
        if args.bang then
            vim.b.disable_autoformat = true
        else
            vim.g.disable_autoformat = true
        end
    end, {
        desc = 'Disable autoformat-on-save',
        bang = true
    })
    vim.api.nvim_create_user_command('ConformEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
    end, {
        desc = 'Re-enable autoformat-on-save'
    })
  end,
  event = { 'BufWritePre', 'InsertEnter' },
  cmd = { 'ConformInfo', 'ConformEnable', 'ConformDisable' },
  keys = {
    {
      '<leader>lf',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      desc = 'Format buffer',
    },
  },
  -- 使用 opts 字段直接引用配置，lazy.nvim 会自动 require
  opts = function()
    return require('custom.config.conform')
  end,
}
