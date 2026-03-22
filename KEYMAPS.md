# Neovim 快捷键说明（按功能分类）

本文档按**功能**归纳当前配置中的快捷键，便于按需查找。配置来源：`lua/keyboard.lua`、`lua/autocmds.lua`、`lua/plugins/` 等。

**约定**

- **Leader**：空格（先按空格再按后续键）。下文写作 `<Space>`。
- **LocalLeader**：`\`
- `**<A-x>`**：Alt + x；`**<S-x>`**：Shift + x；`**<C-x>**`：Ctrl + x

---

## 目录

1. [窗口与分屏](#1-窗口与分屏)
2. [终端](#2-终端)
3. [Buffer、标签栏与文件树](#3-buffer标签栏与文件树)
4. [光标移动与滚动](#4-光标移动与滚动)
5. [文本编辑](#5-文本编辑)（含 [Treesitter 增量选区](#51-treesitter-增量选区)）
6. [搜索与高亮](#6-搜索与高亮)
7. [文件与内容查找（Snacks）](#7-文件与内容查找snacks)
8. [LSP、诊断与符号跳转](#8-lsp诊断与符号跳转)
9. [折叠（nvim-ufo）](#9-折叠nvim-ufo)
10. [Git](#10-git)
11. [插入模式补全（Blink.cmp）](#11-插入模式补全blinkcmp)
12. [AI（CodeCompanion）](#12-aicodecompanion)
13. [界面与编辑选项开关](#13-界面与编辑选项开关)
14. [其它（会话、撤销树、Python venv、插件管理）](#14-其它会话撤销树-python-venv插件管理)
15. [Picker 浮层内（Snacks）](#15-picker-浮层内snacks)
16. [mini 系列](#16-mini-系列)
17. [维护说明](#17-维护说明)

---

## 1. 窗口与分屏


| 模式      | 按键                              | 作用                               |
| ------- | ------------------------------- | -------------------------------- |
| n       | `sv` / `sh`                     | 竖分屏 / 横分屏                        |
| n       | `sc`                            | 关当前窗口（多窗口且排除 NvimTree 计数时）       |
| n       | `so`                            | 仅保留当前窗口；若曾开 NvimTree 会尝试恢复       |
| n       | `<A-h>` `<A-j>` `<A-k>` `<A-l>` | 在窗口间移动焦点（等同 `<C-w> h/j/k/l`）     |
| n, x, o | `s`                             | 取消 Vim 默认的 `s`（配合 mini.surround） |


**说明**：`sc` / `so` 会排除 NvimTree 窗口计数，避免误关到只剩文件树。

---

## 2. 终端


| 模式  | 按键                        | 作用                                                                  |
| --- | ------------------------- | ------------------------------------------------------------------- |
| n   | `<C-`>`                   | **底部** Snacks 终端（约 **12～22** 行，随屏高约 **28%**）；类似 VS Code 底部终端区，与 **bufferline 顶栏** 无关 |
| n   | `2<C-`>` … `9<C-`>`       | 底部 **第 2～9 个** shell（多会话）；同一时间只显示其中一个，其它的隐藏保留                       |
| n   | `<Space>tl`               | **选择**底部终端 slot（`vim.ui.select`，可看 `#` 与部分 title）                   |
| n   | `<Space>tv`               | Snacks **右侧分屏**终端（独立 slot **10**，与底部 1～9 不共用）                       |
| n   | `<Space>t`                | Snacks **浮动**终端（见 `snacks.lua` 里 `styles.terminal`）                 |
| t   | `<Esc>`                   | 仅退出终端插入 → **终端 Normal**（不再顺带关窗，避免 remote-nvim 全屏浮窗被误关）                |
| t   | `<A-c>`                   | 终端 Normal 后关闭该终端窗口（原 Esc 上绑的 `<C-w>c`）                               |
| t   | `<C-w>` 再 `h`/`j`/`k`/`l` | 终端内跳窗口（**勿**用 `<A-hjkl>`：易被终端发成 Esc+字母，导致滚历史/花屏）                    |


**说明**

- 底部多终端靠 Snacks 的 **winbar**（如 `1: title`）区分当前是第几路；切换 slot 时用 **隐藏窗口** 保留进程，不是关 shell。  
- **右侧**（`<Space>tv`，slot **10**）与底部 **1～9** 互不抢占。  
- 终端 buffer **不出现在** BufferLine（`bufferline` 过滤 + `nobuflisted`）。  
- 关掉最后一个编辑窗口后若只剩终端，会在上方自动 `enew` 一格（`autocmds.lua`）。  
- 需要把 `Ctrl+w` 交给 shell 时：连按两次 `Ctrl+w`。

---

