---
id: META-ASSISTANT-WORKFLOW
title: Assistant Update Workflow
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-23
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

## Design-status discipline

Before treating any statement as settled, check both the document frontmatter and the wording around the statement.

- **Approved:** authoritative only to the depth explicitly approved in the file.
- **Draft:** working material that may be revised, replaced, combined, or cut.
- **Candidate, likely, proposed, current direction, working, illustrative, or example:** not approved unless the authoritative file explicitly says otherwise.
- A detailed mechanic, named roster, count, table, trial, asset list, or production note is not automatically approved because it is specific.
- A dependent file cannot promote a draft statement into a locked decision.
- Historical commits and decision logs explain prior thinking but do not override current status.

When the user reopens a prior decision, downgrade the authoritative status and correct dependent summaries before continuing deeper design.

## Prerequisite check before proposing the next question

Before asking or answering a detailed design question:

1. identify its parent decision,
2. confirm that the parent decision is approved,
3. confirm that the roster, count, identity, or system boundary it assumes is approved,
4. and check `OPEN_QUESTIONS.md` for an earlier dependency.

Do not design a named character, Aspect, Tier, ability, trial, Technique interaction, or asset package as final while its identity, inclusion, or parent system remains draft.

When several questions remain, present the earliest unresolved dependency as one concise question. Do not answer a broad package through an unnecessarily long speculative design.

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

## Question classification

Before adding a question, classify the missing decision:

- **Current production-scope decision:** changes initial-release content counts, required systems, authored presentation, interfaces, milestones, or quotation boundaries. Track it in `OPEN_QUESTIONS.md`.
- **Later system or encounter design:** defines routing, room composition, movesets, detailed effects, or feature behavior that can be resolved when that feature is designed. Record it only in the owning file when useful.
- **Playtest or balance variable:** depends on real combat feel, timing, economy, probability, or numerical tuning. Keep it out of the top-level tracker.
- **Resolved direction:** update the authority and remove the question.
- **Deliberate mystery or creative boundary:** preserve it as canon rather than treating it as missing information.

A question is not important merely because it can be asked. It belongs in the tracker only when answering it is necessary to define the initial game or plan its production.

## Question priority

Order current questions by dependency:

1. foundational system purpose, roster, count, and identity decisions,
2. content inventories that other systems consume,
3. unlock, progression, onboarding, and hub scope built around those inventories,
4. authored narrative and presentation packages,
5. release-completion and postgame scope.

Do not prioritize a child mechanic above an unresolved parent identity or roster decision simply because the child mechanic is easier to describe.

## Question hygiene

`OPEN_QUESTIONS.md` contains only unresolved decisions that materially affect current scope, content volume, production planning, or authored presentation.

- Remove a question once its authoritative answer is recorded.
- Do not keep resolved-question summaries in the tracker.
- Do not promote exact tuning values into top-level scope questions.
- Keep frame counts, cooldowns, probabilities, attack timings, and playtest values in the owning gameplay or encounter file.
- Keep exact room counts, route topology, branch frequency, and miniboss frequency out of the tracker until prototyping proves they create a production-scope change.
- Combine overlapping questions around the production decision they block.
- Remove subquestions already answered by authoritative files.
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

A high-level scope pass should establish identity, purpose, boundaries, dependencies, and required content volume. It should not invent final attack lists, exact numerical tuning, frame counts, encounter timings, route probabilities, or final scripts before their design and production stages.

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
