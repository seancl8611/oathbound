---
id: ART-TECHNICAL-STANDARDS
title: Art Technical Standards
category: art-production
status: approved
authority: primary
last_reviewed: 2026-09-16
topics:
  - isometric-2d
  - directional-sprites
  - rig-rendered-2d
  - blender
  - spriteframes
  - frame-registration
  - animation
  - illustrated-environments
  - ai-assisted-assets
  - third-party-assets
  - naming
  - delivery
related:
  - ART-DIRECTION
  - ART-RIG-RENDERED-2D-PIPELINE
  - OVERVIEW-ISOMETRIC-2D-PRESENTATION
  - ART-OUTSOURCING-WORKFLOW
---

# Art Technical Standards

These are the current technical defaults for Oathbound's **authoritative 2D / isometric-style presentation pipeline**. The normal runtime is Godot 2D. Offline 3D tools are allowed and encouraged where they improve character production, but they generate 2D deliverables rather than becoming live gameplay actors.

Final art is judged from the accepted gameplay camera before close-up polish.

## Runtime standard

| Category | Standard |
|---|---|
| Gameplay authority | Planar 2D (`Node2D` / `CharacterBody2D`) |
| Production camera | Fixed high-angle/isometric-style `Camera2D` |
| Accepted proving composition | zoom `0.50`, ground compression `0.72`, framing offset `(0, -12)` |
| Character runtime representation | Eight-direction 2D sprites / `SpriteFrames` |
| Character direction order | `e, se, s, sw, w, nw, n, ne` |
| Character depth | Feet/contact point with Y-based ordering |
| Environment runtime representation | Layered illustrated 2D |
| Combat VFX | Independent 2D presentation driven by gameplay state |
| Offline character source | Hand-drawn 2D or custom 3D model/rig/animation rendered to 2D |
| Godot target | Godot 4.x; current CI/project target 4.7.2 |
| Current internal/display target | 640 x 360 internal / 1280 x 720 display |
| Live runtime 3D | Retired research path; not the production default |

## Gameplay/presentation boundary

Art and presentation may not own or silently alter:

- actor movement or collision;
- gameplay facing;
- target selection;
- attack reach or hit geometry;
- damage timing or values;
- invulnerability windows;
- Poise/interruption outcomes;
- guard/Reprisal outcomes;
- AI or Pressure Director scheduling;
- encounter composition;
- progression or reward state.

`CombatActionRunner` and the owning gameplay systems remain authoritative. Presentation consumes their state.

## Coordinate and registration contract

The game world is a `Vector2` combat plane. Isometric depth is a presentation convention, not a third gameplay axis.

For every directional actor:

- the gameplay node position is the feet/contact point;
- the visible body may extend above, around, or temporarily beyond that point without moving gameplay collision;
- Y-depth uses the actor's gameplay/contact base rather than the top of the art;
- feet registration must remain stable through loops and attacks;
- source animation must not bake gameplay-authoritative root translation into the runtime frames;
- visual scale is independent of collision and attack range.

The current proof runtime profile uses a fixed **128 x 128** canvas with a **(64, 112)** feet anchor. That is the current Godot proof-export contract, not a restriction on the resolution of paid source/master renders.

## Master-source vs runtime-derivative contract

Production must distinguish **editable/high-resolution source** from the **runtime derivative**.

### Source/master deliverables

For a commissioned or internally produced rig-rendered character, retain:

- the editable source model/rig/animations;
- the fixed render camera and lighting/material setup;
- high-resolution transparent directional master renders;
- enough resolution to re-derive alternate runtime treatments without reconstructing the asset.

For a hero character such as Akio, a working target around **1024 x 1024 transparent masters** is appropriate when it contains the full weapon silhouette with comfortable margin, but the exact master canvas may be adjusted to the model/render setup. The important rule is that masters are materially higher resolution than the current 128 x 128 runtime proof output.

### Runtime derivatives

The current proof tools validate a fixed 128 x 128 RGBA frame set with stable registration. Runtime derivatives may later move to another whole-profile canvas if visual testing justifies it, but individual frames may not be auto-trimmed independently.

Clean prerender, larger clean derivative, pixel/downsample treatment, and selective hand cleanup should all be derivable from the same source/master package whenever practical.

## Directional actor contract

All production actor sets render or draw eight independent directions:

`e, se, s, sw, w, nw, n, ne`

Do not assume four directions can be mirrored for final production. Mirroring can reverse:

- weapon hand and scabbard relationship;
- costume asymmetry;
- corruption asymmetry;
- readable slash direction;
- stance details;
- VFX attachment interpretation.

The source-rig render workflow should rotate the actor/root against a fixed camera rather than moving the registration point.

## Animation naming and state contract

Non-attack states use:

`<state>_<direction>`

Examples:

- `idle_s`
- `move_ne`
- `dash_w`
- `defend_se`
- `hurt_n`
- `death_sw`

