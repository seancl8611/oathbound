# Rig-Rendered 2D Character Pipeline

Status: **implementation-ready runtime seam; custom Akio source proof is the current production gate**

This document is the production handoff between an editable 3D character source and Oathbound's approved isometric 2D runtime.

The immediate proof is intentionally staged:

1. prove a **custom Akio** in-game first;
2. finish Akio's Stage 1 set only after the smallest useful gate reads correctly;
3. build one Corrupted Swordsman on the same pipeline;
4. only then decide whether to scale the method across the roster.

Do not turn the retired live-3D experiment back into the runtime. The 3D model exists to generate 2D art.

## Runtime boundary

The 3D model, rig, animation scene, materials and render camera are **offline content-generation tools only**. Normal gameplay stays in Godot 2D.

Combat V2 remains authoritative for positions, movement, hitboxes, hurtboxes, damage, attack timing, Pressure Director admission, AI, targeting and progression. The rendered sprite is a presentation client. In particular, an animation frame never decides when damage occurs.

The runtime chain is:

`authoritative Node2D actor -> CombatActionRunner/state -> DirectionalActorPresentation -> DirectionalSpriteProfile -> SpriteFrames`

## Current registered runtime slots

Godot has two rig-rendered content slots:

- `res://Presentation/Profiles/AkioRigRendered2DProfile.tres`
- `res://Presentation/Profiles/CorruptedSwordsmanRigRendered2DProfile.tres`

They remain intentionally `asset_ready=false` until a complete validated runtime frame set is built. Hushiro continues to use procedural placeholders until then.

The profile/import seam is stable enough that real art can replace the placeholder without changing combat code.

## Production order

The current production order is deliberately risk-limited.

### Akio Proof A — minimum in-game character-production gate

Commission/finish the custom Akio model, materials and rig, then produce at least:

- `idle`
- `move`
- `attack_quick_slash`

Render those actions from all eight directions and integrate them into an isolated proof/profile path if necessary. The purpose is to answer the expensive questions early:

- Does Akio actually read like Akio at the accepted camera?
- Does the custom silhouette survive the small screen-space scale?
- Does the rig/render setup preserve stable feet and clean weapon motion?
- Does clean prerender or deliberate downsample/pixel treatment fit the game better?
- Is the Blender -> render -> validate -> Godot iteration loop practical?

Do **not** weaken the production runtime validator merely to accept an intentionally incomplete Proof A. Use a dedicated proof subset/profile/config when implementation reaches that point.

### Akio Proof B / Stage 1 completion

After Proof A is manually accepted, finish Akio's current Stage 1 animation package:

- `idle`
- `move`
- `dash`
- `defend`
- `hurt`
- `death`
- `attack_quick_slash`
- `attack_cross_cut`
- `attack_heavy_cleave`

The current production `DirectionalSpriteProfile` expects this complete set before Akio is marked asset-ready.

### Corrupted Swordsman proof

Only after Akio's source/render/runtime method is accepted, build the first enemy proof using:

- `idle`
- `move`
- `defend`
- `hurt`
- `death`
- `attack_basic_swing`
- `attack_quick_thrust`
- `attack_cross_swing`
- `attack_running_swing`

The Akio + Swordsman pair then becomes the real gate for crowd depth, repeated actor cost, direction readability, enemy attack recognition, and whether the pipeline should scale to the roster.

## Eight directions

Godot's combat plane uses +X right and +Y down. Render all eight directions independently; production should not rely on horizontal mirroring.

| Name | Godot facing | Screen angle |
| --- | --- | ---: |
| `e` | `(1, 0)` | 0° |
| `se` | `(0.7071, 0.7071)` | 45° |
| `s` | `(0, 1)` | 90° |
| `sw` | `(-0.7071, 0.7071)` | 135° |
| `w` | `(-1, 0)` | 180° |
| `nw` | `(-0.7071, -0.7071)` | 225° |
| `n` | `(0, -1)` | 270° |
| `ne` | `(0.7071, -0.7071)` | 315° |

