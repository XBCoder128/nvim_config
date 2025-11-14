return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                auto_install = true,
                ensure_installed = { 
                    "lua", "vim", "vimdoc", "c", "html", 
                    "javascript", "markdown", "markdown_inline", 
                    "latex", "css", "norg", "scss", "svelte", "tsx",
                    "typst", "vue", "yaml", "json", "mermaid"
                 },
                sync_install = false,
                highlight = {
                    enable = true,
                },
                indent = { enable = true },
            })
        end
    }
}