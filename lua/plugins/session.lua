return {
	{
		"rmagatti/auto-session",
		lazy = false,

		keys = {
			-- 恢复会话
			{ "<leader>ps", ":SessionRestore<CR>:NvimTreeToggle<CR>", desc = "[Session] Restore session" },
			-- 搜索会话
			{ "<leader>pS", ":AutoSession search<CR>", desc = "[Session] Load session" },
			-- 删除会话（picker；按名删除用 :AutoSession delete <name>）
			{ "<leader>pD", ":AutoSession deletePicker<CR>", desc = "[Session] Delete session (picker)" },
		},

		opts = {
			auto_restore = false, -- 禁用自动恢复会话
			suppressed_dirs = { "~/", "~/Downloads", "/", "~/Projects" }, -- 排除目录
		},

		init = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions" -- 会话选项
		end,
	},
}

