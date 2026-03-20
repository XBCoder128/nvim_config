

-- auto open nvim-tree when open neovim
local function open_nvim_tree(data)
	-- buffer is a real file on the disk
	local real_file = vim.fn.filereadable(data.file) == 1

	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
	
	vim.api.nvim_create_autocmd("BufEnter", {
		nested = true,
		callback = function()
			if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
				vim.cmd("quit")
			end
		end,
	})


	if not real_file and not no_name then
		return
	end
	
	if not real_file or no_name then
		local right_win = vim.api.nvim_get_current_win()
		local right_buf = vim.api.nvim_win_get_buf(right_win)
		require("snacks").dashboard.open({
			buf = right_buf,
			win = right_win,
		})
	end

	vim.api.nvim_exec_autocmds("BufWinEnter", { buffer = require("nvim-tree.view").get_bufnr() })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- 文件末尾下方留出「空白」：`scrolloff` 不能在 EOF 下面造出不存在的行，最后一行常会贴底；
-- 光标在最后一行时 `zz` 把当前行移到窗口垂直中央，下面会空出半屏左右的视觉留白。
-- 用「缓冲末行行号」做 stamp，末行上左右移动不会反复 zz；离开末行或 BufWinEnter 会重算。
do
	local group = vim.api.nvim_create_augroup("UserEofViewPadding", { clear = true })

	local function eof_zz_if_needed()
		if vim.bo.buftype ~= "" or vim.bo.filetype == "help" then
			return
		end
		-- 仅 Normal / Visual 下做 zz：插入模式里补全、虚拟文本等会触发 CursorMoved（见 :h CursorMoved），
		-- 若在文件末行仍执行 zz，会与 completion 浮窗叠加重绘，表现为「只有最后一行时光标跳」。
		local m = vim.fn.mode()
		if m ~= "n" and m ~= "v" and m ~= "V" and not (m:byte(1) == 22) then
			return
		end
		local last = vim.fn.line("$")
		if last < 1 then
			return
		end
		if vim.fn.line(".") ~= last then
			vim.w.user_eof_zz_stamp = nil
			return
		end
		if vim.w.user_eof_zz_stamp == last then
			return
		end
		vim.w.user_eof_zz_stamp = last
		vim.cmd("normal! zz")
	end

	vim.api.nvim_create_autocmd("CursorMoved", {
		group = group,
		callback = eof_zz_if_needed,
	})

	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = group,
		callback = function()
			vim.w.user_eof_zz_stamp = nil
			vim.schedule(eof_zz_if_needed)
		end,
	})
end

-- 内置 :terminal 不进入 bufferline
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("UserTermOpen", { clear = true }),
	callback = function()
		vim.cmd.setlocal("nobuflisted nonumber norelativenumber signcolumn=no")
	end,
})

-- Snacks 底部分屏终端同样不进入 bufferline
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("UserSnacksTerm", { clear = true }),
	pattern = "snacks_terminal",
	callback = function()
		vim.bo[vim.api.nvim_get_current_buf()].buflisted = false
	end,
})

-- 关掉最后一个编辑窗口后只剩终端时，自动在上分出一格新 buffer，避免终端铺满（不删终端）
vim.api.nvim_create_autocmd("WinClosed", {
	group = vim.api.nvim_create_augroup("UserTermLayout", { clear = true }),
	callback = function()
		vim.schedule(function()
			if vim.v.exiting ~= vim.NIL then
				return
			end
			for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
				local wins = vim.api.nvim_tabpage_list_wins(tab)
				if #wins == 1 then
					local win = wins[1]
					local buf = vim.api.nvim_win_get_buf(win)
					local bt = vim.bo[buf].buftype
					local ft = vim.bo[buf].filetype
					if bt == "terminal" or ft == "snacks_terminal" then
						vim.api.nvim_win_call(win, function()
							vim.cmd("aboveleft split | enew")
						end)
						local new_wins = vim.api.nvim_tabpage_list_wins(tab)
						for _, w in ipairs(new_wins) do
							if w ~= win then
								vim.api.nvim_set_current_win(w)
								break
							end
						end
					end
				end
			end
		end)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = '[LSP] Hover' })
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
			buffer = args.buf,
			desc = "[LSP] Open Diagnostic Float",
		})
		vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, {
			desc = "[LSP] Signature help",
		})
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, {
			desc = "[LSP] Add workspace floder",
		})
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, {
			desc = "[LSP] Remove workspace floder",
		})
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, {
			desc = "[LSP] List workspace floder",
		})
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
			buffer = args.buf,
			desc = "[LSP] Rename",
		})
	end,
})
