return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
        opts = {
            auto_install = true,
            ensure_installed = { "c", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "markdown", "markdown_inline", "mermaid" },
            sync_install = false,
            highlight = {
                enable = true,
            },
            indent = { enable = true },
        },
        opts_extend = { "ensure_installed" },
    }
}