-- Pyright（Mason）走 npm；远端常无 Node/npm 导致 :MasonInstall 失败。Basedpyright 走 pip，与 Mason 的 pypi 安装器一致。
vim.lsp.enable("basedpyright")

--- venv-selector 默认只重启「root_dir 与当前 project_root 一致」的 Python LSP；不一致时 Pyright 会被漏掉，
--- 仍用系统 Python，表现为第三方包无法 resolve。此处向所有 Pyright 客户端推送解释器（与 :LspPyrightSetPythonPath 同思路）。
local function push_pyright_interpreter_all_clients(python_path, _, _)
	if type(python_path) ~= "string" or python_path == "" or vim.fn.filereadable(python_path) ~= 1 then
		return 0
	end
	local venv_dir = vim.fn.fnamemodify(python_path, ":h:h")
	local py_block = {
		pythonPath = python_path,
		venv = vim.fn.fnamemodify(venv_dir, ":t"),
		venvPath = vim.fn.fnamemodify(venv_dir, ":h"),
	}
	vim.defer_fn(function()
		for _, client in ipairs(vim.lsp.get_clients()) do
			if client.name == "pyright" or client.name == "basedpyright" then
				if client.settings then
					client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, py_block)
				elseif client.config and type(client.config.settings) == "table" then
					client.config.settings =
						vim.tbl_deep_extend("force", client.config.settings, { python = py_block })
				end
				client:notify("workspace/didChangeConfiguration", { settings = nil })
			end
		end
	end, 250)
	return 0
end

--- 新开 :terminal / Snacks 终端时，在 shell 里 source 当前 venv-selector 选中的环境
---（与插件自带的 PATH 注入互补：提示符、部分依赖「已 activate」脚本的工具更一致）
local function register_terminal_venv_shell_activate()
	local group = vim.api.nvim_create_augroup("UserVenvSelectorTermActivate", { clear = true })
	vim.api.nvim_create_autocmd("TermOpen", {
		group = group,
		callback = function(args)
			local buf = args.buf

			local function build_activate_line()
				local ok, vs = pcall(require, "venv-selector")
				if not ok then
					return nil
				end
				local venv_root = vs.venv()
				local py = vs.python()
				if type(venv_root) ~= "string" or venv_root == "" or type(py) ~= "string" or vim.fn.filereadable(py) ~= 1 then
					return nil
				end

				local shell = vim.o.shell or ""
				local is_win = vim.fn.has("win32") == 1

				if is_win then
					local act = venv_root .. "\\Scripts\\activate.bat"
					if vim.fn.filereadable(act) ~= 1 then
						act = venv_root .. "\\Scripts\\activate"
					end
					if vim.fn.filereadable(act) ~= 1 then
						return nil
					end
					return "call " .. vim.fn.shellescape(act)
				end

				local act = venv_root .. "/bin/activate"
				if shell:find("fish") and vim.fn.filereadable(venv_root .. "/bin/activate.fish") == 1 then
					act = venv_root .. "/bin/activate.fish"
				end
				if vim.fn.filereadable(act) ~= 1 then
					return nil
				end
				return "source " .. vim.fn.shellescape(act)
			end

			local line = build_activate_line()
			if not line then
				return
			end

			local tries = 0
			local function send_when_ready()
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				local ch = vim.bo[buf].channel
				if not ch or ch == 0 then
					tries = tries + 1
					if tries < 24 then
						vim.defer_fn(send_when_ready, 25)
					end
					return
				end
				vim.fn.chansend(ch, line .. "\r")
			end

			vim.defer_fn(send_when_ready, 50)
		end,
	})
end

local function conda_shorter_name(filename)
   return filename:gsub("/opt/anaconda3/envs/", "󱔎  "):gsub("/opt/anaconda3", "  base"):gsub("/bin/python", "")
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "python" },
		},
		opts_extend = { "ensure_installed" },
	},
	{
		"mason-org/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				"ruff",
				"basedpyright",
			},
		},
		opts_extend = { "ensure_installed" },
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				python = { "ruff_format" },
			},
		},
	},
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"folke/snacks.nvim",
			-- { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
		},
		-- 启动即加载，避免 Lazy :VenvSelect 桩删除后 setup 失败导致命令消失（E492）；不依赖先打开 .py
		lazy = false,
		keys = {
			{ "<leader>cv", "<cmd>VenvSelect<CR>", desc = "Select Python venv" },
		},
		config = function(_, opts)
			-- 在 config 里再 require，避免 Lazy 合并 spec 时尚未把 venv-selector 加入 rtp
			opts.hooks = {
				require("venv-selector.hooks").dynamic_python_lsp_hook,
				push_pyright_interpreter_all_clients,
			}
			require("venv-selector").setup(opts)
			register_terminal_venv_shell_activate()
		end,
		opts = { -- this can be an empty lua table - just showing below for clarity.
			options = {
				notify_user_on_venv_activation = true,
				picker = "snacks",
				-- on_telescope_result_callback = shorter_name
			},
			search = {
				anaconda_base = {
					command = "fd /bin/python$ /opt/anaconda3/bin -t l --full-path --color never -E pkgs",
					type = "anaconda",
					on_telescope_result_callback = conda_shorter_name
				},
				conda = {
					command = "fd /bin/python$ /opt/anaconda3/envs -t l --full-path --color never -E pkgs",
					type = "anaconda",
					on_telescope_result_callback = conda_shorter_name
				},
			},
		},
	},
}
