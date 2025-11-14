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
            end,
            -- on_highlights = function(hl, c)
            --     -- 增强注释可读性
            --     hl.Comment = { fg = c.comment, italic = true, bold = true }
            --     -- 调整关键字颜色
            --     hl.Keyword = { italic = true }
            --     -- 增强函数名可见性
            --     hl.Function = { fg = c.blue, bold = true }
            -- end
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd("colorscheme tokyonight")
        end
    }
}
