---
id: META-ASSISTANT-WORKFLOW
title: Assistant Update Workflow
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-14
---

# Assistant Update Workflow

This repository is structured so an assistant can apply lore, gameplay, content, or production changes consistently without treating one giant document or one static dependency map as complete.

## Required process for a meaningful change

1. Identify the authoritative file using `SOURCE_OF_TRUTH.md`.
2. Read the authoritative file in full before editing.
3. Build a live search set from the requested change: exact terms, old wording, synonyms, character names, system names, region names, and likely production/UI consequences.
4. Search the current repository and open only files with relevant matches.
5. Use `DOCUMENT_MAP.md` only as a non-exhaustive starting checklist.
6. Classify each relevant match as authoritative, dependent summary, production scope, contractor export, historical record, or unrelated.
7. Update the authoritative file first.
8. Update only the dependent files whose meaning or scope actually changes.
9. Search the repository again for outdated wording, contradictions, and missed references.
10. Preserve stable document IDs and status fields.
11. Add a decision-log entry when the user explicitly approves a major direction.
12. Add unresolved consequences to `OPEN_QUESTIONS.md` rather than inventing answers.
13. Update the asset inventory and milestone files only when production scope changes.
14. Use a focused branch and pull request unless the user explicitly requests a direct commit.

## Search-depth rule

Do not read the entire repository by default. Start broad with repository search, then narrow to relevant files. Expand the search only when the change touches foundational concepts such as Akio, Returning Blood, the Order, combat rules, run structure, regional rosters, or milestone ownership.

## Completion standard

A change is not complete merely because every file listed in `DOCUMENT_MAP.md` was checked. Completion requires:

- the authoritative file updated,
- live repository searches performed,
- relevant matches reviewed,
- a post-edit contradiction search completed,
- production consequences checked when applicable,
- unresolved effects recorded instead of guessed.

## Interpretation rules

- `locked` information overrides draft summaries.
- Gameplay files own mechanics; lore files own fiction; content files own rosters and encounter identity; milestone files own outsourcing scope.
- A contractor brief may summarize a mechanic but should point back to its authoritative internal document.
- Do not silently promote a working assumption to approved design.
- Do not edit unrelated systems merely to make a requested change appear more complete.
- Open questions do not hold equal narrative, gameplay, or production weight. Resolve each only to the level needed for consistency and dependency progress. A minor continuity beat should not receive the same depth or scope as a decision that reshapes the game, campaign, or production plan.

## Adding new content

When adding a new system, character, area, or milestone:

1. Create a stable document ID and authoritative file.
2. Add it to `SOURCE_OF_TRUTH.md` when it owns a new major subject.
3. Add concise `topics` and `related` metadata when those relationships are genuinely useful.
4. Search the live repository for existing references or overlapping concepts.
5. Add terminology only for recurring proper names or system labels.
6. Update full scope, asset inventory, roadmap, and milestones only when applicable.

## Required pull-request audit

Every substantial documentation pull request should include:

- change requested,
- authoritative files changed,
- search terms used,
- relevant files reviewed,
- files changed,
- production-scope impact,
- open questions created or resolved,
- remaining outdated references, or `none found`.