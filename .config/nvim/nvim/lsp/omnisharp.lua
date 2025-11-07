-- OmniSharp LSP 配置（与 nvim-cmp 集成）
local cmp_cap = {}
do
  local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
  if ok then
    cmp_cap = cmp_lsp.default_capabilities()
  end
end

local mason_omnisharp = vim.fn.stdpath('data') .. '/mason/packages/omnisharp/libexec/OmniSharp.dll'

return {
  cmd = { 'dotnet', mason_omnisharp }, -- 通过 dotnet 启动 OmniSharp
  filetypes = { 'cs' },
  root_markers = { 'sln', 'csproj', '.git' },
  capabilities = cmp_cap, -- 注入 cmp 能力
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = true,
}