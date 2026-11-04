# Visual Asset Production Roadmap — Character-First, Integrated Gates

**Status:** approved planning direction (2026-11-03). **Scope:** internal sequencing and acceptance gates; this is not a contractor change order or an authorization to spend.

## Decision

Prioritize Akio and the reusable character source-rig workflow, **without** finishing the complete player/enemy/boss/NPC roster before beginning environments, props, VFX or HUD. Introduce one **small, reusable Hushiro room + essential gameplay effects** after the first enemy proof and before larger roster expansion. Production spending remains character-led, while acceptance is always in-engine and cross-discipline.

The runtime remains authoritative planar Godot 2D. Offline character models/Actions generate eight independent directional sprite renderings. Environments are layered illustrated 2D. Independent 2D VFX and HUD are driven by gameplay state. Never let sprite frame counts or visual effects redefine damage, root motion or combat timings.

## Commission nomenclature

Use the signed/authorized **Hammer commission milestones** as the only milestone numbers for commissioned Akio work. Milestone 1 covers the source Akio and Proof A; proposed Milestone 2 would complete six remaining base Actions and full Akio acceptance. **Proofs are specific experimental tests** and checkpoints are staged reviews/deliveries; neither creates a second milestone numbering system.

The remaining Hushiro/enemy/environment packages are **content planning stages**, not separate numbered commission milestones. Their exact contractor scopes depend on later written approval. **Keep pricing, draft artist briefs and unsigned agreements in private Google Drive, not this public repository.**

## Stage/gate order

| Order | Work | Minimal in-game acceptance before scaling |
|---|---|---|
| 1 — current | Akio Proof A: source model/rig, Idle, Move, Quick Slash. Client renders/validates eight views, tests 2D import and source-relative animation sampling. | Character identity, all-direction camera readability, source-curve completeness, stable feet, weapon path, workable export/CI and real gameplay feel. Resolve blocking feedback before a new animation commission. |
| 2 | Complete Akio's **base nine-animation library** via separately approved commission Milestone 2 after Proof A is accepted. Prototype sword-drawn state continuity and full three-hit phrase early within its gated schedule. | Playable Quick Slash → Cross Cut → Heavy Cleave, Dash/Defend/Hurt/Death, transitions, cancels and state continuity without changing Combat V2 authority. |
| 3 | First enemy **Corrupted Swordsman** on the same source-rig/Blender → PNG → Godot standard. | Player/enemy differentiation, eight-direction windups, collision/sorting, multiple-actor runtime cost, source/renderer reuse. |
| 4 — before broad roster expansion | **One Hushiro benchmark room** with a tiny reusable environment/prop kit, plus essential sword/hit/attack-cue VFX and minimal HUD. | Akio + Swordsman are readable together in a convincing room: proper grounding, occlusion/depth, foreground/background contrast, threat cues and repeatable scene construction. |
| 5 | Blighted Hound and Hollow, then expand the playable Hushiro combat slice to four actors. | Distinct movement/attack roles, crowd readability, basic feedback and multi-enemy playtest in the benchmark room. |
| 6 | Remaining Hushiro standards, two minibosses and Keeper of the Gate; **expand** room foundations, props, arena supports, bespoke VFX and HUD only alongside encounters that need them. | Complete reusable Area 1 route presentation, functional room language, effects/arena coordination and validated combat readability. |
| 7+ | Strand NPCs/services and the rest of the game: Blood Aspects, Yomori, Kagutsuchi, Heart, richer systems/UI, etc. | Region/system-specific gates before expensive art-scale commitments. |

Stages express dependency order, **not** a requirement that only one specialty works at a time. For example, a scoped environment artist may prepare the benchmark kit while Hammer continues accepted character work. Avoid major parallel commitments until the Akio + Swordsman validation and art-treatment comparison are sufficient.

## The minimum Hushiro benchmark kit (not a full village commission)

- Layered ground/base and a path or floor-wear/decal variation, with clear feet/contact alignment.
- A reusable wooden wall/building facade and one low obstacle (broken fence or barricade).
- One tall Y-sorted occluder (torii, post or roof edge) plus one lantern/atmospheric prop to test overlap and contrast.
- Basic shadows/grounding, collision and draw order; construct at least two visibly distinct room compositions from the same pieces.
- **Only essential VFX:** sword-path/trail, hit confirmation, enemy windup/ground danger cue, and any guard feedback actually used by the owning kit. No universal Posture, Deathblow, execution or parry assets.
- Minimal gameplay HUD needed to judge health, action/resource states and visibility over the environment. Full interface polish follows later.

The first room is an **acceptance instrument**, not a commitment to a different game renderer or a full environment production contract. Final environment artist, purchased-pack eligibility and 3D-assisted paintover workflow may be selected after reference/portfolio and licensing comparison.

## Cross-discipline rules

1. **Character creation leads.** Commission editable original source characters/rigs and Actions; generate directional PNG derivatives client-side with the [canonical export procedure](../../tools/rig2d/BLENDER_TO_GODOT_EXPORT_WORKFLOW.md). Preserve high-quality masters and runtime traceability.
2. **Game-scale visual gate first.** Judge finished character silhouette, source frame completeness, action-to-action transitions, NPC/enemy differentiation and VFX/background contrast in Godot, not enlarged in Blender alone.
3. **Use placeholders intentionally.** Existing prototype environments and VFX remain valid until each stage needs a representative final-quality piece. Don't order full regions prematurely.
4. **Reuse before bespoke expansion.** Reuse rooms, props, environmental palettes, base combat effects, materials/rig conventions, export tests and semantic presentation interfaces. Bespoke boss arenas/effects are authorized against encounter requirements.
5. **Own each craft separately.** Hammer's current engagement is Akio source character work. Environment art, specialized VFX and UI can use different contractors; do not presume Hammer is responsible without portfolio review and a new written scope.
6. **No inherited obsolete scope.** Combat V2 does not have universal Posture/Deathblow assets. Techniques are additive rather than limited/replaced slots. Specific Guard/Reprisal and boss vulnerable states are kit-dependent.
7. **No automatic new spending.** Internal batches, gates and examples are planning artifacts. New commissions, paid test work, added transition Actions or extra variants require quotes and written approval under applicable agreements.

## Sources and maintenance

- [Art Direction](ART_DIRECTION.md), [Technical Standards](TECHNICAL_STANDARDS.md), [Asset Inventory](ASSET_INVENTORY.md), [Rig-rendered 2D pipeline](RIG_RENDERED_2D_PIPELINE.md).
- Older numbered art-content package documents remain historical scope references, not an additional commercial milestone schedule; resolve inconsistencies in favor of Combat V2 and this roadmap.
- [Akio commission brief](../commissions/akio/AKIO_COMMISSION_BRIEF.md), [Hammer feedback](../commissions/akio/HAMMER_PROOF_A_FEEDBACK_TRACKER.md), [Akio engineering tracker](AKIO_PROOF_A_INTEGRATION_TRACKER.md), and [canonical eight-direction export workflow](../../tools/rig2d/BLENDER_TO_GODOT_EXPORT_WORKFLOW.md).
