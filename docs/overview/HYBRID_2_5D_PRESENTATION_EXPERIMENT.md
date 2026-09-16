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

The first correct-head Hushiro V2 gameplay review confirmed that the planar-to-3D bridge is functioning, but the presentation still read too close, too conventionally real-time 3D, and too visually muddy during multi-enemy combat. Camera flattening alone did not create the illustrated 2.5D separation being targeted.

The first correct-head V3 gameplay review then provided a useful positive result: moving from V2's `0.52` presentation zoom to V3's `0.40`, reducing actor scale to `0.78`, flattening temporary actor shading, and quantizing presentation facing made the game read materially better. The remaining framing complaint is now narrower: the arena should still show somewhat more space and the player/enemies should still occupy less screen area.

That means two separate conclusions are now locked:

1. **Framing still benefits from one more controlled zoom/scale reduction.**
2. **Camera/framing should no longer be treated as the solution for final actor style.** If characters still read like miniature real-time-3D models after the next pass, the actor renderer changes rather than endlessly reducing camera zoom.

The experiment changes the *presentation treatment*, not the combat simulation.

The near-term visual target is:

> **Dimensional 3D rooms + flatter sprite-like actor treatment + orthographic authored framing + explicit contact shadows and attack VFX.**

The goal is the kind of immediate foreground/background separation and actor readability associated with polished high-angle action roguelites, while preserving Oathbound's own dark Japanese-gothic identity.

## V3 framing iteration 2

`HushiroPlanar3DPresentationBridgeV3.gd` now tests:

- farther framing at `0.35` presentation zoom, down from the successful-but-still-close `0.40` run;
- smaller presentation actors at `0.68` root scale, down from `0.78`, without changing gameplay hitboxes, movement, ranges, spacing, or targeting;
- the same roughly 30-degree camera elevation, because the latest complaint is scale/framing rather than insufficient ground-plane flattening;
- temporary character materials rendered unshaded where they are `StandardMaterial3D`, keeping texture/color information while removing most dynamic 3D body-lighting noise;
- volumetric actor shadow casting disabled while the authored contact shadow remains, making characters read more like placed illustrated figures than miniature fully lit 3D models;
- eight-direction presentation-facing quantization, which makes direction changes read closer to authored directional animation while the authoritative planar actor still uses continuous vectors for gameplay;
- hard per-frame exclusivity for old `Sprite2D` / `AnimatedSprite2D` body art whenever a valid replacement is active;
- lifetime-safe orphan cleanup in both the per-frame synchronization path and the periodic reconciliation path.

## Lifetime regression exposed by manual testing

Two consecutive correct-head manual runs found two versions of the same presentation-lifetime problem:

- V2/V3 run 1: `_sync_actor_visuals()` touched a freed authoritative actor reference before type-safe cleanup;
- V3 run 2: `_reconcile_actors()` reached the same stale-source condition through its periodic registry cleanup path.

V3 therefore treats `Variant` object lifetime as the first gate before any `is Node` / `is Node2D` / `is Node3D` type check in those active actor-registry paths. The deterministic freed-source smoke now covers both sync and reconciliation rather than only the first path.

## What this does not change

V3 does **not** change:

- authoritative `CharacterBody2D` positions;
- attack timing, damage, hitboxes, ranges, or combo rules;
- Pressure Director behavior;
- Health, Poise, guard, or special-parry rules;
- encounter composition or enemy AI;
- production GLB validation/animation timing contracts.

## Decision gate after framing iteration 2

The next manual playtest should answer three questions:

1. Is `0.35` framing far enough out to read multi-enemy pressure comfortably without making the arena feel detached?
2. Is `0.68` actor scale small enough for the player/enemies to stop dominating screen real estate while remaining readable?
3. With framing no longer the dominant problem, do the actors themselves still look too much like ordinary real-time 3D models rather than illustrated 2.5D game characters?

If #1 or #2 still needs a *small* adjustment, tune those values once more within the same architecture. If #3 is yes, stop camera iteration and move to an actor-specific rendering experiment while retaining the accepted 3D room and planar combat contracts.

## Preferred next actor-rendering experiment

If V3 framing iteration 2 confirms that actor style is the remaining problem, prototype a **directional cutout/card actor layer** rather than rewriting combat or abandoning the 3D environment.

The preferred contract is:

- keep authoritative 2D combat actors unchanged;
- keep the current 3D Hushiro room, lighting, floor, props, telegraphs, and camera;
- preserve the existing semantic role/state/action-progress bridge;
- replace only the visible body representation with a camera-facing or direction-selected `Sprite3D`/card presentation;
- drive eight directional views from the same presentation-facing contract already proven in V3;
- synchronize locomotion/dash/attack/hurt/death frames to authoritative source state and attack progress, just as the current 3D animation bridge does;
- keep one authored ground/contact shadow beneath the card;
- make the current 3D actor model a fallback/prototyping source rather than the final live body renderer;
- preserve exclusive replacement: never render the old 2D body, the 3D body, and the directional card simultaneously.

This lets Oathbound pursue a stronger Hades-like 2.5D read without throwing away the stable planar combat simulation or the now-improving 3D environment composition.
