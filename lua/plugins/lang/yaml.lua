local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("yamlls", {
	capabilities = capabilities,
	filetypes = { "yaml", "yaml.docker-compose" },
	settings = {
		yaml = {
			schemaStore = { enable = true },
			validate = true,
			format = { enable = true },
		},
	},
})
vim.lsp.enable("yamlls")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "yaml" },
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"mason-org/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				"yaml-language-server",
				"yamlfmt",
			},
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			-- 先 LSP（yamlls 已开 format），再 yamlfmt；避免仅 yamlfmt 不在 PATH 时报 unavailable
			formatters_by_ft = {
				yaml = { lsp_format = "first", "yamlfmt" },
				["yaml.docker-compose"] = { lsp_format = "first", "yamlfmt" },
			},
		},
	},
}
