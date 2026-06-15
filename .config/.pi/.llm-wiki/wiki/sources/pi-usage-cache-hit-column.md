---
type: source
title: "Pi usage cache hit column"
slug: pi-usage-cache-hit-column
status: insight
created: 2026-06-12
updated: 2026-06-12
category: architecture
---
# Pi usage cache hit column
Added a local patch to the `/usage` extension so it shows a `CH%` column aggregated over the selected period. The formula matches Pi footer logic in `dist/modes/interactive/components/footer.js`: `cacheRead / (input + cacheRead + cacheWrite)`, rendered with one decimal place like `89.2%`. To avoid duplicate `/usage` registrations from the upstream package, the package entry in `[[entities/tmustier-pi-extensions]]` was filtered to exclude `usage-extension/index.ts`, and a local wrapper extension at `/.pi/extensions/usage-cache-hit.ts` re-exported the patched source from the local clone. Related concepts: [[concepts/pi-extensions]], [[concepts/prompt-caching]], [[concepts/pi-usage-dashboard]].
*Category: architecture*
---
*Captured: 2026-06-12*
## Related
_Add links to related pages._