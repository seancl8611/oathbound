---
id: OVERVIEW-HYBRID-2_5D-PRESENTATION-EXPERIMENT
title: Hushiro Hybrid 2.5D Presentation Experiment
category: overview
status: experimental
authority: supporting
last_reviewed: 2026-09-15
topics:
  - hushiro
  - presentation
  - hybrid-2.5d
  - combat-readability
  - planar-combat
related:
  - OVERVIEW-STYLIZED-3D-PRESENTATION
  - OVERVIEW-V2-COMBAT-DIRECTION
---

# Hushiro Hybrid 2.5D Presentation Experiment

## Why this exists

The first correct-head Hushiro V2 gameplay review confirmed that the planar-to-3D bridge is functioning, but the presentation still reads too close, too conventionally real-time 3D, and too visually muddy during multi-enemy combat. Camera flattening alone did not create the illustrated 2.5D separation being targeted.

This experiment therefore changes the *presentation treatment*, not the combat simulation.

The near-term visual target is:

> **Dimensional 3D rooms + flatter sprite-like actor treatment + orthographic authored framing + explicit contact shadows and attack VFX.**

The goal is the kind of immediate foreground/background separation and actor readability associated with polished high-angle action roguelites, while preserving Oathbound's own dark Japanese-gothic identity.

## V3 experiment rules

`HushiroPlanar3DPresentationBridgeV3.gd` deliberately tests the following together:

- farther framing (`0.40` presentation zoom) so the player can read more arena and pressure at once;
- smaller presentation actors (`0.78` root scale) without changing gameplay hitboxes, movement, ranges, or spacing;
- temporary character materials rendered unshaded where they are `StandardMaterial3D`, keeping texture/color information while removing most dynamic 3D body-lighting noise;
- volumetric actor shadow casting disabled while the authored contact shadow remains, making characters read more like placed illustrated figures than miniature fully lit 3D models;
- eight-direction presentation-facing quantization, which makes direction changes read closer to authored directional animation while the authoritative planar actor still uses continuous vectors for gameplay;
- hard per-frame exclusivity for old `Sprite2D` / `AnimatedSprite2D` body art whenever a valid replacement is active;
- immediate orphan-visual retirement when a defeated authoritative actor is freed, preventing both ghost visuals and freed-instance runtime errors.

## What this does not change

V3 does **not** change:

- authoritative `CharacterBody2D` positions;
- attack timing, damage, hitboxes, ranges, or combo rules;
- Pressure Director behavior;
- Health, Poise, guard, or special-parry rules;
- encounter composition or enemy AI;
- production GLB validation/animation timing contracts.

## Acceptance questions

The next manual playtest should answer four questions before further art architecture work:

1. Does the farther framing finally expose enough arena to read multi-enemy pressure comfortably?
2. Do smaller, flatter, eight-direction actors separate from the environment more clearly than the V2 real-time-3D treatment?
3. Are attacks, movement direction, and target identity easier to read even with placeholder character assets?
4. Is the remaining quality problem primarily *asset quality* rather than camera/rendering architecture?

If the answer to #2 is still no, stop iterating camera numbers and move the actor layer to a stronger sprite/cutout pipeline (for example pre-rendered or runtime-rendered directional actor cards) while retaining the same planar combat and 3D environment contracts.
