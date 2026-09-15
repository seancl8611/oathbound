# Oathbound 3D Asset Slots

This directory is the production landing zone for real-time 3D assets used by the planar-combat presentation bridge.

## Character slots

The current runtime checks for these imported Godot scenes first:

- `Characters/Akio/akio.glb`
- `Characters/HushiroSwordsman/hushiro_swordsman.glb`
- `Characters/BlightedHound/blighted_hound.glb`

If a slot is absent, `Planar3DActorVisual.gd` builds a procedural real-time 3D fallback so the gameplay migration remains testable without final art.

The intended source workflow is:

`approved concept/reference -> model -> cleanup -> materials/textures -> rig -> animation/retargeting -> GLB -> Godot`

AI-generated meshes may be used as starting points, but hero characters and important enemies should be manually checked for topology, deformation, silhouette, texture artifacts and concept fidelity before being treated as final production art.

## Animation

Humanoid production models should prefer a retargetable humanoid skeleton. Shared locomotion/reaction clips can use a compatible animation library; signature combat actions should be customized where needed for Oathbound's timing and martial identity.

The current zero-cost prototype candidates are Quaternius' CC0 Universal Base Characters and Universal Animation Library. Their assets are not bundled in this repository by this file; any third-party files that are later committed must include source/license provenance.

## Runtime ownership

The current bridge deliberately keeps the existing Node2D combat actors authoritative. A 3D model mirrors position, facing and action state only. Do not move damage, hitbox, pressure, encounter or balance authority into a model asset without an explicit gameplay migration.

Replacement visuals are exclusive. When a 3D body is active, legacy body Sprite2D/AnimatedSprite2D art must remain hidden rather than rendering underneath it.
