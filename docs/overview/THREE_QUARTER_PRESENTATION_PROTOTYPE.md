# Three-Quarter Presentation Bridge

Status: **transitional compatibility layer**

The original Camera2D three-quarter projection prototype proved the camera composition, room readability, upright actor silhouettes, projected ground cues, and general high-angle direction that Oathbound now wants to keep.

It is no longer the final production target.

The authoritative presentation direction is now [STYLIZED_3D_PRESENTATION_DIRECTION.md](STYLIZED_3D_PRESENTATION_DIRECTION.md):

> **Planar action-roguelite combat + fixed high-angle Camera3D presentation + stylized 3D characters, enemies, rooms, props, lighting, and VFX.**

This file now defines what the existing 2D projection/proxy stack is allowed to do while the 3D vertical slice is built.

## What the current bridge preserves

Until a room or actor is migrated to the 3D production path, the existing three-quarter bridge remains useful for playable continuity and design validation.

Current compatibility responsibilities include:

- preserving existing CharacterBody2D movement/collision for unmigrated actors;
- projecting current room geometry with the established high-angle composition;
- keeping screen-upright actor/UI presentation readable;
- providing temporary upright procedural actor proxies;
- providing temporary contact shadows and Y-derived depth ordering;
- preserving current combat/encounter rules while presentation changes underneath them;
- allowing F9 developer comparison against legacy flat presentation when debugging regressions.

The bridge must not become a reason to keep final production characters or final production rooms in the old representation.

## Existing projection baseline

`Utility/CameraFollow.gd` currently owns the compatibility projection profile:

- horizontal camera zoom: `0.94`;
- ground-plane vertical compression: `0.84`;
- framing offset: `Vector2(0, -18)`;
- actor artwork may be counter-projected vertically;
- world-space interface roots are counter-projected once;
- player/enemy roots receive Y-derived draw order;
- temporary contact shadows establish the ground plane;
- procedural proxy/shadow attachment is deferred so GameFlow construction cannot race `add_child()`.

These values are compatibility tuning, not requirements for the future Camera3D implementation.

## Current world coverage

The compatibility presentation currently covers:

1. The Strand / Hub;
2. Hushiro;
3. Yomori;
4. Kagutsuchi Court;
5. Blood Cavern training.

Title/video/CanvasLayer menu screens remain screen-space interfaces.

## Temporary actor proxies

`Utility/ThreeQuarterActorProxy.gd` remains a temporary readability/prototyping tool.

It may communicate:

- player/enemy role silhouettes;
- broad facing;
- attack/guard posture;
- rough regional identity;
- approximate body volume at the intended camera scale.

It is not final character art and should not receive large final-art investment.

## Replacement visual exclusivity

This compatibility layer must obey the same production rule as the future 3D path:

> **A replacement actor visual is exclusive, not additive.**

When a proxy/custom visual replaces an actor body, previous body visuals must not remain visible underneath it.

The bridge therefore needs to handle more than one direct `Sprite2D` when necessary. Nested or multipart legacy `Sprite2D`/`AnimatedSprite2D` body stacks must be hidden/restored as a set. Intentional auxiliary VFX may opt out explicitly.

Future production 3D actors should avoid heuristics by owning a clear visual root that can be enabled/disabled deterministically.

## Ground-space vs upright-space rule

This classification remains useful in 3D and should survive migration.

### Ground-space

Examples:

- AoE footprints;
- target zones;
- floor trails;
- landing marks;
- contact shadows;
- range indicators;
- floor decals.

These belong to the combat plane and should preserve gameplay scale.

### Upright/screen-space

Examples:

- character bodies;
- interaction labels;
- world health/status UI where retained;
- damage numbers;
- HUD;
- menus;
- selected particles meant to rise vertically.

The 3D implementation may realize these differently, but the semantic distinction remains valuable.

## Regional visual language preserved through migration

### Hushiro

- weathered earth and stone;
- ruined torii/shrine forms;
- broken fencing and sparse village architecture;
- blood/ember ritual accents;
- recent corruption and physical collapse.

Hushiro is the first production 3D proving ground.

### Yomori

- wet blue-green/desaturated ground;
- broken stone and crooked trees;
- exposed roots, reeds, mist, spectral lights;
- long-term predation/adaptation.

### Kagutsuchi Court

- dark court stone;
- crimson lacquer and gold ritual trim;
- strict pillars/wall rhythm;
- banners, braziers, monumental gates;
- disciplined false-ascendancy presentation.

These visual identities move forward into 3D rather than being discarded with the old projection technique.

## Validation responsibility during transition

Existing presentation validation may continue protecting unmigrated scenes, but it must evolve as the 3D path lands.

Do not weaken gameplay invariants just to satisfy a presentation migration. Regional route contracts still own route structure, roster, boss authority, and encounter semantics.

New 3D validation should eventually cover:

- fixed-camera availability/framing;
- ground-plane coordinate agreement;
- required 3D actor visual roots;
- replacement-visual exclusivity;
- collision/hitbox timing parity where a system is migrated;
- room/camera/occlusion conventions;
- representative Hushiro vertical-slice traversal.

## Non-goals

The compatibility bridge does not authorize:

- a full free-camera third-person rewrite;
- changing combat ranges merely to match visuals;
- adding unrestricted vertical navigation;
- replacing stable Pressure Director/encounter systems without a gameplay reason;
- treating procedural proxies as final art.

The bridge exists to keep the game playable while Oathbound moves to its approved stylized 3D production representation.
