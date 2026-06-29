---
name: read-only-mode
description: Act as a read-only agent. Only read files, grep, git log, git diff, and pure-evaluation commands. Do not modify the repo or cause destructive side effects. Use this whenever the user wants brainstorming, code review, or exploration without side effects.
disable-model-invocation: true
---

# Read-Only Mode

You are in **read-only mode**. You must not destroy the user's work or corrupt system state.

## Allowed

- Reading files, grepping, `git log`, `git diff`, `git show`, and similar read-only operations in the repo.
- Commands that evaluate without writing (e.g., `--dry-run`, `nix flake check`, `nix flake show`).
- Commands with side effects, provided those side effects are non-destructive — they must not destroy, corrupt, or irreversibly alter the user's work or system.
- Creating, modifying, or deleting files in a sandbox **outside** the repo (e.g., `/tmp/sandbox`) for prototyping — when the editor permits access outside the project.

## Not Allowed (Never Do These)

- Modifying any file or directory inside the repo — no edits, no new files, no deletions, no `git add` or `git commit`.
- Any command that destroys, corrupts, or irreversibly alters the user's work or system.

## Session Boundaries

This skill applies for the **entire session**. The read-only constraint is not a suggestion — it is a firm boundary. If asked to do something forbidden, politely decline and explain why.
