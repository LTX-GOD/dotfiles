require('render-markdown').setup {
  callout = {
    warning = { raw = '[!WARNING]', rendered = ' Warning', highlight = 'RenderMarkdownWarn', category = 'github' },
  },
  sign = { enabled = false },
  code = {
    -- general
    width = 'block',
    min_width = 80,
    -- borders
    border = 'thin',
    left_pad = 1,
    right_pad = 1,
    -- language info
    position = 'right',
    language_icon = true,
    language_name = true,
    -- avoid making headings ugly
    highlight_inline = 'RenderMarkdownCodeInfo',
  },
  heading = {
    icons = { ' 󰼏 ', ' 󰎨 ', ' 󰼑 ', ' 󰎲 ', ' 󰼓 ', ' 󰎴 ' },
    border = true,
    render_modes = true, -- keep rendering while inserting
  },
  checkbox = {
    unchecked = {
      icon = '󰄱',
      highlight = 'RenderMarkdownCodeFallback',
      scope_highlight = 'RenderMarkdownCodeFallback',
    },
    checked = {
      icon = '󰄵',
      highlight = 'RenderMarkdownUnchecked',
      scope_highlight = 'RenderMarkdownUnchecked',
    },
    custom = {
      question = { raw = '[?]', rendered = '', highlight = 'RenderMarkdownError', scope_highlight = 'RenderMarkdownError' },
      todo = { raw = '[>]', rendered = '󰦖', highlight = 'RenderMarkdownInfo', scope_highlight = 'RenderMarkdownInfo' },
      canceled = { raw = '[-]', rendered = '', highlight = 'RenderMarkdownCodeFallback', scope_highlight = '@text.strike' },
      important = { raw = '[!]', rendered = '', highlight = 'RenderMarkdownWarn', scope_highlight = 'RenderMarkdownWarn' },
      favorite = { raw = '[~]', rendered = '', highlight = 'RenderMarkdownMath', scope_highlight = 'RenderMarkdownMath' },
    },
  },
  pipe_table = {
    alignment_indicator = '─',
    border = { '╭', '┬', '╮', '├', '┼', '┤', '╰', '┴', '╯', '│', '─' },
  },
  link = {
    image = ' ',
    custom = {
      github = { pattern = 'github', icon = ' ' },
      gitlab = { pattern = 'gitlab', icon = '󰮠 ' },
      youtube = { pattern = 'youtube', icon = ' ' },
      cern = { pattern = 'cern.ch', icon = ' ' },
    },
    hyperlink = ' ',
  },
  anti_conceal = {
    disabled_modes = { 'n' },
    ignore = {
      bullet = true, -- render bullet in insert mode
      head_border = true,
      head_background = true,
    },
  },
  -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/509
  win_options = { concealcursor = { rendered = 'nvc' } },
  completions = {
    blink = { enabled = true },
    lsp = { enabled = true },
  },
}
