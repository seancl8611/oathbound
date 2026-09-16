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
  - high-angle-camera
  - directional-sprites
  - planar-combat
  - environment-production
  - character-production
  - rig-rendered-2d
related:
  - OVERVIEW-V2-COMBAT-DIRECTION
  - ART-RIG-RENDERED-2D-PIPELINE
---

# Isometric 2D Runtime Presentation Direction

Status: **approved production direction**

## Decision

Oathbound's live game runtime is **2D planar combat with an authored high-angle/isometric-style presentation**.

The concise target is:

> **2D authoritative combat + fixed high-angle/isometric Camera2D composition + small eight-direction actor sprites + layered illustrated 2D environments + independent 2D combat VFX.**

Character art may be produced through either:

1. fully hand-drawn directional animation; or
2. offline 3D model → rig → animate → fixed-angle render → 2D frames.

Godot should consume the same directional-sprite contract regardless of how the final frames were produced.

## Accepted composition gate

The Hushiro playtest accepted the core composition direction.

Accepted proving profile:

- presentation zoom: `0.50`;
- ground vertical compression: `0.72`;
- framing offset: `(0, -12)`;
- fixed Camera2D orientation;
- small actor screen-space scale appropriate for multi-enemy combat.

These values remain tunable art/readability parameters, but subsequent work should build on this composition rather than reopen the renderer decision without new evidence.

## Current character-production proof

The next production gate is intentionally narrow:

> **Build one Akio-appropriate rig-rendered source character and one Corrupted Swordsman, render both into eight-direction 2D frame sets, and judge whether clean prerender or a deliberate pixel/downsample treatment is the better final character route.**

The Godot runtime reserves `DirectionalSpriteProfile` seams for those roles. Until real frame sets are supplied, procedural placeholders remain valid temporary presentation.

Do not scale the source-rig pipeline across the roster until the Akio/Swordsman pair passes visual, animation, memory, registration, and iteration-speed acceptance.

The detailed production handoff is `docs/art_production/RIG_RENDERED_2D_PIPELINE.md` and the machine-readable proof contract is `tools/rig2d/poc_manifest.json`.

## Gameplay authority boundary

Presentation work does not rewrite Combat V2.

Gameplay remains authoritative for:

- actor world positions and movement;
- gameplay facing;
- hitboxes and hurtboxes;
- attack reach and timing;
- Health and Poise/interruption;
- guard/Reprisal rules owned by the relevant kit;
- Pressure Director scheduling;
- enemy AI and encounter coordination;
- soft targeting and target handoff;
- Techniques, Aspects, Relics, Prosthetics, and Corruption;
- room progression and rewards.

The world remains a `Vector2` combat plane. Isometric depth is a rendering convention, not a new gameplay axis.

## Camera contract

The gameplay camera is fixed, high-angle, and wide enough to support multi-enemy pressure readability.

Future tuning must be driven by threat readability: the player must be able to read melee approaches, ranged setup, projectiles/AoEs, escape space, and environmental obstacles before they become immediate contact threats.

## Actor presentation contract

Actors use a presentation-only adapter separate from gameplay ownership.

Each actor resolves to:

- semantic state such as `idle`, `move`, `dash`, `attack`, `defend`, `hurt`, `death`;
- one of eight presentation directions: `e`, `se`, `s`, `sw`, `w`, `nw`, `n`, `ne`;
- role identity such as `player`, `swordsman`, `hound`, `hollow`, `archer`, `bilemass`, `warden`;
- visual scale independent of gameplay collision size.

Baseline loop/state naming:

`<state>_<direction>`

Examples:

- `idle_s`
- `move_ne`
- `hurt_se`
- `death_n`

Rig-rendered attacks use action-specific names:

`attack_<action_id>_<direction>`

Examples:

- `attack_quick_slash_ne`
- `attack_heavy_cleave_s`
- `attack_basic_swing_w`
- `attack_quick_thrust_n`

Temporary procedural placeholders must satisfy the same presentation seam so final art can replace them without changing movement, combat timing, targeting, or hitboxes.

## Attack animation authority

This is a hard production rule:

> **Rendered attack animation follows combat timing; it never owns combat timing.**

