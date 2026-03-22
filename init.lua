-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Mason 安装的 jq、yamlfmt、stylua 等在 stdpath("data")/mason/bin，需加入 PATH，conform 等才能找到
local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
vim.env.PATH = mason_bin .. (vim.fn.has("win32") == 1 and ";" or ":") .. vim.env.PATH

require("config.lazy")

require("basic")

require("keyboard")

require("autocmds")

vim.g.treesitter_cli_path = "/opt/homebrew/bin/tree-sitter"

pcall(function()
	require("bufferline.groups").builtin.pinned:with({ icon = "󰐃 " })
end)
