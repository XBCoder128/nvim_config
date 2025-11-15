-- 启动 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- 设置 lazy.nvim
require("lazy").setup({
  spec = {
    -- 插件导入设置
    { import = "plugins" },
    { import = "plugins.lang" }, -- 导入`./lua/plugins/lang/`目录下的所有lua文件
  },

  -- 安装插件时使用的颜色方案。
  install = { colorscheme = { "tokyonight" } },

  -- 自动检查插件更新
  checker = { enabled = true },

  -- 用户界面设置
  ui = {
    border = "rounded",
  }
})
