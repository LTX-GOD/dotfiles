vim.lsp.config('gopls', {
    cmd = {'gopls'},
    root_markers = {'go.mod', '.git'},
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true
            },
            staticcheck = true,
            gofumpt = true
        }
    }
})
