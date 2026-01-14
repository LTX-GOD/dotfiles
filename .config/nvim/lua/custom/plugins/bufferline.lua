return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    -- 必须调用 setup，否则插件不会生效
    require("bufferline").setup({
      options = {
        -- 这里可以添加你的配置，或者留空使用默认值
        offsets = {
          {
            filetype = "nvim-tree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          }
        },
      }
    })
  end
}
