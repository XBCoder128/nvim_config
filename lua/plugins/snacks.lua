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
                enabled = true,
                preset = {
                    header = [[
██╗██╗  ██╗██╗   ██╗███╗   ██╗
██║██║ ██╔╝██║   ██║████╗  ██║
██║█████╔╝ ██║   ██║██╔██╗ ██║
██║██╔═██╗ ██║   ██║██║╚██╗██║
██║██║  ██╗╚██████╔╝██║ ╚████║
╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝]],
                },
                sections = {
                    { section = "header" },
                    {
                        { section = "keys",   gap = 1, padding = 1 },
                        { section = "startup" },
                        
                    },
                    {
                        indent = 4,
                        section = "terminal",
                        ttl = -1, -- 避免最后试图写到缓存文件里，大于0的话退出会很慢
                        pane = 2,
                        -- cmd = "chafa ~/.config/nvim/image/nvim.png --format symbols --symbols vhalf --size 56x25 --stretch && sleep 1&&clear",
                        cmd = "zsh ~/.config/nvim/script/loop_gif.sh ~/.config/nvim/image/ikun 0.08",
                        -- cmd = "chafa ~/.config/nvim/image/result.gif --format symbols --symbols vhalf --size 20x10 --stretch -d 0 && \033[0;0H",
                        -- cmd = "chafa ~/.config/nvim/image/result.gif --format symbols --symbols vhalf --size 20x10 --stretch -d 0 && \033[0;0H",
                        height = 30,
                    },
                },
                
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
                            -- 选择当前文件并向下移动光标
                            ["<Tab>"] = { "select_and_prev", mode = { "i", "n" } },
                            -- 选择当前文件并向上移动光标
                            ["<S-Tab>"] = { "select_and_next", mode = { "i", "n" } },
                            -- 历史记录向前
                            ["<A-Up>"] = { "history_back", mode = { "i", "n" } },
                            -- 历史记录向后
                            ["<A-Down>"] = { "history_forward", mode = { "i", "n" } },

                            -- 列表移动光标
                            ["<A-j>"] = { "list_down", mode = { "i", "n" } },
                            ["<A-k>"] = { "list_up", mode = { "i", "n" } },

                            -- 预览窗口滚动
                            ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                            ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },

                            -- 列表大幅度滚动
                            ["<A-u>"] = { "list_scroll_up", mode = { "i", "n" } },
                            ["<A-d>"] = { "list_scroll_down", mode = { "i", "n" } },

                            -- 列表大幅度滚动
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
            -- 关闭 tab 标签
            { "<A-c>",           function() require("snacks").bufdelete() end,                    desc = "[Snacks] Close buffer" },

            -- git 相关窗口操作
            -- - 查看行级提交信息
            { "<leader>sgl",     function() require("snacks").git.blame_line() end,               desc = "[Snacks] Git blame line" },
            -- - 在浏览器打开对应文件
            { "<leader>sgb",     function() require("snacks").gitbrowse() end,                    desc = "[Snacks] Open git brower" },
            -- - 查看git分之
            { "<leader>sgB",     function() require("snacks").picker.git_branches() end,          desc = "[Snacks] Git Branches" },
            -- - 打开 lazygit
            { "<leader>G",       function() require("snacks").lazygit() end,                      desc = "[Snacks] LazyGit" },

            -- 通知相关操作
            { "<leader>sn",      function() require("snacks").picker.notifications() end,         desc = "[Snacks] Notifications" },
            { "<leader>n",       function() require("snacks").notifier.show_history() end,        desc = "[Snacks] Notification show history" },
            { "<leader>un",      function() require("snacks").notifier.hide() end,                desc = "[Snacks] Notification hide" },

            -- 文件/搜索相关操作
            -- 全局智能搜索
            { "<leader><space>", function() require("snacks").picker.smart() end,                 desc = "[Snacks] Smart find file" },
            -- 文件名搜索
            { "<leader>sf",      function() require("snacks").picker.files() end,                 desc = "[Snacks] Find file" },
            -- 项目内搜索
            { "<leader>fp",      function() require("snacks").picker.projects() end,              desc = "[Snacks] Projects" },
            -- 已开启的 tab 内搜索
            { "<leader>,",       function() require("snacks").picker.buffers() end,               desc = "[Snacks] Buffers" },
            -- 项目内代码搜索
            { "<leader>/",       function() require("snacks").picker.grep() end,                  desc = "[Snacks] Grep" },
            -- 已打开的 tab 内代码搜索
            { "<leader>sg",      function() require("snacks").picker.grep_buffers() end,          desc = "[Snacks] Grep Open Buffers" },
            -- 查看历史命令
            { "<leader>;",       function() require("snacks").picker.command_history() end,       desc = "[Snacks] Command History" },
            -- 打开诊断信息窗口
            { "<leader>sd",      function() require("snacks").picker.diagnostics() end,           desc = "[Snacks] Diagnostics" },
            -- 打开拼写提示窗口
            { "<leader>sa",      function() require("snacks").picker.spelling() end,              desc = "[Snacks] Spelling" },
            -- 打开历史跳转窗口
            { "<leader>sj",      function() require("snacks").picker.jumps() end,                 desc = "[Snacks] Jumps" },
            -- 打开高亮配置窗口
            { "<leader>sh",      function() require("snacks").picker.highlights() end,            desc = "[Snacks] Highlights" },
            -- 打开图标窗口
            { "<leader>si",      function() require("snacks").picker.icons() end,                 desc = "[Snacks] Icons" },

            -- LSP 相关操作
            { "gd",              function() require("snacks").picker.lsp_definitions() end,       desc = "[Snacks] Goto Definitions" },
            { "gD",              function() require("snacks").picker.lsp_declarations() end,      desc = "[Snacks]Goto Declaration" },
            { "gr",              function() require("snacks").picker.lsp_references() end,        desc = "[Snacks] References" },
            { "gI",              function() require("snacks").picker.lsp_implementations() end,   desc = "[Snacks] Goto Implementation" },
            { "gy",              function() require("snacks").picker.lsp_type_definitions() end,  desc = "[Snacks] Goto Type Definitions" },
            { "<leader>ss",      function() require("snacks").picker.lsp_symbols() end,           desc = "[Snacks] LSP Symbols" },
            { "<leader>sS",      function() require("snacks").picker.lsp_workspace_symbols() end, desc = "[Snacks] LSP Workspace Symbols" },
            { "gci",             function() require("snacks").picker.lsp_incoming_calls() end,    desc = "[Snacks] Calls Incoming" },
            { "gco",             function() require("snacks").picker.lsp_outgoing_calls() end,    desc = "[Snacks] Calls Outgoing" },

            -- 终端相关操作
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
                    -- 切换拼写提示
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    -- 切换自动换行
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    -- 切换相对行号
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                    -- 显示/关闭语法提示
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    -- 显示/关闭行号
                    Snacks.toggle.line_number():map("<leader>ul")
                    -- 显示/关闭代码折叠
                    Snacks.toggle.option("conceallevel",
                        { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                    -- 显示/关闭树状语法
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
