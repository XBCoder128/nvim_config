return {
    { -- 状态栏
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
            sections = { -- 底部状态栏
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
            winbar = { -- 顶部状态栏
                lualine_a = {
                    {
                        'filename',
                        separator = { left = "", right = "" },
                        max_length = 20,
                        shorting_target = 20, -- Shortens path to leave 40 spaces in the window
                    },
                    {
                        function() return [[]] end,
                        draw_empty = true,
                        padding = 2,
                    }
                },
                lualine_x = {
                    {
                        'searchcount',
                        color = { fg = '#333333', bg = '#CBA6F7', gui = 'bold' },
                        separator = { left = "\u{e0b6}", right = "\u{e0b4}" },
                        padding = 2,
                    },
                    "diagnostics",
                },
                lualine_y = {
                    {
                        'lsp_status',
                        icon = '', -- f013
                        symbols = {
                            spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                            done = '✓',
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
                color = { fg = '#282934', bg = '#FF88C7' },
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

            -- 展示宏录制状态
            table.insert(opts.sections.lualine_x, 1, macro_recording_component)
            -- 展示 minuet 提供者状态
            table.insert(opts.winbar.lualine_x, 1, minuet_lualine_component)

            require('lualine').setup(opts)
        end
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
        opts = {
            mappings = {
                -- Apply hunks inside a visual/operator region
                apply = "",
                -- Reset hunks inside a visual/operator region
                reset = "",
                -- Hunk range textobject to be used inside operator
                -- Works also in Visual mode if mapping differs from apply and reset
                textobject = "",
                -- Go to hunk range in corresponding direction
                goto_first = "",
                goto_prev = "",
                goto_next = "",
                goto_last = "",
            },
        }
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
        "lewis6991/gitsigns.nvim",
        opts = {
            signcolumn = true,
            current_line_blame = true,
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, lhs, rhs, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                -- 定位文件中的 git 变更
                map("n", "]h", function() gitsigns.nav_hunk("next") end, { desc = "[Git] Next hunk" })
                map("n", "]H", function() gitsigns.nav_hunk("last") end, { desc = "[Git] Last hunk" })
                map("n", "[h", function() gitsigns.nav_hunk("prev") end, { desc = "[Git] Previews hunk" })
                map("n", "[H", function() gitsigns.nav_hunk("first") end, { desc = "[Git] First hunk" })

                -- Actions
                map("n", "<leader>ggs", gitsigns.stage_hunk, { desc = "[Git] Stage hunk" })
                -- stylua: ignore
                map("v", "<leader>ggs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
                    { desc = "[Git] Stage hunk (Visual)" })

                map("n", "<leader>ggr", gitsigns.reset_hunk, { desc = "[Git] Reset hunk" })
                -- stylua: ignore
                map("v", "<leader>ggr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
                    { desc = "[Git] Reset hunk (Visual)" })

                map("n", "<leader>ggS", gitsigns.stage_buffer, { desc = "[Git] Stage buffer" })
                map("n", "<leader>ggR", gitsigns.reset_buffer, { desc = "[Git] Reset buffer" })

                map("n", "<leader>ggp", gitsigns.preview_hunk, { desc = "[Git] Preview hunk" })
                map("n", "<leader>ggP", gitsigns.preview_hunk_inline, { desc = "[Git] Preview hunk inline" })

                -- Toggles
                require("snacks")
                    .toggle({
                        name = "line blame",
                        get = function()
                            return require("gitsigns.config").config.current_line_blame
                        end,
                        set = function(enabled)
                            require("gitsigns").toggle_current_line_blame(enabled)
                        end,
                    })
                    :map("<leader>tgb")
                require("snacks")
                    .toggle({
                        name = "word diff",
                        get = function()
                            return require("gitsigns.config").config.word_diff
                        end,
                        set = function(enabled)
                            require("gitsigns").toggle_word_diff(enabled)
                        end,
                    })
                    :map("<leader>tgw")
            end
        },
    },
    { -- 滚动条
        "petertriho/nvim-scrollbar",
        config = function()
            local colors = require("tokyonight.colors").setup()

            require('scrollbar').setup({
                handle = { -- 滚动条颜色
                    color = "#7784BE",
                },
                throttle_ms = 16, -- 滚动条更新频率
                marks = {
                    Search = { color = colors.orange }, -- 搜索高亮颜色
                    Error = { color = colors.error }, -- 错误高亮颜色
                    Warn = { color = colors.warning }, -- 警告高亮颜色
                    Info = { color = colors.info }, -- 信息高亮颜色
                    Hint = { color = colors.hint }, -- 提示高亮颜色
                    Misc = { color = colors.purple }, -- 杂项高亮颜色
                    GitAdd = {
                        text = "┃", -- 添加高亮颜色
                        priority = 7, -- 优先级
                        highlight = "GitSignsAdd", -- 添加高亮颜色
                    },
                    GitChange = {
                        text = "┃", -- 修改高亮颜色
                        priority = 6, -- 优先级
                        highlight = "GitSignsChange", -- 修改高亮颜色
                    },
                },
                handlers = {
                    cursor = true,     -- 光标高亮
                    diagnostic = true, -- 诊断高亮
                    gitsigns = true,   -- 需要 gitsigns
                    handle = true,     -- 需要滚动条高亮
                    search = false,     -- 需要 hlslens
                    ale = false,       -- 需要 ALE
                },
            })
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require('colorizer').setup()
        end,
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        opts = {
            provider_selector = function(_, _, _)
                return { "treesitter", "indent" }
            end,
            preview = {
                win_config = {
                    winhighlight = 'Normal:UFOPreviewFolded',
                    winblend = 0
                },
                mappings = {
                    scrollU = '<C-u>',
                    scrollD = '<C-d>',
                    jumpTop = '[',
                    jumpBot = ']'
                }
            },

            open_fold_hl_timeout = 0,
            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (" 󰁂 %d "):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end,
        },

        init = function()
            vim.o.foldenable = true
            vim.o.foldcolumn = "0" -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.opt.fillchars = {
                fold = " ",
                foldopen = "▾",
                foldsep = "│",
                foldclose = "▸",
            }
        end,

        config = function(_, opts)
            require("ufo").setup(opts)

            -- Ensure our ufo foldlevel is set for the buffer
            vim.api.nvim_create_autocmd("BufReadPre", {
                callback = function()
                    vim.b.ufo_foldlevel = 0
                end,
            })

            ---@param num integer Set the fold level to this number
            local set_buf_foldlevel = function(num)
                vim.b.ufo_foldlevel = num
                require("ufo").closeFoldsWith(num)
            end

            ---@param num integer The amount to change the UFO fold level by
            local change_buf_foldlevel_by = function(num)
                local foldlevel = vim.b.ufo_foldlevel or 0
                -- Ensure the foldlevel can't be set negatively
                if foldlevel + num >= 0 then
                    foldlevel = foldlevel + num
                else
                    foldlevel = 0
                end
                set_buf_foldlevel(foldlevel)
            end

            -- Keymaps
            vim.keymap.set("n", "K", function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end)

            -- stylua: ignore
            vim.keymap.set("n", "zM", function() set_buf_foldlevel(0) end, { desc = "[UFO] Close all folds" })
            vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "[UFO] Open all folds" })

            vim.keymap.set("n", "zm", function()
                local count = vim.v.count
                if count == 0 then
                    count = 1
                end
                change_buf_foldlevel_by(-count)
            end, { desc = "[UFO] Fold More" })
            vim.keymap.set("n", "zr", function()
                local count = vim.v.count
                if count == 0 then
                    count = 1
                end
                change_buf_foldlevel_by(count)
            end, { desc = "[UFO] Fold Less" })

            -- 99% sure `zS` isn't mapped by default
            vim.keymap.set("n", "zS", function()
                if vim.v.count == 0 then
                    vim.notify("No foldlevel given to set!", vim.log.levels.WARN)
                else
                    set_buf_foldlevel(vim.v.count)
                end
            end, { desc = "[UFO] Set foldlevel" })

            -- Delete some predefined keymaps as they are not compatible with nvim-ufo
            vim.keymap.set("n", "zE", "<NOP>", { desc = "Disabled" })
            vim.keymap.set("n", "zx", "<NOP>", { desc = "Disabled" })
            vim.keymap.set("n", "zX", "<NOP>", { desc = "Disabled" })
        end,
    },
}
