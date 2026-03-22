local function float_remote_client(port)
	local addr = ("localhost:%s"):format(port)
	require("remote-nvim.ui").float_term(("nvim --server %s --remote-ui"):format(addr), function(exit_code)
		if exit_code ~= 0 then
			vim.notify(("本地客户端退出码 %s"):format(exit_code), vim.log.levels.ERROR)
		end
	end)
end

return {
	{
		"amitds1997/remote-nvim.nvim",
		version = "*", -- Pin to GitHub releases
		dependencies = {
			"nvim-lua/plenary.nvim", -- For standard functions
			"MunifTanjim/nui.nvim", -- For building the plugin UI
			"nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
		},
		keys = {
			{ "<A-P>", "<cmd>RemoteStart<CR>", desc = "[Remote] RemoteStart" },
		},
		config = function()
			require("remote-nvim").setup({
				--- 在当前 Kitty 里新开 **标签页** 跑 `nvim --remote-ui`。
				--- - 显式 `--to $KITTY_LISTEN_ON`：避免 `kitty @` 连错实例。
				--- - `detach` + 不用 pty：`pty` 下曾出现 exit 0 但**没有新 tab**；无 TTY 时用
				---   `vim.system` 会 `open /dev/tty` 失败，detach 一般可兼顾二者。
				--- 建议在 kitty.conf 设 `listen_on`（会有 `KITTY_LISTEN_ON`），并 `allow_remote_control yes`。
				--- 否则回退 `float_term`。
				client_callback = function(port, _)
					local addr = ("localhost:%s"):format(port)
					local in_kitty = vim.env.KITTY_PID ~= nil and vim.env.KITTY_PID ~= ""
					if not in_kitty or vim.fn.executable("kitty") ~= 1 then
						float_remote_client(port)
						return
					end
					local listen = vim.env.KITTY_LISTEN_ON
					if type(listen) ~= "string" or listen == "" then
						vim.notify_once(
							"remote-nvim：环境变量 KITTY_LISTEN_ON 为空。请在 kitty.conf 设置 listen_on（例如 "
								.. "`listen_on unix:/tmp/kitty-nvim`）并重启 Kitty，否则 `kitty @` 可能无法在当前窗口开新标签。",
							vim.log.levels.WARN,
							{ title = "remote-nvim.nvim" }
						)
					end
					local cmd = { "kitty", "@" }
					if type(listen) == "string" and listen ~= "" then
						cmd[#cmd + 1] = "--to"
						cmd[#cmd + 1] = listen
					end
					vim.list_extend(cmd, {
						"launch",
						"--copy-env",
						"--type=tab",
						"--",
						"nvim",
						"--server",
						addr,
						"--remote-ui",
					})

					local stderr_acc = {}
					local function on_fail(msg, exit_code)
						vim.schedule(function()
							local err = vim.trim(table.concat(stderr_acc, ""))
							vim.notify(
								("%s: %s%s"):format(
									msg,
									tostring(exit_code),
									err ~= "" and ("\n" .. err) or ""
								),
								vim.log.levels.WARN
							)
							float_remote_client(port)
						end)
					end

					-- 1) detach、无 pty（优先）
					local jid = vim.fn.jobstart(cmd, {
						detach = true,
						stderr = function(_, data)
							if data then
								vim.list_extend(stderr_acc, data)
							end
						end,
						on_exit = function(_, exit_code, _)
							if exit_code ~= 0 then
								stderr_acc = {}
								-- 2) 仍失败则用 pty（解决部分环境下 `open /dev/tty`）
								local jid2 = vim.fn.jobstart(cmd, {
									pty = true,
									stderr = function(_, data)
										if data then
											vim.list_extend(stderr_acc, data)
										end
									end,
									on_exit = function(_, code2, _)
										if code2 ~= 0 then
											on_fail("Kitty 新标签启动失败，已回退浮窗", code2)
										end
									end,
								})
								if jid2 <= 0 then
									on_fail("jobstart(kitty @, pty) 失败，已回退浮窗", -1)
								end
							end
						end,
					})
					if jid <= 0 then
						on_fail("jobstart(kitty @, detach) 失败，已回退浮窗", -1)
					end
				end,
			})
		end,
	},
}
