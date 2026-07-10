local M = {}

local state = {
  specs = {},
  order = {},
  loaded = {},
  configured = {},
  loading = {},
}

local pack_noop_load = function() end

local main_modules = {
  ['NvChad/nvim-colorizer.lua'] = 'colorizer',
  ['HakonHarnes/img-clip.nvim'] = 'img-clip',
  ['folke/flash.nvim'] = 'flash',
  ['folke/lazydev.nvim'] = 'lazydev',
  ['folke/which-key.nvim'] = 'which-key',
  ['lewis6991/gitsigns.nvim'] = 'gitsigns',
  ['nvim-lualine/lualine.nvim'] = 'lualine',
  ['saghen/blink.cmp'] = 'blink.cmp',
  ['smjonas/inc-rename.nvim'] = 'inc_rename',
  ['stevearc/conform.nvim'] = 'conform',
  ['williamboman/mason.nvim'] = 'mason',
}

local function notify(msg, level)
  vim.notify('custom.pack: ' .. msg, level or vim.log.levels.INFO)
end

local function tbl_array(value)
  if value == nil then
    return {}
  end

  if type(value) ~= 'table' then
    return { value }
  end

  if vim.islist(value) then
    return value
  end

  return { value }
end

local function is_plugin_spec(value)
  if type(value) ~= 'table' then
    return false
  end

  if type(value[1]) == 'string' then
    return true
  end

  return type(value.src) == 'string'
end

local function spec_name_from_src(src)
  local name = src:gsub('/+$', ''):match('([^/]+)$') or src
  return name:gsub('%.git$', '')
end

local function spec_src_from_repo(repo)
  if repo:match('^https?://') or repo:match('^git@') or repo:match('^gh:') or repo:match('^cb:') then
    return repo
  end

  return 'https://github.com/' .. repo
end

local function infer_main(spec)
  if spec.main then
    return spec.main
  end

  return main_modules[spec._repo]
end

local function needs_configuration(spec)
  return type(spec.config) == 'function' or spec.config == true or spec.opts ~= nil
end

local function resolve_opts(spec)
  if type(spec.opts) == 'function' then
    return spec.opts(spec)
  end

  return spec.opts
end

local function run_default_setup(spec, opts)
  local main = infer_main(spec)
  if not main then
    notify(('no main module mapping for %s; set spec.main or extend custom.pack.main_modules'):format(spec.name), vim.log.levels.ERROR)
    return false
  end

  local ok, plugin = pcall(require, main)
  if not ok then
    notify(('failed to require %s for %s: %s'):format(main, spec.name, plugin), vim.log.levels.ERROR)
    return false
  end

  if type(plugin.setup) == 'function' then
    plugin.setup(opts or {})
    return true
  end

  notify(('module %s for %s does not expose setup()'):format(main, spec.name), vim.log.levels.ERROR)
  return false
end

local function has_lazy_triggers(spec)
  return spec.event ~= nil or spec.cmd ~= nil or spec.ft ~= nil or spec.keys ~= nil
end

local function should_load_eagerly(spec)
  if spec._dependency_only then
    return false
  end

  if spec.eager == true then
    return true
  end

  if spec.lazy == false then
    return true
  end

  if spec.priority then
    return true
  end

  return not has_lazy_triggers(spec)
end

local function make_command_forwarder(command_name, args)
  vim.schedule(function()
    local ok, err = pcall(vim.api.nvim_cmd, {
      cmd = command_name,
      args = args.fargs,
      bang = args.bang,
      mods = args.smods,
      count = args.count >= 0 and args.count or nil,
      reg = args.reg ~= '' and args.reg or nil,
      range = args.range,
      line1 = args.line1,
      line2 = args.line2,
    }, {})

    if not ok then
      notify(('command %s failed: %s'):format(command_name, err), vim.log.levels.ERROR)
    end
  end)
end

local function trigger_key_action(map)
  if type(map[2]) == 'function' then
    return map[2]()
  end

  if type(map[2]) == 'string' then
    vim.api.nvim_feedkeys(vim.keycode(map[2]), 'm', false)
  end
end

