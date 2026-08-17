---
id: META-ASSISTANT-WORKFLOW
title: Assistant Update Workflow
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - assistant-workflow
  - repository-search
  - github-connector
  - authority
  - documentation-maintenance
---

# Assistant Update Workflow

This repository is organized so an assistant can update Oathbound without relying on one oversized design document or duplicating rules across many files.

# Fast read order

For broad design work:

1. `docs/_meta/OPEN_QUESTIONS.md` — what is actually unresolved now.
2. `docs/_meta/SOURCE_OF_TRUTH.md` — which file owns the subject.
3. `docs/_meta/TERMINOLOGY.md` — canonical and deprecated search terms.
4. the authoritative file for the affected subject.
5. `docs/_meta/DOCUMENT_MAP.md` — likely dependent files only when needed.

Read `overview/GAME_OVERVIEW.md` and `overview/FULL_GAME_SCOPE.md` when the request changes game-wide identity, production scope, content counts, or release shape. Do not reread them for every narrow system edit.

# Design-status discipline

Before treating a statement as settled, check the owning document and its wording.

- **locked** — explicit canon/rule not to change casually.
- **approved** — accepted current design to the depth stated.
- **draft** — working direction with unresolved details.
- words such as `candidate`, `working`, `proposed`, `illustrative`, or `example` do not become approved merely because they are specific.
- dependent summaries cannot promote draft material into canon.
- historical logs explain prior decisions but never override current authorities.

When the user explicitly reopens a decision, update the authority and affected summaries rather than preserving two live versions.

# Required update process

1. Identify the authority in `SOURCE_OF_TRUTH.md`.
2. Read the authority before editing.
3. Build a search set from:
   - canonical terms,
   - synonyms,
   - deprecated terminology,
   - proper names,
   - likely dependent systems.
4. Find relevant dependencies.
5. Update the authority first.
6. Update only dependent files whose meaning or scope actually changed.
7. Recheck for stale wording and contradictions.
8. Update `OPEN_QUESTIONS.md` only when unresolved production-relevant work changes.
9. Record major locked direction in decision history.
10. Update milestones/assets only when production scope changes.
11. Use a focused branch and PR.

# Repository-search fallback

GitHub code search may be unavailable or unindexed for this repository. **Do not treat an empty code-search result as proof that no references exist.**

When search is unavailable:

1. use `SOURCE_OF_TRUTH.md` to identify the owner,
2. use canonical/deprecated terms in `TERMINOLOGY.md`,
3. use `DOCUMENT_MAP.md` to seed likely dependencies,
4. list the relevant directory when needed,
5. directly fetch the authority and likely dependent files,
6. inspect the complete branch-vs-main changed-file list / PR patch before merge,
7. state in the PR audit that validation used direct reads because live code search was unavailable.

This fallback is the approved connector-compatible workflow. It is better to make a bounded, explicit direct-read audit than to claim repository-wide coverage from an unavailable index.

# Information ownership

- Overview files summarize game/production shape.
- Gameplay files own mechanics and system rules.
- Lore files own fiction/canon.
- Character files own recurring named-character identity.
- Content files own regional rosters and encounter identity.
- UI files own interaction/presentation behavior.
- Art files own visual requirements/technical delivery.
- Milestone files own outsourcing scope and dependencies.
- `OPEN_QUESTIONS.md` owns only unresolved design priorities.

When files conflict, the authority in `SOURCE_OF_TRUTH.md` wins. Fix the dependent summary rather than preserving parallel definitions.

# Duplication rule

Do not copy full definitions into overview, roadmap, milestone, question-tracker, or history files.

- authority = complete rule,
- overview = enough to understand current shape,
- milestone = what must be produced,
- question tracker = unresolved decisions only,
- history = concise record of what changed.

Prefer links and short summaries over duplicate tables.

# Question hygiene

Before adding a question, classify it:

- **production-scope decision** — belongs in `OPEN_QUESTIONS.md`,
- **later system/encounter design** — belongs in its owning file,
- **playtest/balance variable** — stays in its owning file,
- **resolved direction** — remove from the tracker,
- **deliberate mystery/boundary** — preserve as canon, not a question.

Do not turn every numerical value, room composition, attack timing, rarity percentage, upgrade cost, or UI detail into a top-level agenda item.

# Dependency order

When several design questions remain, prefer:

1. system purpose / roster / identity,
2. content inventory consumed by other systems,
3. unlock / progression / hub ownership,
4. full-run integration and reward flow,
5. narrative delivery,
6. release/postgame scope,
7. final tuning after playable evidence.

Do not design a child feature as final while its parent system is unresolved.

# Metadata and searchability

For a material update:

- keep stable document IDs,
- update `last_reviewed`,
- add a small number of reusable `topics` when they improve discovery,
- use canonical terms from `TERMINOLOGY.md`,
- do not add large alias/keyword blocks that duplicate the body,
- remove stale `next task` wording when a dependency is resolved.

When introducing a new recurring concept, update `TERMINOLOGY.md` and `SOURCE_OF_TRUTH.md` only if they improve future discovery/ownership.

# Pull-request audit

A substantial documentation PR should state:

- requested design change,
- authorities changed,
- major dependencies reviewed,
- stale/superseded material removed,
- production-scope impact,
- unresolved consequences / next dependency,
- search method used, including whether code search was unavailable.

Before merge, inspect:

- branch-vs-main changed filenames,
- key authority patches,
- review threads,
- status checks if any.

Do not claim a full repository search when the search index was unavailable.
