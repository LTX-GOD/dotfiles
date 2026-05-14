return {
  '3rd/image.nvim',
  build = false,
  -- 在 markdown 和 tex 文件类型中启用
  ft = { 'markdown' },
  config = function()
    local has_magick_rock = pcall(require, 'magick')

    require('image').setup({
      -- 使用 kitty 后端进行图片渲染
      backend = 'kitty',
      -- 图片处理器配置
      processor = has_magick_rock and 'magick_rock' or 'magick_cli',
      -- 集成配置
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'markdown', 'vimwiki' }, -- markdown 文件类型
        },
        neorg = {
          enabled = true,
          filetypes = { 'norg' },
        },
        typst = {
          enabled = true,
          filetypes = { 'typst' },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      -- 最大图片尺寸
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      -- 窗口重叠处理
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
      -- 编辑器事件
      editor_only_render_when_focused = false,
      -- Tmux 支持
      tmux_show_only_in_active_window = false,
      -- 劫持文件协议以支持本地图片
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    })
  end,
}
