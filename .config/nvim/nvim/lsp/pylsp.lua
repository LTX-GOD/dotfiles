---@brief
---
--- https://github.com/python-lsp/python-lsp-server
---
--- A Python 3.6+ implementation of the Language Server Protocol.
--- 支持uv虚拟环境管理
---
--- See the [project's README](https://github.com/python-lsp/python-lsp-server) for installation instructions.
---
--- Configuration options are documented [here](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md).
--- In order to configure an option, it must be translated to a nested Lua table and included in the `settings` argument to the `config('pylsp', {})` function.
--- For example, in order to set the `pylsp.plugins.pycodestyle.ignore` option:
--- ```lua
--- vim.lsp.config('pylsp', {
---   settings = {
---     pylsp = {
---       plugins = {
---         pycodestyle = {
---           ignore = {'W391'},
---           maxLineLength = 100
---         }
---       }
---     }
---   }
--- })
--- ```
---
--- Note: This is a community fork of `pyls`.

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
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_markers = { 'uv.lock', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = false
        },
        pyflakes = {
          enabled = false
        }
      }
    }
  },
  on_init = function(client)
    -- 设置uv管理的Python路径
    local python_path = get_uv_python_path()
    if python_path then
      client.config.settings.pylsp = vim.tbl_deep_extend('force', client.config.settings.pylsp or {}, {
        plugins = {
          jedi = {
            environment = python_path
          }
        }
      })
    end
  end
}
