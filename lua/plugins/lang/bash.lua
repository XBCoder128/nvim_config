local capabilities = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config('bashls', {
    capabilities = capabilities,
    filetypes = { 'bash', 'sh', 'zsh' },
})
vim.lsp.enable('bashls')

return {
    {
        "williamboman/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "bash-language-server",
            },
        },
        opts_extend = { "ensure_installed" },
    },

    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                bash = { "beautysh" },
                sh = { "beautysh" },
                zsh = { "beautysh" },
            },
        },
    },
}
