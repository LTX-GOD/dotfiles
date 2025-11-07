-- 获取uv管理的Python路径
local function get_uv_python_path()
  local handle = io.popen('uv python find 2>/dev/null')
  if handle then
    local result = handle:read('*a')
    handle:close()
    if result and result ~= '' then
      return vim.trim(result)
    end
  end
  return nil
end

return {
  settings = {
    basedpyright = {
      analysis = { 
        typeCheckingMode = 'off',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
    python = {
      pythonPath = get_uv_python_path(),
    },
  },
  root_makers = {
    'uv.lock',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  },
  filetypes = { 'python' },
  cmd = { 'basedpyright-langserver', '--stdio' },
}
