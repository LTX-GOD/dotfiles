---@diagnostic disable: missing-fields
require('snacks').setup {
    notifier = {},
    bufdelete = {},
    git = {},
    rename = {},
    picker = {
        matcher = {
            frecency = true,
            cwd_bonus = true,
            history_bonus = true
        },
        formatters = {
            icon_width = 3
        },
        win = {
            input = {
                keys = {
                    ['<Esc>'] = {
                        'close',
                        mode = { 'n', 'i' }
                    }
                }
            }
        }
    },
    dashboard = {
        preset = {
            keys = { {
                icon = ' ',
                key = 'f',
                desc = 'Find File',
                action = ':lua Snacks.dashboard.pick("files")'
            }, {
                icon = ' ',
                key = 'n',
                desc = 'New File',
                action = ':ene | startinsert'
            }, {
                icon = ' ',
                key = 'g',
                desc = 'Find Text',
                action = ':lua Snacks.dashboard.pick("live_grep")'
            }, {
                icon = ' ',
                key = 'r',
                desc = 'Recent Files',
                action = ':lua Snacks.dashboard.pick("oldfiles")'
            }, {
                icon = ' ',
                key = 'c',
                desc = 'Config',
                action = ':lua Snacks.dashboard.pick("files", {cwd = vim.fn.stdpath("config")})'
            }, {
                icon = ' ',
                key = 's',
                desc = 'Restore Session',
                section = 'session'
            }, {
                icon = '󰒲 ',
                key = 'L',
                desc = 'Lazy',
                action = ':Lazy',
                enabled = package.loaded.lazy ~= nil
            }, {
                icon = ' ',
                key = 'q',
                desc = 'Quit',
                action = ':qa'
            } },
            header = [[
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣋⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⡏⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡌⢰⠋⢳⣝⠿⢡⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⡇⣿⢿⣿⣿⣿⣿⣿⣿⡿⠿⠇⠀⠀⠀⠙⢧⢸⡿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣶⢸⣿⣿⣿⣿⣿⣿⣿⠀⠄⠀⠀⠀⠀⠀⠂⣴⣿⣿⣿⣿⣿⣿⣿⠋⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⢀⠔⣠⣾⣿⣿⣿⣿⣿⣿⠟⣡⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣡⣾⣿⣿⣿⣿⣿⣿⠟⢁⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⠀⡀⢀⣼⣿⣿⣿⣿⣿⣿⡿⠋⠀⢷⣝⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⢟⣵⢸⣿⣿⣿⣿⣿⣿⡿⢀⣴⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠙⢷⡙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⡿⣡⠟⠁⢸⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠙⢦⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣷⣄⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣷⣄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⡿⠿⠿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⡿⠛⠋⠀⠂⠀⠀⠀⠀⠀⢀⠀⠀⠀⠰⣿⣿⠿⠛⠂⣽⡇⣼⠟⠛⠛⠻⣿
⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⡟⣰⡟⠛⠋⡀⢠⣾⠛⠛⠃⢠⡾⢛⢻⣷⠸⢡⡾⠟⢿⡿⠰⢡⡿⠛⢻⡷⢸
⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⡟⠀⠻⢷⣶⡄⢀⣿⠃⠈⠀⢀⣿⢡⡟⣸⡏⢠⣿⢡⠇⣾⢃⢃⣿⠷⠶⠾⢃⣾
⣿⣿⣿⣿⢸⣿⣿⣿⡿⢋⠀⣈⣀⣠⣿⠃⢸⣿⣄⣀⡄⢸⣧⣘⣱⡟⡀⢸⣧⣬⣼⡏⣼⢸⣿⣬⣭⡌⣿⣿
⣿⣿⣿⣿⣮⣛⣛⣋⣠⣾⣌⣉⡉⠉⠁⠀⠀⠉⢉⣉⣼⣦⣍⣉⣥⣾⣷⣌⣉⣡⣉⣁⣼⣬⣉⣉⣉⣴⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
            ]]
        },
        sections = {
            { section = "header" },
            { section = "keys",   gap = 1, padding = 1 },
            { section = "startup" },
            {
                pane = 2,
                section = "terminal",
                icon = " ",
                title = "Calendar",
                cmd = "cal",
                height = 10,
                padding = 1,
                indent = 2,
            },
            { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            {
                pane = 2,
                icon = " ",
                title = "Git Status",
                section = "terminal",
                enabled = function()
                    return Snacks.git.get_root() ~= nil
                end,
                cmd = "git status --short --branch --renames",
                height = 5,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
            },
        }
    },
    image = {
        enabled = true,
        doc = {
            enabled = true,
            inline = false,
            float = true,
            max_width = 40,
            max_height = 30
        },
        math = {
            enabled = true,
        },
        resolve = function(_, src)
            local vault_path = vim.fn.expand '~' ..
                '/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian Vault'

            -- when the file path is *attachments/*
            local att_path = src:match '(attachments/.*)'
            if att_path then
                return vault_path .. '/' .. att_path
            end

            -- when the file path is pure basename without any directory component
            if not src:match '[/\\]' then
                return vault_path .. '/attachments/' .. src
            end

            -- when the file path is absolute path
            if src:match '^/' then
                return src
            end

            return src
        end
    },
    indent = {
        indent = {
            enabled = false
        },
        animate = {
            duration = {
                step = 10,
                duration = 100
            }
        },
        scope = {
            enabled = true,
            char = '┊',
            underline = false,
            only_current = true,
            priority = 1000
        }
    },
    statuscolumn = {
        left = { 'mark', 'git' },
        right = { 'fold' },
        folds = {
            open = true,
            git_hl = true
        },
        git = {
            patterns = { 'GitSign', 'MiniDiffSign' }
        }
    }
}
