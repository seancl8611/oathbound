# Rig-rendered 2D proof tooling

Status: **Akio commission Proof A integration-ready; real source delivery is the next content step.**

This folder is the client-owned bridge between an editable Blender character source and Oathbound's live Godot 2D runtime.

Production authority:

- \`docs/overview/ISOMETRIC_2D_PRESENTATION_DIRECTION.md\` — runtime/presentation direction
- \`docs/art_production/RIG_RENDERED_2D_PIPELINE.md\` — source/master/runtime production handoff
- \`docs/commissions/akio/AKIO_COMMISSION_BRIEF.md\` — Akio commission engineering boundary
- \`akio_proof_a_manifest.json\` — Milestone 1 / Proof A runtime-derivative contract
- \`poc_manifest.json\` — complete Akio + Corrupted Swordsman runtime-derivative contract

The commissioned artist delivers editable source character work. Oathbound owns directional rendering, derivative generation, validation, and Godot integration.

## Current production order

1. Receive/accept the custom Akio source model + rig.
2. Integrate the delivered source into the client-owned Blender render setup.
3. Prove **Idle + Move + Quick Slash** in all eight directions using the dedicated Proof A contract.
4. Judge Akio in Oathbound before authorizing the remaining core animation package.
5. After Milestone 2 is delivered, build the complete Akio production profile.
6. Build one Corrupted Swordsman on the same pipeline.
7. Only then decide whether to scale the method across the roster.

The full production validator remains strict. Proof A has its own profile, manifest, and Blender export template rather than weakening the nine-animation production contract.

## 1. Prepare the delivered Blender source

The artist's source file does not need to use Oathbound's internal object names or include our render/export setup.

Create a client working copy and configure:

- the delivered character mesh and armature;
- a stable rotation/root object aligned to the feet/contact point;
- the delivered editable Actions;
- a fixed orthographic/high-angle render camera;
- transparent output;
- client-selected lighting/material treatment;
- the object and Action names in the selected export config.

Proof A template:

- \`blender/akio_proof_a_export.template.json\`

Full production templates:

- \`blender/akio_export.template.json\`
- \`blender/corrupted_swordsman_export.template.json\`

The object/action names in these templates are placeholders. Update a working config to match the delivered \`.blend\`; do not rename gameplay actions or rewrite Godot combat code to fit an artist's internal naming.

## 2. Render all eight directions

The production direction order is:

\`e, se, s, sw, w, nw, n, ne\`

All eight are rendered independently. Do not mirror only four directions because handedness, scabbard placement, costume asymmetry, and weapon paths would reverse.

Proof A example:

\`\`\`bash
blender -b /path/to/akio_source_working.blend \
  -P tools/rig2d/blender/render_directional.py -- \
  --config tools/rig2d/blender/akio_proof_a_export.template.json
\`\`\`

The exporter rotates the configured root object, applies each configured Action, samples its frame range, and writes:

\`<animation_base>_<direction>_<frame:03>.png\`

Example:

\`attack_quick_slash_ne_004.png\`

The current proof templates assume a 24 fps Blender timeline sampled every two frames, producing a 12 fps runtime derivative. Source animation FPS and runtime sprite cadence remain separate decisions.

Generated working renders belong under \`tools/rig2d/exports/\`, which is git-ignored.

## 3. Preserve client-generated high-resolution masters

For commissioned/final-source characters, the client should generate and preserve transparent high-resolution directional masters before creating runtime derivatives.

A working Akio target around **1024 x 1024** is appropriate when it comfortably contains the full body and katana silhouette.

Masters should:

- use one fixed canvas per output tier;
- preserve stable feet registration;
- avoid per-frame auto-cropping;
- use one fixed projection/camera;
- preserve enough margin for weapon arcs;
- remain traceable to the source Action and runtime derivative.

These rendered masters are **client-generated integration artifacts**, not required artist deliverables under the current Akio commission scope.

## 4. Validate the Proof A runtime frame set

Proof A expects only:

- \`idle\`
- \`move\`
- \`attack_quick_slash\`

across all eight directions: **24 directional clips total**.

Validate the runtime derivative with:

\`\`\`bash
python tools/rig2d/validate_frame_set.py \
  --manifest tools/rig2d/akio_proof_a_manifest.json \
  --actor akio \
  --source tools/rig2d/exports/akio_proof_a/frames
\`\`\`

The validator rejects malformed names, missing directions, non-contiguous frame numbering, incorrect canvas size, and PNGs that are not 8-bit RGBA.

The complete production contract continues to use \`poc_manifest.json\`.

## 5. Install Proof A frames into Godot

A Proof A working frame set should be installed under:

\`game/oathbound/Art2D/RigRendered/Akio/ProofA/Frames\`

Then import and build the dedicated \`SpriteFrames\` resource:

\`\`\`bash
godot --headless --path game/oathbound --import

godot --headless --path game/oathbound \
  --script res://Tools/Rig2D/BuildDirectionalSpriteFrames.gd -- \
  --profile=res://Presentation/Profiles/AkioProofAProfile.tres \
  --source=res://Art2D/RigRendered/Akio/ProofA/Frames \
  --output=res://Art2D/RigRendered/Akio/ProofA/AkioProofADirectionalSpriteFrames.tres
\`\`\`

The full nine-animation production set continues to use:

\`res://Presentation/Profiles/AkioRigRendered2DProfile.tres\`

## 6. Activate Proof A for a Hushiro playtest

\`HushiroIsometric2DPresentation.gd\` now exposes \`player_profile_override\`.

Normal gameplay leaves this unset and continues to use the full production Akio profile/placeholder path.

For an Akio Proof A playtest, assign:

\`res://Presentation/Profiles/AkioProofAProfile.tres\`

to \`player_profile_override\` in the relevant Hushiro playtest scene/configuration.

The Proof A profile temporarily aliases unfinished attack ids such as Cross Cut and Heavy Cleave to Quick Slash so a normal combat playtest does not drop out of commissioned art. Uncommissioned non-attack states fall back to the directional idle frame. These are proof-only presentation fallbacks; they do not change gameplay action identity or timing.

## 7. Run automated readiness validation

Before manual playtesting:

\`\`\`bash
python tools/rig2d/validate_tooling_contract.py

godot --headless --path game/oathbound --import

godot --headless --path game/oathbound \
  res://Regions/Hushiro/Validation/AkioProofAReadinessSmoke.tscn
\`\`\`

The smoke protects:

- the 24-clip Proof A contract;
- temporary attack aliases;
- the full production profile remaining separate;
- the Hushiro player-profile override seam.

The existing full-pipeline smoke remains:

\`\`\`bash
godot --headless --path game/oathbound \
  res://Regions/Hushiro/Validation/RigRendered2DPipelineSmoke.tscn
\`\`\`

## 8. Judge the real Akio proof in Hushiro

Manual Proof A acceptance should focus on:

- Akio-specific silhouette at actual gameplay scale;
- eight-direction readability;
- Combat Run feel;
- Quick Slash anticipation, weapon path, impact, and recovery;
- stable feet/contact registration;
- absence of visual sliding from unintended root motion;
- crowd/depth behavior;
- clean-prerender vs downsample/pixel treatment;
- source -> render -> derivative -> Godot iteration speed.

Do not authorize the full remaining animation package merely because the source looks good in Blender. Proof A exists to validate the character inside the actual game.
