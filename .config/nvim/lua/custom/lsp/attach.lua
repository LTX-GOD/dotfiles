-- 处理 LSP 附加时的逻辑（Keymaps, UI 等）
local M = {}

function M.setup()
    -- 定义 LSP 相关的快捷键
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', {
            clear = true
        }),
        callback = function(event)
            local map = function(keys, func, desc)
                vim.keymap.set('n', keys, func, {
                    buffer = event.buf,
                    desc = 'LSP: ' .. desc
                })
            end

            -- 跳转到定义
            map('gd', function()
                require('snacks').picker.lsp_definitions()
            end, 'Goto Definition')

            -- 分屏跳转到定义
            map('gD', function()
                local win = vim.api.nvim_get_current_win()
                local width = vim.api.nvim_win_get_width(win)
                local height = vim.api.nvim_win_get_height(win)

                -- 模仿 tmux 的分割逻辑: 8 * width - 20 * height
                -- 如果水平空间更多，则垂直分割 (vsplit)
                local value = 8 * width - 20 * height
                if value < 0 then
                    vim.cmd 'split'
                else
                    vim.cmd 'vsplit'
                end
                vim.lsp.buf.definition()
            end, 'Goto Definition (split)')

            -- 跳转到引用
            map('gr', function()
                require('snacks').picker.lsp_references()
            end, 'Goto References')

            -- 代码操作
            map('<leader>la', vim.lsp.buf.code_action, 'Code Action')

            -- 重命名
            vim.keymap.set('n', '<leader>rn', function()
                return ':inc_rename ' .. vim.fn.expand('<cword>')
            end, {
                buffer = event.buf,
                expr = true,
                desc = 'LSP: Rename'
            })

            -- 显示诊断
            map('<leader>ld', function()
                vim.diagnostic.open_float {
                    source = true
                }
            end, 'Show Diagnostic')

            -- 切换诊断显示
            map('<leader>td', (function()
                local diag_status = 1 -- 1 显示; 0 隐藏
                return function()
                    if diag_status == 1 then
                        diag_status = 0
                        vim.diagnostic.config {
                            underline = false,
                            virtual_text = false,
                            signs = false,
                            update_in_insert = false
                        }
                    else
                        diag_status = 1
                        vim.diagnostic.config {
                            underline = true,
                            virtual_text = true,
                            signs = true,
                            update_in_insert = true
                        }
                    end
                end
            end)(), 'Toggle diagnostics display')

            -- 客户端对象
            local client = vim.lsp.get_client_by_id(event.data.client_id)

            -- 折叠支持
            if client and client.supports_method 'textDocument/foldingRange' then
                local win = vim.api.nvim_get_current_win()
                vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
            end

            -- 内嵌提示 (Inlay Hints)
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                map('<leader>th', function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
                        bufnr = event.buf
                    })
                end, 'Toggle Inlay Hints')
            end

            -- 光标下单词高亮
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) and
                vim.bo.filetype ~= 'bigfile' then
                local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', {
                    clear = false
                })
                vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.document_highlight
                })

                vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.clear_references
                })

                vim.api.nvim_create_autocmd('LspDetach', {
                    group = vim.api.nvim_create_augroup('kickstart-lsp-detach', {
                        clear = true
                    }),
                    callback = function(event2)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds {
                            group = 'kickstart-lsp-highlight',
                            buffer = event2.buf
                        }
                    end
                })
            end
        end
    })

    -- 诊断 UI 配置
    local signs = {
        ERROR = '',
        WARN = '',
        INFO = '',
        HINT = ''
    }

    -- 设置诊断行号高亮组
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, {
            text = icon,
            texthl = hl,
            numhl = hl
        })
    end

    -- 这里的 Highlight 设置可以保留
    vim.api.nvim_set_hl(0, "DiagnosticLineNrError", {
        fg = vim.api.nvim_get_hl(0, {
            name = "DiagnosticError"
        }).fg,
        bold = true
    })
    vim.api.nvim_set_hl(0, "DiagnosticLineNrWarning", {
        fg = vim.api.nvim_get_hl(0, {
            name = "DiagnosticWarning"
        }).fg,
        bold = true
    })
    vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo", {
        fg = vim.api.nvim_get_hl(0, {
            name = "DiagnosticInfo"
        }).fg,
        bold = true
    })
    vim.api.nvim_set_hl(0, "DiagnosticLineNrHint", {
        fg = vim.api.nvim_get_hl(0, {
            name = "DiagnosticHint"
        }).fg,
        bold = true
    })

    vim.diagnostic.config {
        virtual_text = {
            spacing = 5,
            prefix = '◍ '
        },
        float = {
            severity_sort = true
        },
        severity_sort = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = signs.ERROR,
                [vim.diagnostic.severity.WARN] = signs.WARN,
                [vim.diagnostic.severity.INFO] = signs.INFO,
                [vim.diagnostic.severity.HINT] = signs.HINT
            },
            numhl = {
                [vim.diagnostic.severity.ERROR] = 'DiagnosticLineNrError',
                [vim.diagnostic.severity.WARN] = 'DiagnosticLineNrWarning',
                [vim.diagnostic.severity.INFO] = 'DiagnosticLineNrInfo',
                [vim.diagnostic.severity.HINT] = 'DiagnosticLineNrHint'
            }
        }
    }

    -- 用户命令
    local api, lsp = vim.api, vim.lsp
    api.nvim_create_user_command('LspHealth', ':checkhealth vim.lsp', {
        desc = 'Alias to `:checkhealth vim.lsp`'
    })
    api.nvim_create_user_command('LspLog', function()
        vim.cmd(string.format('tabnew %s', lsp.get_log_path()))
    end, {
        desc = 'Opens the Nvim LSP client log.'
    })
end

return M
