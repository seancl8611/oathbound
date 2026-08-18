---
id: META-UPDATE-PROTOCOL
title: Documentation Update Protocol
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-18
---

# Documentation Update Protocol

Use this process for material design, lore, content, UI, production, implementation-feedback, or playtest-driven changes.

1. Identify authority in `SOURCE_OF_TRUTH.md`.
2. Read the authoritative file before editing.
3. Build a search set from canonical terms, synonyms, deprecated wording, proper names, and likely consequences. Use `TERMINOLOGY.md` as a search anchor.
4. Search the repository when live search is available.
5. If code search is unavailable/unindexed, use the approved direct-read fallback in `ASSISTANT_WORKFLOW.md`: authority → terminology → dependency map → relevant directory/files → branch diff/PR patch.
6. Use `DOCUMENT_MAP.md` only as a non-exhaustive dependency hint.
7. Update the authority first.
8. Update only dependent summaries/production docs whose meaning or scope changes.
9. Recheck for contradictions, stale status wording, and deprecated terms.
10. Record major locked design decisions in decision history and keep only unresolved implementation/production-relevant questions in `OPEN_QUESTIONS.md`.
11. Update milestone/asset files only when production scope changes.
12. Use a focused branch and pull request.
13. Review changed filenames, key patches, review threads, and checks before merge.

# Implementation and playtest feedback loop

`approved` means **current accepted source of truth**, not "immune to revision."

Oathbound is now transitioning from documentation-first planning back toward implementation. The expected loop is:

1. document enough of a mechanic/content package to implement it,
2. use explicit first-playtest values where exact balance is not yet knowable,
3. implement the current authority in Godot,
4. playtest and record concrete problems or measurements,
5. revise the owning authority when evidence supports a change,
6. update implementation to match the revised authority.

Do not keep implementation blocked while trying to solve final balance purely on paper.

## Design-question threshold

Add or retain a question in `OPEN_QUESTIONS.md` only when its answer is needed to:

- define launch content,
- define a code/data/UI/art contract,
- avoid predictable implementation rework,
- or provide a coherent first-playtest baseline.

Do **not** promote a value to a top-level design question merely because it is not final. Final damage, timing, economy, frequency, pacing, and similar tuning normally remain in the owning file until playable evidence shows a broader design consequence.

## Documentation-to-code reconciliation

When the Godot project is connected or imported into the working repository, compare implementation against the documentation before blindly updating either side.

Classify each relevant system/content item as:

- matches current authority,
- implemented but based on superseded design,
- partially implemented,
- missing,
- obsolete and should be removed.

The documentation remains the design authority unless the user explicitly approves a change after reviewing implementation/playtest evidence.

# Safety rules

- Do not convert a draft example into approved canon without explicit user approval.
- Do not silently change gameplay while revising lore, or lore while revising gameplay.
- Do not remove apparently redundant material until its authoritative replacement is confirmed.
- Preserve stable document IDs when rewriting or renaming files.
- Historical context may remain in decision history even after live design language is removed.
- Do not claim repository-wide live-search coverage when the search index was unavailable; state the bounded direct-read audit instead.
- Prefer deleting stale duplicate definitions from summaries over maintaining parallel rules.
- Prefer a usable prototype contract over false precision when playtesting is the better source of truth.