`CombatActionRunner` exposes presentation-only normalized action progress. `DirectionalActorPresentation` uses that progress to select the visible frame of action-specific directional animation.

Therefore:

- changing frame count cannot silently move gameplay hit windows;
- hitstop and gameplay timing remain authoritative outside the sprite frame set;
- re-rendering a source model cannot alter damage timing;
- art production can iterate independently from combat logic.

Idle and locomotion loops may free-run at their authored SpriteFrames speed.

## Feet, registration, and scale contract

Every production character asset is authored around a stable ground-contact anchor.

Rules:

- actor world position represents its feet/contact point on the combat plane;
- visual height does not alter collision dimensions;
- bulky/tall roles scale presentation separately from gameplay collision/range;
- source animation does not introduce gameplay root motion;
- attack frames visually follow authoritative action progress;
- replacement body art is exclusive and must hide obsolete placeholder/body visuals.

The first Akio/Swordsman proof uses a fixed `128 x 128` frame canvas and `(64, 112)` feet anchor. Those values may be revised only as a whole-profile contract; individual frames must not be independently auto-trimmed around the moving body or weapon.

## Direction contract

The production direction order is:

`e, se, s, sw, w, nw, n, ne`

The source asset rotates against a fixed render camera so one authored action can generate all required directions. The runtime selects the already-rendered direction from gameplay facing.

No gameplay facing calculation should depend on sprite appearance.

## Clean-prerender vs pixel-treatment proof

Keep high-quality source renders so the same rig/action can be evaluated as:

1. clean prerendered 2D;
2. downsampled/quantized pixel treatment;
3. selectively hand-cleaned frames if useful.

Do not lock a final palette count, outline treatment, or exact source-render shader before the Akio/Swordsman comparison. Registration, direction naming, gameplay-timing separation, and runtime import are the stable engineering contract.

## Environment contract

Hushiro environments use layered illustrated 2D construction.

Recommended layer language:

1. ground/base painting;
2. floor decals, wear, blood, ash, roots, and ritual markings;
3. low props that do not occlude actors;
4. actors/enemies and gameplay pickups;
5. depth-sorted mid-height props;
6. tall scenery/occluders such as torii, trees, houses, walls, and shrine structures;
7. foreground silhouettes/frames;
8. world VFX and telegraphs;
9. screen-space HUD.

Depth sorting uses each object's ground-contact/base Y rather than the top of its artwork. Tall props may split into base and foreground/upper layers when that produces clearer overlap.

## VFX contract

Body art and combat VFX remain separate.

Sword trails, hit flashes, danger telegraphs, projectile cues, ground AoEs, status effects, and corruption effects are driven by combat state but should not be baked into the character frame set unless a specific production need justifies it.

This keeps combat readability and timing stable while actor art is replaced or rerendered.

## Offline source-rig pipeline

Expected production pipeline:

`concept → model → rig → animate → fixed-camera directional renders → optional pixel treatment → SpriteFrames → DirectionalActorPresentation`

The source render camera, canvas, feet anchor, direction names, and animation-state names are standardized so rerendering an updated model does not require gameplay-code changes.

The repository includes validation/import tooling for conventionally named PNG sequences and `DirectionalSpriteProfile` resources. A profile becomes asset-ready only after its required direction/animation contract passes.

## Immediate priorities

1. keep the accepted Hushiro camera/composition and Combat V2 behavior stable;
2. acquire/create the first Akio-appropriate source rig and required proof actions;
3. render/import Akio's eight-direction proof set;
4. create/render the Corrupted Swordsman using the same camera/canvas/feet rules;
5. compare clean prerender and pixel/downsample treatment in real Hushiro combat;
6. validate multiple actors, Y-depth, attack readability, and memory/import cost;
7. only after that acceptance decision, expand the character pipeline;
8. continue layered Hushiro scenery production independently where it does not obscure the character comparison.

## Scope guard

Do not add a second live actor-rendering architecture beside this one. Experimental or retired renderer code may remain temporarily only while cleanup work is active; ordinary gameplay scenes, production docs, tests, and new implementation should target the current isometric 2D presentation contract.