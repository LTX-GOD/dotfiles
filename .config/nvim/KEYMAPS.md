# Neovim 快捷键文档

`<leader>` = `Space`，`<localleader>` = `Space`

---

## 基础移动

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `jk` | Insert | 退出插入模式（等同 `<Esc>`） |
| `j` / `k` | Normal/Visual | 自动适配软换行（`gj`/`gk`） |
| `<A-Left>` | Normal/Insert | 跳到行首 |
| `<A-Right>` | Normal/Insert | 跳到行尾 |
| `<C-d>` | Normal | 向下滚动 5 行并居中 |
| `<C-u>` | Normal | 向上滚动 5 行并居中 |
| `<CR>` | Normal | 折叠展开/收起（`za`） |

---

## 窗口管理

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<Esc>` | Normal | 清除搜索高亮 |
| `\` | Normal | 水平分屏 |
| `\|` | Normal | 垂直分屏 |
| `<leader>-` | Normal | 水平分屏 |
| `<leader>\|` | Normal | 垂直分屏 |
| `+` | Normal | 最大化当前窗口 |
| `<leader>=` | Normal | 恢复窗口均等大小（`=` 保留给缩进操作符） |
| `<C-h/j/k/l>` | Normal | 在窗口间移动 |
| `<C-w><C-t>` | Normal | 当前 Buffer 在新 Tab 打开 |
| `VimResized` | 自动 | 窗口大小变化时自动均等化 |

---

## 标签页 / Buffer

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `L` | Normal | 下一个 Tab |
| `H` | Normal | 上一个 Tab |
| `]b` | Normal | 下一个 Buffer（BufferLine） |
| `[b` | Normal | 上一个 Buffer（BufferLine） |
| `<leader>bp` | Normal | 选择 Buffer（BufferLine Pick） |
| `<leader>bD` | Normal | 选择并关闭 Buffer |
| `<leader>bc` | Normal | 关闭当前 Buffer |
| `<leader>bC` | Normal | 关闭其他所有 Buffer |
| `<leader><leader>` | Normal | 列出所有 Buffer（Snacks Picker） |

---

## 文件查找（Snacks Picker）

| 快捷键 | 说明 |
|--------|------|
| `<leader>ff` | 智能查找文件（Smart） |
| `<leader>fo` | 查找最近打开文件 |
| `<leader>fw` | 全局搜索内容（Grep） |
| `<leader>fb` | 在当前 Buffer 中搜索行 |
| `<leader>fh` | 搜索帮助文档 |
| `<leader>fk` | 搜索快捷键 |
| `<leader>fl` | 切换 Picker 布局 |
| `<leader>fm` | 搜索标记（Marks） |
| `<leader>fn` | 搜索通知历史 |
| `<leader>fs` | 搜索工作区符号（LSP Workspace Symbols） |
| `<leader>ls` | 搜索当前文件符号（LSP/Treesitter） |
| `<leader>fi` | 搜索图标 |
| `<leader>fd` | 搜索诊断信息 |
| `<leader>fH` | 搜索高亮组 |
| `<leader>fc` | 搜索 Nvim 配置文件 |
| `<leader>f/` | 搜索历史 |
| `<leader>fj` | 搜索跳转列表 |
| `<leader>ft` | 搜索 TODO（Markdown 文件时搜索待办项） |
| `<leader>fg` | 查找 Git 仓库（自定义 Picker） |
| `<leader>fJ` | 从所有窗口内容中跳转到 `file:line` |

---

## Git

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>gg` | Normal | 打开 Lazygit |
| `<leader>gb` | Normal | 显示当前行 Git Blame |
| `]c` | Normal | 跳到下一个 Git Hunk |
| `[c` | Normal | 跳到上一个 Git Hunk |
| `<leader>gs` | Normal/Visual | 暂存 Hunk |
| `<leader>gr` | Normal/Visual | 重置 Hunk |
| `<leader>gp` | Normal | 预览 Hunk |
| `<leader>gd` | Normal | 与 Index 对比（diff） |
| `<leader>gD` | Normal | 与上一次提交对比（diff） |
| `<leader>tb` | Normal | 切换当前行 Blame 显示 |
| `<leader>tD` | Normal | 切换内联删除行预览 |
| `<leader>tg` | Normal | 切换 Git Signs 显示 |

---

## LSP

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gd` | Normal | 跳转到定义（Snacks Picker） |
| `gD` | Normal | 在分屏中跳转到定义 |
| `gr` | Normal | 跳转到引用（Snacks Picker） |
| `<leader>la` | Normal | 代码操作（Code Action） |
| `<leader>ld` | Normal | 显示当前光标诊断浮窗 |
| `<leader>rn` | Normal | 重命名（优先使用 inc-rename） |
| `<leader>td` | Normal | 切换诊断显示 |
| `<leader>th` | Normal | 切换 Inlay Hints |
| `<leader>lf` | Normal | 格式化当前 Buffer |
| `<leader>tf` | Normal | 切换保存时自动格式化 |

LSP 用户命令：
- `:LspHealth` — 检查 LSP 状态
- `:LspLog` — 在新 Tab 中打开 LSP 日志
- `:ConformInfo` / `:ConformEnable` / `:ConformDisable` — Conform 控制

---

## 调试（DAP）

| 快捷键 | 说明 |
|--------|------|
| `<F5>` | 继续/启动调试 |
| `<F10>` | 单步跳过（Step Over） |
| `<F11>` | 单步进入（Step Into） |
| `<F12>` | 单步退出（Step Out） |
| `<leader>db` | 切换断点 |
| `<leader>dB` | 设置条件断点 |
| `<leader>dr` | 重启调试 |
| `<leader>dq` | 终止调试 |
| `<leader>du` | 切换 DAP UI |

---

## Java 文件特有（`lua/custom/plugins/jdtls.lua`）

打开任意 `.java` 文件后由 jdtls 注册，均为 Buffer 本地快捷键。

| 快捷键 | 说明 |
|--------|------|
| `<F5>` | 启动调试（配置为空时自动发现主类并重试，最多 5 次） |
| `<leader>dJ` | 刷新主类配置并启动调试 |
| `<leader>jt` | 运行光标所在的单个测试方法 |
| `<leader>jT` | 运行当前测试类 |
| `<leader>jr` | 运行 Spring Boot 项目（自动识别 mvnw/gradlew/mvn/gradle，在终端启动） |

> 测试与调试依赖 `java-debug-adapter` 与 `java-test`（Mason 自动安装）。
> 运行前需确保项目已编译（jdtls 完成导入、`Building` 进度结束），否则主类发现会失败并提示。

---

## Maven POM 文件特有（`after/ftplugin/xml.lua`）

在 `pom.xml` 或 `~/.m2` 下的 `*.pom` 文件中可用。

| 快捷键 | 说明 |
|--------|------|
| `gd` | 跳转到光标所在 `<dependency>`/`<parent>`/`<plugin>` 对应的本地 POM 文件 |
| `<leader>jP` | 直接跳转到 `<parent>` 对应的 POM 文件 |

> 解析 `~/.m2/repository` 本地缓存；若依赖版本写成 `${...}` 变量则无法解析。
> 找不到文件时先运行 `mvn dependency:resolve` 把 POM 拉到本地。

---

## 跳转（Flash）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `ss` | Normal/Visual/Operator | Flash 跳转 |
| `SS` | Normal/Visual/Operator | Flash Treesitter 语法跳转 |

---

## 文件树（Neo-tree 左侧边栏）

| 快捷键 | 说明 |
|--------|------|
| `<leader>e` | 聚焦文件树（未打开则打开） |
| `<leader>E` | 切换文件树（开/关） |
| `<leader>fe` | 打开并定位到当前文件 |

**文件树内按键：**

| 键 | 说明 |
|----|------|
| `<CR>` / `<2-LeftMouse>` | 打开文件 |
| `<Space>` | 展开/收起节点 |
| `<Tab>` | 跳回编辑区（文件树保持打开） |
| `s` | 垂直分屏打开 |
| `S` | 水平分屏打开 |
| `t` | 在新 Tab 打开 |
| `P` | 预览（浮窗） |
| `l` | 聚焦预览 |
| `a` | 新建文件（支持 `{a,b}.txt` 大括号展开） |
| `A` | 新建目录 |
| `d` | 删除 |
| `r` | 重命名 |
| `y` / `x` / `p` | 复制/剪切/粘贴 |
| `m` | 移动 |
| `H` | 切换隐藏文件显示 |
| `<bs>` | 返回上级目录 |
| `.` | 设置当前目录为根目录 |
| `/` | 模糊查找 |
| `q` | 关闭文件树 |
| `R` | 刷新 |
| `?` | 显示帮助 |
| `[g` / `]g` | 上/下一个 Git 修改文件 |
| `oc/od/og/om/on/os/ot` | 按创建时间/诊断/Git/修改/名称/大小/类型排序 |
| `<` / `>` | 切换 Source（文件系统/Git Status） |

---

## 编辑与剪贴板

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `p` | Visual | 粘贴但不覆盖剪贴板 |
| `<leader>p` | Visual | 普通粘贴（覆盖剪贴板） |
| `<space>X` | Normal | 执行当前 Lua 文件 |
| `<space>x` | Normal | 执行当前行 Lua |
| `<space>x` | Visual | 执行选中 Lua |
| `<leader>P` | Normal | 粘贴系统剪贴板图片（img-clip，Markdown） |

---

## mini.surround

| 快捷键 | 说明 |
|--------|------|
| `sa{motion}` | 添加包围符 |
| `sd{char}` | 删除包围符 |
| `sr{old}{new}` | 替换包围符 |
| `sf` / `sF` | 向右/向左查找包围符 |
| `sh` | 高亮包围符 |
| `sn` | 更新 `n` 行范围 |

后缀 `l`/`n` 指向上一个/下一个。

---

## AI 补全（Minuet / Blink）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<C-space>` | Insert | 显示/隐藏补全文档 |
| `<C-y>` | Insert | 确认选中项 |
| `<C-e>` | Insert | 关闭补全菜单 |
| `<C-n>` / `<Down>` | Insert | 下一个补全项 |
| `<C-p>` / `<Up>` | Insert | 上一个补全项 |
| `<C-b>` / `<C-f>` | Insert | 文档上/下滚动 |
| `<Tab>` | Insert | 展开代码片段 / 下一个补全项 |
| `<S-Tab>` | Insert | 代码片段后退 / 上一个补全项 |
| `<CR>` | Insert | 确认补全 |
| `<A-y>` | Insert | 接受 AI（Minuet）补全 |
| `<A-A>` | Insert | 接受 Minuet 虚拟文本全部 |
| `<A-a>` | Insert | 接受 Minuet 虚拟文本当前行 |
| `<A-z>` | Insert | 接受 Minuet 虚拟文本 N 行 |
| `<A-[>` / `<A-]>` | Insert | Minuet 上/下一个建议 |
| `<A-e>` | Insert | 关闭 Minuet 虚拟文本 |

---

## 终端

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>t1` | Normal | 切换终端（Snacks Terminal） |
| `<Esc>` | Terminal | 进入 Normal 模式（lazygit/claude/pi 等 TUI 中不生效，Esc 传给程序本身） |
| `<C-q>` | Terminal | 关闭终端窗口 |
| `<C-h/j/k/l>` | Terminal | 切换到对应方向窗口 |

---

## Quickfix

| 快捷键 | 说明 |
|--------|------|
| `]q` | 下一条 |
| `[q` | 上一条 |
| `<CR>` | 跳转到条目 |

---

## 通知

| 快捷键 | 说明 |
|--------|------|
| `<leader>n` | 查看通知历史 |

---

## AI 助手（Sidekick）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>ac` | Normal | 切换 Claude 面板 |
| `<leader>ax` | Normal | 切换 Pi 面板 |
| `<leader>ap` | Normal | 打开 Prompt 库 |
| `<leader>av` | Visual | 发送选中内容 |

---

## 其他

| 快捷键 | 说明 |
|--------|------|
| `<leader>tz` | 专注模式（切换 GitSigns/InlayHints/Diagnostics） |
| `<leader>?` | 当前 Buffer 本地快捷键（Which-key） |
| `q` | 关闭帮助/Quickfix/DAP 浮窗（自动绑定） |

---

## Go 文件特有（`after/ftplugin/go.lua`）

| 快捷键 | 说明 |
|--------|------|
| `<leader>rt` | 运行当前包所有测试 |
| `<leader>rf` | 运行光标所在测试函数 |
| `<leader>rb` | 构建整个项目（`go build ./...`） |

---

## Markdown 文件特有

| 快捷键 | 说明 |
|--------|------|
| `gx` | 智能打开光标处 Markdown 链接 URL |

---

## 配置与维护

用户命令：
- `:PackUpdate` — 更新所有插件
- `:PackPlugins` — 检查插件状态（离线）
- `:Mason` — 打开 Mason LSP 工具管理器
- `:TSUpdate` — 更新 Treesitter 解析器
