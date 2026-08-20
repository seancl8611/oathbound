# Oathbound Godot Project

The canonical Oathbound Godot project is committed at:

`game/oathbound/`

## Engine baseline

Use **Godot v4.7.2.stable.official [ed1daf0bf]** for implementation and playtesting.

The imported prototype originated on Godot 4.0. The repository is being progressively reconciled against the 4.7.2 baseline and the current Oathbound design authority.

## Project organization

Current implementation should prefer the canonical structure inside `game/oathbound/`:

- `Core/` — shared gameplay infrastructure such as chamber and encounter plumbing.
- `Regions/Hushiro/` — current Hushiro-specific chambers, encounters, and enemies.
- `Enemy/Area 2` and `Enemy/Area 3` — imported later-region compatibility content pending their own reconciliation passes.
- `Areas/Area1` and `Enemy/Area 1` — deprecated compatibility shims only; do not add new implementation there.
- `Legacy/` — explicitly retired prototype resources retained only for reference or compatibility.
- `Utility/`, `autoload/`, `Player/`, `World/`, `GUI/`, and asset directories — existing shared systems that have not yet been reorganized into feature ownership.

Use **Chamber** for playable run-room code and filenames. Current route-role vocabulary is `combat`, `shrine`, `merchant`, `rest`, `miniboss`, and `boss`; legacy `shop` / `treasure` identifiers may remain only as compatibility aliases until later-region routing is reconciled.

## Clean checkout workflow

1. Pull or download the repository revision/branch you want to test.
2. Open `game/oathbound/project.godot` in the pinned Godot 4.7.2 editor.
3. Allow Godot to rebuild its local import cache on first open.
4. Do not commit `.godot/`, `.import/`, generated export credentials, or other ignored editor caches.
5. Run the game from the title-screen main scene and report parser, import, resource, runtime, or gameplay errors against the exact revision tested.

The repository copy is the shared implementation source of truth. Local-only scripts/resources should be committed before they are treated as part of the game.

## Validation

On Windows, `game/oathbound/tools/validate_project.ps1` checks the local Godot build and runs a headless full-resource import against the project. This does not replace playtesting, but it gives us a repeatable parser/import sanity check before subjective testing.

The authoritative gameplay/narrative design remains under `docs/`; compatibility code inside the imported prototype can be superseded by those current documents during reconciliation.
