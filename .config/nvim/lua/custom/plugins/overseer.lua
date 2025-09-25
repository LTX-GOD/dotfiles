return {
    'stevearc/overseer.nvim',
    event = 'VeryLazy',
    cmd = {'OverseerToggle', 'OverseerOpen'},
    keys = {{
        '<leader>rt',
        '<cmd>OverseerToggle<cr>',
        desc = 'Overseer toggle task list'
    }},
    config = function()
        require 'custom.config.overseer'
    end
}
