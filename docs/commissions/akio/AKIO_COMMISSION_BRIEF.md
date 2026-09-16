# Akio 3D Character Commission Brief

## Goal
Create a high-quality 3D **Akio** that can become the long-term source asset for Oathbound. The 3D model will be rigged and animated, then rendered into 2D sprites for the actual Godot game.

## Character direction
Akio is a disciplined samurai beast hunter. He should feel practical, worn and dangerous rather than ornate or heroic.

Key visual traits:
- lean, dark samurai-hunter silhouette;
- layered/weathered cloth and wrapped limbs;
- compact practical armor and light lamellar pieces;
- katana and scabbard clearly readable at the hip;
- scarf, cords, pouches and ritual details without excessive small visual noise;
- strong silhouette from a high-angle gameplay camera.

Approved concept/reference images will be supplied before modeling.

## Stage 1 animations
Create these as separate editable animations:

1. **Idle** — restrained combat-ready stance.
2. **Move / combat run** — fast, controlled combat movement rather than a casual jog.
3. **Dash / step-dodge** — short, decisive evasive burst.
4. **Defend** — clear compact guard posture.
5. **Hurt** — short readable hit reaction.
6. **Death** — grounded combat death.
7. **Quick Slash** — fast, compact opening katana cut.
8. **Cross Cut** — clearly different second cut using a different weapon/body path.
9. **Heavy Cleave** — slower, more committed final attack in the basic chain, with stronger anticipation and follow-through.

The basic sword phrase should feel like:

`fast opening cut -> distinct continuation -> heavy finisher`

Do **not** design to exact gameplay timestamps. The animator should make the motion feel convincing; Godot timings will be tuned around the accepted animations.

## Blood Aspects
Akio later changes fighting style through Blood Aspects:
- **Wolf:** faster, aggressive 4-hit pressure sequence;
- **Wraith:** longer-range 2-hit spacing/control sequence;
- **Ronin:** slower, heavier 3-hit committed sequence.

Do not animate the full Aspect libraries in Stage 1. The initial rig should simply be reusable enough to support future weapon, stance, material and animation variations.

## Required source deliverables
- complete editable Blender `.blend`;
- final model, UVs, textures and materials;
- reusable deformation/control rig;
- katana and scabbard as separate editable objects;
- all Stage 1 animations as editable Blender Actions;
- useful hand/weapon/scabbard/VFX attachment points;
- fixed render camera and lighting setup;
- transparent high-resolution master PNG sequences;
- all eight directions: `E, SE, S, SW, W, NW, N, NE`;
- stable feet/contact registration and no per-frame auto-cropping;
- disclosure of any third-party assets, mocap, AI content or required plugins;
- commercial modification and derivative-render rights so the character can be reanimated and rerendered later.

Animations should be primarily **in-place**. Godot owns gameplay movement, attack travel, collision and damage.

## 2D conversion
Each 3D animation is authored once, then rendered from all eight directions using the same fixed camera. Keep high-resolution masters. We will derive the game-ready sprite size/style from those masters and compare clean prerendered and downsampled/stylized versions.

## Approval stages
1. Character turnaround / design interpretation.
2. 3D blockout.
3. Final model + materials.
4. Rig + deformation test.
5. Animation test using Idle, Move, Quick Slash and Heavy Cleave.
6. Finish all Stage 1 animations and eight-direction renders.
7. Deliver complete editable source package.

After Stage 1 is tested in Oathbound, the next likely animation order is **Hold Thrust, Dash Slash, Counter Cut**, followed later by the dedicated Wolf/Wraith/Ronin libraries.