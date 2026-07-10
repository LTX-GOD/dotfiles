return {
  'benomahony/uv.nvim',
  ft = { 'python' },
  dependencies = {
    'folke/snacks.nvim',
  },
  opts = {
    auto_activate_venv = true,
    notify_activate_venv = true,
    auto_commands = true,
    picker_integration = true,
    keymaps = {
      prefix = '<leader>u',
      commands = true,
      run_file = true,
      run_selection = true,
      run_function = true,
      venv = true,
      init = true,
      add = true,
      remove = true,
      sync = true,
    },
    execution = {
      run_command = 'uv run python',
    },
  },
  config = function(_, opts)
    require('uv').setup(opts)

    vim.api.nvim_create_user_command('UVStatus', function()
      vim.system({ 'uv', '--version' }, { text = true }, function(out)
        vim.schedule(function()
          vim.notify(vim.trim(out.stdout or ''), vim.log.levels.INFO, { title = 'uv' })
        end)
      end)
    end, { desc = '显示 uv 版本' })

    vim.api.nvim_create_user_command('UVInfo', function()
      vim.system({ 'uv', 'info' }, { text = true }, function(out)
        vim.schedule(function()
          local msg = vim.trim((out.stdout or '') .. (out.stderr or ''))
          vim.notify(msg, vim.log.levels.INFO, { title = 'uv info' })
        end)
      end)
    end, { desc = '显示 uv 项目信息' })
  end,
}
