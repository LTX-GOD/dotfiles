---@brief
---
--- Ruff LSP配置，根据官方文档优化，支持uv虚拟环境管理
---
return {
  cmd = { 'ruff', 'server' },
  root_markers = { 'uv.lock', 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  filetypes = { 'python' },
  init_options = {
    settings = {
      -- 设置日志级别
      logLevel = 'info',
      -- Ruff配置选项
      configuration = {
        -- 忽略的错误代码
        ignore = {
          'F401',  -- 未使用的导入
          'F821',  -- 未定义的名称
          'E501',  -- 行太长
          'E402',  -- 模块级导入不在文件顶部
          'F403',  -- 无法检测未定义名称（星号导入）
          'F405',  -- 可能未定义或由星号导入定义
        },
        -- 选择要启用的规则集
        select = {
          'E',   -- pycodestyle错误
          'W',   -- pycodestyle警告
          'F',   -- Pyflakes
          'I',   -- isort
        },
        -- 每行最大字符数（使用连字符格式）
        ['line-length'] = 120,
        -- 修复设置
        fix = true,
        -- 格式化设置
        format = {
          -- 使用双引号（注意：字段名使用连字符）
          ['quote-style'] = 'double',
          -- 缩进样式（注意：字段名使用连字符）
          ['indent-style'] = 'space',
        },
      },
    }
  },
  -- 禁用hover和rename功能，让ty处理
  on_attach = function(client, bufnr)
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.renameProvider = false
  end,
}
