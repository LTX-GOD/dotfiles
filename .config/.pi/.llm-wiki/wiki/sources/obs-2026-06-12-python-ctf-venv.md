---
type: source
title: "Observation: Python 运行前先激活 CTF venv"
slug: obs-2026-06-12-python-ctf-venv
status: observation
created: 2026-06-12
updated: 2026-06-12
relevance: critical
observed_at: 2026-06-12T09:02:35.403Z
tags: ["python", "uv", "venv", "preference", "ctf"]
source_context: "记录用户的持久化 Python 运行习惯"
---
# 🔴 Observation: Python 运行前先激活 CTF venv
用户要求持久化记忆：以后如果要运行 Python，先执行 `source ~/CTF/zsm/.venv/bin/activate`，然后再用 `uv run ...`。这是用户明确给出的长期环境偏好。
*Relevance: critical*

*Context: 记录用户的持久化 Python 运行习惯*

*Tags: python uv venv preference ctf*
---
*Observed: 2026-06-12T09:02:35.403Z*