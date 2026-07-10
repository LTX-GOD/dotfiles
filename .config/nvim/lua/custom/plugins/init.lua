local specs = {}

local function add(module)
  specs[#specs + 1] = require('custom.plugins.' .. module)
end

add 'bufferline'
add 'catppuccin'
add 'completion'
add 'conform'
add 'dap'
add 'flash'
add 'gitsigns'
add 'image'
add 'jdtls'
add 'inc-rename'
add 'keymap'
add 'lazydev'
add 'lsp'
add 'lualine'
add 'markdown'
add 'mini'
add 'minuet'
add 'neo-tree'
add 'nvim-colorizer'
add 'sidekick'
add 'snacks'
add 'treesitter'
add 'uv'
add 'vim-kitty'
add 'vim-sleuth'

return specs
