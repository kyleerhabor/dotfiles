---
name: re-read-files
description: Before making claims about a file, re-read it along with its callers, callees, and data flow. Use when the user references a specific file whose role in a larger system matters.
---

# Re-Read Files

When the user discusses a file and you are about to make a claim or propose a change, don't read it in isolation. A file's meaning is shaped by what calls it, what it calls, what feeds its inputs, and what it produces.

**Callers and callees.** If the file is sourced, imported, included, or executed by other files, those define its contract. A change that works when read alone can break expectations set by callers with different conventions.

**Inputs and outputs.** Where do variables, arguments, and environment values come from? Where do results go? A file may be fed by multiple callers that set the same variable with different semantics.

**Current state.** Files change between reads. Build outputs decay. Always check what's on disk now, not what you remember from earlier.
