require('custom.compat.treesitter_0_12').setup()

local languages = {
  'bash',
  'python',
  'cpp',
  'diff',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'html',
  'xml',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
  'snakemake',
}

local filetypes = {
  'bash',
  'cpp',
  'diff',
  'gitdiff',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'python',
  'query',
  'sh',
  'snakemake',
  'vim',
  'vimdoc',
  'xml',
}

require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath 'data' .. '/site',
}

require('nvim-treesitter').install(languages)

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-treesitter', { clear = true }),
  pattern = filetypes,
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
      or vim.bo[ev.buf].filetype

    if lang ~= 'latex' and not (lang == 'yaml' and vim.api.nvim_buf_line_count(ev.buf) > 5000) then
      pcall(vim.treesitter.start, ev.buf)
    end

    if lang ~= 'ruby' and not (lang == 'yaml' and vim.api.nvim_buf_line_count(ev.buf) > 5000) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
