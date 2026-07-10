local function has_exec(cmd)
  return vim.fn.executable(cmd) == 1
end

local markdown_formatters = { 'cbfmt' }
if has_exec 'prettierd' then
  table.insert(markdown_formatters, 1, 'prettierd')
end

local json_formatters = {}
if has_exec 'prettierd' then
  json_formatters = { 'prettierd' }
end

local snakemake_formatters = {}
if has_exec 'snakefmt' then
  snakemake_formatters = { 'snakefmt' }
end

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
    java = { 'google-java-format' },
    cpp = { 'clang-format' },
    python = { 'ruff_fix', 'ruff_format' },
    snakemake = snakemake_formatters,
    markdown = markdown_formatters,
    json = json_formatters,
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