The machine-readable runtime copy is `tools/rig2d/poc_manifest.json`.

The source exporter should rotate the character/root against a fixed camera so handedness, scabbard placement, costume asymmetry, corruption asymmetry and slash direction remain physically correct.

## Animation naming

Non-attack states use:

`<state>_<direction>`

Examples: `idle_s`, `move_ne`, `dash_w`, `defend_se`.

Attack states use the gameplay action id:

`attack_<action_id>_<direction>`

Examples: `attack_quick_slash_ne`, `attack_heavy_cleave_s`, `attack_basic_swing_w`, `attack_quick_thrust_n`.

The profile may alias secondary gameplay ids to a shared proof clip when that is explicitly intentional. Aliasing is a temporary presentation mapping, not permission to change gameplay action identity.

## Source animation vs runtime timing

Source animation and gameplay timing are separate layers.

The animator should create convincing motion with readable anticipation, strike, follow-through and recovery. Source Actions may be authored at a conventional DCC frame rate such as 24 or 30 fps.

Do not require a contractor to reproduce every current prototype millisecond exactly. Combat timing is still evolving and the Godot action runtime remains authoritative.

For attacks, `DirectionalActorPresentation` samples the visible sprite frame from `CombatActionRunner.action_progress()`.

Consequences:

- the visible attack follows the authoritative startup/active/recovery timeline;
- changing sprite frame count cannot move a hit window;
- timing tuning does not require baking gameplay events into the source rig;
- the artist still needs clear motion phases so speed-remapping remains readable;
- hitstop and future action-speed changes remain gameplay-owned.

Idle and movement loops may free-run at their authored SpriteFrames speed.

## Root-motion rule

Runtime movement is authored by Godot, not by the sprite sequence.

The source rig may use natural body translation while animating, but the delivered/rendered gameplay sequence must support an in-place export so:

- dash distance remains owned by gameplay;
- attack travel remains owned by gameplay;
- collision remains attached to the authoritative actor;
- directional frames do not drag the registration point across the canvas.

## Source/master render contract

A paid custom character should not be delivered only as final-size runtime sprites.

Retain:

- editable Blender source;
- model, UVs, textures/materials;
- rig/control rig;
- editable Actions;
- fixed camera/render setup;
- transparent **high-resolution master renders** for every delivered action/direction;
- source information/licensing for any third-party or generated dependencies.

For Akio, a working target around **1024 x 1024 transparent masters** is appropriate when it comfortably contains the full sword silhouette. The exact master canvas may be adjusted based on the source model and camera; the requirement is that it remain materially higher resolution than the runtime derivative and consistent across the actor's delivered set.

Master renders should keep:

- one fixed canvas per source tier;
- stable feet/contact registration;
- no per-frame auto-cropping;
- fixed projection/camera;
- consistent lighting/material treatment;
- enough margin for the full weapon path.

High-resolution masters may live outside the runtime project/package if repository size makes that practical. The editable source and ownership/provenance still need to be preserved.

## Runtime derivative contract

The current Godot proof profile uses:

- RGBA PNG with transparency;
- fixed `128 x 128` runtime canvas;
- feet anchor at pixel `(64, 112)`;
- 12 fps baseline for free-running proof loops;
- no per-frame trimming/cropping;
- no baked gameplay root motion;
- nearest-neighbor filtering for the current pixel-treatment-ready proof path.

These are **runtime proof values**, not the required resolution of the paid master renders.

The whole runtime profile may later move to 256 or another fixed canvas if the Akio comparison proves that necessary. Individual frames must still share one consistent registration contract.

## Clean-prerender vs pixel-treatment test

The comparison must originate from the same source rig/master renders wherever possible.

Evaluate at least:

1. clean prerendered 2D;
2. deliberate downsample/quantized pixel treatment;
3. selective hand cleanup if it materially improves readability.

Do not lock the final palette count, outline treatment, exact filter, or final runtime resolution before the Akio proof is judged in real Hushiro combat.

The production decision should be driven by:

