-- remote-nvim 等依赖 Telescope；默认只用 C-n/p 移动选项，与编辑器里 `<A-j/k>` 习惯对齐
return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<A-j>"] = actions.move_selection_next,
							["<A-k>"] = actions.move_selection_previous,
						},
						n = {
							["<A-j>"] = actions.move_selection_next,
							["<A-k>"] = actions.move_selection_previous,
						},
					},
				},
			})
		end,
	},
}
