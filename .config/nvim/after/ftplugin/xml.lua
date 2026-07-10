local fname = vim.fn.expand('%:t')
if fname ~= 'pom.xml' and not fname:match('%.pom$') then return end

local function m2_pom_path(group_id, artifact_id, version)
  return vim.fn.expand('~/.m2/repository')
    .. '/' .. group_id:gsub('%.', '/')
    .. '/' .. artifact_id
    .. '/' .. version
    .. '/' .. artifact_id .. '-' .. version .. '.pom'
end

local function open_pom(group_id, artifact_id, version)
  local path = m2_pom_path(group_id, artifact_id, version)
  if vim.uv.fs_stat(path) then
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
  else
    vim.notify(
      string.format('%s:%s:%s\n未在 ~/.m2 中找到，先运行 mvn dependency:resolve', group_id, artifact_id, version),
      vim.log.levels.WARN
    )
  end
end

-- 找光标所在的最近 XML 块（dependency / parent / plugin）
local function find_coords_at_cursor()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, '\n')

  -- 收集所有 artifact 块的位置
  local blocks = {}
  for _, tag in ipairs { 'dependency', 'parent', 'plugin' } do
    for s, block, e in content:gmatch('()<' .. tag .. '>(.-)</' .. tag .. '>()') do
      local start_line = select(2, content:sub(1, s):gsub('\n', '')) + 1
      local end_line   = select(2, content:sub(1, e):gsub('\n', '')) + 1
      local g = block:match('<groupId>%s*(.-)%s*</groupId>')
      local a = block:match('<artifactId>%s*(.-)%s*</artifactId>')
      local v = block:match('<version>%s*(.-)%s*</version>')
      if g and a and v then
        table.insert(blocks, { g = g, a = a, v = v, s = start_line, e = end_line })
      end
    end
  end

  for _, b in ipairs(blocks) do
    if row >= b.s and row <= b.e then
      return b.g, b.a, b.v
    end
  end
end

-- gd：跳转到光标所在依赖的 POM
vim.keymap.set('n', 'gd', function()
  local g, a, v = find_coords_at_cursor()
  if g then
    open_pom(g, a, v)
  else
    vim.notify('光标不在 <dependency>/<parent>/<plugin> 块内', vim.log.levels.WARN)
  end
end, { buffer = true, desc = 'Maven: 跳转到依赖 POM' })

-- <leader>jP：专门跳转到 parent POM
vim.keymap.set('n', '<leader>jP', function()
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  local parent = content:match('<parent>(.-)</parent>')
  if not parent then
    vim.notify('pom.xml 中没有 <parent>', vim.log.levels.WARN)
    return
  end
  local g = parent:match('<groupId>%s*(.-)%s*</groupId>')
  local a = parent:match('<artifactId>%s*(.-)%s*</artifactId>')
  local v = parent:match('<version>%s*(.-)%s*</version>')
  if g and a and v then
    open_pom(g, a, v)
  else
    vim.notify('无法解析 <parent> 坐标', vim.log.levels.ERROR)
  end
end, { buffer = true, desc = 'Maven: 打开 parent POM' })
