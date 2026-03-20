-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("config.lazy")

require("basic")

require("keyboard")

require("autocmds")

vim.g.treesitter_cli_path = "/opt/homebrew/bin/tree-sitter"

pcall(function()
	require("bufferline.groups").builtin.pinned:with({ icon = "󰐃 " })
end)
