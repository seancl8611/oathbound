---
id: META-UPDATE-PROTOCOL
title: Documentation Update Protocol
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-10
---

# Documentation Update Protocol

Use this process for all material design, lore, content, UI, or production changes.

1. Identify the authoritative file using `SOURCE_OF_TRUTH.md`.
2. Read that file before editing.
3. Build a live search set from exact terms, synonyms, legacy wording, proper names, and likely system consequences.
4. Search the current repository and open only relevant matches.
5. Use `DOCUMENT_MAP.md` as a non-exhaustive review hint, not as proof of coverage.
6. Update the authoritative definition first.
7. Update dependent summaries and production documents only where meaning or scope actually changes.
8. Search again for contradictions, stale wording, and missed references.
9. Add major locked decisions to `DECISION_LOG.md`.
10. Add unresolved consequences or questions to `OPEN_QUESTIONS.md`.
11. Update milestone or asset documents only when production scope changes.
12. Use a focused branch and commit message.
13. Open a pull request with the search terms used, files reviewed, files changed, design impact, and unresolved issues.

## Safety rules

- Do not convert a draft idea into locked canon without explicit approval.
- Do not silently change gameplay while revising lore, or lore while revising gameplay.
- Do not remove content solely because it appears redundant until its authoritative replacement is confirmed.
- Preserve stable document IDs when renaming files.
- Mark obsolete material as `deprecated` before deletion when historical context may matter.
- Do not claim repository-wide consistency without a post-edit live search.
