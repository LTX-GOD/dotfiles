return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    require('mini.ai').setup { mappings = {
      goto_left = '[',
      goto_right = ']',
    } }
    require('mini.icons').setup {
      style = 'glyph',
      file = {
        README = { glyph = '󰆈', hl = 'MiniIconsYellow' },
        ['README.md'] = { glyph = '󰆈', hl = 'MiniIconsYellow' },
      },
      filetype = {
        bash = { glyph = '󱆃', hl = 'MiniIconsGreen' },
        sh = { glyph = '󱆃', hl = 'MiniIconsGrey' },
        toml = { glyph = '󱄽', hl = 'MiniIconsOrange' },
      },
    }
    require('mini.surround').setup {
      mappings = {
        add = 'sa',
        delete = 'sd',
        find = 'sf',
        find_left = 'sF',
        highlight = 'sh',
        replace = 'sr',
        update_n_lines = 'sn',
        suffix_last = 'l',
        suffix_next = 'n',
      },
    }
    require('mini.pairs').setup {}
    require('mini.comment').setup {}
  end,
}
