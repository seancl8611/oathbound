---
id: OVERVIEW-ISOMETRIC-2D-PRESENTATION
title: Isometric 2D Runtime Presentation Direction
category: overview
status: approved
authority: primary
last_reviewed: 2026-09-16
topics:
  - project-identity
  - isometric
  - three-quarter-camera
  - directional-sprites
  - planar-combat
  - environment-production
  - character-production
supersedes:
  - OVERVIEW-STYLIZED-3D-PRESENTATION
related:
  - OVERVIEW-V2-COMBAT-DIRECTION
  - OVERVIEW-HYBRID-2_5D-PRESENTATION-EXPERIMENT
---

# Isometric 2D Runtime Presentation Direction

Status: **approved production direction**

## Decision

Oathbound's live game runtime remains **2D planar combat with an authored high-angle/isometric presentation**.

Real-time 3D actors and environments are no longer the active Hushiro vertical-slice target. The September 2026 Planar3D work remains useful research and a recoverable experiment, but it is not the production renderer for ordinary gameplay.

The concise target is:

> **2D authoritative combat + fixed high-angle/isometric Camera2D composition + small eight-direction actor sprites + layered illustrated 2D environments + independent 2D combat VFX.**

This direction is intentionally compatible with two future character-art pipelines:

1. fully hand-drawn directional animation; or
2. offline 3D model -> rig -> animate -> fixed-angle render -> 2D sprite atlas.

Godot should not care which pipeline produced the final frames.

## What remains authoritative

Presentation work does not rewrite Combat V2.

Keep the existing authorities for:

- player/enemy world positions;
- hitboxes and hurtboxes;
- attack reach and timing;
- Health and Poise/interruption;
- special-response parry rules;
- Pressure Director scheduling;
- enemy AI and encounter coordination;
- soft targeting and target handoff;
- Techniques, Aspects, Relics, Prosthetics and Corruption;
- room progression and rewards.

The world remains a `Vector2` combat plane. Isometric depth is a rendering convention, not a new gameplay axis.

## Camera contract

The gameplay camera is fixed, high-angle and substantially wider than the original close 2D presentation.

Current Hushiro proving profile:

- presentation zoom: `0.50`;
- ground vertical compression: `0.72`;
- framing offset: `(0, -12)`;
- no player-controlled camera rotation;
- no live 3D camera in ordinary Hushiro combat.

These values are a playtest baseline, not a final immutable art number. Future tuning should be driven by threat readability: the player must be able to read melee approaches, ranged setup, projectiles/AoEs, escape space and environmental obstacles before they become immediate contact threats.

## Actor presentation contract

Actors use a presentation-only adapter separate from gameplay ownership.

Each actor resolves to:

- semantic state: `idle`, `move`, `dash`, `attack`, `defend`, `hurt`, `death`;
- one of eight presentation directions: `e`, `se`, `s`, `sw`, `w`, `nw`, `n`, `ne`;
- role identity such as `player`, `swordsman`, `hound`, `hollow`, `archer`, `bilemass`, `warden`;
- a visual scale independent of collision size.

Production sprite animation naming contract:

`<state>_<direction>`

Examples:

- `idle_s`
- `move_ne`
- `attack_w`
- `hurt_se`
- `death_n`

Temporary procedural 2D placeholders may satisfy this contract until actual art exists. A final hand-drawn atlas or offline-rendered atlas must be able to replace the placeholder without modifying movement, combat timing or hitboxes.

## Feet/pivot and scale contract

Every production character asset must be authored around a stable ground-contact anchor.

Rules:

- the actor's world position represents its feet/contact point on the combat plane;
- visual height does not alter collision dimensions;
- tall/bulky roles scale presentation separately from gameplay collision/range;
- animation must not introduce gameplay root motion;
- attack frames visually follow authoritative action progress rather than owning impact timing;
- old body sprites are exclusive with replacement presentation and must not render underneath new art.

## Environment contract

Hushiro environments should move toward layered illustrated 2D rather than live 3D geometry.

Recommended layer language:

1. ground/base painting;
2. floor decals, wear, blood, ash, roots and ritual markings;
3. low props that do not occlude actors;
4. actors/enemies and gameplay pickups;
5. depth-sorted mid-height props;
6. tall scenery/occluders such as torii, trees, houses, walls and shrine structures;
7. foreground silhouettes/frames;
8. world VFX and telegraphs;
9. screen-space HUD.

Depth sorting should use the object's ground-contact/base Y rather than the top of its artwork. Tall props may split into base and foreground/upper layers when that produces clearer overlap.

## VFX contract

Body art and combat VFX remain separate.

Sword trails, hit flashes, danger telegraphs, projectile cues, ground AoEs, status effects and corruption effects should be driven by combat state but not embedded into the character sprite atlas unless there is a strong production reason.

This allows character art to be replaced without touching combat readability or impact timing.

## Offline 3D-to-2D compatibility

If Oathbound later uses rigged 3D characters for production, those assets are content-generation tools rather than the live renderer.

Expected pipeline:

`concept -> model -> rig -> animate -> fixed camera directional renders -> atlas -> DirectionalActorPresentation`

The export camera, sprite canvas, feet pivot, direction names and animation-state names must be standardized so re-rendering an updated model does not require gameplay code changes.

## Immediate vertical-slice goal

The next Hushiro playtest does not need final art. It must prove an **ugly-but-correct** production composition:

- live runtime is 2D;
- camera is far enough out for multi-enemy threat reading;
- player/enemy bodies are materially smaller than the rejected live-3D versions;
- all standard roles have distinct placeholder silhouettes;
- presentation uses eight-direction state resolution;
- old body sprites never stack beneath replacements;
- actor sorting is tied to the ground plane;
- layered Hushiro scenery and CombatFX remain visible;
- no presentation system changes gameplay distances/timing.

After that gate, effort should shift from renderer architecture toward better placeholder/final actor art and Hushiro environment composition.

## Retired active path

`Planar3DPresentationBridge`, Hushiro V1/V2/V3 live-3D presenters, curated Quaternius actors and production-GLB validation remain in source control as research/reference. They must not be instantiated by the ordinary Hushiro `CombatChamber` while this direction is active.
