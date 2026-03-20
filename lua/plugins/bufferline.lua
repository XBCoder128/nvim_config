return {
    {
        "akinsho/bufferline.nvim",
        dependencies = {
            'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
            "moll/vim-bbye"
        },
        opts = {
            highlights = {
                fill = {
                    fg = '#1E1E2F',
                    bg = '#1E1E2F',
                },
                background = {
                    fg = '#AEB4C8',
                    bg = '#282934',
                },
                buffer = {
                    fg = '#AEB4C8',
                    bg = '#282934',
                },
                tab = {
                    bg = '#282934',
                },
                tab_close = {
                    bg = '#1E1E2F',
                },
                close_button = {
                    bg = '#282934',
                },
                close_button_visible = {
                    bg = '#282934',
                },
                close_button_selected = {
                    bg = '#393B48',
                },
                buffer_visible = {
                    fg = '#D0D4E0',
                    bg = '#282934',
                },
                buffer_selected = {
                    fg = '#EEF0F7',
                    bg = '#393B48',
                },
                numbers = {
                    fg = '#AEB4C8',
                    bg = '#282934',
                },
                numbers_visible = {
                    fg = '#D0D4E0',
                    bg = '#282934',
                },
                numbers_selected = {
                    fg = '#EEF0F7',
                    bg = '#393B48',
                },
                diagnostic = {
                    bg = '#1E1E2F',
                },
                diagnostic_visible = {
                    bg = '#1E1E2F',
                },
                diagnostic_selected = {
                    bg = '#393B48',
                },
                hint = {
                    bg = '#282934',
                },
                hint_visible = {
                    bg = '#282934',
                },
                hint_selected = {
                    bg = '#393B48',
                },
                hint_diagnostic = {
                    bg = '#282934',
                },
                hint_diagnostic_visible = {
                    bg = '#282934',
                },
                hint_diagnostic_selected = {
                    bg = '#393B48',
                },
                info = {
                    bg = '#282934',
                },
                info_visible = {
                    bg = '#282934',
                },
                info_selected = {
                    bg = '#393B48',
                },
                info_diagnostic = {
                    bg = '#282934',
                },
                info_diagnostic_visible = {
                    bg = '#282934',
                },
                info_diagnostic_selected = {
                    bg = '#393B48',
                },
                warning = {
                    bg = '#282934',
                },
                warning_visible = {
                    bg = '#282934',
                },
                warning_selected = {
                    bg = '#393B48',
                },
                warning_diagnostic = {
                    bg = '#282934',
                },
                warning_diagnostic_visible = {
                    bg = '#282934',
                },
                warning_diagnostic_selected = {
                    bg = '#393B48',
                },
                error = {
                    bg = '#282934',
                },
                error_visible = {
                    bg = '#282934',
                },
                error_selected = {
                    bg = '#393B48',
                },
                error_diagnostic = {
                    bg = '#282934',
                },
                error_diagnostic_visible = {
                    bg = '#282934',
                },
                error_diagnostic_selected = {
                    bg = '#393B48',
                },
                modified = {
                    bg = '#282934',
                },
                modified_visible = {
                    bg = '#282934',
                },
                modified_selected = {
                    bg = '#393B48',
                },
                duplicate_selected = {
                    bg = '#393B48',
                },
                duplicate_visible = {
                    bg = '#282934',
                },
                duplicate = {
                    bg = '#282934',
                },
                separator_selected = {
                    fg = '#1E1E2F',
                    bg = '#393B48',
                },
                separator_visible = {
                    fg = '#1E1E2F',
                    bg = '#282934',
                },
                separator = {
                    fg = '#1E1E2F',
                    bg = '#282934',
                },
                indicator_visible = {
                    fg = '#1E1E2F',
                    bg = '#282934',
                },
                indicator_selected = {
                    fg = '#1E1E2F',
                    bg = '#393B48',
                },
                -- BufferLinePick / PickClose：快捷键字母与标签需在深色底上可读（勿用近黑 #1E1E2F）
                pick_selected = {
                    fg = '#F5E0DC',
                    bg = '#393B48',
                    bold = true,
                },
                pick_visible = {
                    fg = '#F5C2E7',
                    bg = '#282934',
                    bold = true,
                },
                pick = {
                    fg = '#F5C2E7',
                    bg = '#282934',
                    bold = true,
                },
                offset_separator = {
                    fg = '#1E1E2F',
                    bg = '#282934',
                },
                trunc_marker = {
                    fg = '#1E1E2F',
                    bg = '#282934',
                }
            },
            options = {
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { 'close' }
                },
                lose_command = "Bdelete! %d",
                right_mouse_command = "Bdelete! %d",
                diagnostics = "nvim_lsp",

                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local s = ""
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == "error" and " " or (e == "warning" and " " or "")
                        s = s .. n .. sym
                    end
                    return s
                end,

                custom_filter = function(buf_number, _buf_numbers)
                    local bt = vim.bo[buf_number].buftype
                    local ft = vim.bo[buf_number].filetype
                    if bt == "terminal" or ft == "snacks_terminal" then
                        return false
                    end
                    return true
                end,

                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "center",
                    },
                },
                indicator = {
                    style = 'underline',
                },

                separator_style = "slant", -- 分隔符样式
                "#7ca1f2"
            },
        },
    },
}