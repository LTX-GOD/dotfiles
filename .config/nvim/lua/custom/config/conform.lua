return {
  notify_on_error = true,
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return {
      timeout_ms = 5000,
      lsp_format = 'fallback',
    }
  end,
  formatters_by_ft = {
    cpp = { 'clang-format' },
    python = { 'ruff_fix', 'ruff_format' },
    snakemake = { 'snakefmt' },
    markdown = { 'prettierd', 'cbfmt' },
    json = { 'prettierd' },
    toml = { 'taplo' },
    go = { 'gofmt', 'goimports' },
  },
  formatters = {
    taplo = {
      command = 'taplo',
      args = { 'fmt', '--option', 'indent_tables=false', '-' },
    },
    ruff_fix = {
      command = 'ruff',
      args = { 'check', '--select', 'I', '--fix', '--stdin-filename', '$FILENAME', '-' },
      stdin = true,
    },
  },
}
