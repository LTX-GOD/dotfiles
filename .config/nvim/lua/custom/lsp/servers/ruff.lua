---@brief
---
--- https://github.com/astral-sh/ruff
---
--- Ruff LSP 配置，参照官方 initializationOptions 协议
---
---@type vim.lsp.Config
return {
  cmd = { 'ruff', 'server' },
  root_markers = { 'uv.lock', 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  filetypes = { 'python' },
  init_options = {
    settings = {
      logLevel = 'info',
      lint = {
        select = { 'E', 'W', 'F', 'I' },
        ignore = { 'F401', 'F821', 'E501', 'E402', 'F403', 'F405' },
      },
      format = {
        quoteStyle = 'double',
        indentStyle = 'space',
      },
      lineLength = 120,
    },
  },
  -- hover 和 rename 交给 ty 处理
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.renameProvider = false
  end,
}
