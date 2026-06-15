---
type: source
title: "Observation: Patched /usage with cache hit percentage"
slug: obs-2026-06-12-patched-usage-with-cache-hit-percentage
status: observation
created: 2026-06-12
updated: 2026-06-12
relevance: high
observed_at: 2026-06-12T08:53:00.478Z
tags: ["pi", "extension", "usage", "cache", "hit", "patch", "settings"]
source_context: "Adding cache-hit percentage to Pi /usage command"
---
# ⭐ Observation: Patched /usage with cache hit percentage
Modified the installed /usage extension source at /Users/zsm/.pi/agent/git/github.com/tmustier/pi-extensions/usage-extension/index.ts to add a CH% column. Formula matches Pi footer logic from dist/modes/interactive/components/footer.js: cacheRead / (input + cacheRead + cacheWrite), rendered with one decimal place like 89.2%. Also updated /Users/zsm/.pi/agent/settings.json to disable the package-provided usage-extension and load a local wrapper extension at /Users/zsm/.config/.pi/.pi/extensions/usage-cache-hit.ts that re-exports the patched source, avoiding duplicate /usage registration.
*Relevance: high*

*Context: Adding cache-hit percentage to Pi /usage command*

*Tags: pi extension usage cache hit patch settings*
---
*Observed: 2026-06-12T08:53:00.478Z*