# Oathbound 3D Asset Slots

This directory is the production landing zone for real-time 3D assets used by the planar-combat presentation bridge.

## Character slots

The current runtime checks for these production/replacement slots first:

- `Characters/Akio/akio.glb`
- `Characters/HushiroSwordsman/hushiro_swordsman.glb`
- `Characters/BlightedHound/blighted_hound.glb`

If a slot is absent, `Planar3DActorVisual.gd` builds a procedural real-time 3D fallback so gameplay migration remains testable without final art.

Do **not** copy an arbitrary downloaded model directly into one of these three runtime slots. Third-party assets enter through the intake area first, are validated in Godot, and only become a live actor after scale/rig/material/animation review.

## Automated third-party intake

Curated reusable assets live under:

`Art3D/ThirdParty/<Creator>/<Pack>/...`

Their machine-readable source of truth is:

`tools/assets/asset_manifest.json`

The sync workflow:

`.github/workflows/sync-third-party-assets.yml`

uses `tools/assets/fetch_assets.py` to download only explicitly approved files, verify their license/destination policy and SHA-256, run a headless Godot import check, and commit verified binary assets back to the active development branch when necessary.

Human-readable provenance is kept in `docs/assets/THIRD_PARTY_ASSETS.md`.

This lets Oathbound use public CC0 character/animation/environment assets without requiring the project owner to manually download, unzip, rename, or place files. A broken/removed/mutated remote asset fails the intake job instead of silently changing the game.

## Character production path

The intended source workflow is:

`approved concept/reference -> reusable base/kitbash or model -> cleanup -> materials/textures -> rig -> animation/retargeting -> reviewed runtime slot -> Godot`

For the placeholder phase, the preferred order is:

1. audited CC0 humanoid/animation foundations;
2. Oathbound-specific kitbash/silhouette/material treatment;
3. free CC0 creature/environment assets where they fit;
4. AI-generated candidates only where identity-specific geometry adds enough value;
5. bespoke/commissioned production art after the camera/rendering direction proves itself.

AI-generated meshes may be used as starting points, but hero characters and important enemies must be checked for topology, deformation, silhouette, texture artifacts, rig compatibility and concept fidelity before being treated as final production art.

## Animation

Humanoid production models should prefer a retargetable humanoid skeleton. Shared locomotion/reaction clips can use a compatible animation library; signature combat actions should be customized where needed for Oathbound's timing and martial identity.

The zero-cost bootstrap uses Quaternius' CC0 Universal Base Characters and Universal Animation Library as audited references. These files are staged under `ThirdParty/` rather than pretending that the stock character is Akio.

## Rendering target

Real-time 3D is not an excuse to look like a conventional chunky 3D action game. The presentation target is:

> **a real 3D world deliberately trying to read like illustrated 2D at gameplay distance.**

That means flatter orthographic three-quarter framing, controlled values, restrained PBR/specular response, strong silhouettes, painterly/toon material treatment, and selective depth/shadow cues. Imported assets are raw ingredients and must be visually unified before they become representative Oathbound placeholders.

## Runtime ownership

The current bridge deliberately keeps the existing Node2D combat actors authoritative. A 3D model mirrors position, facing and action state only. Do not move damage, hitbox, pressure, encounter or balance authority into a model asset without an explicit gameplay migration.

Replacement visuals are exclusive. When a 3D body is active, legacy body Sprite2D/AnimatedSprite2D art must remain hidden rather than rendering underneath it.
