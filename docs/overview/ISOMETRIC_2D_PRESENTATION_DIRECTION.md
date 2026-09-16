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
  - ART-DIRECTION
  - ART-TECHNICAL-STANDARDS
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
2. offline 3D model -> rig -> animate -> fixed-angle render -> 2D frames.

Godot consumes the same directional-sprite contract regardless of how the final frames were produced.

Live real-time 3D actors/environments are not the ordinary production target. The previous Planar3D work remains historical research/reference unless the project explicitly reopens that renderer decision.

## Accepted composition gate

The Hushiro playtest accepted the core composition direction.

Accepted proving profile:

- presentation zoom: `0.50`;
- ground vertical compression: `0.72`;
- framing offset: `(0, -12)`;
- fixed Camera2D orientation;
- small actor screen-space scale appropriate for multi-enemy combat.

These values remain tunable art/readability parameters, but subsequent work should build on this composition rather than reopen the renderer decision without new evidence.

## Current character-production gate

The next expensive art decision is intentionally staged around a **custom Akio**, not a generic universal-base character.

### Gate A — Akio minimum proof

Produce the custom Akio model/rig and prove at least:

- Idle;
- Move / combat run;
- Quick Slash;
- all eight directions;
- stable feet/contact registration;
- high-resolution transparent masters;
- one or more current runtime derivatives for in-game comparison.

Judge this proof inside the accepted Hushiro camera before paying for or producing a complete animation library.

The purpose is to validate Akio's real silhouette, animation language, source-rig quality, render setup, clean-prerender vs pixel/downsample treatment, and iteration speed.

### Gate B — Akio Stage 1

After Gate A passes, complete the current Akio production profile:

`idle`, `move`, `dash`, `defend`, `hurt`, `death`, `attack_quick_slash`, `attack_cross_cut`, `attack_heavy_cleave`.

### Gate C — Corrupted Swordsman

After the Akio pipeline is accepted, produce one Corrupted Swordsman with the same camera/registration/runtime contract. The Akio + Swordsman pair is then used to validate crowd depth, repeated actor cost, player/enemy style consistency, and whether the pipeline should scale across the roster.

Do not scale the source-rig pipeline across the roster until these gates pass.

The detailed production handoff is `docs/art_production/RIG_RENDERED_2D_PIPELINE.md`, the artist-facing Akio authority is `docs/commissions/akio/AKIO_COMMISSION_BRIEF.md`, and the machine-readable **current runtime derivative** contract is `tools/rig2d/poc_manifest.json`.

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

Camera changes should be evaluated in representative multi-enemy Hushiro combat rather than from an empty-room screenshot alone.

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
- source animation authoring FPS does not need to equal runtime sprite FPS;
- art production can iterate independently from combat logic.

The animator should still provide clear anticipation, strike/follow-through, and recovery structure. Godot can remap those visual phases over the authoritative action timeline without requiring the source Action to encode gameplay events.

Idle and locomotion loops may free-run at their authored SpriteFrames speed.

## Feet, registration, and scale contract

Every production character asset is authored around a stable ground-contact anchor.

Rules:

- actor world position represents its feet/contact point on the combat plane;
- visual height does not alter collision dimensions;
- bulky/tall roles scale presentation separately from gameplay collision/range;
- source animation does not introduce gameplay-authoritative root motion;
- attack frames visually follow authoritative action progress;
- replacement body art is exclusive and must hide obsolete placeholder/body visuals.

The current Godot proof derivative uses a fixed `128 x 128` frame canvas and `(64, 112)` feet anchor. Those values describe the **runtime proof profile**, not the resolution of paid source/master renders.

Paid/custom source art should preserve substantially higher-resolution transparent master renders and editable source files so runtime resolution/style can be changed without reconstructing the character.

## Source/master vs runtime derivative

The production pipeline explicitly has two tiers.

### Source/master tier

Keep:

