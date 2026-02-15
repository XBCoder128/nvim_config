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
        },
        opts_extend = { "ensure_installed" },
    }
}
