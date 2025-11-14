-- 编码
vim.g.encoding = "UTF-8"

-- 光标行
-- vim.wo.cursorline = true

-- 不可见字符的显示，这里只把空格显示为一个点
vim.o.list = true
vim.o.listchars = "space:·"

-- 样式
vim.o.termguicolors = true
vim.opt.termguicolors = true

-- 缩进2个空格等于一个Tab
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftround = true

-- >> << 时移动长度
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4

-- 空格替代tab
vim.o.expandtab = true
vim.bo.expandtab = true

-- 新行对齐当前行
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true

-- jkhl 移动时光标周围保留8行
vim.o.scrolloff = 12
vim.o.sidescrolloff = 12

-- 使用相对行号
vim.wo.number = true
vim.wo.relativenumber = true

-- 当文件被外部程序修改时，自动加载
vim.o.autoread = true
vim.bo.autoread = true

-- 禁止折行
vim.wo.wrap = false

-- 鼠标支持
vim.o.mouse = "a"

-- split window 从下边和右边出现
vim.o.splitbelow = true
vim.o.splitright = true

-- 永远显示 tabline
vim.o.showtabline = 2

-- 光标在行首尾时<Left><Right>可以跳到下一行
vim.o.whichwrap = '<,>,[,]'

-- 允许隐藏被修改过的buffer
vim.o.hidden = true

-- 显示左侧图标指示列
vim.wo.signcolumn = "yes"

-- 启用系统剪贴板
vim.o.clipboard = "unnamedplus"

-- 使用增强状态栏插件后不再需要 vim 的模式提示
vim.o.showmode = false

-- 搜索大小写不敏感，除非包含大写
vim.o.ignorecase = true
vim.o.smartcase = true

-- 永远显示 tabline
vim.o.showtabline = 2

-- 补全增强
vim.o.wildmenu = true

-- 禁止创建备份文件
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- 命令行高为2，提供足够的显示空间
vim.o.cmdheight = 0

vim.g.lazyvim_blink_main = true

vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

-- smaller updatetime
vim.o.updatetime = 300
-- 设置 timeoutlen 为等待键盘快捷键连击时间500毫秒，可根据需要设置
vim.o.timeoutlen = 500

-- 搜索不要高亮
vim.o.hlsearch = false