# Oathbound

Private source repository for Oathbound game design, lore, content, art production, contractor-ready source material, and the Godot project.

## Documentation

The authoritative internal documentation lives under [`docs/`](docs/README.md).

Start with:

- [Game Overview](docs/overview/GAME_OVERVIEW.md)
- [Full Game Scope](docs/overview/FULL_GAME_SCOPE.md)
- [Production Roadmap](docs/overview/PRODUCTION_ROADMAP.md)
- [Source of Truth Map](docs/_meta/SOURCE_OF_TRUTH.md)
- [Assistant Update Workflow](docs/_meta/ASSISTANT_WORKFLOW.md)
- [Open Questions](docs/_meta/OPEN_QUESTIONS.md)

## Repository model

- `docs/` — authoritative Markdown design and production documentation
- `contractor_docs/` — generated Word/PDF contractor deliverables and templates
- `art/` — references, concepts, approved source art, and exports
- `assets/` — game-ready imported assets
- `game/` — Godot project

## Change workflow

Major changes should use focused branches and pull requests. Update the authoritative file first, review dependencies, search for contradictions, and record major approved decisions.

Word and PDF files are external deliverables. Markdown remains the internal source of truth.
