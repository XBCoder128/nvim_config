local capabilities = require("blink.cmp").get_lsp_capabilities()
-- 诊断 /「lint」主要来自 gopls：
-- • nilness：在能建立控制流/SSA 的前提下报「已知 nil 仍解引用」等；对应 staticcheck 里常见为 SA5011 一类
-- • nilfunc / ifaceassert / unused* / printf 等同理
-- • staticcheck = true：跑大量 SA* 规则（含更多潜在 bug）
--
-- 重要：若包本身有「类型检查级」错误（例如 main 重复声明、未定义类型、import 错），gopls 往往无法完整跑
-- nilness/staticcheck，此时 *nil 指针可能完全没有波浪线。先修到本目录能 `go build ./...` 再看诊断。
-- 更重的聚合 lint（golangci-lint 等）需另接 nvim-lint；本文件只配 gopls。
vim.lsp.config("gopls", {
	capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				-- 空指针 / 控制流
				nilness = true,
				nilfunc = true,
				ifaceassert = true,
				-- 常见误用
				unusedparams = true,
				unusedvariable = true,
				unusedwrite = true,
				unusedresult = true,
				errorsas = true,
				printf = true,
				-- shadow 易在短变量 := 上误报，需要再开
				-- shadow = true,
			},
			staticcheck = true,
			directoryFilters = { "-.git", "-node_modules", "-.venv" },
		},
	},
})
vim.lsp.enable("gopls")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "go", "gomod", "gosum", "gowork" },
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"mason-org/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				"gopls",
				"goimports",
			},
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			-- goimports：gofmt 风格 + 整理 import；gopls 亦可格式化，作优先可避免工具缺失
			formatters_by_ft = {
				go = { lsp_format = "first", "goimports" },
				gomod = { lsp_format = "first" },
				gosum = { lsp_format = "first" },
				gowork = { lsp_format = "first" },
			},
		},
	},
}
