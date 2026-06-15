vim.filetype.add {
  extension = {
    qmt = 'qmt',
    ipynb = 'ipynb',
    gotmpl = 'gotmpl',
    mdx = 'markdown.mdx',
    ent = 'xml',
    h = function(_, bufnr)
      local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
      if first_line:match 'NVIDIA Corporation' then
        return 'cuda'
      end
      return 'cpp'
    end,
  },
  filename = {
    ['Snakefile'] = 'snakemake',
    ['docker-compose.yaml'] = 'yaml.docker-compose',
    ['docker-compose.yml'] = 'yaml.docker-compose',
    ['compose.yaml'] = 'yaml.docker-compose',
    ['compose.yml'] = 'yaml.docker-compose',
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'qf', 'dap-float' },
  callback = function()
    vim.keymap.set('n', 'q', '<CMD>quit<CR>', { buffer = true, silent = true })
  end,
})
