vim.api.nvim_create_autocmd("BufEnter", {
	nested = true,
	callback = function()
		if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
			vim.cmd("quit")
		end
	end,
})

-- auto open nvim-tree when open neovim
local function open_nvim_tree(data)
	-- buffer is a real file on the disk
	local real_file = vim.fn.filereadable(data.file) == 1

	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	-- only files please
	if not real_file and not no_name then
		return
	end

	-- open the tree but dont focus it
	require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
	vim.api.nvim_exec_autocmds("BufWinEnter", { buffer = require("nvim-tree.view").get_bufnr() })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

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
