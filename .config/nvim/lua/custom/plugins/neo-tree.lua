return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- 可选，用于文件图标
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "切换文件树" },
    { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "在文件树中显示当前文件" },
    { "<Tab>", "<cmd>Neotree focus<cr>", desc = "聚焦到文件树" },
  },
  opts = function()
    return require('custom.config.neo-tree')
  end,
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- 自动命令：在启动时打开neo-tree（可选）
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 0 then
          vim.cmd("Neotree show")
        end
      end,
    })
  end,
}
