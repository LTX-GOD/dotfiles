local M = {}
function M.indent()
    if vim.o.expandtab then
        return 'SW:' .. vim.o.shiftwidth
    else
        return 'TS:' .. vim.o.tabstop
    end
end

return M
