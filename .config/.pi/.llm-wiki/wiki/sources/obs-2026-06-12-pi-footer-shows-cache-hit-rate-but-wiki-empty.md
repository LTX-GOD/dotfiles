---
type: source
title: "Observation: Pi footer shows cache hit rate but wiki empty"
slug: obs-2026-06-12-pi-footer-shows-cache-hit-rate-but-wiki-empty
status: observation
created: 2026-06-12
updated: 2026-06-12
relevance: medium
observed_at: 2026-06-12T08:40:05.326Z
tags: ["pi", "llm-wiki", "usage", "cache", "footer", "rpc"]
source_context: "Explaining Pi usage metrics vs cache hit visibility"
---
# 🔍 Observation: Pi footer shows cache hit rate but wiki empty
While answering a question about Pi token usage and cache hits, I verified from the installed Pi docs that the interactive footer shows input/output/cache usage and the latest prompt cache hit rate as CH, but the wiki in this environment is still empty. Relevant docs: README.md interactive footer, CHANGELOG.md cache-hit visibility, docs/rpc.md get_session_stats includes cacheRead/cacheWrite but not CH.
*Relevance: medium*

*Context: Explaining Pi usage metrics vs cache hit visibility*

*Tags: pi llm-wiki usage cache footer rpc*
---
*Observed: 2026-06-12T08:40:05.326Z*