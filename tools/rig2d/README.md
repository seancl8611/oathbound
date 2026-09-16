# Rig-rendered 2D proof tooling

Status: **Godot runtime integration ready; custom Akio source proof is the next content step.**

This folder is the working bridge between a Blender character source and the live Godot 2D runtime.

Production authority:

- `docs/overview/ISOMETRIC_2D_PRESENTATION_DIRECTION.md` — runtime/presentation direction
- `docs/art_production/RIG_RENDERED_2D_PIPELINE.md` — source/master/runtime production handoff
- `docs/commissions/akio/AKIO_COMMISSION_BRIEF.md` — artist-facing Akio commission scope
- `poc_manifest.json` — current **runtime derivative** contract

The repository tooling currently validates the fixed 128 x 128 proof derivative. It does **not** replace the separate requirement to preserve higher-resolution paid master renders and editable source files.

## Current production order

1. Commission/finish the custom Akio source model + rig.
2. Prove Akio **Idle + Move + Quick Slash** in all eight directions first.
3. Judge Akio in Oathbound before completing the full Stage 1 animation library.
4. Finish the current Akio production profile after that proof passes.
5. Build one Corrupted Swordsman on the same pipeline.
6. Only then decide whether to scale the method across the roster.

Do not weaken the full production validator merely to accept the intentionally incomplete first Akio proof. When implementation reaches that point, use a dedicated proof subset/profile/config for the three-action gate.

## 1. Build the Blender source scene

For each actor, create a Blender scene with:

- character mesh and armature;
- stable root object whose origin/registration corresponds to the feet/contact point;
- in-place gameplay Actions with no authoritative gameplay root motion;
- fixed orthographic render camera;
- transparent world/background output;
- consistent lighting/material setup;
- semantic Action names that map cleanly to the runtime animation bases.

Current full-profile templates:

- `blender/akio_export.template.json`
- `blender/corrupted_swordsman_export.template.json`

The object/action names in those files are explicit placeholders. Rename them to match the real `.blend` scene rather than changing Godot gameplay code.

The current templates are configured for the 128 x 128 runtime proof derivative. A paid Akio source should also preserve higher-resolution transparent masters. Extend the render tooling deliberately when the real source arrives if we want one automated master -> derivative flow.

## 2. Render all eight directions

The production direction order is:

`e, se, s, sw, w, nw, n, ne`

All eight should be rendered independently. Do not assume horizontal mirroring is safe for final production because handedness, scabbard placement, costume asymmetry and weapon paths would reverse.

Current runtime-derivative example from the repository root:

```bash
blender -b /path/to/akio_source.blend \
  -P tools/rig2d/blender/render_directional.py -- \
  --config tools/rig2d/blender/akio_export.template.json
```

The exporter rotates the configured root object, applies each configured Action, samples its frame range, and writes:

`<animation_base>_<direction>_<frame:03>.png`

Example:

`attack_quick_slash_ne_004.png`

The existing templates assume a 24 fps Blender timeline sampled every two frames, producing the current 12 fps proof cadence. Source animation authoring FPS and runtime sprite cadence are separate decisions; change the export cadence only deliberately.

Generated working renders belong under `tools/rig2d/exports/`, which is git-ignored.

## 3. Preserve high-resolution masters

For commissioned/final-source characters, keep transparent high-resolution master renders separate from the runtime derivative.

The current Akio brief recommends roughly 1024 x 1024 masters when that canvas comfortably contains the full body/weapon silhouette. Exact master resolution may be adjusted, but the master set must:

- remain fixed per output tier;
- preserve stable feet registration;
- avoid per-frame auto-cropping;
- use the fixed projection/camera;
- contain enough margin for weapon arcs;
- remain traceable to the runtime derivative.

Do not treat `poc_manifest.json`'s 128 x 128 value as the paid-master specification.

## 4. Validate the final runtime frame set

Before copying runtime-derivative frames into Godot, validate naming, coverage, frame numbering, PNG format, and canvas size:

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

The production validator fails on missing directional clips, malformed names, non-contiguous frame numbering, wrong canvas size, or PNGs that are not 8-bit RGBA.

For the initial three-action Akio Gate A, use a separate limited proof validator/config rather than removing requirements from the production profile.

## 5. Install validated frames into Godot

Full production-profile frame sets belong at:

- `game/oathbound/Art2D/RigRendered/Akio/Frames`
- `game/oathbound/Art2D/RigRendered/CorruptedSwordsman/Frames`

Then import and build the Godot `SpriteFrames` resource:

```bash
godot --headless --path game/oathbound --import

godot --headless --path game/oathbound \
  --script res://Tools/Rig2D/BuildDirectionalSpriteFrames.gd -- \
  --profile=res://Presentation/Profiles/AkioRigRendered2DProfile.tres \
  --source=res://Art2D/RigRendered/Akio/Frames \
  --output=res://Art2D/RigRendered/Akio/AkioDirectionalSpriteFrames.tres
```

Use the equivalent Corrupted Swordsman paths/profile for the enemy proof.

## 6. Validate in the accepted Hushiro slice

Run the dedicated Godot validation before manual playtesting:

```bash
godot --headless --path game/oathbound \
  res://Regions/Hushiro/Validation/RigRendered2DPipelineSmoke.tscn
```

Then play the normal Hushiro chamber at the accepted `0.50` zoom / `0.72` ground-compression composition.

The proof is about art/readability and production viability, not a new combat-authority layer.

Judge:

- eight-direction readability;
- Akio-specific silhouette;
- attack anticipation and weapon path;
- feet registration;
- crowd depth sorting;
- clean prerender vs pixel/downsample treatment;
- memory/import cost;
- Blender/master/derivative iteration speed.

Do not scale the pipeline to the wider roster until the Akio gate and subsequent Akio + Swordsman comparison are accepted.
