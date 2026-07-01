---
name: re-read-files
description: Before proposing a change, read current state and verify diffs apply cleanly.
---

# Re-Read Files

Before proposing any code change:

1. **Read the target.** Read the file(s) being modified on disk. Files change between turns — do not rely on memory.

2. **Read the callers and callees.** If the file imports from or is imported by other project files, read them too. A rename or restructure in a dependency breaks the target.

3. **Read back after composing.** After drafting the diff, re-read the target file one more time. Confirm:
   - Line numbers and context match the current file.
   - No duplicate blocks or stale references.

4. **Show evidence.** When presenting a diff, include the relevant snippet of the file as-read so the reader can verify without opening the file.
