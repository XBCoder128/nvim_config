return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            image = {
                enabled = true,
                doc = {
                    enabled = true,
                    inline = true,
                    max_width = 80,
                    max_height = 40,
                    conceal = function(lang, type)
                        -- only conceal math expressions
                        return false
                    end,
                },
                icons = {
                    math = "󰪚 ",
                    chart = "󰄧 ",
                    image = " ",
                },
                wo = {
                    wrap = true,
                    number = false,
                    relativenumber = false,
                    cursorcolumn = false,
                    signcolumn = "no",
                    foldcolumn = "0",
                    list = true,
                    spell = true,
                    statuscolumn = "",
                },
                convert = {
                    notify = false, -- show a notification on error
                    mermaid = function()
                        local theme = "dark"
                        return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
                    end,
                    magick = {
                        default = { "{src}[0]" },                      -- default for raster images
                        vector = { "-density", 384, "{src}[{page}]" }, -- used by vector images like svg
                        math = { "-density", 384, "{src}[{page}]", "-trim" },
                        pdf = { "-density", 384, "{src}[{page}]", "-background", "white", "-alpha", "remove", "-resize 50%", "-trim" },
                    },
                },
                math = {
                    enabled = true,          -- enable math expression rendering
                    latex = {
                        font_size = "large", -- see https://www.sascha-frank.com/latex-font-size.html
                        tpl = [[
                            \documentclass[preview,border=1pt,varwidth,12pt]{standalone}
                            \usepackage{${packages}}
                            \begin{document}
                            ${header}
                            { \${font_size} \selectfont
                            \color[HTML]{CDD6F4}
                            ${content}
                            }
                            \end{document}]],
                    },
                },
            },
            bigfile = { enabled = true },
            dashboard = {
                enabled = false,
            },
            explorer = { enabled = false },
            indent = { enabled = true },
            input = { enabled = true },
            picker = {
                enabled = true,
                previewers = {
                    diff = {
                        builtin = false,
                        cmd = { "delta" }
                    },
                    git = {
                        builtin = false,
                        args = {}
                    },
                },
                sources = {
                    spelling = {
                        layout = { preset = "select" }
                    },
                },
                win = {
                    input = {
                        keys = {
                            ["<Tab>"] = { "select_and_prev", mode = { "i", "n" } },
                            ["<S-Tab>"] = { "select_and_next", mode = { "i", "n" } },
                            ["<A-Up>"] = { "history_back", mode = { "i", "n" } },
                            ["<A-Down>"] = { "history_forward", mode = { "i", "n" } },
                            ["<A-j>"] = { "list_down", mode = { "i", "n" } },
                            ["<A-k>"] = { "list_up", mode = { "i", "n" } },
                            ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                            ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                            ["<A-u>"] = { "list_scroll_up", mode = { "i", "n" } },
                            ["<A-d>"] = { "list_scroll_down", mode = { "i", "n" } },
                            ["<C-j>"] = { "list_scroll_down", mode = { "i", "n" } },
                            ["<C-k>"] = { "list_scroll_up", mode = { "i", "n" } },
                        }
                    }
                },
                layout = {
                    preset = "telescope"
                }
            },
            notifier = {
                enabled = true,
                style = "notification",
            },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            terminal = { enabled = true },
            lazygit = {
                -- your lazygit configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
            styles = {
                terminal = {
                    relative = "editor",
                    position = "float",
                    border = "rounded",
                    backdrop = 60,
                    height = 0.8,
                    width = 0.6,
                    zindex = 50
                }
            }
        },

        keys = {
            { "<A-c>",           function() require("snacks").bufdelete() end,                    desc = "[Snacks] Close buffer" },

            { "<leader>sgl",     function() require("snacks").git.blame_line() end,               desc = "[Snacks] Git blame line" },
            { "<leader>sgb",     function() require("snacks").gitbrowse() end,                    desc = "[Snacks] Open git brower" },
            { "<leader>sgB",     function() require("snacks").picker.git_branches() end,          desc = "[Snacks] Git Branches" },
            { "<leader>G",       function() require("snacks").lazygit() end,                      desc = "[Snacks] LazyGit" },

            { "<leader>sn",      function() require("snacks").picker.notifications() end,         desc = "[Snacks] Notifications" },
            { "<leader>n",       function() require("snacks").notifier.show_history() end,        desc = "[Snacks] Notification show history" },
            { "<leader>un",      function() require("snacks").notifier.hide() end,                desc = "[Snacks] Notification hide" },

            { "<leader><space>", function() require("snacks").picker.smart() end,                 desc = "[Snacks] Smart find file" },
            { "<leader>sf",      function() require("snacks").picker.files() end,                 desc = "[Snacks] Find file" },
            { "<leader>fp",      function() require("snacks").picker.projects() end,              desc = "[Snacks] Projects" },
            { "<leader>,",       function() require("snacks").picker.buffers() end,               desc = "[Snacks] Buffers" },
            { "<leader>/",       function() require("snacks").picker.grep() end,                  desc = "[Snacks] Grep" },
            { "<leader>sg",      function() require("snacks").picker.grep_buffers() end,          desc = "[Snacks] Grep Open Buffers" },
            { "<leader>:",       function() require("snacks").picker.command_history() end,       desc = "[Snacks] Command History" },
            { "<leader>sd",      function() require("snacks").picker.diagnostics() end,           desc = "[Snacks] Diagnostics" },
            { "<leader>sa",      function() require("snacks").picker.spelling() end,              desc = "[Snacks] Spelling" },
            { "<leader>sj",      function() require("snacks").picker.jumps() end,                 desc = "[Snacks] Jumps" },
            { "<leader>sh",      function() require("snacks").picker.highlights() end,            desc = "[Snacks] Highlights" },
            { "<leader>si",      function() require("snacks").picker.icons() end,                 desc = "[Snacks] Icons" },

            { "gd",              function() require("snacks").picker.lsp_definitions() end,       desc = "[Snacks] Goto Definitions" },
            { "gD",              function() require("snacks").picker.lsp_declarations() end,      desc = "[Snacks]Goto Declaration" },
            { "gr",              function() require("snacks").picker.lsp_references() end,        desc = "[Snacks] References" },
            { "gI",              function() require("snacks").picker.lsp_implementations() end,   desc = "[Snacks] Goto Implementation" },
            { "gy",              function() require("snacks").picker.lsp_type_definitions() end,  desc = "[Snacks] Goto Type Definitions" },
            { "<leader>ss",      function() require("snacks").picker.lsp_symbols() end,           desc = "[Snacks] LSP Symbols" },
            { "<leader>sS",      function() require("snacks").picker.lsp_workspace_symbols() end, desc = "[Snacks] LSP Workspace Symbols" },
            { "gci",             function() require("snacks").picker.lsp_incoming_calls() end,    desc = "[Snacks] Calls Incoming" },
            { "gco",             function() require("snacks").picker.lsp_outgoing_calls() end,    desc = "[Snacks] Calls Outgoing" },

            { "<leader>t",       function() require("snacks").terminal() end,                     desc = "[Snacks] Terminal" }

        },

        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end

                    -- Override print to use snacks for `:=` command
                    if vim.fn.has("nvim-0.11") == 1 then
                        vim._print = function(_, ...)
                            dd(...)
                        end
                    else
                        vim.print = _G.dd
                    end

                    -- Create some toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.line_number():map("<leader>ul")
                    Snacks.toggle.option("conceallevel",
                        { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                    Snacks.toggle.treesitter():map("<leader>uT")
                    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
                        "<leader>ub")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                    Snacks.toggle.indent():map("<leader>ug")
                    Snacks.toggle.dim():map("<leader>uD")
                end,
            })
        end,
    }
}
