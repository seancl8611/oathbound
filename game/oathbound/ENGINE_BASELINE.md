# Oathbound Godot Engine Baseline

## Pinned editor/runtime

- Version: `v4.7.2.stable.official`
- Build hash: `ed1daf0bf`
- Project root: `game/oathbound/`
- Previous project baseline: Godot 4.0 stable

This exact 4.7.2 build is the implementation/playtest baseline until the repository explicitly changes it.

## Migration contract

The project was imported from a Godot 4.0 prototype and is now organized under the canonical Oathbound project root. The migration does **not** make legacy gameplay architecture authoritative. Current design authority remains under `docs/` and implementation is reconciled package-by-package.

Generated editor/import state is intentionally not versioned. A clean checkout should rebuild `.godot/` locally under the pinned editor.

## Static 4.0 -> 4.7 audit

Godot's official minor-version migration guides were reviewed from 4.0 through 4.7. The current project is a 2D GDScript project, so many C#, 3D, and GDExtension compatibility breaks do not apply to the critical runtime paths inspected so far.

High-risk migration areas that require explicit validation when encountered:

- removed/renamed 2D navigation APIs introduced during the 4.0 -> 4.1 transition,
- removed engine/editor methods in later 4.x releases,
- resource/import format upgrades performed by newer editors,
- behavior changes that only surface when scenes are loaded or exercised at runtime.

The connected GitHub code-search index has not been reliable for repository-wide symbol scans, so direct resource reads and explicit compatibility shims are used during structural migrations rather than assuming an empty search result proves a reference no longer exists.

## Required validation before this baseline is treated as clean

1. Run `tools/validate_project.ps1` from `game/oathbound/` with the pinned Godot executable.
2. Confirm the full resource import completes without parser/import errors.
3. Open `game/oathbound/project.godot` in the 4.7.2 editor and allow any editor-owned resource upgrade to complete.
4. Run the title-screen/main-game path.
5. Report and fix any parser, missing-resource, scene-load, or runtime errors.
6. Commit only source/resource changes produced by the migration that belong in version control; do not commit `.godot/` caches.

Gameplay reconciliation branches should target the 4.7.2 Oathbound project rather than imported Godot 4.0 behavior.