- editable model/rig/Actions;
- fixed render setup;
- high-resolution transparent masters;
- stable registration;
- no per-frame cropping;
- enough margin for weapon arcs;
- provenance/rights information.

For Akio, approximately `1024 x 1024` transparent masters are a reasonable working target if the full weapon silhouette fits comfortably, but the exact master canvas can be adjusted to the source setup.

### Runtime derivative tier

The current proof validator and Blender templates are built around `128 x 128` RGBA frames at a 12 fps proof cadence. That is the current import/test contract, not a final visual-resolution decision.

If the Akio proof shows that a different whole-profile canvas or cadence is needed, update the runtime profile/tooling deliberately. Do not auto-trim individual frames or allow the feet anchor to wander.

## Direction contract

The production direction order is:

`e, se, s, sw, w, nw, n, ne`

The source asset rotates against a fixed render camera so one authored action can generate all required directions. The runtime selects the already-rendered direction from gameplay facing.

Render all eight directions independently for production. Do not assume four-direction horizontal mirroring is safe, because handedness, katana/scabbard placement, costume asymmetry, corruption asymmetry and weapon paths would reverse.

No gameplay facing calculation should depend on sprite appearance.

## Clean-prerender vs pixel-treatment proof

Keep high-quality source renders so the same rig/action can be evaluated as:

1. clean prerendered 2D;
2. downsampled/quantized pixel treatment;
3. selectively hand-cleaned frames if useful.

Do not lock a final palette count, outline treatment, exact source-render shader, or final runtime resolution before the Akio comparison. Registration, direction naming, gameplay-timing separation, source ownership, and runtime import are the stable engineering contract.

The style decision should be made from actual Hushiro combat with multiple threats, not enlarged isolated character previews.

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

The production target is not live modular 3D scenery. Offline 3D can still be used as a perspective/layout/paintover aid if the final runtime result remains layered 2D and obeys the same occlusion/readability rules.

## VFX contract

Body art and combat VFX remain separate.

Sword trails, hit flashes, danger telegraphs, projectile cues, ground AoEs, status effects, and corruption effects are driven by combat state but should not be baked into the character frame set unless a specific production need justifies it.

This keeps combat readability and timing stable while actor art is replaced or rerendered.

## Offline source-rig pipeline

Expected production pipeline:

`concept/turnaround -> custom model -> rig -> animate -> fixed-camera high-res directional masters -> runtime derivatives -> optional pixel treatment -> SpriteFrames -> DirectionalActorPresentation`

The source render camera, feet anchor, direction names, animation-state names, and source-to-runtime traceability are standardized so rerendering an updated model does not require gameplay-code changes.

The repository includes validation/import tooling for conventionally named runtime PNG sequences and `DirectionalSpriteProfile` resources. A production profile becomes asset-ready only after its required direction/animation contract passes.

## Immediate priorities

1. keep the accepted Hushiro camera/composition and Combat V2 behavior stable;
2. use the Akio commission brief to source/produce the custom Akio model, textures, rig and editable source package;
3. complete Akio Gate A with Idle + Move + Quick Slash in all eight directions;
4. derive clean and pixel/downsample runtime treatments from the same high-resolution masters;
5. judge Akio in real Hushiro combat before completing the full paid animation set;
6. after Akio Gate A passes, finish the current Stage 1 profile and validate dash/guard/hurt/death/full basic chain;
7. only then produce the Corrupted Swordsman proof on the same standards;
8. validate multiple actors, Y-depth, attack readability, memory/import cost and iteration speed;
9. only after that acceptance decision, expand character production across the roster;
10. continue layered Hushiro scenery production where it does not obscure the character comparison.

## Scope guard

Do not add a second live actor-rendering architecture beside this one. Experimental or retired renderer code may remain temporarily only as historical research/reference; ordinary gameplay scenes, production docs, tests, and new implementation should target the current isometric 2D presentation contract.
