# Oathbound Documentation

This directory is the internal source of truth for Oathbound design, lore, content, UI/UX, art production, and production planning.

## Start here

Read these files in order for broad design work:

1. [Game overview](overview/GAME_OVERVIEW.md)
2. [Full game scope](overview/FULL_GAME_SCOPE.md)
3. [Current design questions](_meta/OPEN_QUESTIONS.md)
4. [Source of truth](_meta/SOURCE_OF_TRUTH.md)
5. The authoritative file for the subject being discussed

## Authoritative sections

- [Gameplay](gameplay/README.md)
- [Lore](lore/README.md)
- [Characters](characters/README.md)
- [Regional content](content/README.md)
- [Art production](art_production/README.md)
- [UI/UX](ui_ux/README.md)

## Repository control files

- [`_meta/SOURCE_OF_TRUTH.md`](_meta/SOURCE_OF_TRUTH.md) assigns ownership.
- [`_meta/OPEN_QUESTIONS.md`](_meta/OPEN_QUESTIONS.md) contains only current unresolved design priorities.
- [`_meta/ASSISTANT_WORKFLOW.md`](_meta/ASSISTANT_WORKFLOW.md) defines the update and review process.
- [`_meta/DOCUMENT_MAP.md`](_meta/DOCUMENT_MAP.md) provides non-exhaustive dependency hints.
- [`_meta/TERMINOLOGY.md`](_meta/TERMINOLOGY.md) defines preferred and deprecated wording.
- [`_meta/DECISION_LOG.md`](_meta/DECISION_LOG.md) is historical context, not a substitute for current authoritative files.

Resolved questions should be removed from the tracker after the authoritative documents are updated. Exact tuning remains in the gameplay or encounter file that owns it.

## External documents

Markdown remains authoritative. Contractor-ready Word and PDF files are generated exports tracked under `docs/external/` and `contractor_docs/`.