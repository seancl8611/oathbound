# Oathbound 3D Asset Slots

This directory is the production landing zone for real-time 3D assets used by the planar-combat presentation bridge.

## Character slots

The current Hushiro V2 runtime checks these canonical production/replacement slots first:

- `Characters/Akio/akio.glb`
- `Characters/HushiroSwordsman/hushiro_swordsman.glb`
- `Characters/BlightedHound/blighted_hound.glb`
- `Characters/Hollow/hollow.glb`
- `Characters/HushiroArcher/hushiro_archer.glb`
- `Characters/CellarBilemass/cellar_bilemass.glb`
- `Characters/HushiroWarden/hushiro_warden.glb`

A path merely existing is **not** enough to displace the current presentation. `Planar3DActorVisual.gd` rejects external scenes that do not contain renderable mesh geometry, and the bridge only hides an authoritative legacy actor after a renderable replacement has been built successfully.

If a production slot is absent or rejected, Hushiro V2 falls back by role:

- Akio and Swordsman use the audited Quaternius CC0 humanoid + remapped Universal Animation Library tier;
- Blighted Hound uses its authored Hushiro predator silhouette;
- Hollow, Archer, Bilemass and Warden use authored role-specific Hushiro blockout silhouettes;
- the shared anonymous procedural actor remains a final safety net outside those covered Hushiro roles, not the intended Hushiro V2 presentation.

Do **not** copy an arbitrary downloaded model directly into a runtime slot. Third-party assets enter through the intake area first, are validated in Godot, and only become a live actor after scale/rig/material/animation review.

Runtime diagnostics intentionally distinguish three production-model states:

1. **slot exists** — a resource is present at the canonical path;
2. **role spawned** — that semantic actor role currently has a live presentation actor;
3. **production model active** — the spawned actor actually accepted and is rendering the role-specific GLB.

This distinction prevents an empty, malformed, or rejected file from being reported as a successful production-art handoff.

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

Production animation remains presentation-driven by authoritative combat state. Root motion from an imported model is not allowed to silently move the gameplay proxy or redefine attack timing, range, invulnerability, damage, Pressure Director admission, or encounter logic.

## Rendering target

Real-time 3D is not an excuse to look like a conventional chunky 3D action game. The presentation target is:

> **a real 3D world deliberately trying to read like illustrated 2D at gameplay distance.**

That means flatter orthographic three-quarter framing, controlled values, restrained PBR/specular response, strong silhouettes, painterly/toon material treatment, and selective depth/shadow cues. Imported assets are raw ingredients and must be visually unified before they become representative Oathbound placeholders.

## Runtime ownership

The current bridge deliberately keeps the existing Node2D combat actors authoritative. A 3D model mirrors position, facing and action state only. Do not move damage, hitbox, pressure, encounter or balance authority into a model asset without an explicit gameplay migration.

Replacement visuals are exclusive and fail-safe. When a valid 3D body is active, legacy body Sprite2D/AnimatedSprite2D art stays hidden rather than rendering underneath it. If replacement creation fails or becomes non-renderable, the authoritative legacy actor is restored instead of disappearing.
