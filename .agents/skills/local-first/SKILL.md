---
name: local-first
description: Prefer local resources (installed tools, source code, artifacts, git history) over remote ones (Internet, live APIs, live repos). Local is faster, version-accurate, and works offline.
---

# Local First

When you need information about a tool, library, or system, exhaust what's already on the machine before reaching for the Internet.

**Local** means anything already available without a network call: installed binaries and their `--help` or man pages, source trees on disk, build outputs and logs, package caches, git history, existing files in the project. For installed tools, `--help`, man pages, and built-in help commands are first-class — they ship with the exact version you have and are often more current than online documentation.

**Remote** means anything requiring a network call: fetching URLs, cloning repositories live, searching the web, querying APIs, reading online documentation that is not locally cached.

**Boundary cases** — some operations straddle the line. `git log` is local; `git fetch` is remote. Running a command already installed is local; installing a new tool to answer a question crosses the boundary. Use judgment.

**No fixed sequence** — there is no ordered checklist. Sometimes you grep a source tree first, other times you run `--help`. The point is awareness: check what's already available before going out to the network.
