---
id: OVERVIEW-STYLIZED-3D-PRESENTATION
title: Stylized 3D Presentation Direction (Superseded)
category: overview
status: superseded
authority: historical
last_reviewed: 2026-09-16
topics:
  - project-identity
  - three-quarter-camera
  - stylized-3d
  - planar-combat
  - presentation-research
superseded_by:
  - OVERVIEW-ISOMETRIC-2D-PRESENTATION
related:
  - OVERVIEW-ISOMETRIC-2D-PRESENTATION
  - OVERVIEW-HYBRID-2_5D-PRESENTATION-EXPERIMENT
  - OVERVIEW-V2-COMBAT-DIRECTION
---

# Stylized 3D Presentation Direction — Historical / Superseded

Status: **superseded September 16, 2026**.

The current presentation authority is:

`docs/overview/ISOMETRIC_2D_PRESENTATION_DIRECTION.md`

## Historical decision

Oathbound temporarily pursued a live real-time 3D presentation while preserving its authoritative planar Combat V2 simulation. That experiment produced the `Planar3DPresentationBridge` family, Hushiro V1/V2/V3 presentation passes, temporary Quaternius character integration, external-model/animation validation, contact-shadow/VFX work, and a representative runtime 3D environment.

The experiment was useful because it proved several durable architectural principles:

- presentation can remain separate from authoritative combat;
- gameplay can remain a `Vector2` ground-plane simulation;
- body replacement must be exclusive rather than additive;
- character animation must follow authoritative attack/action state rather than own timing or root motion;
- camera composition, actor screen scale and threat readability should be validated in real encounters before expensive art production;
- final art should be replaceable without rewriting movement, hitboxes, AI, Pressure Director or progression.

## Why live 3D was retired

Correct-head manual playtests improved as the camera moved farther out and actor scale decreased, but the result continued to read as miniature real-time 3D rather than the illustrated isometric presentation the project is targeting. The temporary 3D character tier also did not resemble Oathbound's intended final characters/enemies closely enough to justify further runtime-renderer iteration.

The project therefore stopped treating real-time 3D actors/environments as the ordinary gameplay production target.

## Current replacement direction

Oathbound now targets:

> **2D authoritative combat + fixed high-angle/isometric Camera2D composition + small eight-direction actor sprites + layered illustrated 2D environments + independent 2D combat VFX.**

Character art may eventually be produced either by hand or through an **offline** 3D pipeline:

`concept -> model -> rig -> animate -> fixed-angle directional renders -> 2D sprite atlas`

In both cases Godot's ordinary combat runtime consumes 2D directional frames rather than rendering the production character model live.

See `ISOMETRIC_2D_PRESENTATION_DIRECTION.md` for the active camera, actor-state/direction, feet/pivot, depth-sorting, environment-layering and asset-replacement contracts.

## Retained research

The following remain in source control as research/reference unless separately removed later:

- `res://Utility/Planar3DPresentationBridge.gd`
- Hushiro `Presentation3D` scripts and validation fixtures
- Quaternius curated humanoid/animation experiments
- production GLB validation and external-animation synchronization utilities

They must **not** be instantiated by the ordinary Hushiro `CombatChamber` while the isometric-2D direction is active.

## Durable rule retained from the experiment

> **A replacement actor visual is exclusive, never additive.**

Old body sprites/AnimatedSprites must not render beneath a new placeholder or final directional actor presentation. Intentional VFX should remain separate and explicitly classified so body replacement does not erase combat feedback.
