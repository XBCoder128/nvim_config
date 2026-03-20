# NvimTree 快捷键说明

本配置里 `**lua/plugins/ui.lua` 未设置 `on_attach**`，文件树缓冲区内的键位与 **nvim-tree 插件默认**一致（实现见 lazy 内 `nvim-tree/lua/nvim-tree/keymap.lua` 的 `on_attach_default`）。若你日后在 `setup({ on_attach = ... })` 里自定义，以下「树内默认」可能不再完全适用。

---

## 1. 本配置额外绑定的全局快捷键（在普通 buffer 也可用）


| 模式  | 按键          | 作用                             | 定义位置                      |
| --- | ----------- | ------------------------------ | ------------------------- |
| n   | `<A-m>`     | 开关 NvimTree（`:NvimTreeToggle`） | `lua/keyboard.lua`        |
| n   | `<Space>ps` | 恢复会话后会再执行一次 `NvimTreeToggle`   | `lua/plugins/session.lua` |


其它与树配合的逻辑（**不是** NvimTree 自带键位）：


| 模式  | 按键   | 作用                                 | 说明                                |
| --- | ---- | ---------------------------------- | --------------------------------- |
| n   | `so` | 仅保留当前窗口；若之前开着 NvimTree 会尝试再打开      | `keyboard.lua`，内部 `:NvimTreeOpen` |
| —   | （启动） | `VimEnter` 时自动 `tree.toggle`（不抢焦点） | `lua/autocmds.lua`                |


---

## 2. 文件树窗口内：nvim-tree 默认键位（Normal，buffer-local）

以下均在 **光标位于 NvimTree 窗口内** 时生效；`x` 表示可视模式也可用。


| 按键               | 作用（插件描述）                                               |
| ---------------- | ------------------------------------------------------ |
| `<C-]>`          | CD：把根目录设为当前节点                                          |
| `<C-e>`          | Open: In Place                                         |
| `<C-k>`          | Info（信息浮层）                                             |
| `<C-r>`          | Rename: Omit Filename                                  |
| `<C-t>`          | Open: New Tab                                          |
| `<C-v>`          | Open: Vertical Split                                   |
| `<C-x>`          | Open: Horizontal Split                                 |
| `<BS>`           | Close Directory                                        |
| `<CR>`           | Open                                                   |
| `<Del>`          | Delete（n / x）,..-F                                    |
| `<Tab>`          | Open Preview                                           |
| `>` / `<`        | Next / Previous Sibling                                |
| `.`              | Run Command                                            |
| `-`              | Up（根目录切到父级）                                            |
| `a`              | Create File Or Directory                               |
| `bd`             | Delete Bookmarked                                      |
| `bt`             | Trash Bookmarked                                       |
| `bmv`            | Move Bookmarked                                        |
| `B`              | Toggle Filter: No Buffer                               |
| `c`              | Copy（n / x）                                            |
| `C`              | Toggle Filter: Git Clean                               |
| `[c` / `]c`      | Prev / Next Git                                        |
| `d`              | Delete（n / x）                                          |
| `D`              | Trash（n / x）                                           |
| `E`              | Expand All                                             |
| `e`              | Rename: Basename                                       |
| `[e` / `]e`      | Prev / Next Diagnostic                                 |
| `F`              | Live Filter: Clear                                     |
| `f`              | Live Filter: Start                                     |
| `g?`             | Help（树内帮助）                                             |
| `gy`             | Copy Absolute Path                                     |
| `ge`             | Copy Basename                                          |
| `H`              | Toggle Filter: Dotfiles（本配置默认过滤点文件，按 `H` 可切换显示）        |
| `I`              | Toggle Filter: Git Ignored                             |
| `J` / `K`        | Last / First Sibling                                   |
| `L`              | Toggle Group Empty                                     |
| `M`              | Toggle Filter: No Bookmark                             |
| `m`              | Toggle Bookmark（n / x）                                 |
| `o`              | Open                                                   |
| `O`              | Open: No Window Picker                                 |
| `p`              | Paste                                                  |
| `P`              | Parent Directory                                       |
| `q`              | Close（关闭树窗口）                                           |
| `r`              | Rename                                                 |
| `R`              | Refresh                                                |
| `s`              | Run System（本配置 `system_open.cmd = "open"`，macOS）       |
| `S`              | Search                                                 |
| `u`              | Rename: Full Path                                      |
| `U`              | Toggle Filter: Custom（本配置 `custom` 含 `node_modules` 等） |
| `W`              | Collapse All                                           |
| `x`              | Cut（n / x）                                             |
| `y`              | Copy Name                                              |
| `Y`              | Copy Relative Path                                     |
| `<2-LeftMouse>`  | Open（双击左键）                                             |
| `<2-RightMouse>` | CD（双击右键）                                               |


---

## 3. 与本配置相关的行为说明


| 项                                | 值 / 说明                                                |
| -------------------------------- | ----------------------------------------------------- |
| `view.width`                     | 34                                                    |
| `view.side`                      | left                                                  |
| `filters.dotfiles`               | `true`（点文件默认隐藏，树内按 `**H`** 切换）                        |
| `filters.custom`                 | 含 `node_modules`                                      |
| `git.enable`                     | `false`（Git 着色/部分 Git 相关过滤可能不明显，`[c` `]c` 等仍保留在默认键位上） |
| `actions.open_file.quit_on_open` | `false`（打开文件后不自动关树）                                   |


---

## 4. 自查命令

在 **NvimTree 窗口内**：

```vim
:verbose map <buffer>
```

帮助：

```vim
:h nvim-tree-mappings-default
```