## 3. Buffer、标签栏与文件树

NvimTree **树内全部默认键位**与说明见 **[NVIM-TREE.md](NVIM-TREE.md)**。


| 模式  | 按键                | 作用                            |
| --- | ----------------- | ----------------------------- |
| n   | `<A-m>`           | 开关 NvimTree                   |
| n   | `<A-,>` / `<A-.>` | 上一个 / 下一个 Buffer（BufferLine）  |
| n   | `<A-P>`           | **remote-nvim**：`:RemoteStart`                         |
| n   | `<A-p>`       | 固定当前 Buffer（图钉，原 `<A-p>`）                         |
| n   | `<Space>bc`       | BufferLine 按字母选择并关闭           |
| n   | `<A-c>`           | 关闭当前 buffer（Snacks.bufdelete） |


---

## 4. 光标移动与滚动


| 模式      | 按键                | 作用                       |
| ------- | ----------------- | ------------------------ |
| n       | `<C-j>` / `<C-k>` | 下 / 上移 6 行               |
| n       | `<C-u>` / `<C-d>` | 下 / 上移 15 行（半屏改短步长）      |
| n       | `<C-h>` / `<C-l>` | 行首（`^`）/ 行尾（`$`）         |
| n, x, o | `<S-H>` / `<S-L>` | 同上（含可视、operator-pending） |
| i       | `<C-h>` / `<C-l>` | 插入模式跳到行首 / 行尾            |


**说明**：全局 `scrolloff=12` 在 `basic.lua`。文件**最后一行**下方「留白」由 `autocmds.lua` 里 `UserEofViewPadding`（末行 `zz`）配合实现。

---

## 5. 文本编辑


| 模式  | 按键               | 作用                        |
| --- | ---------------- | ------------------------- |
| n   | `<A-z>`          | 切换 `wrap`                 |
| i   | `jk`             | 退出插入模式                    |
| n   | `q` / `qq` / `Q` | `:q` / `:qa` / `:qa!`     |
| v   | `<` / `>`        | 缩进后保持选中                   |
| v   | `J` / `K`        | 选中行下移 / 上移                |
| v   | `p`              | 粘贴不覆盖无名寄存器（`"_dP`）        |
| n   | `<A-/>`          | 切换行注释（Comment.nvim，n / v） |


### 5.1 Treesitter 增量选区

在**已启用 Treesitter** 的缓冲区里，按语法树逐级扩大/缩小选区（例如函数里 `for` 内的 `if`：`<A-]>` 多次往往依次包住更大块，直到整段函数；中间可能多一两次小节点，取决于语法树形状）。键位用 Alt+`[` / `]`，避免与内置 `gn`、`gr{char}` 冲突。


| 模式  | 按键      | 作用                                        |
| --- | ------- | ----------------------------------------- |
| n   | `<A-]>` | 从光标处开始，选中当前最小的**命名**语法节点                  |
| v   | `<A-]>` | 将选区扩大到**上一层命名父节点**（可连按）                   |
| v   | `<A-e>` | 按 **locals 作用域**扩大（步进与 `<A-]>` 不同，可按习惯选用） |
| v   | `<A-[>` | 退回上一档选区                                   |


已用手动 `v` 选好一块时，第一次在可视模式下按 `<A-]>` 会把选区对齐到**刚好包住当前范围**的节点，之后再按 `<A-]>` 再往外扩。

---

## 6. 搜索与高亮


| 模式  | 按键   | 作用             |
| --- | ---- | -------------- |
| n   | `//` | 清除搜索高亮（`:noh`） |


---

## 7. 文件与内容查找（Snacks）


| 按键               | 作用                     |
| ---------------- | ---------------------- |
| `<Space><Space>` | 智能找文件                  |
| `<Space>sf`      | 按文件名搜索                 |
| `<Space>fp`      | 项目列表                   |
| `<Space>,`       | 已打开 buffer 列表          |
| `<Space>/`       | 工作区内 grep              |
| `<Space>so`      | **仅已打开** buffer 内 grep |
| `<Space>;`       | 命令历史                   |
| `<Space>sd`      | 诊断列表                   |
| `<Space>sa`      | 拼写建议                   |
| `<Space>sj`      | 跳转列表（Ctrl-o / Ctrl-i）  |
| `<Space>sh`      | 高亮组预览                  |
| `<Space>si`      | 图标表                    |
| `<Space>sn`      | 通知 picker              |
| `<Space>n`       | 通知历史                   |
| `<Space>un`      | 隐藏通知                   |


**说明**：`<Space><Space>` = Leader + 第二次空格。

---

## 8. LSP、诊断与符号跳转

### 8.1 缓冲区级 LSP（`autocmds`）


