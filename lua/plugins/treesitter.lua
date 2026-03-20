return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
        opts = {
            auto_install = true,
            ensure_installed = { "c", "vim", "vimdoc", "query", "elixir",
             "heex", "javascript", "html", "markdown", "markdown_inline",
              "mermaid", "latex", "css", "html", "javascript", "norg", 
              "scss", "svelte", "tsx", "typst", "vue" },
            sync_install = true,
            highlight = {
                enable = true,
            },
            indent = { enable = true },
            -- 可视模式下逐步扩大选区（if → for → 函数等）。不用 gnn/grn：会与内置 gn、gr{char} 冲突。
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<A-]>", -- n：从光标开始选中当前命名节点
                    node_incremental = "<A-]>", -- x：扩大到父命名节点（可连按）
                    scope_incremental = "<A-e>", -- x：按 locals 作用域扩大
                    node_decremental = "<A-[>", -- x：退回上一档
                },
            },
        },
        opts_extend = { "ensure_installed" },
        -- lazy 默认会调 require("nvim-treesitter").setup(opts)，但该函数丢弃 opts、也不调
        -- configs.setup，导致 highlight / incremental_selection 等从未真正启用。
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    }
}