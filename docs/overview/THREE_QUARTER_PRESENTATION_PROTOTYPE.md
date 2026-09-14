# Three-Quarter / 2.5D Presentation Direction

Status: **direction adopted; vertical-slice implementation in progress**

Branch: `agent/three-quarter-pov-prototype`

## Decision

Oathbound is moving toward a fixed high-angle three-quarter / isometric-like presentation.

The first camera-only playtest was intentionally crude and exposed the main weakness of a projection-only approach: old top-down environment art simply looks compressed when viewed through non-uniform zoom. The useful result of that test was the spatial direction itself. The project should now build authored presentation content around the new view rather than trying to make legacy art carry the conversion.

This remains a 2D gameplay simulation:

- `CharacterBody2D` movement remains authoritative.
- Current 2D collision shapes and hitboxes remain authoritative.
- Current 2D enemy AI, navigation, pressure logic and encounter geometry remain authoritative.
- Attack ranges and ground distances are not rewritten merely for presentation.
- The renderer/presentation layer projects those coordinates for the screen.

Architecture rule:

> **2D combat simulation + fixed three-quarter projected presentation + dimensional artwork.**

Do not migrate Oathbound to full `CharacterBody3D` / 3D physics merely to obtain this camera style unless a later prototype proves that actual vertical gameplay is required.

## V2 projection baseline

`CameraFollow.gd` owns the reversible global camera profile.

Current defaults:

- horizontal camera zoom: `0.94`
- ground-plane vertical compression: `0.84`
- framing offset: `Vector2(0, -18)`
- character art is counter-projected vertically so body sprites do not inherit the floor squash
- player/enemy roots receive Y-derived draw order
- player/enemy contact shadows establish a visible ground plane
- shadow creation is deferred so GameFlow room construction cannot race `add_child()`

The projection is deliberately gentler than V1 (`0.72` compression). V2 relies more on authored depth cues, vertical silhouettes and foreground occlusion instead of forcing the entire visual effect through camera distortion.

A world-space circle still reads as an ellipse on screen, which is expected for a circular ground-space range viewed from a high angle. Physics remains circular in simulation space.

## Hushiro vertical-slice placeholder art

`Regions/Hushiro/Presentation/ThreeQuarterHushiroPrototype.gd` provides temporary procedural scenery for the canonical Hushiro combat chamber.

It is presentation-only and adds no collision or combat authority. Current placeholders include:

- a bounded trapezoidal combat floor rather than an infinite dirt field;
- sparse diagonal ground guides and worn central combat space;
- a far retaining wall with visible top faces;
- a ruined torii with hanging talisman remnants;
- roadside shrine ruins and rock clusters;
- foreground broken fences and dead grass that can occlude actors;
- Y-anchored prop depth using the same broad ordering convention as actors.

This is not intended to become final vector art. Its purpose is to test composition, depth readability and the production rules future painted assets must obey.

## Playtest controls

Press **F9** at runtime to switch instantly between:

1. the three-quarter V2 presentation, and
2. the legacy top-down presentation.

A small upper-left badge shows which mode is active.

## What the next playtest should answer

Judge the V2 slice on:

- whether the room now reads as a place with a foreground, combat plane and backdrop rather than a stretched texture;
- whether Akio/enemies remain readable while moving through Y depth;
- whether foreground props make the scene feel dimensional without obscuring combat unfairly;
- whether the gentler projection preserves natural movement and spacing;
- whether attack ranges and enemy pressure still feel correct visually;
- what size and silhouette future Akio/enemy three-quarter artwork should target;
- whether the fixed camera exposes enough arena context for Hades-like multi-enemy combat.

Do **not** judge the final character-art quality yet. Current sprites were authored for the previous view.

## Production conversion roadmap

### 1. Camera and depth foundation

- stable fixed three-quarter profile;
- actor/prop depth anchors;
- contact shadows;
- foreground occlusion policy;
- screen-upright vs ground-projected element policy.

### 2. Hushiro presentation vertical slice

- one deliberately authored combat chamber;
- Akio placeholder authored for the target angle;
- Swordsman plus one contrasting enemy placeholder;
- representative melee/ranged telegraphs;
- impact, slash and movement VFX adapted to the ground projection.

### 3. Character art pipeline

Initial production target: up to eight directions where silhouette/facing materially matters. Not every animation needs eight unique drawings if mirroring or authored directional reuse remains readable.

Character art needs:

- stable foot/ground anchors;
- consistent body height through directional frames;
- silhouettes that remain readable against dark environments;
- weapon arcs authored around screen depth rather than top-down radial motion.

### 4. Environment conversion

Replace procedural placeholders with dimensional Hushiro modules:

- floor/ground planes;
- walls with visible faces and top surfaces;
- gates, shrines, houses and cliffs with explicit ground anchors;
- foreground modules designed to occlude only safe combat space;
- atmospheric background layers outside the simulation bounds.

### 5. VFX and UI conversion

Classify every effect as either:

- **ground-space**: projected with the arena (AoE rings, target zones, floor trails, landing marks), or
- **screen/upright**: kept visually upright (damage numbers, most HUD, status labels, selected particles).

This classification should prevent the stretched-overlay problem from returning as more content is converted.

## Non-goals

The presentation shift does not require throwing away the current combat architecture. Player movement, enemy AI, Pressure Director, Health/Poise rules, encounter scheduling, Aspects, Techniques, Relics and other combat systems remain useful unless playtesting reveals a separate gameplay reason to change them.
