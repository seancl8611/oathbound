---
id: ART-TECHNICAL-STANDARDS
title: Art Technical Standards
category: art-production
status: approved
authority: primary
last_reviewed: 2026-09-14
topics:
  - stylized-3d
  - gltf
  - godot-import
  - rigging
  - animation-retargeting
  - ai-assisted-assets
  - third-party-assets
  - naming
  - delivery
related:
  - ART-DIRECTION
  - ART-OUTSOURCING-WORKFLOW
  - OVERVIEW-STYLIZED-3D-PRESENTATION
---

# Art Technical Standards

These are the current defaults for Oathbound's **real-time stylized 3D production pipeline**. The fixed high-angle camera and planar combat contract remain the primary constraints. Final art should be judged from gameplay distance before close-up polish.

## Runtime standard

| Category | Standard |
|---|---|
| Production representation | Real-time stylized 3D by default |
| Camera | Fixed high-angle / three-quarter Camera3D; little or no player-controlled rotation |
| Gameplay plane | X/Z ground plane; vertical representation does not imply unrestricted vertical gameplay |
| Preferred interchange | glTF 2.0 / GLB |
| Character delivery | Game-ready model + materials/textures + rig + animation-ready skeleton |
| Environment delivery | Modular 3D kit pieces with clean pivots, consistent scale, and collision/occlusion intent documented |
| Godot target | Godot 4.x, current project uses 4.7 feature level |
| UI/illustration | 2D remains valid for HUD, portraits, Technique/Relic art, story art, decals, and selected VFX |
| Hades-style prerender | Optional later A/B fallback, not the current default runtime |

## Coordinate and scale contract

The live migration bridge currently maps authoritative 2D combat coordinates to 3D at **64 gameplay pixels = 1 meter**:

`Vector2(x, y) -> Vector3(x / 64, 0, y / 64)`

This is a migration scale, not a permanent physics mandate. Production models should nevertheless be authored near sensible meter scale so replacement assets do not need extreme import scaling.

Working prototype targets:

- Akio: approximately 1.8–2.0 m visual height;
- standard humanoids: approximately 1.7–2.1 m depending on role;
- Hound: approximately 0.7–1.0 m shoulder/head height with a longer ground footprint;
- large standard/controller enemies: scale by silhouette and gameplay footprint, not realism alone;
- bosses: established relative to Akio and camera readability.

The character origin/pivot should sit at the gameplay contact point between the feet and ground unless a specific creature rig requires a documented exception.

## Character model standard

Priorities, in order:

1. gameplay silhouette;
2. weapon and hand readability;
3. rig deformation around major combat poses;
4. cloth/armor mass that supports the character identity;
5. materials that survive dark lighting;
6. corruption landmarks and regional identity;
7. close-up detail only after the above are proven.

Avoid spending polygon or texture budget on facial/detail work that cannot be read from the normal camera.

For humanoids, prefer a clean humanoid skeleton compatible with Godot retargeting. Keep weapon attachment points explicit. Akio should have stable anchors for katana hand, sheath, weapon-tip/VFX, prosthetic/equipment, and future cloth/secondary motion.

## Animation standard

Animation is rig-driven 3D by default.

Required principles:

- combat impact timing remains authored by gameplay; animation must match those windows rather than redefining them;
- locomotion/reactions may be shared or retargeted across compatible humanoid rigs;
- signature attacks should receive custom animation when generic motion weakens role identity;
- root motion is not automatically authoritative; planar gameplay movement remains owned by the combat runtime unless a specific migration explicitly changes that contract;
- imported animation libraries must be tested for scale, root motion, foot sliding, facing axis, and bone mapping before production use;
- animation names should remain semantic and stable enough to map from combat actions.

Working clip families:

- idle / ready;
- locomotion in the required directions or a retargetable directional locomotion set;
- dash / evasive movement;
- basic attack chain;
- special/Technique attacks;
- guard/parry/special-response poses where relevant;
- hit/interruption reactions;
- death;
- boss/miniboss execution or phase-specific clips as authored.

## Materials and textures

Real-time 3D should look deliberately illustrated rather than physically neutral.

Allowed/encouraged techniques include:

