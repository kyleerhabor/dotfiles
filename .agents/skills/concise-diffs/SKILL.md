---
name: concise-diffs
description: Present proposed code changes as unified diffs with enough context to be self-identifying.
disable-model-invocation: true
---

# Concise Diffs

When proposing a code change:

- Show a unified diff (`-` for old, `+` for new).
- Include enough surrounding context that the change is identifiable without opening the file. `...` may be used for large unchanged sections, but never in a way that hides which selector, block, or file the diff targets.
- If the change is self-evident, don't over-explain. If it has non-obvious intent, constraints, or tradeoffs, explain briefly.
