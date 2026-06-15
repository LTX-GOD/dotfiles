Web 访问工具选择优先级：
1. fetch_server_fetch — 首选，最快的 HTTP 抓取，适用于 90% 场景（静态 HTML、API JSON、纯文本内容）
2. agent-browser — 需要 JS 渲染、登录态、表单交互、截图时使用
3. burp — 安全审计专用，需拦截修改请求时使用（需先启动 Burp Suite）
4. bluebud-headless — 全站批量爬取/站点地图场景
决策：fetch 走量，browser 走质，burp 走安全，bluebud 走全站。拿内容先试 fetch，不行再升 browser。 <!-- created=2026-06-13, last=2026-06-13 -->
§
在这台机器上，用 `sage -python` 直接执行包含 Sage 语法（如 `PR.<x> = PolynomialRing(...)`）的脚本会报 `SyntaxError`; 应改为保存为 `*.sage` 并用 `sage <file.sage>` 运行，或在 Python 模式下改写为显式的 `PolynomialRing(...)` 构造。 <!-- created=2026-06-14, last=2026-06-14 -->
§
在这台机器上做文件发现时，`rg` 可能不可用；尝试 `rg --files` 失败后，不要改用 `grep --files`（会报 `option --files is ambiguous`），应回退到 `find`、`ls`、`file` 组合进行枚举与初筛。 <!-- created=2026-06-14, last=2026-06-14 -->
§
在当前环境中，`rg` 可能不可用；尝试用 `rg --files` 进行快速枚举后若失败，需改用 `find`、`ls`、`file` 组合进行文件发现与初筛，避免依赖 `grep --files` 这类会报歧义的调用。 <!-- created=2026-06-14, last=2026-06-14 -->
§
在 Sage 中通过 `sage -python` 执行脚本时，不能使用 `.sage` 语法糖（如 `PR.<x> = PolynomialRing(...)`）；这类代码应放进 `.sage` 文件直接跑，或改写成标准 Python 构造方式。 <!-- created=2026-06-14, last=2026-06-14 -->
§
On this machine, Foundry CLI tools `forge`, `cast`, and `anvil` were not available in PATH during CTF smart-contract work; when solving locally, prefer Python/Web3 or install Foundry explicitly instead of assuming those binaries exist. <!-- created=2026-06-14, last=2026-06-14 -->
§
`fetch-server`/MCP 抓取公开搜索页时会受 robots 限制；例如 DuckDuckGo `/html` 和 GitHub 搜索结果页可能直接拒绝 autonomous fetch，GitHub 搜索 API 也可能返回 `401 Requires authentication`。做公开资料检索时不要只依赖这些入口，必要时改用允许抓取的源或浏览器型工具。 <!-- created=2026-06-14, last=2026-06-14 -->
§
`fetch-server`/MCP 抓取会遵守目标站点 `robots.txt`；例如 DuckDuckGo HTML 搜索页和 GitHub 搜索页可能因 robots 限制而拒绝自动抓取，不能把它当成稳定的搜索替代品。 <!-- created=2026-06-14, last=2026-06-14 -->