`/Users/zsm/Downloads/Alice` 题目的核心逻辑不在主程序 writer，而在 `alice.dat` 驱动的自修改 VM：VM 指令长度为 5 字节，`0x25` 会触发 `SIGTRAP`，由 patch table 动态修补 code page；`features.bin` writer 已可复现，但仅靠 target 文件不能稳定恢复 flag。 <!-- created=2026-06-14, last=2026-06-14 -->
§
Alice 逆向题的核心在 `core.dec.dylib` 的 `_b9`：它使用 5 字节指令的自修改 VM。`alice.dat` 含 patch table（offset `0x7000`，count `0x185`），opcode `0x25` 会触发 `SIGTRAP` 由 handler 动态 patch VM 字节码，因此静态看第一层 dump 不完整，必须在 patch 后再 dump/分析。 <!-- created=2026-06-14, last=2026-06-14 -->
§
在 `/Users/zsm/Downloads/Alice` 这个 Alice 逆向题里，用户确认正确解题方向应是按 VM 核心逻辑重建最终二维码图片，而不是做外层 QR 模块猜测脚本。 <!-- created=2026-06-14, last=2026-06-14 -->