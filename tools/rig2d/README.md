# Rig-rendered 2D proof tooling

Status: **Godot integration ready; offline Akio + Corrupted Swordsman proof is the next content step.**

This folder is the working bridge between a Blender character rig and the live Godot 2D runtime. The production contract remains documented in `docs/art_production/RIG_RENDERED_2D_PIPELINE.md`; the machine-readable runtime contract is `poc_manifest.json`.

The first proof is intentionally limited to two actors:

- Akio;
- one Corrupted Swordsman.

Do not expand this pipeline to the rest of the roster until those two actors have been judged in the accepted Hushiro camera.

## 1. Build the Blender proof scene

For each actor, create a Blender scene with:

- the character mesh and armature;
- a stable root object whose origin is the feet/contact point;
- in-place actions with no gameplay root motion;
- a fixed orthographic render camera;
- transparent world/background output;
- one action for every animation base in the actor template.

Start from one of the templates in `blender/`:

- `akio_export.template.json`
- `corrupted_swordsman_export.template.json`

The object/action names in those files are explicit placeholders. Rename them to match the actual `.blend` scene rather than changing Godot gameplay code.

## 2. Render all eight directions

Run Blender in background mode from the repository root:

```bash
blender -b /path/to/akio_proof.blend \
  -P tools/rig2d/blender/render_directional.py -- \
  --config tools/rig2d/blender/akio_export.template.json
```

The exporter rotates the configured root object, applies each configured action, samples its frame range, and writes files using the Godot contract:

`<animation_base>_<direction>_<frame:03>.png`

Example:

`attack_quick_slash_ne_004.png`

The templates assume a 24 fps Blender timeline sampled every two frames, producing the current 12 fps proof cadence. Change that only deliberately.

Generated working renders belong under `tools/rig2d/exports/`, which is git-ignored.

## 3. Validate the final runtime frame set

Before copying frames into Godot, validate naming, coverage, frame numbering, PNG format, and canvas size:

```bash
python tools/rig2d/validate_frame_set.py \
  --manifest tools/rig2d/poc_manifest.json \
  --actor akio \
  --source tools/rig2d/exports/akio/frames
```

For the soldier proof:

```bash
python tools/rig2d/validate_frame_set.py \
  --manifest tools/rig2d/poc_manifest.json \
  --actor corrupted_swordsman \
  --source tools/rig2d/exports/corrupted_swordsman/frames
```

The validator fails on missing directional clips, malformed names, non-contiguous frame numbering, wrong canvas size, or PNGs that are not 8-bit RGBA.

## 4. Install validated frames into Godot

Copy the validated frame sets to:

- `game/oathbound/Art2D/RigRendered/Akio/Frames`
- `game/oathbound/Art2D/RigRendered/CorruptedSwordsman/Frames`

Then import and build the Godot `SpriteFrames` resources:

```bash
godot --headless --path game/oathbound --import

godot --headless --path game/oathbound \
  --script res://Tools/Rig2D/BuildDirectionalSpriteFrames.gd -- \
  --profile=res://Presentation/Profiles/AkioRigRendered2DProfile.tres \
  --source=res://Art2D/RigRendered/Akio/Frames \
  --output=res://Art2D/RigRendered/Akio/AkioDirectionalSpriteFrames.tres
```

Use the equivalent Corrupted Swordsman paths/profile for the enemy proof.

## 5. Validate in the accepted Hushiro slice

Run the dedicated Godot validation before manual playtesting:

```bash
godot --headless --path game/oathbound \
  res://Regions/Hushiro/Validation/RigRendered2DPipelineSmoke.tscn
```

Then play the normal Hushiro chamber at the accepted `0.50` zoom / `0.72` ground-compression composition. The proof is about art/readability and production viability, not a new combat-authority layer.

The decision gate remains: eight-direction readability, attack silhouette/anticipation, feet registration, crowd depth sorting, pixel treatment, memory/import cost, and Blender iteration speed.