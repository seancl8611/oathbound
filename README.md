# Oathbound

Private source repository for Oathbound game design, lore, content, UI/UX, art production, contractor source material, and the Godot project.

## Documentation

Authoritative internal documentation lives under [`docs/`](docs/README.md).

For design work, start with:

1. [Current Design Questions](docs/_meta/OPEN_QUESTIONS.md) — unresolved agenda.
2. [Source of Truth](docs/_meta/SOURCE_OF_TRUTH.md) — find the owning document.
3. [Terminology](docs/_meta/TERMINOLOGY.md) — canonical/deprecated search anchors.
4. The authoritative file for the subject.
5. [Document Review Map](docs/_meta/DOCUMENT_MAP.md) when dependency hints are needed.

Use [Game Overview](docs/overview/GAME_OVERVIEW.md) and [Full Game Scope](docs/overview/FULL_GAME_SCOPE.md) for broad game/production context rather than as the first stop for every narrow update.

## Repository model

- `docs/` — authoritative Markdown design and production documentation
- `contractor_docs/` — generated contractor deliverables and export records
- `art/` — references, concepts, approved source art, and exports
- `assets/` — game-ready imported assets
- `game/` — Godot project

## Change workflow

Major changes use focused branches and pull requests.

Update the authoritative file first, review live dependencies, remove stale/duplicated statements, and keep only unresolved design priorities in `docs/_meta/OPEN_QUESTIONS.md`.

If GitHub code search is unavailable or unindexed, use the direct-read fallback documented in [`ASSISTANT_WORKFLOW.md`](docs/_meta/ASSISTANT_WORKFLOW.md) rather than treating empty search results as proof of consistency.

Exact tuning belongs in the gameplay or encounter file that owns it. Word/PDF files are exports; Markdown remains the internal source of truth.
