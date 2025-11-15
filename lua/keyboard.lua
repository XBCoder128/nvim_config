local map = vim.keymap.set

opt = { noremap = true, silent = true }
local function get_options(desc)
    if desc then
        return { noremap = true, silent = true, desc = desc }
    end
    return opt
end

-- 检查是否是 nvim tree buffer
local function is_nvim_tree_buf(buf)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

    if buf_name:match("NvimTree") or filetype == "NvimTree" then
        return true
    end

    -- 尝试使用 nvim-tree 的工具函数检查
    local ok, utils = pcall(require, "nvim-tree.utils")
    if ok and utils and utils.is_nvim_tree_buf then
        return utils.is_nvim_tree_buf(buf)
    end

    return false
end

-- 检查 nvim tree 是否打开
local function is_nvim_tree_open()
    local wins = vim.api.nvim_list_wins()

    for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if is_nvim_tree_buf(buf) then
            return true
        end
    end

    return false
end

-- 获取不包含 nvim tree 的窗口个数
local function get_non_tree_win_count()
    local wins = vim.api.nvim_list_wins()
    local non_tree_wins = 0

    for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if not is_nvim_tree_buf(buf) then
            non_tree_wins = non_tree_wins + 1
        end
    end

    return non_tree_wins
end

-- 获取第一个非 nvim tree 的窗口
local function get_first_non_tree_win()
    local wins = vim.api.nvim_list_wins()

    for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if not is_nvim_tree_buf(buf) then
            return win
        end
    end

    return nil
end

-- Lazy.nvim 快捷键
map("n", "<leader>L", "<CMD>Lazy<CR>", {desc = "[Lazy] Open Lazy.nvim" })

-- 取消 s 默认功能
map({"n", "x", "o"}, "s", "", opt)

-- windows 分屏快捷键
map("n", "sv", ":vsp<CR>", opt)
map("n", "sh", ":sp<CR>", opt)

map('n', '<A-z>', '<Cmd>set wrap!<CR>', opt)


-- 关闭当前标签
map("n", "sc", function ()
    -- 如果不包含 nvim tree 的窗口个数大于 1，才关闭
    if get_non_tree_win_count() > 1 then
        vim.cmd("close")
    end
end, opt)

-- 关闭其他标签
map("n", "so", function ()
    -- 如果不包含 nvim tree 的窗口个数大于 1，才关闭其他窗口
    if get_non_tree_win_count() > 1 then
        -- 检查 nvim tree 之前是否打开
        local was_tree_open = is_nvim_tree_open()

        -- 关闭其他窗口
        vim.cmd("only")

        -- 如果之前 nvim tree 是打开的，则再次打开
        if was_tree_open then
            vim.cmd("NvimTreeOpen")
            -- 将焦点移动到代码窗口
            local code_win = get_first_non_tree_win()
            if code_win then
                vim.api.nvim_set_current_win(code_win)
            end
        end
    end
end, opt)

-- Alt + hjkl  窗口之间跳转
map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)

-- 嵌入终端配置
map("n", "<leader>T", ":sp | :resize 10 | terminal<CR> | i", get_options("[Terminal] Open horizontal terminal"))
map("n", "<leader>Tv", ":vsp | terminal<CR> | i", get_options("[Terminal] Open vertical terminal"))

map("t", "<Esc>", "<C-\\><C-N><C-w>c", opt)
map("t", "<A-h>", "<C-\\><C-N><C-w>h", opt)
map("t", "<A-j>", "<C-\\><C-N><C-w>j", opt)
map("t", "<A-k>", "<C-\\><C-N><C-w>k", opt)
map("t", "<A-l>", "<C-\\><C-N><C-w>l", opt)

-- visual模式下缩进代码
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)

-- 上下移动选中文本
map("v", "J", ":move '>+1<CR>gv-gv", opt)
map("v", "K", ":move '<-2<CR>gv-gv", opt)

-- 上下滚动浏览
map("n", "<C-j>", "6j", opt)
map("n", "<C-k>", "6k", opt)

-- ctrl u / ctrl + d  只移动9行，默认移动半屏
map("n", "<C-u>", "15k", opt)
map("n", "<C-d>", "15j", opt)

-- 在visual 模式里粘贴不要复制
map("v", "p", '"_dP', opt)

-- 退出
map("i", "jk", "<ESC>", opt)
map("n", "q", ":q<CR>", opt)
map("n", "qq", ":qa<CR>", opt)
map("n", "Q", ":qa!<CR>", opt)

-- insert 模式下，跳到行首行尾
map("i", "<C-h>", "<ESC>I", opt)
map("i", "<C-l>", "<ESC>A", opt)
map("n", "<C-h>", "^", opt)
map("n", "<C-l>", "$", opt)

-- nvim tree
vim.api.nvim_set_keymap("n", "<A-m>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})

-- bufferline
-- 左右Tab切换
map("n", "<A-,>", ":BufferLineCyclePrev<CR>", opt)
map("n", "<A-.>", ":BufferLineCycleNext<CR>", opt)

-- 固定标签页
map("n", "<A-p>", ":BufferLineTogglePin<CR>", opt)

-- 进入标签选择关闭模式
map("n", "<leader>bc", ":BufferLinePickClose<CR>", get_options("[BufferLine] Close buffer"))

-- 切换自动折行
map("n", "<A-z>", ":set wrap!<CR>", opt)

-- 移动到行首行尾
map({"n", "x", "o"}, "<S-H>", "^", get_options("[Move] Move to beginning of line"))
map({"n", "x", "o"}, "<S-L>", "$", get_options("[Move] Move to end of line"))
