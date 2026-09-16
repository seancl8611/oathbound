---
id: META-SOURCE-OF-TRUTH
title: Source of Truth
category: meta
status: approved
authority: primary
last_reviewed: 2026-09-16
---

# Source of Truth

Each major subject has one owning authority. Dependent docs summarize or translate that authority; they do not preserve superseded mechanics for compatibility.

| Subject | Authority |
|---|---|
| Game identity / current project shape | `docs/overview/GAME_OVERVIEW.md` |
| Design pillars | `docs/overview/DESIGN_PILLARS.md` |
| Combat direction | `docs/overview/V2_COMBAT_DIRECTION.md` |
| Shared combat rules | `docs/gameplay/COMBAT.md` |
| Isometric 2D runtime presentation | `docs/overview/ISOMETRIC_2D_PRESENTATION_DIRECTION.md` |
| Production roadmap | `docs/overview/PRODUCTION_ROADMAP.md` |
| Art direction | `docs/art_production/ART_DIRECTION.md` |
| Art technical standards | `docs/art_production/TECHNICAL_STANDARDS.md` |
| Rig-rendered character pipeline | `docs/art_production/RIG_RENDERED_2D_PIPELINE.md` |
| Akio commission | `docs/commissions/akio/AKIO_COMMISSION_BRIEF.md` |
| Blood Aspect system | `docs/gameplay/BLOOD_ASPECTS.md` |
| Wolf / Wraith / Ronin | corresponding `docs/gameplay/*_ASPECT.md` |
| Aspect first-playtest values | `docs/gameplay/ASPECT_IMPLEMENTATION_BASELINES.md` |
| Technique system | `docs/gameplay/TECHNIQUES.md` |
| Technique roster | `docs/gameplay/TECHNIQUE_CATALOG.md` |
| Prosthetics | `docs/gameplay/PROSTHETICS.md` |
| Relics | `docs/gameplay/RELICS.md` |
| Corruption / Shrines | `docs/gameplay/CORRUPTION_AND_SHRINES.md` |
| Progression / currencies | `docs/gameplay/PROGRESSION.md` + `ITEMS_AND_REWARDS.md` |
| Run structure | `docs/gameplay/RUN_STRUCTURE.md` |
| Akio character canon | `docs/characters/AKIO.md` |
| Regional content | relevant `docs/content/area_*` authority |
| True-final Heart encounter | `docs/content/area_3/TRUE_FINAL_HEART.md` |
| Run HUD / combat feedback | `docs/ui_ux/HUD.md` |
| Current unresolved work | `docs/_meta/OPEN_QUESTIONS.md` |
| Canonical terminology / retired search anchors | `docs/_meta/TERMINOLOGY.md` |

## Conflict rules

1. Current Combat V2 authority supersedes older universal Posture/Deathblow assumptions. Standard enemies use Health plus hidden Poise/interruption; player-facing Posture and the shared Deathblow/execution loop are retired.
2. Current presentation authority supersedes live Planar3D / Camera3D experiments. The production runtime is authoritative planar 2D with fixed high-angle Camera2D directional-sprite presentation.
3. Current Technique authority uses additive ownership with no Technique slots/global inventory cap. The current catalog baseline is 40 Techniques + 6 refinements; older five-action matrices are historical.
4. Blood Aspect identity belongs to the Aspect authorities. Shared docs must not invent one universal defensive event simply to make old Technique or UI content fit.
5. First-playtest numeric baselines are tunable implementation targets, not immutable design law.
6. Historical/research docs never override a current authority.

When a current authority and runtime disagree, reconcile both around the approved direction rather than restoring a retired system merely to satisfy an old test, count, or compatibility path.
