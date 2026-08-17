# Oathbound Documentation

Markdown under `docs/` is Oathbound's internal source of truth for design, lore, content, UI/UX, art production, and production planning.

## Fast lookup

For most design work, read in this order:

1. [Current Design Questions](_meta/OPEN_QUESTIONS.md) — unresolved agenda only.
2. [Source of Truth](_meta/SOURCE_OF_TRUTH.md) — find the owning file.
3. [Terminology](_meta/TERMINOLOGY.md) — canonical and deprecated search anchors.
4. The authoritative file for the subject.
5. [Document Review Map](_meta/DOCUMENT_MAP.md) — likely dependencies when needed.

Use [Game Overview](overview/GAME_OVERVIEW.md) and [Full Game Scope](overview/FULL_GAME_SCOPE.md) when the question is game-wide or production-wide rather than for every narrow mechanic edit.

## Authoritative sections

- [Gameplay](gameplay/README.md)
- [Lore](lore/README.md)
- [Characters](characters/README.md)
- [Regional content](content/README.md)
- [Art production](art_production/README.md)
- [UI/UX](ui_ux/README.md)

## Repository control files

- [`_meta/SOURCE_OF_TRUTH.md`](_meta/SOURCE_OF_TRUTH.md) — ownership registry.
- [`_meta/OPEN_QUESTIONS.md`](_meta/OPEN_QUESTIONS.md) — unresolved priorities only.
- [`_meta/TERMINOLOGY.md`](_meta/TERMINOLOGY.md) — preferred/deprecated terms and search anchors.
- [`_meta/ASSISTANT_WORKFLOW.md`](_meta/ASSISTANT_WORKFLOW.md) — assistant read/update workflow, including the fallback when GitHub code search is unavailable.
- [`_meta/DOCUMENT_MAP.md`](_meta/DOCUMENT_MAP.md) — non-exhaustive dependency hints.
- [`_meta/UPDATE_PROTOCOL.md`](_meta/UPDATE_PROTOCOL.md) — material-change protocol.
- [`_meta/DECISION_LOG.md`](_meta/DECISION_LOG.md) — concise major-decision history.
- [`_meta/CHANGELOG.md`](_meta/CHANGELOG.md) — concise documentation-change history.

## Search reliability

If GitHub code search is unavailable or unindexed, do not treat an empty result as proof that a term does not exist. Follow the direct-read fallback in `ASSISTANT_WORKFLOW.md`: authority → terminology → dependency map → relevant files → branch diff / PR patch.

## Documentation hygiene

- Complete rules live only in their authority.
- Overview/roadmap files summarize; they do not maintain duplicate mechanics tables.
- `OPEN_QUESTIONS.md` contains unresolved work, not resolved design history.
- Exact playtest tuning remains in the gameplay/encounter file that owns it.
- Word/PDF files are exports; Markdown remains authoritative.
