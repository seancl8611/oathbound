---
id: META-UPDATE-PROTOCOL
title: Documentation Update Protocol
category: meta
status: approved
authority: primary
---

# Documentation Update Protocol

Use this process for all material design or lore changes.

1. Identify the authoritative file using `SOURCE_OF_TRUTH.md`.
2. Update the authoritative definition first.
3. Review `DOCUMENT_MAP.md` for known dependent files.
4. Search the repository for outdated wording, contradictions, and duplicate definitions.
5. Update dependent summaries without copying unnecessary detail.
6. Add major locked decisions to `DECISION_LOG.md`.
7. Add unresolved consequences or questions to `OPEN_QUESTIONS.md`.
8. Update milestone or asset documents only when production scope changes.
9. Use a focused branch and commit message.
10. Open a pull request summarizing changed files, design impact, and unresolved issues.

## Safety rules

- Do not convert a draft idea into locked canon without explicit approval.
- Do not silently change gameplay while revising lore, or lore while revising gameplay.
- Do not remove content solely because it appears redundant until its authoritative replacement is confirmed.
- Preserve stable document IDs when renaming files.
- Mark obsolete material as `deprecated` before deletion when historical context may matter.
