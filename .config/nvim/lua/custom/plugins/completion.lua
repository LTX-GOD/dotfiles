return {
  'saghen/blink.cmp',
  version = '*',
  dependencies = {
    'milanglacier/minuet-ai.nvim',
  },
  event = 'InsertEnter',
  opts = function()
    return {
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
      kind_icons = {
        Deepseek = '',
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'minuet' },
      providers = {
        lsp = {
          score_offset = 100,
          fallbacks = { 'buffer' },
        },
        path = {
          score_offset = 50,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
          },
        },
        snippets = {
          score_offset = 30,
          min_keyword_length = 1,
        },
        buffer = {
          score_offset = 10,
          min_keyword_length = 1,
          max_items = 10,
        },
        minuet = {
          name = 'minuet',
          module = 'minuet.blink',
          async = true,
          timeout_ms = 3000,
          score_offset = 50,
        },
      },
    },
    cmdline = {
      enabled = true,
      sources = {
        default = { 'cmdline', 'path' },
      },
      keymap = {
        preset = 'default',
        ['<CR>'] = { 'select_and_accept', 'fallback' },
      },
    },
    signature = {
      enabled = true,
      trigger = {
        enabled = true,
        show_on_trigger_character = true,
        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
      },
      window = {
        border = 'rounded',
        scrollbar = false,
      },
    },
    completion = {
      keyword = {
        range = 'full',
      },
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
        prefetch_on_insert = false,
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },
      menu = {
        auto_show = true,
        min_width = 15,
        max_height = 10,
        border = 'rounded',
        draw = {
          align_to = 'label',
          padding = 1,
          gap = 1,
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'source_name' },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
        update_delay_ms = 50,
        window = {
          border = 'rounded',
          scrollbar = true,
        },
      },
      ghost_text = {
        enabled = false,
      },
    },
    keymap = {
      preset = 'default',
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-y>'] = { 'select_and_accept' },
      ['<A-y>'] = require('minuet').make_blink_map(),
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<Tab>'] = {
        'snippet_forward',
        function()
          if vim.lsp.inline_completion then
            return vim.lsp.inline_completion.get()
          end
        end,
        'select_next',
        'fallback',
      },
      ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
    },
    enabled = function()
      return vim.bo.buftype ~= 'prompt'
        and vim.bo.buftype ~= 'nofile'
        and vim.b.completion ~= false
    end,
    snippets = {},
    }
  end,
  opts_extend = { 'sources.default' },
}
