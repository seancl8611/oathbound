# Oathbound Godot Project

The canonical Oathbound Godot project is committed at:

`game/SurvivorsClone_Complete-main/`

## Engine baseline

Use **Godot v4.7.2.stable.official [ed1daf0bf]** for implementation and playtesting.

The imported prototype originated on Godot 4.0. The repository is now being reconciled against the 4.7.2 baseline before further gameplay implementation proceeds.

## Clean checkout workflow

1. Pull or download the repository revision/branch you want to test.
2. Open `game/SurvivorsClone_Complete-main/project.godot` in the pinned Godot 4.7.2 editor.
3. Allow Godot to rebuild its local import cache on first open.
4. Do not commit `.godot/`, `.import/`, generated export credentials, or other ignored editor caches.
5. Run the game from the title-screen main scene and report parser, import, resource, runtime, or gameplay errors against the exact revision tested.

The repository copy is the shared implementation source of truth. Local-only scripts/resources should be committed before they are treated as part of the game.

## Validation

On Windows, `tools/validate_project.ps1` checks the local Godot build and runs a headless full-resource import against the project. This does not replace playtesting, but it gives us a repeatable parser/import sanity check before subjective testing.

The authoritative gameplay/narrative design remains under `docs/`; legacy code and content inside the imported Godot prototype can be superseded by those current documents during reconciliation.
