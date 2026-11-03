# Art Production

Oathbound's production art targets an illustrated high-angle 2D game. Runtime combat stays planar 2D; offline 3D character rigs may be used to generate directional 2D frames.

## Primary art authorities

- `ART_DIRECTION.md` — visual language and gameplay-scale readability.
- `TECHNICAL_STANDARDS.md` — current 2D/runtime and source-rig delivery rules.
- `RIG_RENDERED_2D_PIPELINE.md` — Blender/source-rig -> directional-frame -> Godot workflow.
- `ASSET_INVENTORY.md` — high-level production groups/counts.
- `CORE_VFX.md` — shared combat feedback.
- `ASPECT_VFX.md`, `TECHNIQUE_VFX.md`, `PROSTHETIC_VFX.md` — system-specific presentation.
- `../commissions/akio/AKIO_COMMISSION_BRIEF.md` — authoritative repository artist commission brief.
- [Hammer Proof A feedback tracker](../commissions/akio/HAMMER_PROOF_A_FEEDBACK_TRACKER.md) — live queue of artist-facing feedback, observed source-art issues, and questions; **not an approved change order**.
- [Akio Proof A integration tracker](AKIO_PROOF_A_INTEGRATION_TRACKER.md) — live internal Godot engineering tasks, status, dependencies, and playtest evidence; **not a replacement for gameplay authority**.

## Current production priorities

**Canonical staged plan:** [Visual Asset Roadmap — Character-First, Integrated Gates](VISUAL_ASSET_ROADMAP.md). The plan prioritizes character commissions but explicitly does **not** finish the entire character roster before environments, props, VFX and HUD.

1. Accept Akio Proof A only after full editable-source, eight-view export and real Godot playtest/feedback checks; compare clean prerender versus deliberate downsample treatment. Follow the source-complete [Blender-to-Godot workflow](../../tools/rig2d/BLENDER_TO_GODOT_EXPORT_WORKFLOW.md).
2. Separately quote/authorize Hammer's proposed Akio Milestone 2 for the six remaining base animations; validate sword-drawn transitions and the three-hit combo before committing to expensive expansions. See [Milestone 2 planning](../commissions/akio/AKIO_MILESTONE_02_PLANNING.md).
3. Prove one Corrupted Swordsman using the same pipeline before expanding the enemy roster.
4. **Before bulk character production**, introduce one small reusable Hushiro combat room, basic props, essential independent VFX and minimal HUD to test visual cohesion, feet/occlusion, contrast and threat readability.
5. Expand Hushiro enemies, minibosses, boss and room/effect kits in gameplay-driven batches; defer the Strand and later regions until their own production gates.

**Contract naming caution:** Hammer's Akio commission Milestone 1/2 and Oathbound's Art Production Milestone 1/2 are different work breakdowns. Internal art stages do not expand signed contractor scope or authorize payment.

## Current combat-art boundary

Standard combat does **not** require universal player/enemy Posture bars, posture-break cues, Deathblow prompts, or execution animations. Health is the normal defeat condition; hidden Poise/interruption controls reaction resistance. Guard, Reprisal, bespoke boss vulnerability, and other special states receive art only where the owning kit/encounter actually uses them.

The current Technique baseline is **40 Techniques + 6 refinements** with additive run ownership. Action labels are triggers, not equipment slots.

## Production rule

Spend detail where the accepted gameplay camera can read it: silhouette, weapon path, stance, anticipation, impact, cloth/armor mass, role distinction, corruption landmarks, and strong value separation. Close-up detail is secondary.