| 模式  | 按键                        | 作用           |
| --- | ------------------------- | ------------ |
| n   | `<Space>d`                | 光标处诊断浮窗      |
| n   | `<Space>gk`               | 签名帮助         |
| n   | `<Space>wa` / `<Space>wr` | 添加 / 移除工作区目录 |
| n   | `<Space>wl`               | 打印工作区目录列表    |
| n   | `<Space>rn`               | 重命名符号        |


### 8.2 Snacks + 内置跳转


| 模式  | 按键                        | 作用                         |
| --- | ------------------------- | -------------------------- |
| n   | `gd` / `gD`               | 定义 / 声明（picker）            |
| n   | `gr`                      | 引用                         |
| n   | `gI`                      | 实现                         |
| n   | `gy`                      | 类型定义                       |
| n   | `<Space>ss` / `<Space>sS` | 当前文件符号 / 工作区符号             |
| n   | `gci` / `gco`             | 入站 / 出站调用                  |
| n   | `K`                       | 有折叠则 UFO peek，否则 LSP hover |


**LSP hover 浮窗（noice）**：`<C-f>` 向下、`<C-b>` 向上滚动文档；没有可滚动的 LSP 浮窗时，行为与 Vim 默认一致（普通/插入模式下仍是翻页）。

---

## 9. 折叠（nvim-ufo）


| 模式  | 按键                 | 作用                                          |
| --- | ------------------ | ------------------------------------------- |
| n   | `zM` / `zR`        | 全部折叠 / 全部展开                                 |
| n   | `zm` / `zr`        | 按**整个缓冲区的折叠深度**多折一层 / 少折一层（可配合数字，与 `zc` 不同） |
| n   | `zS`               | 设置 foldlevel（需 count，如 `5zS`）               |
| n   | `zc` / `zo` / `za` | 光标处折叠 / 展开 / 切换（只影响当前折叠，适合「只折这一个函数」）        |
| n   | `zE` `zx` `zX`     | 禁用（与 UFO 冲突）                                |


`zm` / `zr` 用的是 UFO 的 `closeFoldsWith`（整页按层级折叠），不是只折光标下的一个区域。UFO 预览窗内：`<C-u>` / `<C-d>` 滚动，`[` / `]` 跳顶/底。

---

## 10. Git

### Snacks


| 按键           | 作用            |
| ------------ | ------------- |
| `<Space>sgl` | 当前行 Git blame |
| `<Space>sgb` | 浏览器打开远程文件     |
| `<Space>sgB` | Git 分支 picker |
| `<Space>G`   | LazyGit       |


### GitSigns（缓冲区级）


| 模式    | 按键                          | 作用                |
| ----- | --------------------------- | ----------------- |
| n     | `]h` / `[h`                 | 下一块 / 上一块 hunk    |
| n     | `]H` / `[H`                 | 最后 / 第一块 hunk     |
| n / v | `<Space>ggs`                | Stage hunk        |
| n / v | `<Space>ggr`                | Reset hunk        |
| n     | `<Space>ggS` / `<Space>ggR` | Stage / Reset 整缓冲 |
| n     | `<Space>ggp` / `<Space>ggP` | 预览 hunk / 行内预览    |
| —     | `<Space>tgb`                | 切换当前行 blame       |
| —     | `<Space>tgw`                | 切换词级 diff         |


---

## 11. 插入模式补全（Blink.cmp）


| 模式  | 按键                    | 作用                                                                   |
| --- | --------------------- | -------------------------------------------------------------------- |
| c   | `<A-j>` / `<A-k>`     | **命令行** Blink 补全候选项下 / 上（`:`、`/`、`q:` 等；与插入模式键位分开配置）                |
| i   | `<A-j>` / `<A-k>`     | 候选项下 / 上                                                             |
| i   | `<C-n>` / `<C-p>`     | 同上                                                                   |
| i   | `<C-u>` / `<C-d>`     | 补全文档窗滚动                                                              |
| i   | `<Tab>` / `<CR>`      | 补全菜单打开时接受；需先用 `<C-n>`/`C-p` 或 `<A-j>`/`A-k` 选中项（未选中则 Tab 为缩进、CR 为换行） |
| i   | `<S-CR>`              | 关补全并换行                                                               |
| i   | `<A-/>`               | 开关补全菜单                                                               |
| i   | `<C-Space>` / `<A-.>` | 手动打开补全                                                               |
| i   | `<A-n>` / `<A-p>`     | 仅 buffer 词补全                                                         |
| i   | `<A-y>`               | Minuet（AI）补全源                                                        |


