local M = {}

--- Check if any LSP client is attached to the current buffer
M.is_lsp_attached = function()
  local clients = vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() }
  return next(clients) ~= nil
end

--- Check if running on macOS
M.is_mac = function()
  local uname = vim.uv.os_uname()
  return uname.sysname == 'Darwin'
end

--- Jump to file:line detected in any window (useful for log files)
M.jump_to_file_lnum_from_all_windows = function()
    local matches = {}
    local seen = {}

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)

        -- Avoid duplicates if multiple windows show the same buffer
        if not seen[buf] then
            seen[buf] = true
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

            for _, line in ipairs(lines) do
                for filepath, lno in string.gmatch(line, '([%w%./~_-]+):(%d+)') do
                    table.insert(matches, {
                        label = filepath .. ':' .. lno,
                        file = filepath,
                        lnum = tonumber(lno)
                    })
                end
            end
        end
    end

    if vim.tbl_isempty(matches) then
        vim.notify("No file:line patterns found in any window", vim.log.levels.INFO)
        return
    end

    vim.ui.select(matches, {
        prompt = "Jump to file:line",
        format_item = function(item)
            return item.label
        end
    }, function(choice)
        if choice then
            vim.cmd('edit ' .. choice.file)
            vim.api.nvim_win_set_cursor(0, {choice.lnum, 0})
        end
    end)
end

--- Toggle distraction free mode (hides UI elements)
M.toggle_distraction_free = function()
    local feedkeys = vim.api.nvim_feedkeys
    local t = vim.api.nvim_replace_termcodes
    -- Assuming these keys toggle various UI elements (gitsigns, inlay hints, diagnostics, etc.)
    -- Ensure these mappings exist or adapt logic to call functions directly
    feedkeys(t('<leader>tg', true, true, true), 'm', false) -- Toggle gitsigns
    feedkeys(t('<leader>th', true, true, true), 'm', false) -- Toggle inlay hints (LSP)
    feedkeys(t('<leader>td', true, true, true), 'm', false) -- Toggle diagnostics (LSP)
    -- feedkeys(t('<leader>tt', true, true, true), 'm', false) -- Unknown toggle?
end

return M
