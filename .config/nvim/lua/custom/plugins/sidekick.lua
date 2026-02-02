return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  -- 只有当 Copilot 登录后才完全启用 NES，但 CLI 功能随时可用
  cmd = { "Sidekick" },
  keys = {
    {
      "<c-.>",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- 快速打开 Claude
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      desc = "Sidekick Toggle Claude",
    },
    {
      "<leader>ax",
      function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end,
      desc = "Sidekick Toggle Codex",
    },
  },
  opts = function()
    return require('custom.config.sidekick')
  end,
  -- 尝试解决代码插入问题
  config = function(_, opts)
    require("sidekick").setup(opts)

    -- 自定义命令：将当前系统剪贴板内容粘贴到上一个窗口
    vim.api.nvim_create_user_command("SidekickPaste", function()
      local content = vim.fn.getreg('+')
      vim.cmd('wincmd p')  -- 跳回编辑器
      -- 在光标后粘贴
      vim.api.nvim_put(vim.split(content, '\n'), 'l', true, true)
    end, {})
  end
}
