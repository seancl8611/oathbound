---
id: META-UPDATE-PROTOCOL
title: Documentation Update Protocol
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-17
---

# Documentation Update Protocol

Use this process for material design, lore, content, UI, or production changes.

1. Identify authority in `SOURCE_OF_TRUTH.md`.
2. Read the authoritative file before editing.
3. Build a search set from canonical terms, synonyms, deprecated wording, proper names, and likely consequences. Use `TERMINOLOGY.md` as a search anchor.
4. Search the repository when live search is available.
5. If code search is unavailable/unindexed, use the approved direct-read fallback in `ASSISTANT_WORKFLOW.md`: authority → terminology → dependency map → relevant directory/files → branch diff/PR patch.
6. Use `DOCUMENT_MAP.md` only as a non-exhaustive dependency hint.
7. Update the authority first.
8. Update only dependent summaries/production docs whose meaning or scope changes.
9. Recheck for contradictions, stale status wording, and deprecated terms.
10. Record major locked decisions in decision history and keep unresolved production-relevant consequences in `OPEN_QUESTIONS.md`.
11. Update milestone/asset files only when production scope changes.
12. Use a focused branch and pull request.
13. Review changed filenames, key patches, review threads, and checks before merge.

## Safety rules

- Do not convert a draft example into approved canon without explicit user approval.
- Do not silently change gameplay while revising lore, or lore while revising gameplay.
- Do not remove apparently redundant material until its authoritative replacement is confirmed.
- Preserve stable document IDs when rewriting or renaming files.
- Historical context may remain in decision history even after live design language is removed.
- Do not claim repository-wide live-search coverage when the search index was unavailable; state the bounded direct-read audit instead.
- Prefer deleting stale duplicate definitions from summaries over maintaining parallel rules.
