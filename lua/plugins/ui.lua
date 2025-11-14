return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            options = {
                theme = "tokyonight",

                -- https://github.com/ryanoasis/powerline-extra-symbols
                section_separators = { left = "\u{e0c6}", right = "\u{e0c7}" },
            },
            extensions = { "nvim-tree" },
            sections = {
                lualine_a = {
                    {
                        "mode",
                        separator = { left = "\u{e0b6}", right = "\u{e0c6}" },
                    }
                },
                lualine_b = { "branch", "diff" },
                lualine_c = {
                    {
                        "filename",
                        path = 1, -- 0: Just the filename
                    }
                },
                lualine_x = {},
                lualine_y = {
                    "filesize",
                    {
                        "fileformat",
                        symbols = {
                            unix = '', -- e712
                            dos = '', -- e70f
                            mac = '', -- e711
                        },
                    },
                    "encoding",
                    "filetype",
                },
                lualine_z = {
                    {
                        "location",
                        separator = { left = "\u{e0c7}", right = "\u{e0b4}" },
                    }
                },
            },
            winbar = {
                lualine_a = {
                    {
                        'filename',
                        separator = { left = "", right = "" },
                        max_length = 20,
                        shorting_target = 20, -- Shortens path to leave 40 spaces in the window
                    },
                },
                lualine_b = {
                    {
                        function() return [[]] end,
                        draw_empty = true
                    }
                },
                lualine_c = {
                    {
                        'searchcount',
                        color = { fg = '#333333', bg = '#CBA6F7', gui = 'bold' },
                        separator = { left = "\u{e0b6}", right = "\u{e0b4}" },
                        padding = 2,
                    }
                },
                lualine_x = {
                    "diagnostics",
                },
                lualine_y = {
                    {
                        'lsp_status',
                        icon = '', -- f013
                        symbols = {
                            -- Standard unicode symbols to cycle through for LSP progress:
                            spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                            -- Standard unicode symbol for when LSP is done:
                            done = '✓',
                            -- Delimiter inserted between LSP names:
                            separator = ' ',
                        },
                        -- List of LSP names to ignore (e.g., `null-ls`):
                        ignore_lsp = {},
                        -- Display the LSP name
                        show_name = true,
                    }
                },
            },
        },
        config = function(_, opts)
            local minute_lualine = require('minuet.lualine')

            local function show_macro_recording()
                local recording_register = vim.fn.reg_recording()
                if recording_register ~= '' then
                    return '󰑋 ' .. recording_register
                end
                return ''
            end

            local macro_recording_component = {
                show_macro_recording,
                color = { fg = '#ffffff', bg = '#FF88C7' },
                separator = { left = "\u{e0b6}", right = "\u{e0b4}" },
                padding = 0,
            }

            local minuet_lualine_component = {
                minute_lualine,
                color = { fg = '#7aa2f7', bg = '#394b70' },
                display_name = 'provider',
                separator = { left = "\u{e0b6}", right = "\u{e0b4}" },
                display_on_idle = true,
                icon = { '', align = 'left' },
            }

            table.insert(opts.sections.lualine_x, 1, macro_recording_component)
            table.insert(opts.winbar.lualine_x, 1, minuet_lualine_component)

            require('lualine').setup(opts)
        end
    },
    -- {
    --     'romgrk/barbar.nvim',
    --     dependencies = {
    --         'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
    --         'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    --     },
    --     init = function() vim.g.barbar_auto_setup = false end,
    --     event = { "VeryLazy" },
    --     opts = {
    --         icons = {
    --             pinned = { button = '', filename = true },
    --             separator = {left = '▏', right = '▕'},
    --         },
    --         sidebar_filetypes = {
    --             NvimTree = true,
    --         },
    --     },
    --     version = '^1.0.0', -- optional: only update when a new 1.x version is released
    -- },
    {
        "akinsho/bufferline.nvim",
        dependencies = {
            'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
            "moll/vim-bbye"
        },
        opts = {
            options = {
                lose_command = "Bdelete! %d",
                right_mouse_command = "Bdelete! %d",
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local s = " "
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == "error" and " " or (e == "warning" and " " or "")
                        s = s .. n .. sym
                    end
                    return s
                end,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { 'close' }
                },
                indicator = {
                    style = 'underline',
                },
                separator_style = { '▏', '▕' },
            },
        },
    },
    {
        'nvim-tree/nvim-tree.lua',
        version = "*",
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        opts = {
            view = {
                -- 宽度
                width = 34,
                -- 也可以 'right'
                side = 'left',

                number = false,
                relativenumber = false,
                -- 显示图标
                signcolumn = 'yes',
            },
            actions = {
                open_file = {
                    -- 首次打开大小适配
                    resize_window = false,
                    -- 打开文件时关闭
                    quit_on_open = false,
                },
            },
            system_open = {
                cmd = 'open',
            },
            filters = {
                dotfiles = true,
                custom = { 'node_modules' },
            },
            git = {
                enable = false,
            },
            renderer = {
                group_empty = true,
            },
        },
        config = function(_, opts)
            require('nvim-tree').setup(opts)
        end
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        submodules = false,
        main = 'rainbow-delimiters.setup',
        opts = {},
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        keys = {
        },
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = false,        -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,        -- add a border to hover docs and signature help
            },
            routes = {
                {
                    filter = { event = "msg_show", kind = "search_count" },
                    opts = { skip = true },
                },
                {
                    filter = { event = "msg_show", kind = "" },
                    opts = { skip = true },
                },
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
        }
    },
    {
        "echasnovski/mini.diff",
        event = "VeryLazy",
        version = "*",
        opts = {}
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
            win = {
                title = false,
                width = 0.33
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                theme = 'hyper',
                disable_move = true,
                config = {
                    week_header = {
                        enable = true,
                    },
                    shortcut = {
                        { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
                        {
                            icon = ' ',
                            icon_hl = '@variable',
                            desc = 'Files',
                            group = 'Label',
                            action = 'Telescope find_files',
                            key = 'f',
                        },
                        {
                            desc = ' Apps',
                            group = 'DiagnosticHint',
                            action = 'Telescope app',
                            key = 'a',
                        },
                        {
                            desc = ' dotfiles',
                            group = 'Number',
                            action = 'Telescope dotfiles',
                            key = 'd',
                        },
                    },
                }
            }
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    }
}
