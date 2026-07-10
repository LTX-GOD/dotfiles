-- 只保留与 neo-tree 默认值不同的配置；完整选项见 :h neo-tree
return {
  popup_border_style = 'rounded',
  default_component_configs = {
    git_status = {
      symbols = {
        -- 名字已经用 git_status_colors 上色，added/modified 图标是冗余信息，留空
        added = '',
        modified = '',
        deleted = '✖',
        renamed = '󰁕',
        untracked = '',
        ignored = '',
        unstaged = '󰄱',
        staged = '',
        conflict = '',
      },
    },
  },
  window = {
    position = 'left',
    width = 35,
    mappings = {
      ['<Tab>'] = function()
        vim.cmd 'wincmd p'
      end,
      ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = true } },
      ['l'] = 'focus_preview',
    },
  },
  filesystem = {
    filtered_items = {
      visible = true, -- 隐藏文件变暗显示而不是完全隐藏
    },
  },
  -- 只保留 filesystem 和 git_status 两个 source
  source_selector = {
    winbar = false,
    statusline = false,
    sources = {
      { source = 'filesystem' },
      { source = 'git_status' },
    },
  },
  git_status = {
    window = { position = 'float' },
  },
}
