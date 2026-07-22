---
id: META-ASSISTANT-WORKFLOW
title: Assistant Update Workflow
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-21
---

# Assistant Update Workflow

This repository is organized so an assistant can update Oathbound without relying on one oversized design document or repeating the same rule across many files.

## Read order

For broad design work, begin with:

1. `docs/overview/GAME_OVERVIEW.md`
2. `docs/overview/FULL_GAME_SCOPE.md`
3. `docs/_meta/OPEN_QUESTIONS.md`
4. `docs/_meta/SOURCE_OF_TRUTH.md`
5. the authoritative file for the affected subject

Use `DOCUMENT_MAP.md` only to seed likely dependencies. Live repository search remains required.

## Required process

1. Identify the authoritative file in `SOURCE_OF_TRUTH.md`.
2. Read that file in full.
3. Search for the current term, older wording, synonyms, affected names, and likely gameplay, lore, UI, art, and milestone consequences.
4. Classify each match as authoritative definition, dependent summary, production scope, contractor export, historical record, or unrelated.
5. Update the authoritative file first.
6. Update only dependent files whose meaning or scope changes.
7. Search again for contradictions, stale status claims, deprecated terminology, and missed references.
8. Preserve stable document IDs.
9. Update the asset inventory and milestone files only when production scope changes.
10. Use a focused branch and pull request unless a direct commit is explicitly requested.

## Question hygiene

`OPEN_QUESTIONS.md` contains only unresolved decisions that materially affect current scope, content volume, production planning, or narrative presentation.

- Remove a question once its authoritative answer is recorded.
- Do not keep resolved-question summaries in the tracker.
- Do not promote exact tuning values into top-level scope questions.
- Keep frame counts, cooldowns, probabilities, attack timings, and playtest values in the owning gameplay or encounter file.
- Combine overlapping questions around the production decision they block.
- Preserve deliberate mysteries as canon boundaries rather than treating them as problems that must be answered.

## Information ownership

- Overview files summarize the current game and production shape.
- Gameplay files own mechanics and system rules.
- Lore files own fiction and canon.
- Character files own recurring named-character identity.
- Content files own regional rosters and encounter identity.
- UI files own interaction and presentation behavior.
- Art files own visual requirements and technical delivery.
- Milestone files own outsourcing scope and dependencies.
- `OPEN_QUESTIONS.md` owns only the current unresolved design agenda.

When two files conflict, the authority assigned in `SOURCE_OF_TRUTH.md` wins. Correct the dependent summary rather than preserving both versions.

## Depth rule

Resolve a question only to the level needed for the current design stage.

A high-level scope pass should establish identity, purpose, boundaries, dependencies, and required content volume. It should not invent final attack lists, exact numerical tuning, frame counts, or encounter timings before implementation and playtesting.

## Duplication rule

Do not copy complete definitions into overview, milestone, or tracker files.

- Authoritative files contain the full rule.
- Overview files contain only what is needed to understand the game.
- Milestones contain only what must be produced and what must be locked before quotation.
- Related files should link to the authority instead of maintaining parallel versions.

## Pull-request audit

A substantial documentation pull request should state:

- the requested change,
- authoritative files changed,
- major dependent files reviewed,
- production-scope impact,
- questions created, combined, resolved, or deferred,
- and whether outdated references remain.

Avoid listing every search term or unchanged file unless it materially helps review.