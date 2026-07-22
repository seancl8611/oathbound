# Oathbound

Private source repository for Oathbound game design, lore, content, UI/UX, art production, contractor source material, and the Godot project.

## Documentation

Authoritative internal documentation lives under [`docs/`](docs/README.md).

Start with:

1. [Game Overview](docs/overview/GAME_OVERVIEW.md)
2. [Full Game Scope](docs/overview/FULL_GAME_SCOPE.md)
3. [Current Design Questions](docs/_meta/OPEN_QUESTIONS.md)
4. [Source of Truth](docs/_meta/SOURCE_OF_TRUTH.md)
5. [Assistant Update Workflow](docs/_meta/ASSISTANT_WORKFLOW.md)

## Repository model

- `docs/` — authoritative Markdown design and production documentation
- `contractor_docs/` — generated contractor deliverables and export records
- `art/` — references, concepts, approved source art, and exports
- `assets/` — game-ready imported assets
- `game/` — Godot project

## Change workflow

Major changes should use focused branches and pull requests.

Update the authoritative file first, review live dependencies, remove stale or duplicated statements, and keep unresolved scope decisions in `docs/_meta/OPEN_QUESTIONS.md`.

Exact tuning belongs in the gameplay or encounter file that owns it. Word and PDF files are exports; Markdown remains the internal source of truth.