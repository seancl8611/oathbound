# Art Production

Oathbound's production art targets an illustrated high-angle 2D game. Runtime combat stays planar 2D; offline 3D character rigs may be used to generate directional 2D frames.

## Primary art authorities

- `ART_DIRECTION.md` — visual language and gameplay-scale readability.
- `TECHNICAL_STANDARDS.md` — current 2D/runtime and source-rig delivery rules.
- `RIG_RENDERED_2D_PIPELINE.md` — Blender/source-rig -> directional-frame -> Godot workflow.
- `ASSET_INVENTORY.md` — high-level production groups/counts.
- `CORE_VFX.md` — shared combat feedback.
- `ASPECT_VFX.md`, `TECHNIQUE_VFX.md`, `PROSTHETIC_VFX.md` — system-specific presentation.
- `../commissions/akio/AKIO_COMMISSION_BRIEF.md` — the single artist-facing Akio commission brief.

## Current production priorities

1. Finish Combat V2 presentation cleanup so retired Posture/Deathblow assumptions do not generate art scope.
2. Produce Akio as the first reusable source-rig character and render the agreed Stage 1 directional set.
3. Compare clean stylized prerendering against an intentional pixel/downsample treatment from the same masters.
4. Produce one Corrupted Swordsman after Akio passes the first in-game gate.
5. Scale the pipeline only after actor size, silhouette, animation readability, feet registration, depth sorting, memory/import cost, and iteration speed are proven in real Hushiro combat.

## Current combat-art boundary

Standard combat does **not** require universal player/enemy Posture bars, posture-break cues, Deathblow prompts, or execution animations. Health is the normal defeat condition; hidden Poise/interruption controls reaction resistance. Guard, Reprisal, bespoke boss vulnerability, and other special states receive art only where the owning kit/encounter actually uses them.

The current Technique baseline is **40 Techniques + 6 refinements** with additive run ownership. Action labels are triggers, not equipment slots.

## Production rule

Spend detail where the accepted gameplay camera can read it: silhouette, weapon path, stance, anticipation, impact, cloth/armor mass, role distinction, corruption landmarks, and strong value separation. Close-up detail is secondary.