Attack states use the gameplay action id:

`attack_<action_id>_<direction>`

Examples:

- `attack_quick_slash_ne`
- `attack_cross_cut_s`
- `attack_heavy_cleave_w`
- `attack_basic_swing_se`

The runtime profile may explicitly alias closely related gameplay ids to one presentation clip during a proof. Alias/fallback behavior must be documented rather than hidden in artist naming.

## Animation authoring standard

Source animation and runtime sprite playback have different responsibilities.

### Source animation

A Blender/Maya/other source animation may be authored at a normal animation timeline rate such as 24 or 30 fps. The artist should focus on:

- readable anticipation;
- clean weapon path;
- convincing body mechanics;
- distinct impact/follow-through;
- readable recovery;
- stable feet/root setup appropriate for in-place gameplay;
- deformation quality at extreme sword poses.

The artist should not be forced to hand-match every current prototype millisecond. Early gameplay timing may still be tuned after the motion is accepted.

### Runtime sampling

The exported sprite cadence is a separate production choice. The current proof defaults to **12 fps** derivatives, but clean prerender and pixel-treatment comparisons may justify a different cadence later.

For attacks, `DirectionalActorPresentation` samples the visible frame from normalized authoritative `CombatActionRunner` progress. Therefore the sprite animation follows gameplay timing and cannot move the hit window merely by changing frame count.

Idle/move/other free-running loops may use their authored `SpriteFrames` speed.

## 3D source-rig standard

When using offline 3D for a production character, priorities are:

1. recognizable gameplay silhouette;
2. weapon/scabbard readability;
3. clean deformation through required combat poses;
4. cloth/armor mass that supports identity;
5. materials/lighting that survive the final 2D render;
6. corruption landmarks and asymmetry;
7. close-up detail only after the above are proven.

For Akio specifically, the source package should provide:

- editable model, UVs, materials, and textures;
- reusable humanoid deformation/control rig;
- katana and scabbard as separate editable objects;
- stable hand/weapon/scabbard attachment structure;
- useful VFX/weapon-tip/blade-base reference points where practical;
- neutral bind/reference pose;
- combat-ready pose/idle;
- editable animation Actions/clips;
- fixed orthographic render camera and repeatable render setup;
- relative/packed dependencies so the project can reopen without missing external files.

The source rig may come from Blender directly or be authored partly in ZBrush/Maya/Substance/another DCC, but the final paid Akio package should include a working Blender source/render handoff because the repository render tooling targets Blender.

## Root-motion rule

Gameplay movement remains authoritative in Godot.

- locomotion should be renderable in place;
- dash/attack source motion may contain body mechanics but must not force the runtime actor to translate according to pixels in the animation;
- if an animator authors root displacement for natural motion, the export/render pipeline must provide an in-place version or otherwise neutralize the gameplay translation;
- collision, attack travel, and dash distance are not read from the sprite sequence.

## Render output standard

Rig-rendered source frames should use:

- transparent RGBA output;
- fixed camera and projection across all directions/actions;
- fixed canvas per output tier;
- stable feet/contact registration;
- consistent lighting and shadow treatment;
- no per-frame auto-crop;
- no camera drift;
- no direction-specific scale change;
- exact semantic file naming;
- zero-padded frame numbering.

Runtime proof naming:

`<animation_base>_<direction>_<frame:03>.png`

Example:

`attack_quick_slash_ne_004.png`

## Godot import contract

The current runtime path is:

`authoritative actor -> CombatActionRunner/state -> DirectionalActorPresentation -> DirectionalSpriteProfile -> SpriteFrames`

Current registered proof profiles:

- `res://Presentation/Profiles/AkioRigRendered2DProfile.tres`
- `res://Presentation/Profiles/CorruptedSwordsmanRigRendered2DProfile.tres`

The current builder is:

`res://Tools/Rig2D/BuildDirectionalSpriteFrames.gd`

The machine-readable **runtime derivative** proof contract is:

`tools/rig2d/poc_manifest.json`

The manifest's 128 x 128 / 12 fps values describe the current Godot proof derivative. They do not replace the separate requirement to preserve higher-resolution paid masters/source files.

## Character-production gating

The current production order is:

1. commission/finish a custom Akio source model and rig;
2. prove **Idle + Move + Quick Slash** first as the smallest useful in-game character-production gate;
3. judge silhouette, camera scale, feet registration, animation quality, render treatment, and iteration workflow in Oathbound;
4. after that gate is accepted, finish Akio's remaining Stage 1 animation set;
5. only after Akio's pipeline is accepted, commission/build the Corrupted Swordsman proof on the same standards;
6. only after the pair proves the pipeline, scale it to the wider roster.

This staged order reduces the risk of paying for a complete animation library before the actual in-game character-production method is proven.

## Environment technical standard

Production environments are layered illustrated 2D, not live modular 3D room kits.

Favor reusable painted/modular pieces where they preserve authored composition:

