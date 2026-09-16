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
  - rig-rendered-2d
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

This direction is intentionally compatible with two character-art pipelines:

1. fully hand-drawn directional animation; or
2. offline 3D model -> rig -> animate -> fixed-angle render -> 2D sprite atlas.

Godot must not care which pipeline produced the final frames.

## September 16, 2026 composition gate: accepted

The first live playtest of the new Hushiro 2D-isometric presentation accepted the core composition direction.

Accepted qualities:

- the fixed high-angle perspective reads substantially better than the rejected live-3D slice;
- `0.50` presentation zoom gives materially better multi-enemy visibility;
- `0.72` ground compression creates the intended elevated/isometric read without changing the combat plane;
- player/enemy screen size is appropriate for the wider combat language;
- encounter space and approach vectors are easier to read;
- the accepted camera/profile survived a cleared encounter, reward collection and room transition without changing Combat V2 ownership.

Therefore camera distance, basic actor scale and the 2D runtime direction are no longer waiting on an architectural proof. They remain tunable art/readability values, but subsequent work should build **on this composition** rather than reopen the renderer decision without new evidence.

## Current character-production proof

The next production gate is intentionally narrower than a roster conversion:

> **Build one rig-rendered Akio and one rig-rendered Corrupted Swordsman, render both into eight-direction 2D atlases, and judge whether this pipeline plus a pixel-art/downsampled treatment is the right final character route.**

The Godot runtime now reserves explicit `DirectionalSpriteProfile` slots for those two roles. Until real atlases are supplied, their existing procedural placeholders remain active. Other enemy roles stay on placeholders during this proof.

Do not build the rest of Hushiro's roster from a 3D rig until the Akio/Swordsman pair passes visual, animation, memory and iteration-speed acceptance.

The detailed production handoff is `docs/art_production/RIG_RENDERED_2D_PIPELINE.md` and the machine-readable proof contract is `tools/rig2d/poc_manifest.json`.

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

Accepted Hushiro proving profile:

- presentation zoom: `0.50`;
- ground vertical compression: `0.72`;
- framing offset: `(0, -12)`;
- no player-controlled camera rotation;
- no live 3D camera in ordinary Hushiro combat.

Future tuning must be driven by threat readability: the player must be able to read melee approaches, ranged setup, projectiles/AoEs, escape space and environmental obstacles before they become immediate contact threats.

## Actor presentation contract

Actors use a presentation-only adapter separate from gameplay ownership.

Each actor resolves to:

- semantic state: `idle`, `move`, `dash`, `attack`, `defend`, `hurt`, `death`;
- one of eight presentation directions: `e`, `se`, `s`, `sw`, `w`, `nw`, `n`, `ne`;
- role identity such as `player`, `swordsman`, `hound`, `hollow`, `archer`, `bilemass`, `warden`;
- a visual scale independent of collision size.

Baseline production naming:

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

Temporary procedural 2D placeholders satisfy the same presentation seam until actual art exists. A hand-drawn atlas or offline-rendered atlas must replace the placeholder without modifying movement, combat timing or hitboxes.

## Attack animation authority

This is a hard rule for the rig-render proof:

> **Rendered attack animation follows combat timing; it never owns combat timing.**

`CombatActionRunner` exposes presentation-only normalized action progress. `DirectionalActorPresentation` uses that progress to select the visible frame of attack-specific directional animations.

Therefore:

- attack frame count can change without moving a hitbox window;
- hitstop and gameplay timing remain authoritative outside the sprite atlas;
- a re-rendered model cannot silently alter damage timing;
- the art pipeline can iterate independently from combat logic.

Idle and movement loops may free-run at their authored SpriteFrames speed.

## Feet/pivot and scale contract

Every production character asset must be authored around a stable ground-contact anchor.

Rules:

- the actor's world position represents its feet/contact point on the combat plane;
- visual height does not alter collision dimensions;
- tall/bulky roles scale presentation separately from gameplay collision/range;
- animation must not introduce gameplay root motion;
- attack frames visually follow authoritative action progress rather than owning impact timing;
- old body sprites are exclusive with replacement presentation and must not render underneath new art.

The initial Akio/Swordsman proof uses a fixed `128 x 128` frame canvas and `(64, 112)` feet anchor for every rendered frame. These can be revised as one whole-profile contract if the first model proves it needs more canvas, but individual frames must not be auto-trimmed around the moving body or weapon.

## Pixel-art proof contract

The first rig-rendered profiles are configured for nearest-neighbor filtering and pixel-snapped presentation once real atlases are active.

The comparison should retain high-quality source renders so the same rig can be evaluated as:

1. clean pre-rendered 2D;
2. downsampled/quantized pixel-art treatment;
3. selectively hand-cleaned pixel frames if needed.

Do not lock a final palette count, outline treatment or exact render-camera setup before the Akio/Swordsman comparison. Those are art decisions. Registration, direction naming and gameplay timing separation are the stable engineering contract.

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

## Offline 3D-to-2D pipeline

If Oathbound uses rigged 3D characters for production, those assets are content-generation tools rather than the live renderer.

Expected pipeline:

`concept -> model -> rig -> animate -> fixed camera directional renders -> optional pixel treatment -> SpriteFrames -> DirectionalActorPresentation`

The export camera, sprite canvas, feet pivot, direction names and animation-state names must be standardized so re-rendering an updated model does not require gameplay code changes.

A headless Godot builder now exists to ingest conventionally named imported PNG sequences, build a `SpriteFrames` resource, validate every required direction/animation and mark a profile asset-ready only after its contract passes.

## Current immediate priorities

1. keep the accepted Hushiro camera/composition and Combat V2 behavior stable;
2. create the first Akio 3D model/rig against the rig-rendered 2D contract;
3. render/import Akio's required eight-direction proof set;
4. create/render the Corrupted Swordsman using the same camera/canvas/feet-registration rules;
5. compare clean pre-rendered vs pixel-art/downsampled presentation in real Hushiro combat;
6. only after that acceptance decision, expand the character pipeline or invest heavily in remaining Hushiro character art;
7. continue developing layered Hushiro 2D scenery independently of the character proof where it does not obscure that comparison.

## Retired active path

`Planar3DPresentationBridge`, Hushiro V1/V2/V3 live-3D presenters, curated Quaternius actors and production-GLB validation remain in source control as research/reference. They must not be instantiated by the ordinary Hushiro `CombatChamber` while this direction is active.
