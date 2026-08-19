# Oathbound Godot Engine Baseline

## Pinned editor/runtime

- Version: `v4.7.2.stable.official`
- Build hash: `ed1daf0bf`
- Project root: `game/SurvivorsClone_Complete-main/`
- Previous project baseline: Godot 4.0 stable

This exact 4.7.2 build is the implementation/playtest baseline until the repository explicitly changes it.

## Migration contract

The project is being migrated in-place from the imported Godot 4.0 prototype. The migration does **not** make legacy gameplay architecture authoritative. Current design authority remains under `docs/` and implementation is reconciled package-by-package.

Generated editor/import state is intentionally not versioned. A clean checkout should rebuild `.godot/` locally under the pinned editor.

## Static 4.0 -> 4.7 audit

Godot's official minor-version migration guides were reviewed from 4.0 through 4.7. The current project is a 2D GDScript project, so many C#, 3D, and GDExtension compatibility breaks do not apply to the critical runtime paths inspected so far.

High-risk migration areas that require explicit validation when encountered:

- removed/renamed 2D navigation APIs introduced during the 4.0 -> 4.1 transition,
- removed engine/editor methods in later 4.x releases,
- resource/import format upgrades performed by newer editors,
- behavior changes that only surface when scenes are loaded or exercised at runtime.

The connected GitHub code-search index was not reliable for a repository-wide symbol scan, so this is a bounded direct-read audit rather than a claim that every legacy file has already been proven 4.7-compatible.

## Required validation before this baseline is treated as clean

1. Run `tools/validate_project.ps1` with the pinned Godot executable.
2. Confirm the full resource import completes without parser/import errors.
3. Open the project in the 4.7.2 editor and allow any editor-owned resource upgrade to complete.
4. Run the title-screen/main-game path.
5. Report and fix any parser, missing-resource, scene-load, or runtime errors.
6. Commit only source/resource changes produced by the migration that belong in version control; do not commit `.godot/` caches.

After this engine baseline is validated, gameplay reconciliation branches should target the 4.7.2 project rather than Godot 4.0 behavior.
