local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("jsonls", {
	capabilities = capabilities,
	settings = {
		json = {
			validate = { enable = true },
		},
	},
})
vim.lsp.enable("jsonls")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "json" },
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"mason-org/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				"json-lsp",
				"jq",
			},
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			-- jsonc 含注释，jq 会失败；可走全局 conform 的 lsp_format fallback（jsonls）
			formatters_by_ft = {
				json = { "jq" },
			},
		},
	},
}
