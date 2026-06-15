pnpm/Node 依赖约束：不要假设可直接 `require('ethers')` 或靠 `pnpm install` 临时补齐依赖；pnpm 布局可能不暴露顶层模块，安装也可能被 `ERR_PNPM_IGNORED_BUILDS` / `pnpm approve-builds` 拦住。优先复用仓库现有 `node_modules` 和本地可执行文件。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[correction] 在 Web Shop 题目中，用户补充并纠正了关键事实：目标站点的 bot 不是普通命令解析器，而是 LangChain 实现；后续分析应优先按提示注入、上下文/记忆污染、工具调用滥用等 LangChain 攻击面推进。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[tool-quirk] Web Shop 题目的认证接口要求标准 `Authorization: Bearer <token>` 头；直接发送裸 token 会返回 `{"detail":"missing token"}`，看起来像未携带认证。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[correction] 在当前 Web Shop CTF 题目中，不要继续走弱口令/弱密码分支。之前尝试了已存在用户名枚举与密码登录（如 ivory、mona、support、admin、staff、bot），结果均返回 `invalid username or password`，用户随后明确指出“没有弱密码漏洞，要想方法外带出来”。后续应转向 LangChain 聊天消息/元数据注入、上下文污染和数据外带方向。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[insight] 这道 `Cuneiform` 题的公共零集 Gröbner 基曾快速给出维数 `5`，说明四个二次式的公共零集不是零维唯一点集，而包含一个 5 维锥/高维成分；直接解 `q_i(x)=profile_i` 或盲目把公共零集当作唯一 opening 去解通常不成立，需要先恢复隐藏线性/几何结构。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[correction] In the `101.245.103.157:5049` Web Shop CTF challenge, weak-password/default-password guessing is a dead end. The user explicitly corrected that there is no weak password vulnerability, so future work should avoid spending time on password guessing and instead focus on exfiltration or LangChain abuse paths. <!-- created=2026-06-14, last=2026-06-14 -->
§
[insight] For the `101.245.103.157:5049` Web Shop CTF target, `LangChain`-style serialized objects injected into chat metadata are partly normalized server-side: standard message classes like `SystemMessage`, `HumanMessage`, `AIMessage`, `ToolMessage`, and `ChatMessage` can come back flattened into message fields, and `/api/chat/presence` changes `contextSize`, indicating a separate context pool worth targeting for prompt/context injection rather than public-chat-only poisoning. <!-- created=2026-06-14, last=2026-06-14 -->
§
[insight] 这道 `Cuneiform` 密码题的结构性进展：四个 tablet 对应的二次型矩阵都满秩，四个二次式公共零集的 Gröbner 基分析曾给出维数 `5`，说明目标对象更像一个 4 维线性子空间的仿射锥/相关几何成分，而不是直接零维唯一解。后续求解应优先走正交几何/Witt 分解与极大全等距子空间参数化，而不是把 `q_i(x)=profile_i` 当成普通小规模方程组硬解。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[correction] Cuneiform SCTF 2026 crypto challenge: I incorrectly concluded `chall.py` and `output.txt` were inconsistent because `TallyField._digits()` appeared to make tablet scores collapse to three values; the user corrected that the files are official and directly provided. Do not treat this as file-version mismatch without further proof; assume the behavior is intentional or part of the challenge. — Failed: Overweighted a local implementation observation and declared an attachment mismatch, conflicting with the user's official-file clarification. <!-- created=2026-06-14, last=2026-06-14 -->
§
PHP 8.4 沙箱约束：依赖 `curl_exec` 的 open_basedir 绕过和依赖 `ext-soap` 的 UAF 链，在 `curl_exec`/`curl_multi_exec` 被禁用且 `soap` 未加载时都不适用；应转向不依赖 cURL/SOAP 的引擎、SPL 或 `unserialize` 利用链。 <!-- created=2026-06-14, last=2026-06-14 -->
§
调试 Codex CLI 兼容的 Responses API/mock 上游时有两条关键约束：1) SSE 流必须完整收尾到 `response.completed`，否则 CLI 会报 `stream disconnected before completion` 或重连；最小可用流可以只返回一条 `agent_message`。2) MCP 工具调用不能把函数名扁平写成 `mcp__sandbox__sandbox_eval` 之类的字符串；应使用 `mcp_tool_call`/等价结构，并把 `server` 与 `tool` 分开（如 `server: "sandbox"`, `tool: "sandbox_eval"`）。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[tool-quirk] Codex CLI 0.139.0 的伪造 Responses API 上游中，MCP 工具调用不能把函数名写成扁平形式 `mcp__sandbox__sandbox_eval`；这样会报 `unsupported call`. 正确回包应使用 `mcp_tool_call` 项，并把服务器和工具拆开为 `server: "sandbox"`、`tool: "sandbox_eval"`。 — Failed: 将 MCP 调用名扁平化后，Codex 工具路由无法识别，报错 `unsupported call: mcp__sandbox__sandbox_eval`。 <!-- created=2026-06-14, last=2026-06-14 -->
§
本机工具约束合并：抓 Web 内容先用 `fetch-server`/MCP（静态 HTML、JSON、纯文本），需要 JS 渲染、登录态、表单交互或截图时再升到 `agent-browser`；拦截改包用 Burp；全站批量爬取用 `bluebud-headless`。`fetch-server` 遵守 `robots.txt`，DuckDuckGo/GitHub 搜索页等可能拒抓，GitHub 搜索 API 未认证也可能返回 `401`。若 `rg --files` 不可用，回退到 `find` + `ls` + `file`，不要用 `grep --files`。Sage 含 `PR.<x>` 语法糖时应用 `sage <file>.sage`，或改写为标准 Python 显式构造。不要假设本机已装 Foundry（`forge`/`cast`/`anvil`）；EVM 本地解题优先 Python/Web3 或原生 JSON-RPC。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[failure] 在当前 PHP 8.4 沙箱题上，曾尝试按参考资料走两条已知链：1) `php-src#16802` / `CURLOPT_PROTOCOLS_STR="all"` 的 cURL open_basedir 绕过；2) `GHSA-85c2-q967-79q5` 的 `ext-soap` UAF。两条都不适用：目标是 `PHP 8.4.22`，且 `curl_exec`、`curl_multi_exec` 已被 `disable_functions` 移除，`soap` 扩展也未加载。更有效的方向是利用源码级黑名单仅检查 `code` 文本这一缺陷，通过 `eval(base64_decode($_POST["x"]))` 把 SPL/unserialize PoC 从请求参数喂进去。 — Failed: 前两条链都依赖当前环境不具备的前提：cURL 执行入口被禁用，SOAP 扩展不存在；因此继续在 open_basedir/cURL 或 SOAP 上投入时间收益很低。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[tool-quirk] 在伪造 OpenAI-compatible Responses API 给 Codex CLI 时，如果 SSE 流在 `response.completed` 之前关闭，Codex 会报 `stream disconnected before completion: stream closed before response.completed`；最小可用假上游必须发送完整完成事件再断开连接。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[tool-quirk] 在给 Codex CLI 伪造 MCP 工具调用时，扁平函数名 `mcp__sandbox__sandbox_eval` 会报 `unsupported call`；可用格式应让调用落到 `server=sandbox`、`tool=sandbox_eval` 的 MCP 结构，而不是把 server 和 tool 压成一个函数名。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[tool-quirk] Codex CLI 对自定义 OpenAI-compatible Responses API 的最小 SSE 响应是可接受的，但 MCP 工具调用名不能写成扁平的 `mcp__sandbox__sandbox_eval`；这样会报 `unsupported call: mcp__sandbox__sandbox_eval`。可行方式是按 MCP server/tool 结构发起调用（server=`sandbox`，tool=`sandbox_eval`），随后 Codex 会产生 `mcp_tool_call` 事件并在后续回合回传工具结果。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[tool-quirk] 在用 mock Responses API 调试 Codex CLI 时，如果配置里要求的 MCP server 没有完成 initialize 握手，Codex 会在真正发起模型请求前直接失败：`required MCP servers failed to initialize ... handshaking with MCP server failed: connection closed: initialize response`。解决方式是改用不依赖该 MCP 的最小配置，或先确保 MCP initialize 流程可正常完成。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[correction] 在 `dont_poison_me` 这道题上，用户明确纠正了解题方向：不要继续把主要精力放在 60 字符受限的纯 Python 表达式逃逸上；更核心的利用链是伪造 OpenAI-compatible Responses API，诱导远端 Codex 调用 MCP 工具 `sandbox_eval`，再借助 PTY/`less` 逃逸去执行 `/readflag`。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[tool-quirk] 在 dont_poison_me 题目中，Codex 对 MCP 工具调用不接受扁平函数名 `mcp__sandbox__sandbox_eval`；实际尝试会报 `unsupported call: mcp__sandbox__sandbox_eval`。有效方式是按命名空间/服务形式调用：namespace/server 为 `mcp__sandbox`/`sandbox`，tool name 为 `sandbox_eval`。 — Failed: 扁平化函数名格式与 Codex 的 MCP 路由不兼容，导致工具调用被直接拒绝。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[tool-quirk] `idalib-mcp` 的上下文绑定会丢失；依赖当前 bound context 或自动生成的短 `session_id` 继续调用时，可能出现 `No database bound for this context` 或 `Database/session not found`。更稳妥的做法是重新 `open` 目标二进制并指定稳定的自定义 `session_id`，或在后续调用中直接传 `input_path`/`filename` 重新路由。 — Failed: 分析过程中 MCP worker 清掉了已绑定 session，后续 `disasm/decompile` 对旧 context 或旧短 session id 失败。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[tool-quirk] `idalib-mcp` 的会话/上下文可能在分析过程中丢失；表现为 `No database bound for this context` 或 `Database/session not found`。仅显式传旧 `session_id` 可能也会失效，可靠做法是按输入路径重新 `open` 二进制并恢复分析。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[tool-quirk] `idalib-mcp` 的会话上下文不稳定：分析过程中 session 可能被 worker 清掉，随后显式传入先前的 `database=session_id` 会报 `Database/session not found` 或 `No database bound for this context`。遇到这种情况需要重新 `open` 二进制并重建会话，不要假设旧 session_id 一直可用。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[correction] 在 Alice 逆向题中，用户明确纠正：`solve_modules.py` 这类基于 QR 模块尺寸假设/约束求解的脚本方向是错的；正确方向应按 VM 的核心数据流写前向模拟器，最终生成二维码图片再解码，而不是先假设二维码模块并直接求解。 <!-- created=2026-06-14, last=2026-06-14 -->
§
[insight] Alice 题的 `blocks.bin`/`features.bin` 不足以直接用通用 QR 模块约束恢复结果；更可靠的路径是先逆全 VM 与 wrapper/writer 流程，恢复 VM 生成的完整二维码图，再做识别。 <!-- created=2026-06-14, last=2026-06-14 -->