- silhouette quality;
- motion readability;
- weapon clarity;
- visual identity;
- frame stability;
- memory/import cost;
- iteration time;
- how well multiple enemies remain readable at once.

## Rendering output layout

The current runtime derivative uses one flat source directory per actor:

`<animation_base>_<direction>_<frame:03>.png`

Examples:

- `move_ne_000.png`
- `move_ne_001.png`
- `attack_quick_slash_w_000.png`
- `attack_quick_slash_w_011.png`

Zero-padded frame numbers are required so lexical sorting equals animation order.

High-resolution masters may use the same semantic naming in a separate master-render directory so derivatives can be traced back to source frames.

## Current repository tooling

The machine-readable **runtime derivative** contract is:

`tools/rig2d/poc_manifest.json`

The current Blender templates/exporter are also configured around the 128 x 128 runtime proof. They are not yet the paid-master renderer contract.

`tools/rig2d/README.md` owns the current repository command flow. When the real Akio source arrives, extend the tooling deliberately if we want one automated command to render high-resolution masters and derive runtime outputs. Do not silently reinterpret the existing 128 x 128 validator as if it already validates master delivery.

## Building SpriteFrames

After runtime-derivative PNGs are copied into the Godot project, import them first:

```bash
godot --headless --path game/oathbound --import
```

Then build the profile. Akio example:

```bash
godot --headless --path game/oathbound \
  --script res://Tools/Rig2D/BuildDirectionalSpriteFrames.gd -- \
  --profile=res://Presentation/Profiles/AkioRigRendered2DProfile.tres \
  --source=res://Art2D/RigRendered/Akio/Frames \
  --output=res://Art2D/RigRendered/Akio/AkioDirectionalSpriteFrames.tres
```

The production builder refuses to mark the profile ready unless every required direction/animation exists, loop flags are correct, frames are non-null, and the fixed runtime canvas matches the profile.

## Akio source requirements

The custom Akio source should preserve future production flexibility.

Required/source-useful elements include:

- neutral bind/reference pose;
- combat-ready idle pose;
- editable deformation/control rig;
- katana and scabbard as separate objects;
- stable weapon-hand relationship;
- useful hand, weapon-tip/blade-base, scabbard and body reference points where practical;
- no dependency on an inaccessible proprietary rig/plugin for ordinary editing/rendering;
- files that reopen with packed/relative dependencies;
- enough topology/deformation quality for later Wolf/Wraith/Ronin action libraries.

The current commission authority is:

`docs/commissions/akio/AKIO_COMMISSION_BRIEF.md`

## Rights/provenance requirement

The project needs sufficient rights to use, modify, reanimate, rerender, create derivatives from, and commercially distribute the delivered asset/renders at the agreed scope, plus the editable source package promised by the brief.

The artist must disclose third-party meshes, clothing, textures, mocap, animation packs, AI-generated content, and plugins that materially affect source use or rights.

Repository documentation describes the production requirement; final contract language should be reviewed independently when needed.

## Acceptance gate before expanding the pipeline

### Akio Proof A acceptance

Judge the first Akio proof at the accepted Hushiro camera on:

- recognizably Akio-specific silhouette;
- idle/move/Quick Slash readability in all eight directions;
- stable feet/contact registration;
- no visual sliding caused by unintended root motion;
- readable weapon path and anticipation at actual combat size;
- clean-prerender vs downsample/pixel treatment comparison;
- practical source/render/derivative iteration.

If Akio fails this gate, fix the source/rig/render treatment before buying or producing a full animation library.

### Akio Stage 1 acceptance

After Proof A passes, require the complete current Akio production profile and test dash, guard, hurt, death and the full basic chain.

### Akio + Swordsman pipeline acceptance

Only after both are integrated should the project decide whether to scale the method. Judge:

- crowd direction readability;
- overlap/Y-depth behavior;
- enemy attack recognition;
- repeated actor memory/import cost;
- render/build speed;
- style consistency across player/enemy roles;
- whether the chosen treatment strengthens Oathbound's identity enough to justify roster-wide use.

Do not build the remaining roster from this pipeline until that test is accepted.
