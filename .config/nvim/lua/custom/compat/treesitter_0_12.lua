local M = {}

function M.setup()
  if vim.fn.has 'nvim-0.12' ~= 1 then
    return
  end

  local ok, query = pcall(require, 'vim.treesitter.query')
  if not ok then
    return
  end

  local html_script_type_languages = {
    importmap = 'json',
    module = 'javascript',
    ['application/ecmascript'] = 'javascript',
    ['text/ecmascript'] = 'javascript',
  }

  local non_filetype_match_injection_language_aliases = {
    ex = 'elixir',
    pl = 'perl',
    sh = 'bash',
    ts = 'typescript',
    uxn = 'uxntal',
  }

  local opts = { force = true, all = false }

  local function first_node(match, capture_id)
    local nodes = match[capture_id]
    if not nodes or #nodes == 0 then
      return nil
    end
    return nodes[1]
  end

  local function ensure_capture_metadata(metadata, capture_id)
    metadata[capture_id] = metadata[capture_id] or {}
    return metadata[capture_id]
  end

  local function get_parser_from_markdown_info_string(injection_alias)
    local match = vim.filetype.match { filename = 'a.' .. injection_alias }
    return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
  end

  query.add_directive('set-lang-from-mimetype!', function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    if type(capture_id) ~= 'number' then
      return
    end

    local node = first_node(match, capture_id)
    if not node then
      return
    end

    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata['injection.language'] = configured
      return
    end

    local parts = vim.split(type_attr_value, '/', {})
    metadata['injection.language'] = parts[#parts]
  end, opts)

  query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    if type(capture_id) ~= 'number' then
      return
    end

    local node = first_node(match, capture_id)
    if not node then
      return
    end

    local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata['injection.language'] = get_parser_from_markdown_info_string(injection_alias)
  end, opts)

  query.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    if type(capture_id) ~= 'number' then
      return
    end

    local node = first_node(match, capture_id)
    if not node then
      return
    end

    local capture_metadata = ensure_capture_metadata(metadata, capture_id)
    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = capture_metadata }) or ''
    capture_metadata.text = text:lower()
  end, opts)
end

return M
