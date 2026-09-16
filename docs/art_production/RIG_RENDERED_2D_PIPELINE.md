# Rig-Rendered 2D Character Pipeline

Status: **implementation-ready proof pipeline**

This document is the production handoff between a future Blender/3D character rig and Oathbound's approved 2D isometric runtime. The first proof is deliberately limited to **Akio + one Corrupted Swordsman**. Do not convert the rest of the enemy roster until that pair proves that eight-direction rig renders, animation readability, pixel treatment, memory cost and iteration speed are worth the pipeline.

## Runtime boundary

The 3D model, rig, animation scene and render camera are **offline content-generation tools only**. Normal gameplay stays in Godot 2D.

Combat V2 remains authoritative for positions, movement, hitboxes, hurtboxes, damage, attack timing, Pressure Director admission, AI, targeting and progression. The rendered sprite is a presentation client. In particular, an attack frame never decides when damage occurs.

The runtime chain is:

`authoritative Node2D actor -> CombatActionRunner/state -> DirectionalActorPresentation -> DirectionalSpriteProfile -> SpriteFrames`

## Proof assets already registered

Godot now has two content slots:

- `res://Presentation/Profiles/AkioRigRendered2DProfile.tres`
- `res://Presentation/Profiles/CorruptedSwordsmanRigRendered2DProfile.tres`

They intentionally have `asset_ready=false` and no `SpriteFrames` yet. Hushiro continues to use its procedural placeholders until real frames are built. Once a profile receives a valid atlas, the same presenter automatically replaces the placeholder without changing combat code.

## Eight directions

Godot's combat plane uses +X right and +Y down. Render and name all eight directions independently; the proof should not rely on horizontal mirroring.

| Name | Godot facing | Screen angle |
| --- | --- | ---: |
| `e` | `(1, 0)` | 0° |
| `se` | `(0.7071, 0.7071)` | 45° |
| `s` | `(0, 1)` | 90° |
| `sw` | `(-0.7071, 0.7071)` | 135° |
| `w` | `(-1, 0)` | 180° |
| `nw` | `(-0.7071, -0.7071)` | 225° |
| `n` | `(0, -1)` | 270° |
| `ne` | `(0.7071, -0.7071)` | 315° |

The machine-readable copy is `tools/rig2d/poc_manifest.json`.

## Animation naming

Non-attack states use:

`<state>_<direction>`

Examples: `idle_s`, `move_ne`, `dash_w`, `defend_se`.

Attack states use the gameplay action id:

`attack_<action_id>_<direction>`

Examples: `attack_quick_slash_ne`, `attack_heavy_cleave_s`, `attack_basic_swing_w`, `attack_quick_thrust_n`.

The profile may alias secondary gameplay ids to a shared proof clip. This is how the first Swordsman proof can reuse `attack_cross_swing_*` for inherited follow-up slash ids without changing enemy combat code.

### Akio proof set

Render eight directions for these nine bases:

`idle`, `move`, `dash`, `defend`, `hurt`, `death`, `attack_quick_slash`, `attack_cross_cut`, `attack_heavy_cleave`.

That is 72 directional animations. Hold Thrust, Dash Slash, Counter Cut, Aspect-specific attacks and Prosthetics may temporarily alias/fallback while the route is being judged.

### Corrupted Swordsman proof set

Render eight directions for:

`idle`, `move`, `defend`, `hurt`, `death`, `attack_basic_swing`, `attack_quick_thrust`, `attack_cross_swing`, `attack_running_swing`.

Again, 72 directional animations. This is intentionally one soldier archetype, not a roster-wide commitment.

## Frame/canvas contract

The proof profiles start with these values:

- RGBA PNG with transparency;
- fixed `128 x 128` canvas on **every frame**;
- feet anchor at pixel `(64, 112)`;
- 12 fps baseline for free-running loops;
- no per-frame trimming/cropping;
- no baked gameplay root motion;
- nearest-neighbor filtering in Godot;
- pixel-snapped actor presentation when a rig atlas is active.

The actor's feet must remain on the same registration point through every animation. Weapon/body motion may move inside the canvas, but the canvas and feet registration do not move. If a sword needs more room, increase the profile canvas for the entire actor before rendering; do not dynamically crop individual frames.

The initial profile scale assumes the rendered subject will occupy roughly the same perceived height as the accepted placeholders. It is explicitly tunable after the first render without changing collision or combat range.

## Pixel-art test path

The recommended proof is **high-quality 3D animation rendered to transparent frames, then deliberately downsampled/stylized to a low-resolution sprite treatment**. Keep the original high-resolution renders outside the runtime export so we can compare:

1. clean pre-rendered 2D;
2. downsampled/quantized pixel-art treatment;
3. potentially hand-cleaned pixel frames.

Godot's profile currently requests nearest-neighbor filtering. This means the art team can swap the actual PNG treatment while the gameplay integration stays identical.

Do not lock the final palette count, outline treatment or render-camera pitch before the Akio/Swordsman comparison. Those are visual decisions; the registration and animation contract should remain stable.

## Authoritative attack sampling

Idle and movement loops may play at their authored SpriteFrames speed. Attack clips are different: `DirectionalActorPresentation` samples the current attack frame from `CombatActionRunner.action_progress()`.

Consequences:

- the sprite follows existing startup/active/recovery timing;
- changing PNG frame count cannot move a hit window;
- hitstop or future timing tuning does not require re-authoring gameplay events into the sprite atlas;
- the same render set can be tested against combat tuning without giving presentation gameplay authority.

This is a hard production rule for the proof.

## Rendering output layout

Place the imported PNGs for an actor in one flat source directory using:

`<animation_base>_<direction>_<frame:03>.png`

Examples:

- `move_ne_000.png`
- `move_ne_001.png`
- `attack_quick_slash_w_000.png`
- `attack_quick_slash_w_011.png`

Zero-padded frame numbers are required so lexical sorting equals animation order.

## Building SpriteFrames

After PNGs are copied into the Godot project, import them first:

```bash
godot --headless --path game/oathbound --import
```

Then build the atlas/profile. Akio example:

```bash
godot --headless --path game/oathbound \
  --script res://Tools/Rig2D/BuildDirectionalSpriteFrames.gd -- \
  --profile=res://Presentation/Profiles/AkioRigRendered2DProfile.tres \
  --source=res://Art2D/RigRendered/Akio/Frames \
  --output=res://Art2D/RigRendered/Akio/AkioDirectionalSpriteFrames.tres
```

The builder refuses to mark the profile ready unless every required direction/animation exists, loop flags are correct, frames are non-null, and the fixed canvas size matches the profile. The same command works for the Swordsman profile with its own source/output paths.

## Acceptance gate before expanding the pipeline

Only Akio and the Corrupted Swordsman should receive real rig-rendered art for the first comparison. Judge the pair in the already-approved Hushiro camera on:

- eight-direction locomotion readability;
- attack silhouette and anticipation at actual combat size;
- whether 12 fps/pixel stepping feels intentional rather than choppy;
- visual registration during dashes/lunges/hitstop;
- overlap/depth sorting in crowds;
- memory and import/build cost;
- how quickly one animation can be revised in Blender and re-rendered;
- whether the pixel-art treatment strengthens Oathbound's identity compared with cleaner pre-rendered frames.

Do not build the remaining roster from this pipeline until that test is accepted.
