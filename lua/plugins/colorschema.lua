return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "storm",
            transparent = true,
            terminal_colors = true,
            styles = {
                sidebars = "transparent", -- style for sidebars, see below
                floats = "transparent",   -- style for floating windows
            },
            lualine_bold = true,
            on_colors = function(colors)
                colors.bg_statusline = colors.none
                -- Virtual text 背景透明
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "NONE", fg = colors.error})
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "NONE", fg = colors.warning})
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "NONE", fg = colors.info})
                vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "NONE", fg = colors.hint})
                
                -- git 变更展示高亮配置
                vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "NONE", fg = "#47C769"})
                vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "NONE", fg = "#CBA6F7"})
                vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "NONE", fg = "#F38BA8"})
                vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { bg = "NONE", fg = "#47C769"})
                vim.api.nvim_set_hl(0, "MiniDiffSignChange", { bg = "NONE", fg = "#CBA6F7"})
                vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { bg = "NONE", fg = "#F38BA8"})

                -- UFO 代码折叠浮窗预览 透明背景
                vim.api.nvim_set_hl(0, "UFOPreviewFolded", { bg = "NONE"})
            end,

            on_highlights = function(hl, c)
                -- 调整关键字颜色
                hl.Keyword = { bold = true }
                -- 增强函数名可见性
                hl.Function = { bold = true }
            end
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd("colorscheme tokyonight")
        end
    }
}
