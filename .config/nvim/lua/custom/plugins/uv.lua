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
      vim.cmd '!uv --version'
    end, { desc = '显示uv版本信息' })

    vim.api.nvim_create_user_command('UVInfo', function()
      vim.cmd '!uv info'
    end, { desc = '显示uv项目信息' })
  end,
}
