---
id: META-ASSISTANT-WORKFLOW
title: Assistant Update Workflow
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-10
---

# Assistant Update Workflow

This repository is structured so an assistant can apply a lore, gameplay, content, or production change consistently without treating one giant document as the source of truth.

## Required process for a change request

1. Read `SOURCE_OF_TRUTH.md` to identify the authoritative file.
2. Read the relevant authoritative file before editing.
3. Read `DOCUMENT_MAP.md` to identify dependent files.
4. Search the repository for the old term, rule, name, or mechanic.
5. Update the authoritative file first.
6. Update only the necessary summaries and production consequences.
7. Preserve stable document IDs and status fields.
8. Add a decision-log entry when the user explicitly approves a major direction.
9. Add unresolved consequences to `OPEN_QUESTIONS.md` rather than inventing answers.
10. Update the asset inventory and milestone only when asset scope changes.
11. Use a focused branch and pull request unless the user explicitly requests a direct commit.

## Interpretation rules

- `locked` information overrides draft summaries.
- Gameplay files own mechanics; lore files own fiction; content files own rosters and encounter identity; milestone files own outsourcing scope.
- A contractor brief may summarize a mechanic but should link back to its authoritative internal document.
- Do not silently promote a working assumption to approved design.
- Do not edit unrelated systems merely to make a requested change seem more complete.

## Adding new content

When adding a new system, character, area, or milestone:

1. Create a stable document ID.
2. Add the authoritative file in the correct folder.
3. Add it to `SOURCE_OF_TRUTH.md`.
4. Add dependency routes to `DOCUMENT_MAP.md`.
5. Add terminology if it introduces a proper name or system label.
6. Update full scope, asset inventory, and roadmap only when applicable.

## Preferred pull-request summary

- Change requested
- Authoritative files changed
- Dependent files reviewed
- Production-scope impact
- Open questions created or resolved
- Statements intentionally left unchanged
