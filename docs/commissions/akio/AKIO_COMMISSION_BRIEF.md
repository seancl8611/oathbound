# Akio 3D Character Commission Brief

## Goal

Create a high-quality custom 3D **Akio** that can become the long-term reusable source character for Oathbound.

The commissioned model, rig, materials, and animations are **offline production source assets**, not a live Godot actor. Oathbound's client-side pipeline will render the delivered source from eight directions, derive runtime sprites, and integrate those sprites into the existing Godot 2D combat runtime.

The external artist-facing production specification is the detailed creative/technical scope. This repository brief records the engineering boundary that the game expects.

## Character direction

Akio is a disciplined Order beast hunter and katana swordsman. He should feel practical, worn, controlled, and dangerous rather than noble, ceremonial, theatrical, or generic-anime.

Key visual traits:

- lean, grounded working-warrior silhouette;
- layered/weathered cloth and wrapped limbs;
- compact practical reinforcement/light armor;
- katana and scabbard clearly readable at the hip;
- restrained scarf, cords, pouches, seals, and ritual details;
- readable asymmetry that survives eight-direction rendering;
- strong stance and weapon path from the fixed high-angle gameplay camera.

Design decisions are judged at actual gameplay scale, not only in close-up presentation renders.

## Artist source responsibility

The current commission asks the artist to deliver editable source work, not finished runtime sprite sheets.

Required source direction:

- custom final Akio model;
- clean topology suitable for deformation and sword animation;
- final UVs, textures, and materials;
- reusable humanoid deformation/control rig;
- neutral bind/reference pose;
- katana and scabbard as separate editable objects;
- useful hand/weapon/scabbard/VFX reference points where practical;
- commissioned animations as editable Blender Actions or clearly organized equivalent Actions in the delivered Blender file;
- source organization that reopens cleanly without inaccessible proprietary dependencies;
- disclosure of third-party meshes, clothing, textures, mocap, animation packs, AI-generated content, add-ons, and plugins.

Other DCC tools may be used during production, but the final normal-use handoff must be workable in Blender.

## Client-side directional rendering

The **Client** owns the downstream rendering/export pipeline.

For every accepted source animation, Oathbound will render:

\`E, SE, S, SW, W, NW, N, NE\`

The client integration setup will provide the fixed high-angle camera, render canvas, lighting/material treatment, output naming, high-resolution masters, runtime derivatives, and Godot import.

The artist is therefore **not required to deliver eight-direction PNG sequences under the current scope**.

The artist's responsibility is to make each source animation remain readable when viewed from the required eight directions and to preserve stable, primarily in-place body/weapon motion suitable for client-side rendering.

## Milestone 1 / Proof A

Milestone 1 is the current paid gate.

### Checkpoint A — character design approval

Resolve enough visual information to approve:

- full-body silhouette and proportions;
- front / three-quarter / side / back information sufficient for production;
- palette/material direction;
- major asymmetry;
- gameplay-camera silhouette/readability.

### Checkpoint B — final 3D source character

Deliver the approved custom model, materials, reusable rig, Blender source handoff, katana/scabbard setup, and deformation-ready character.

### Checkpoint C — Proof A animations

Author these three editable source animations:

1. **Idle** — restrained combat-ready loop.
2. **Move / Combat Run** — fast, controlled combat locomotion.
3. **Quick Slash** — fast, compact opening katana cut with a clean weapon path.

Oathbound then renders the three Actions from all eight directions and tests them in-game.

Proof A is used to judge:

- Akio-specific silhouette at the accepted camera;
- deformation quality;
- stable feet/contact registration;
- weapon readability;
- animation language;
- source-to-render iteration quality;
- clean prerender vs downsample/pixel treatment;
- runtime integration without changing gameplay authority.

Milestone 1 ends at accepted Proof A.

## Milestone 2 — future core animation package

Milestone 2 is not part of the currently authorized work. It begins only after Proof A is accepted and separate written approval is given.

The intended core animation set is:

1. **Idle**
2. **Move / Combat Run**
3. **Dash / Step-Dodge**
4. **Defend**
5. **Hurt**
6. **Death**
7. **Quick Slash**
8. **Cross Cut**
9. **Heavy Cleave**

The basic sword phrase should read as:

\`fast opening cut -> distinct continuation -> heavy finisher\`

## Animation timing

Source animation should be authored for convincing motion with readable:

- anticipation;
- strike/impact;
- follow-through;
- recovery.

A conventional source rate such as 24 or 30 fps is fine.

Godot remains authoritative for gameplay movement, dash distance, collision, damage timing, hit windows, invulnerability, and legal transitions. Animations should therefore be primarily **in-place** for gameplay output. Natural translation may be useful while authoring, but the delivered source must support stable client-side in-place rendering.

## Blood Aspects

Akio later changes fighting style through Blood Aspects:

- **Wolf:** faster, aggressive pressure sequence;
- **Wraith:** longer-range spacing/positional sequence;
- **Ronin:** slower, heavier committed sequence with guard/Reprisal identity.

Do not animate the complete Aspect libraries during Milestone 1. The initial model/rig should remain reusable enough for later stance, material, weapon-motion, and animation variations.

## Rights and provenance

The project needs sufficient rights to use the delivered work in Oathbound, modify it, reanimate it, rerender it, derive 2D assets from it, and commercially distribute the resulting game and related approved materials at the agreed contractual scope.

Editable source delivery is required.

Any third-party restriction that could limit commercial use, modification, derived renders, or future contractor handoff must be disclosed before acceptance.

The production specification is the creative/technical scope; the final Artist Services Agreement controls payment, revisions/acceptance, ownership/license terms, confidentiality, cancellation, schedule changes, and other legal terms.

## Runtime integration authority

The commission must not rewrite player gameplay.

The current integration chain is:

\`authoritative Node2D player -> CombatActionRunner/state -> DirectionalActorPresentation -> DirectionalSpriteProfile -> SpriteFrames\`

Milestone 1 uses the dedicated partial profile:

\`res://Presentation/Profiles/AkioProofAProfile.tres\`

The full production profile remains:

\`res://Presentation/Profiles/AkioRigRendered2DProfile.tres\`

Proof A intentionally requires only **Idle + Move + Quick Slash**. The full production profile remains strict for the complete nine-animation package.