local function merge_dependencies(existing, incoming)
  local merged = {}
  local seen = {}

  for _, dep in ipairs(tbl_array(existing)) do
    merged[#merged + 1] = dep
    local key = type(dep) == 'string' and dep or dep.name or dep[1] or dep.src
    seen[key] = true
  end

  for _, dep in ipairs(tbl_array(incoming)) do
    local key = type(dep) == 'string' and dep or dep.name or dep[1] or dep.src
    if not seen[key] then
      merged[#merged + 1] = dep
      seen[key] = true
    end
  end

  return merged
end

local function register_spec(spec, dependency_only)
  local existing = state.specs[spec.name]
  if existing then
    if not dependency_only then
      existing._dependency_only = false
    end

    existing.dependencies = merge_dependencies(existing.dependencies, spec.dependencies)

    for key, value in pairs(spec) do
      if key ~= 'dependencies' and key ~= '_dependency_only' and existing[key] == nil then
        existing[key] = value
      end
    end

    return existing
  end

  spec._dependency_only = dependency_only or false
  state.specs[spec.name] = spec
  state.order[#state.order + 1] = spec.name
  return spec
end

local function normalize_spec(raw)
  local repo = raw[1]
  local spec = {}

  for key, value in pairs(raw) do
    if key ~= 1 then
      spec[key] = value
    end
  end

  spec.src = spec.src or spec_src_from_repo(repo)
  spec.name = spec.name or spec_name_from_src(spec.src)
  spec.version = spec.version or spec.tag or spec.branch

  if spec.version == '*' then
    spec.version = vim.version.range '*'
  end

  spec._repo = repo or spec.src

  return spec
end

local function collect_dependency(dep)
  if type(dep) == 'string' then
    return normalize_spec { dep }
  end

  if is_plugin_spec(dep) then
    return normalize_spec(dep)
  end
end

local function collect_spec_tree(raw, dependency_only)
  if type(raw) ~= 'table' then
    return
  end

  if not is_plugin_spec(raw) then
    for _, item in ipairs(tbl_array(raw)) do
      collect_spec_tree(item, dependency_only)
    end
    return
  end

  local spec = register_spec(normalize_spec(raw), dependency_only)
  local dep_names = {}

  for _, dep in ipairs(tbl_array(spec.dependencies)) do
    local dep_spec = collect_dependency(dep)
    if dep_spec then
      local registered = register_spec(dep_spec, true)
      dep_names[#dep_names + 1] = registered.name
      if type(dep) == 'table' then
        collect_spec_tree(dep, true)
      end
    end
  end

  spec._dependency_names = dep_names
end

local function load_plugin(name)
  if state.loading[name] then
    return true
  end

  local spec = state.specs[name]
  if not spec then
    notify(('unknown plugin %s'):format(name), vim.log.levels.ERROR)
    return false
  end

  if state.loaded[name] and (state.configured[name] or not needs_configuration(spec)) then
    return true
  end

  state.loading[name] = true

  for _, dep_name in ipairs(spec._dependency_names or {}) do
    local ok = load_plugin(dep_name)
    if not ok then
      state.loading[name] = nil
      return false
    end
  end

  if not state.loaded[name] then
    local ok_pack, err_pack = pcall(vim.cmd, 'packadd ' .. vim.fn.fnameescape(name))
    if not ok_pack then
      state.loading[name] = nil
      notify(('failed to load %s: %s'):format(name, err_pack), vim.log.levels.ERROR)
      return false
    end

    state.loaded[name] = true
  end

  if not needs_configuration(spec) then
    state.configured[name] = true
    state.loading[name] = nil
    return true
  end

  if state.configured[name] then
    state.loading[name] = nil
    return true
  end

  local opts = resolve_opts(spec)

  if type(spec.config) == 'function' then
    local ok_config, err_config = pcall(spec.config, spec, opts)
    if not ok_config then
      state.loading[name] = nil
      notify(('config failed for %s: %s'):format(name, err_config), vim.log.levels.ERROR)
      return false
    end
  else
    local ok_setup, setup_result = pcall(run_default_setup, spec, opts)
    if not ok_setup then
      state.loading[name] = nil
      notify(('setup failed for %s: %s'):format(name, setup_result), vim.log.levels.ERROR)
      return false
    end
    if not setup_result then
      state.loading[name] = nil
      return false
    end
  end

  state.configured[name] = true
  state.loading[name] = nil
  return true
end

local function create_key_stub(spec, map)
  local lhs = map[1]
  if type(lhs) ~= 'string' then
    return
  end

  local modes = tbl_array(map.mode or 'n')
  local opts = {
    desc = map.desc,
    expr = map.expr,
    nowait = map.nowait,
    remap = map.remap,
    silent = map.silent ~= false,
  }

  for _, mode in ipairs(modes) do
    vim.keymap.set(mode, lhs, function()
      if load_plugin(spec.name) then
        return trigger_key_action(map)
      end
    end, opts)
  end
end

local function create_cmd_stub(spec, command_name)
  local register
  register = function()
    vim.api.nvim_create_user_command(command_name, function(args)
      pcall(vim.api.nvim_del_user_command, command_name)

      if not load_plugin(spec.name) then
        register()
        return
      end

      if vim.fn.exists(':' .. command_name) == 0 then
        notify(('plugin %s did not define command :%s after loading'):format(spec.name, command_name), vim.log.levels.ERROR)
        register()
        return
      end

      make_command_forwarder(command_name, args)
    end, {
      bang = true,
      bar = true,
      complete = 'file',
      nargs = '*',
      range = true,
    })
  end

  register()
end

local function create_event_stub(spec, event_name)
  local event = event_name
  local pattern

  if event_name == 'VeryLazy' then
    event = 'User'
    pattern = 'VeryLazy'
  end

  vim.api.nvim_create_autocmd(event, {
    once = true,
    pattern = pattern,
    callback = function()
      load_plugin(spec.name)
    end,
  })
end

local function register_lazy_handlers(spec)
  for _, event_name in ipairs(tbl_array(spec.event)) do
    if type(event_name) == 'string' then
      create_event_stub(spec, event_name)
    end
  end

  for _, filetype in ipairs(tbl_array(spec.ft)) do
    if type(filetype) == 'string' then
      vim.api.nvim_create_autocmd('FileType', {
        once = true,
        pattern = filetype,
        callback = function(ev)
          if load_plugin(spec.name) then
            vim.schedule(function()
              vim.api.nvim_exec_autocmds('FileType', { buffer = ev.buf, modeline = false })
            end)
          end
        end,
      })
    end
  end

  for _, command_name in ipairs(tbl_array(spec.cmd)) do
    if type(command_name) == 'string' and vim.fn.exists(':' .. command_name) == 0 then
      create_cmd_stub(spec, command_name)
    end
  end

  for _, map in ipairs(tbl_array(spec.keys)) do
    if type(map) == 'table' then
      create_key_stub(spec, map)
    end
  end
end

local function register_pack_commands()
  vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update()
  end, { desc = 'Update plugins managed by vim.pack' })

  vim.api.nvim_create_user_command('PackPlugins', function()
    vim.pack.update(nil, { offline = true })
  end, { desc = 'Inspect plugins managed by vim.pack' })
end

local function register_pack_changed_hook()
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then
        return
      end

      local spec = state.specs[ev.data.spec.name]
      if not spec or spec.build == false or spec.build == nil then
        return
      end

      if not state.loaded[spec.name] then
        load_plugin(spec.name)
      end

      if type(spec.build) == 'function' then
        spec.build(spec)
        return
      end

      if type(spec.build) == 'string' then
        local command = spec.build:gsub('^:', '')
        vim.cmd(command)
      end
    end,
  })
end

local function bootstrap_specs()
  local ok, module_specs = pcall(require, 'custom.plugins')
  if ok then
    collect_spec_tree(module_specs, false)
  else
    notify(('failed to load custom.plugins: %s'):format(module_specs), vim.log.levels.ERROR)
  end
end
local function run_init_hooks()
  for _, name in ipairs(state.order) do
    local spec = state.specs[name]
    if type(spec.init) == 'function' then
      local ok, err = pcall(spec.init, spec)
      if not ok then
        notify(('init failed for %s: %s'):format(name, err), vim.log.levels.ERROR)
      end
    end
  end
end

local function add_plugins_to_vim_pack()
  local pack_specs = {}

  for _, name in ipairs(state.order) do
    local spec = state.specs[name]
    pack_specs[#pack_specs + 1] = {
      src = spec.src,
      name = spec.name,
      version = spec.version,
    }
  end

  vim.pack.add(pack_specs, { load = pack_noop_load, confirm = true })
end

local function trigger_very_lazy()
  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
      vim.schedule(function()
        vim.api.nvim_exec_autocmds('User', { pattern = 'VeryLazy', modeline = false })
      end)
    end,
  })
end

function M.load(name)
  return load_plugin(name)
end

function M.setup()
  register_pack_commands()
  register_pack_changed_hook()
  trigger_very_lazy()

  bootstrap_specs()
  run_init_hooks()
  add_plugins_to_vim_pack()

  for _, name in ipairs(state.order) do
    register_lazy_handlers(state.specs[name])
  end

  local eager = {}
  for _, name in ipairs(state.order) do
    local spec = state.specs[name]
    if should_load_eagerly(spec) then
      eager[#eager + 1] = spec
    end
  end

  table.sort(eager, function(a, b)
    return (a.priority or 0) > (b.priority or 0)
  end)

  for _, spec in ipairs(eager) do
    load_plugin(spec.name)
  end
end

return M
