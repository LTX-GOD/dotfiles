---@brief
---
--- https://github.com/astral-sh/ty
---
--- ty - 极快的 Python 类型检查器和语言服务器（Rust 编写）
---
---@type vim.lsp.Config
return {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
}