- hand-painted albedo/value control;
- restrained roughness and metallic response;
- stylized normal detail where it remains readable;
- toon/painterly light ramps;
- selective outlines/ink accents;
- rim accents for silhouette separation;
- controlled baked or painted value gradients;
- decals for blood, grime, ritual marks, and region-specific wear.

Avoid depending on expensive material complexity where a simpler reusable shader produces the same gameplay read.

## AI-assisted asset policy

AI generation is allowed as a **production accelerator**, especially for prototype meshes, blockout props, texture exploration, concept-to-3D drafts, and variant generation.

Generated assets are not automatically production-ready. Before shipping, important assets should be checked for:

- silhouette accuracy against approved concept/reference art;
- topology and deformation quality;
- UV/material consistency;
- rig quality and bone naming;
- animation compatibility;
- hidden/non-manifold/internal geometry;
- texture artifacts or unintended symbols/details;
- polygon/texture budget;
- legal/license provenance of the generation workflow and source inputs.

Hero characters and bosses should receive manual cleanup even when AI supplies the starting mesh.

## Public / third-party asset policy

CC0 is preferred for raw assets that may be committed and redistributed with the repository.

Current approved prototype candidates include:

- **Quaternius Universal Base Characters** — CC0, humanoid rig, game-ready topology, glTF support;
- **Quaternius Universal Animation Library** — CC0, Godot-tested humanoid animation library suitable for retargeting;
- **Kenney CC0 3D kits** — useful for temporary environment/prop blockout where their visual language does not become final art by accident.

Any committed third-party asset must have its source, license, and modification status recorded. Placeholder use does not automatically approve the asset as final Oathbound art.

Do not commit raw assets whose license forbids redistribution. For non-CC0/non-permissive sources, verify the actual license before repository inclusion.

## Replacement model contract

The live 3D actor visual runtime currently checks these production slots first:

- `res://Art3D/Characters/Akio/akio.glb`
- `res://Art3D/Characters/HushiroSwordsman/hushiro_swordsman.glb`
- `res://Art3D/Characters/BlightedHound/blighted_hound.glb`

If a production/AI model is present there, the visual bridge can use it instead of its procedural fallback. Replacement visuals remain exclusive: old body sprites must stay hidden while the 3D representation is active.

## Environment modularity

Environment production should favor reusable kits rather than one giant unique mesh per room.

Examples for Hushiro:

- wall and broken-wall modules;
- torii/gate pieces;
- house and roof modules;
- fences/barricades;
- stone path pieces;
- rocks/debris;
- dead trees/vegetation;
- shrine/lantern props;
- decals and corruption overlays.

Room composition may combine unique hero landmarks with shared modular pieces. Collision/gameplay bounds remain authored independently from decorative geometry during the migration.

## Naming

Recommended model/source naming:

`ASSETID_assetname_LOD#.glb`

`ASSETID_assetname_source.blend`

Animation clips:

`assetname_action_variant`

Examples:

- `PC_AKIO_akio_LOD0.glb`
- `EN_A1_SWORDSMAN_hushiro_swordsman_LOD0.glb`
- `akio_quick_slash_01`
- `hushiro_swordsman_attack_windup`

Preserve the same asset identity across concept sheets, source models, textures, rigs, animations, previews, inventory entries, and contractor briefs.

## Delivery-folder baseline

Each production batch should contain the relevant subset of:

- `/Models`
- `/Textures`
- `/Source`
- `/Animations`
- `/Previews`
- `/Notes`
- `/Licenses`

Reference folders and delivery folders must remain separate so visual references cannot be mistaken for approved deliverables.

## Acceptance checks

- model scale and ground pivot are correct;
- silhouette reads from the gameplay camera;
- weapon and attack direction are immediately readable;
- rig deformation survives required poses;
- animation timing matches gameplay impact windows;
- imported materials remain legible in representative dark lighting;
- no old body sprite/model renders underneath the replacement;
- model/animation imports into Godot without manual repair every run;
- environment props do not create uncontrolled combat occlusion;
- performance is validated at the project's 640×360 internal / 1280×720 display target;
- license/provenance is recorded for external assets.
