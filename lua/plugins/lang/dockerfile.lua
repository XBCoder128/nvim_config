local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("dockerls", {
	capabilities = capabilities,
	settings = {
		docker = {
			languageserver = {
				formatter = { ignoreMultilineInstructions = false },
			},
		},
	},
})
vim.lsp.enable("dockerls")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "dockerfile" },
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"mason-org/mason.nvim",
		optional = true,
		opts = {
			-- Mason 无 dockerfmt 包；格式化由 dockerls 负责，若本机有 dockerfmt（brew/go）可作后备
			ensure_installed = {
				"dockerfile-language-server",
			},
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				dockerfile = { lsp_format = "first", "dockerfmt" },
			},
		},
	},
}
