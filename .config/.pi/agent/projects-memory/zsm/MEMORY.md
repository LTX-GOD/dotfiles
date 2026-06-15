当前 CTF Web Shop 题目（101.245.103.157:5049）的关键线索：`/api/bot/chat` 机器人是 LangChain 实现；前端和接口表明只有 `support_admin` 才能访问规则测试台和商品 3 的发货预览；`/login <staff-code>` 是提权关键入口。 <!-- created=2026-06-14, last=2026-06-14 -->
§
在 `http://web-84cfcf0dea.adworld.xctf.org.cn` 这道 PHP 沙箱题里，源码黑名单只检查提交的 `code` 文本，不检查请求参数；已验证可通过运行时输入绕过黑名单，把被点名的符号动态喂进去，例如 `session_start` 可动态调用，`ArrayObject` 可通过 `ReflectionClass($_POST['c'])` 实例化。因此后续应优先寻找依赖 `unserialize` / 内置类 / session 原语的利用链，而不是假设黑名单里的 token 全部不可用。 <!-- created=2026-06-14, last=2026-06-14 -->
§
当前 PHP 8.4 沙箱逃逸 CTF 目标 `http://web-84cfcf0dea.adworld.xctf.org.cn` 已确认运行 `PHP 8.4.22`，且源码黑名单只检查提交的 `code` 文本，不检查请求参数；黑名单中的符号可通过 `$_POST` 动态喂入，已验证 `session_start` 可动态调用，`ArrayObject` 可通过 `ReflectionClass($_POST['c'])` 实例化。后续应优先沿运行时参数注入 + `unserialize`/内置类链继续挖利用。 <!-- created=2026-06-14, last=2026-06-14 -->
§
当前 PHP 8.4 沙箱逃逸 CTF 目标 `http://web-84cfcf0dea.adworld.xctf.org.cn` 运行的是 `PHP 8.4.22`。题目源码的黑名单只检查提交的 `code` 文本，不检查请求参数，因此被屏蔽的符号可通过 `$_POST`/运行时字符串动态喂入；已验证 `session_start` 可动态调用，`ArrayObject` 可通过 `ReflectionClass($_POST['c'])` 实例化。基于 `unserialize` 的 `ArrayObject`/SPL 序列化 PoC 能把后端打到 `502 Bad Gateway`，说明目标仍暴露可触发的 `spl` 反序列化漏洞面，后续应优先沿这条链寻找 RCE/提权原语。 <!-- created=2026-06-14, last=2026-06-14 -->
§
当前 PHP 8.4 沙箱逃逸 CTF 目标 `http://web-84cfcf0dea.adworld.xctf.org.cn` 的源码黑名单只检查提交的 `code` 文本，不检查请求参数。可通过 `eval($_POST['x'])` 或从 `$_POST` 动态取函数名/类名，绕过对 `session_start`、`call_user_func_array`、`ArrayObject`、`ArrayIterator`、`SplMaxHeap` 等 token 的源码级拦截。后续应优先把 PoC 代码或关键符号放到请求参数中执行。 <!-- created=2026-06-14, last=2026-06-14 -->
§
当前 adworld PHP 8.4 沙箱逃逸 CTF 目标已确认 `PHP 8.4.22`，`/lfag-9f1d7c2e-6a2c-4e54-9d7e-6cb10c4b8f9a` 为随机化 flag 路径且权限为 `0400 root:root`；因此仅绕过 `open_basedir` 不够，后续重点应放在先拿 RCE/提权再读 flag。 <!-- created=2026-06-14, last=2026-06-14 -->
§
当前 PHP 8.4 沙箱逃逸 CTF 目标 `http://web-84cfcf0dea.adworld.xctf.org.cn` 运行 `PHP 8.4.22`，当前只看到标准扩展加 `sodium`/`opcache`，不像额外装了自定义扩展。flag 真实路径是 `/lfag-9f1d7c2e-6a2c-4e54-9d7e-6cb10c4b8f9a`，权限为 `root:root 0400`，PHP 进程身份是 `www-data`，因此单纯任意读或 open_basedir 绕过不够，后续重点应放在先拿 RCE/提权。题目的源码黑名单只检查初始 `code` 文本，不检查运行时从请求参数再 `eval` 的内容，因此 `<?php eval(base64_decode($_POST["x"]));` 可作为稳定的黑名单绕过入口，把真实 payload 放进 POST 参数 `x`。最近的 SPL/unserialize PoC（如 `php-src#22047` 的 `ArrayObject+GlobIterator+foreach`、`php-src#22049` 的 `ArrayIterator+clone`）会把远端后端打到 `502`，说明这条漏洞面在目标上可达。 <!-- created=2026-06-14, last=2026-06-14 -->