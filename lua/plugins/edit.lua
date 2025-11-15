return {
    { -- 自动补全括号
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            ignored_next_char = "[%w%.]",
        },
    },
    { -- 撤销树
        "mbbill/undotree",
        keys = {
            { "<leader>ut", ":UndotreeToggle<CR>", desc = "Toggle undotree" },
        },
        init = function()
            vim.g.undotree_WindowLayout = 4
            vim.cmd([[
                if has("persistent_undo")
                    let target_path = expand("~/.undodir")

                    if !isdirectory(target_path)
                        call mkdir(target_path, "p", 0700)
                    endif

                    let &undodir = target_path
                    set undofile
                endif
            ]])
        end,
    },
    { -- 注释
        "numToStr/Comment.nvim",
        -- stylua: ignore
        keys = {
            { "<A-/>", function() require("Comment.api").toggle.linewise.current() end,                 mode = "n", desc = "[Comment] Comment current line", },
            { "<A-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", mode = "v", desc = "Comment current line", },
        },
        config = true,
    },
    { -- 环绕文本
        "echasnovski/mini.surround",
        version = "*",
        event = "BufReadPost",
        config = true,
        keys = {
            -- Disable the vanilla `s` keybinding
            { "s", "<NOP>", mode = { "n", "x", "o" } },
        },
    },
    { -- 扩展 `a`/`i` 文本对象
        -- Extend `a`/`i` textobjects
        "echasnovski/mini.ai",
        version = "*",
        event = "BufReadPost",
        config = true,
    },
}