- ground/base plates;
- paths and floor wear;
- walls, broken walls, fences, and barricades;
- torii/gate pieces;
- building facades/roof silhouettes;
- trees/vegetation;
- rocks/debris;
- shrine/lantern props;
- corruption overlays;
- foreground/upper occluder pieces.

Tall props may be split into a ground/base layer and an upper foreground layer. Collision remains authored separately from decorative art when needed for clarity.

## Materials and texture treatment

For painted 2D, values and material cues are authored directly into the illustration.

For offline 3D source rigs, allowed/encouraged techniques include:

- hand-painted albedo/value control;
- restrained roughness/metallic response;
- stylized normals where useful;
- toon/painterly ramps;
- selective outlines/ink accents;
- rim accents for silhouette separation;
- controlled baked/painted value gradients;
- decals for blood, grime, ritual marks, and regional wear.

Do not overbuild source shaders whose key qualities disappear after the 2D render/downsample treatment.

## AI-assisted asset policy

AI generation may be used as a production accelerator for concept exploration, prototype meshes, blockouts, texture exploration, and variant studies when its provenance is acceptable.

Generated material is not automatically production-ready. Before shipping, important assets must be checked for:

- silhouette accuracy against approved references;
- topology/deformation quality where 3D is used;
- UV/material consistency;
- rig quality and bone naming;
- animation compatibility;
- hidden/non-manifold/internal geometry;
- texture artifacts or unintended symbols/details;
- final 2D readability;
- source/license/provenance risk.

Hero characters and bosses require deliberate human cleanup and approval even when AI contributes to an early source stage.

## Public / third-party asset policy

CC0 or clearly permissive licensing is preferred for raw assets committed to the repository.

Quaternius Universal Base Characters and Universal Animation Library were useful during the retired live-3D presentation experiment. They remain valid research/reference material, but they are **not** the approved visual baseline for Akio or the final roster.

Any committed third-party asset must have source, license, and modification status recorded. Placeholder/research use does not automatically approve an asset as final Oathbound art.

Do not commit raw assets whose license forbids redistribution. For commissioned work, require explicit disclosure of third-party meshes, clothing, textures, mocap, animation packs, AI-generated material, and plugins that affect delivery or rights.

## Naming

Preserve one asset identity across concept sheets, Blender source, textures, animation Actions, master renders, runtime derivatives, previews, and contractor briefs.

Recommended source names:

- `PC_AKIO_akio_source.blend`
- `EN_A1_SWORDSMAN_hushiro_swordsman_source.blend`

Recommended animation Action names should be semantic and map cleanly to gameplay ids, for example:

- `akio_idle`
- `akio_move`
- `akio_quick_slash`
- `akio_cross_cut`
- `akio_heavy_cleave`

Runtime frame names still follow the directional contract described above.

## Delivery-folder baseline

A production character delivery should contain the relevant subset of:

- `/Source`
- `/Models`
- `/Textures`
- `/Animations`
- `/MasterRenders`
- `/RuntimeDerivatives` when supplied
- `/Previews`
- `/Notes`
- `/Licenses`

Reference folders and paid deliverables must remain separate so visual references cannot be mistaken for owned source art.

## Commission/rightsholder requirements

For paid character work, the production agreement should explicitly cover the project's right to use, modify, reanimate, rerender, create derivatives from, and commercially distribute the delivered game asset/renders at the required scope. The project must also receive the editable source deliverables promised by the brief.

Third-party dependencies and any restrictions must be disclosed before final acceptance. Contract language should be reviewed independently when ownership stakes justify it; repository documentation is a production requirement, not legal advice.

## Acceptance checks

A character or environment batch is not accepted merely because the files exist.

### Character checks

- recognizable silhouette at the accepted gameplay camera;
- correct feet/contact registration;
- all required directions present;
- weapon/facing immediately readable;
- no unintended mirroring of asymmetry;
- animation deformation survives required poses;
- attack anticipation/impact/follow-through remain readable at runtime size;
- no gameplay-authoritative root motion is baked into runtime frames;
- attack frames follow CombatActionRunner timing rather than own it;
- master/source package can be reopened without missing dependencies;
- runtime frame set imports without recurring manual repair;
- clean and pixel/downsample treatments can be compared without gameplay changes;
- provenance/rights are recorded.

### Environment checks

- actors remain readable against the background;
- tall props sort/occlude correctly from their base/contact point;
- environment layers do not hide critical threats for excessive time;
- collision intent remains independent from decorative overlap where needed;
- VFX/telegraphs remain legible over the art;
- performance is validated at the project target resolution.

## Historical live-3D boundary

`Planar3DPresentationBridge`, Hushiro `Presentation3D`, GLB runtime validators, and related Quaternius integration remain research/reference from the rejected real-time 3D experiment. They are not production standards and ordinary gameplay must not reactivate them without an explicit new direction decision.
