return {
  'catppuccin/nvim',
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      transparent_background = true,
      term_colors = true,
      integrations = {
        mini = {
          enabled = true,
          indentscope_color = 'sky',
        },
        neotree = true,
        treesitter = true,
        notify = true,
        gitsigns = true,
        flash = true,
        blink_cmp = true,
        mason = true,
        snacks = true,
      },
      highlight_overrides = {
        mocha = function(mocha)
          return {
            CursorLineNr = { fg = mocha.yellow },
            FlashCurrent = { bg = mocha.peach, fg = mocha.base },
            FlashMatch = { bg = mocha.red, fg = mocha.base },
            FlashLabel = { bg = mocha.teal, fg = mocha.base },
          }
        end,
      },
    }
    vim.cmd.colorscheme 'catppuccin-mocha'
    vim.cmd.hi 'Comment gui=none'
  end,
}
