# Akio 3D Character Commission Brief

## Goal
Create a high-quality custom 3D **Akio** that can become the long-term source asset for Oathbound.

The 3D character is an **offline production source**, not a live Godot actor. The model will be rigged and animated, then rendered from eight directions into 2D sprites for the actual game.

## Character direction
Akio is a disciplined samurai beast hunter. He should feel practical, worn and dangerous rather than ornate or conventionally heroic.

Key visual traits:

- lean, dark samurai-hunter silhouette;
- layered/weathered cloth and wrapped limbs;
- compact practical armor and light lamellar pieces;
- katana and scabbard clearly readable at the hip;
- scarf, cords, pouches and ritual details without excessive small visual noise;
- strong stance/weapon silhouette from a high-angle gameplay camera;
- readable asymmetry that survives eight-direction rendering.

Approved concept/reference images and gameplay-camera screenshots will be supplied before modeling.

The artist should design for the actual small on-screen combat scale, not only for close-up renders.

## Production setup

The final source package should be usable in **Blender** for rerendering and later animation work.

The artist may use other tools during creation, but final delivery should include a working Blender source/render handoff with no inaccessible dependency required for normal editing/rendering.

Please include:

- neutral bind/reference pose;
- combat-ready pose/idle;
- reusable humanoid deformation/control rig;
- katana and scabbard as separate editable objects;
- useful hand/weapon/scabbard attachment structure;
- clean source organization and semantic animation names.

## Eight-direction output

Each approved 3D animation is authored once, then rendered from:

`E, SE, S, SW, W, NW, N, NE`

Use one fixed orthographic/high-angle render camera and rotate the character/root for directional views.

Do not rely on mirroring only four directions. Akio's handedness, katana/scabbard placement, costume asymmetry and weapon paths must remain correct.

Every rendered frame must keep stable feet/contact registration with no per-frame auto-cropping.

## Proof A — first paid/in-game gate

Before completing the full animation package, prove these three actions:

1. **Idle** — restrained combat-ready stance.
2. **Move / combat run** — fast, controlled combat movement rather than a casual jog.
3. **Quick Slash** — fast, compact opening katana cut with a readable weapon path.

Render all three from all eight directions.

This first gate is used inside Oathbound to judge:

- whether the finished Akio silhouette works at the real gameplay camera;
- rig/deformation quality;
- stable feet registration;
- weapon readability;
- source/render iteration quality;
- clean prerender vs downsample/pixel-style treatment.

If this gate exposes a fundamental model/rig/render problem, we should fix it before paying for the complete animation library.

## Proof B / Stage 1 animation set

After Proof A is accepted, complete these as separate editable animations:

1. **Idle**
2. **Move / combat run**
3. **Dash / step-dodge** — short, decisive evasive burst.
4. **Defend** — clear compact guard posture.
5. **Hurt** — short readable hit reaction.
6. **Death** — grounded combat death.
7. **Quick Slash** — fast, compact opening katana cut.
8. **Cross Cut** — clearly different continuation using a different weapon/body path.
9. **Heavy Cleave** — slower, more committed finisher with stronger anticipation and follow-through.

The basic sword phrase should feel like:

`fast opening cut -> distinct continuation -> heavy finisher`

## Animation timing

Do **not** design the source animation around one exact current Godot millisecond timeline.

Author convincing motion with clear:

- anticipation;
- strike/impact motion;
- follow-through;
- recovery.

A normal source-animation timeline such as 24 or 30 fps is fine.

Godot remains authoritative for gameplay movement, dash distance, collision, damage, hit windows and legal transitions. The final sprite presentation is mapped over normalized gameplay action progress.

Animations should therefore be primarily **in-place**. If natural root translation is used while authoring, also provide/render an in-place gameplay version.

## High-resolution masters and runtime sprites

Do not deliver only 128 x 128 finished sprites.

Please keep transparent **high-resolution master renders** for every delivered animation/direction. A working target around **1024 x 1024** per frame is appropriate if it comfortably contains the full Akio/katana silhouette; the exact source canvas may be adjusted to the render setup as long as it remains fixed and substantially higher resolution than the game derivative.

We will derive the final runtime sprite size/style from those masters. The current Godot proof uses a 128 x 128 derivative, but we want freedom to compare:

- clean prerendered 2D;
- larger clean derivatives if needed;
- downsampled/pixel-style treatment;
- selective hand cleanup.

## Blood Aspects

Akio later changes fighting style through Blood Aspects:

- **Wolf:** faster, aggressive pressure sequence;
- **Wraith:** longer-range spacing/positional sequence;
- **Ronin:** slower, heavier committed sequence with guard/Reprisal identity.

Do not animate the full Aspect libraries in Stage 1. The initial model/rig should simply be reusable enough to support future stance, material, weapon-motion and animation variations.

## Required source deliverables

- complete editable Blender `.blend`;
- final model, UVs, textures and materials;
- reusable deformation/control rig;
- neutral bind/reference pose;
- katana and scabbard as separate editable objects;
- all commissioned animations as editable Blender Actions;
- useful hand/weapon/scabbard/VFX reference points where practical;
- fixed render camera and lighting/material setup;
- transparent high-resolution master PNG sequences;
- all eight directions for every commissioned action;
- stable feet/contact registration;
- no per-frame auto-cropping;
- no gameplay-authoritative root motion in exported gameplay sequences;
- packed or clearly documented relative dependencies so the source reopens cleanly;
- disclosure of third-party meshes, clothing, textures, mocap, animation packs, AI-generated content and required plugins.

## Rights requirement

The project needs sufficient rights to use the delivered work in Oathbound, modify it, reanimate it, rerender it, create derivative 2D assets from it, and commercially distribute the resulting game/assets at the agreed scope.

The editable source package is required in addition to rendered outputs.

Any third-party restrictions must be disclosed before final acceptance. Final contract wording can be handled separately; this brief defines the production expectation.

## Approval milestones

1. Character turnaround / interpretation of approved Akio references.
2. 3D silhouette/blockout at gameplay-relevant views.
3. Final model + materials.
4. Rig + deformation test.
5. **Proof A:** Idle + Move + Quick Slash, all eight directions, high-resolution masters.
6. In-game acceptance of Akio silhouette/render treatment.
7. **Proof B:** finish the remaining Stage 1 animations and renders.
8. Deliver the complete editable source package.

After Stage 1 is tested in Oathbound, the next likely Akio animation order is **Hold Thrust, Dash Slash, Counter Cut**, followed later by the dedicated Wolf/Wraith/Ronin libraries.
