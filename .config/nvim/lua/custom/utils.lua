local M = {}

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
            vim.cmd('edit ' .. vim.fn.fnameescape(choice.file))
            vim.api.nvim_win_set_cursor(0, { choice.lnum, 0 })
        end
    end)
end

--- Toggle distraction free mode (hides UI elements)
M.toggle_distraction_free = function()
    pcall(function() require('gitsigns').toggle_signs() end)
    pcall(function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 })
    end)
    require('custom.lsp.attach').toggle_diagnostics()
end

return M