**说明**：Normal 下 `<A-p>` 仍是 BufferLine 固定标签，与插入模式不冲突。CodeCompanion 聊天 buffer 中 Blink 默认源不含 Minuet；其它文件里 Minuet 在默认源中参与自动补全，`**<A-y>`** 仍可只拉 Minuet。

补全为 **Blink 默认触发**（关键字、LSP 触发符等会自动出菜单）。仍可用 `**<A-/>`** / `**<C-Space>`** 手动开关。

另：与 [blink.cmp#968](https://github.com/Saghen/blink.cmp/issues/968) 同类时，Blink 会临时改写 `iskeyword`；`completion.lua` 的 `**config` 里已 patch `with_constant_is_keyword**`，且 `**fuzzy.implementation = lua**`。手动 `show` 用 `**defer_fn(25ms)**`；菜单 `**draw.align_to = label**`。`**jk` 退出插入**由 `**edit.lua` 的 better-escape.nvim** 处理（避免原生 `imap jk` 的 pending）。**最后一行**编辑时若曾与补全叠加重绘，见 `**autocmds.lua`** 的 `**UserEofViewPadding`**（仅在 Normal / Visual 下对末行 `zz`）。

---

## 12. AI（CodeCompanion）


| 上下文       | 按键                        | 作用               |
| --------- | ------------------------- | ---------------- |
| —         | `<Space>cc`               | 打开聊天             |
| v         | `<Space>cm` / `cr` / `ce` | 注释 / 重构 / 解释（选区） |
| n, x, o   | `<Space>ai`               | 输入需求后执行          |
| Chat（n/i） | `<A-s>`                   | 发送               |
| Chat（n/i） | `<A-c>`                   | 关聊天              |
| Inline（n） | `<Space>a` / `<Space>r`   | 接受 / 拒绝建议        |


**说明**：普通 buffer 里 `<A-c>` 是 Snacks 关 buffer；在 CodeCompanion 聊天里才是关聊天。

---

## 13. 界面与编辑选项开关

以下在 VeryLazy 后注册（`<Space>u` 前缀）：


| 按键          | 作用            |
| ----------- | ------------- |
| `<Space>us` | 拼写检查          |
| `<Space>uw` | wrap          |
| `<Space>uL` | 相对行号          |
| `<Space>ud` | 诊断显示          |
| `<Space>ul` | 行号            |
| `<Space>uc` | conceallevel  |
| `<Space>uT` | Treesitter 高亮 |
| `<Space>ub` | 背景 light/dark |
| `<Space>uh` | Inlay hints   |
| `<Space>ug` | 缩进向导          |
| `<Space>uD` | Dim 非当前窗口     |



| 按键         | 作用                    |
| ---------- | --------------------- |
| `<Space>?` | 当前 buffer 的 which-key |


---

## 14. 其它（会话、撤销树、Python venv、插件管理）


| 按键                                      | 作用                                  |
| --------------------------------------- | ----------------------------------- |
| `<Space>L`                              | Lazy.nvim UI                        |
| `<Space>tf`                             | 开关保存时自动格式化（conform）                 |
| `<Space>ut`                             | Undotree                            |
| `<Space>ps` / `<Space>pS` / `<Space>pD` | 恢复会话 / 搜索会话 / 删除会话                  |
| `<Space>cv`                             | Python venv-selector（`:VenvSelect`） |


**venv-selector**：依赖系统 `**fd`**（或 Debian/Ubuntu 的 `fdfind`）；Anaconda 路径在 `lua/plugins/lang/python.lua` 的 `search` 中，远程目录不同时请改路径。

---

## 15. Picker 浮层内（Snacks）

搜索框已打开时：


| 按键                    | 作用       |
| --------------------- | -------- |
| `<Tab>` / `<S-Tab>`   | 多选并上/下移动 |
| `<A-Up>` / `<A-Down>` | 输入历史     |
| `<A-j>` / `<A-k>`     | 列表项上/下   |
| `<C-u>` / `<C-d>`     | 预览区滚动    |
| `<A-u>` / `<A-d>`     | 列表大步滚动   |
| `<C-j>` / `<C-k>`     | 列表小步滚动   |


**Telescope**（例如 **remote-nvim** 的列表）：在 **i / n** 模式下同样使用 `<A-j>` / `<A-k>` 上下移动选项（`plugins/telescope.lua`）。

---

## 16. mini 系列

- **mini.diff**：未绑定快捷键。  
- **mini.ai**：默认 `a`/`i` 文本对象扩展，见 `:h mini.ai`。  
- **mini.surround**：默认 `sa` / `sd` / `sr` 等，见 `:h mini.surround`（与全局 `s` 映射有关时注意冲突）。

---

## 17. 维护说明

配置变更后请同步更新本文件。实际键位以 `:WhichKey`、`:verbose map <键>` 为准。