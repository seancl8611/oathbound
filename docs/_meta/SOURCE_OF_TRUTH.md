---
id: META-SOURCE-OF-TRUTH
title: Source of Truth
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-11
---

# Source of Truth

Each major subject has one authoritative file. Other documents should summarize and link rather than duplicate the complete definition.

This registry identifies ownership only. It is not a dependency map and does not define every file that must be reviewed after a change. Dependency discovery must use live repository search and the workflow in `ASSISTANT_WORKFLOW.md`.

| Subject | Authoritative file |
|---|---|
| Game identity and pitch | `docs/overview/GAME_OVERVIEW.md` |
| Design pillars | `docs/overview/DESIGN_PILLARS.md` |
| Full production scope | `docs/overview/FULL_GAME_SCOPE.md` |
| Top-level production order | `docs/overview/PRODUCTION_ROADMAP.md` |
| Core gameplay loop | `docs/gameplay/CORE_LOOP.md` |
| Combat rules and vocabulary | `docs/gameplay/COMBAT.md` |
| Run structure | `docs/gameplay/RUN_STRUCTURE.md` |
| Blood Aspect mechanics | `docs/gameplay/BLOOD_ASPECTS.md` |
| Corruption and Shrine mechanics | `docs/gameplay/CORRUPTION_AND_SHRINES.md` |
| Technique mechanics, active slots, reserve, and refinements | `docs/gameplay/TECHNIQUES.md` |
| Persistent and run progression | `docs/gameplay/PROGRESSION.md` |
| Blood Cavern trial rules | `docs/gameplay/BLOOD_CAVERN_TRIALS.md` |
| Prosthetic tool mechanics | `docs/gameplay/PROSTHETICS.md` |
| Items, currencies, room rewards, and reward cadence | `docs/gameplay/ITEMS_AND_REWARDS.md` |
| Beast Blood canon | `docs/lore/BEAST_BLOOD.md` |
| Returning Blood canon | `docs/lore/RETURNING_BLOOD.md` |
| The Order | `docs/lore/THE_ORDER.md` |
| Barrier and Blood Moon | `docs/lore/THE_BARRIER_AND_BLOOD_MOON.md` |
| Eclipse Shogun canon | `docs/lore/ECLIPSE_SHOGUN.md` |
| Akio | `docs/characters/AKIO.md` |
| Strand NPC roster | `docs/characters/STRAND_NPCS.md` |
| Individual Strand NPC identities | `docs/characters/strand/*.md` |
| Cross-area room identities | `docs/content/ROOM_TYPES.md` |
| Area 1 regional identity | `docs/content/area_1/OVERVIEW.md` |
| Area 1 enemy family and roster | `docs/content/area_1/ENEMIES.md` |
| Individual Area 1 enemies | `docs/content/area_1/enemies/*.md` |
| Area 1 minibosses | `docs/content/area_1/MINIBOSSES.md` |
| Area 1 boss encounter | `docs/content/area_1/BOSS.md` |
| Area 1 environment and rooms | `docs/content/area_1/ENVIRONMENT_AND_ROOMS.md` |
| Area 2 regional identity | `docs/content/area_2/OVERVIEW.md` |
| Area 2 enemy family and roster | `docs/content/area_2/ENEMIES.md` |
| Individual Area 2 enemies | `docs/content/area_2/enemies/*.md` |
| Area 2 minibosses | `docs/content/area_2/MINIBOSSES.md` |
| Area 2 boss encounter | `docs/content/area_2/BOSS.md` |
| Area 3 regional identity | `docs/content/area_3/OVERVIEW.md` |
| Area 3 enemy family and roster | `docs/content/area_3/ENEMIES.md` |
| Individual Area 3 enemies | `docs/content/area_3/enemies/*.md` |
| Area 3 minibosses | `docs/content/area_3/MINIBOSSES.md` |
| Area 3 boss encounter | `docs/content/area_3/BOSS.md` |
| Strand hub identity | `docs/content/strand/OVERVIEW.md` |
| Strand interactible roster | `docs/content/strand/INTERACTIBLES.md` |
| Individual Strand service definitions | `docs/content/strand/interactibles/*.md` |
| Art direction | `docs/art_production/ART_DIRECTION.md` |
| Art technical standards | `docs/art_production/TECHNICAL_STANDARDS.md` |
| Character/enemy brief requirements | `docs/art_production/CHARACTER_BRIEF_STANDARD.md` |
| Shared combat and Corruption VFX | `docs/art_production/CORE_VFX.md` |
| Blood Aspect VFX | `docs/art_production/ASPECT_VFX.md` |
| Prosthetic VFX | `docs/art_production/PROSTHETIC_VFX.md` |
| Technique VFX | `docs/art_production/TECHNIQUE_VFX.md` |
| Item, pickup, and reward art | `docs/art_production/ITEM_REWARD_ART.md` |
| Art asset inventory | `docs/art_production/ASSET_INVENTORY.md` |
| Outsourcing process | `docs/art_production/OUTSOURCING_WORKFLOW.md` |
| Milestone scope | `docs/art_production/milestones/MILESTONE_*.md` |
| Run HUD and combat feedback | `docs/ui_ux/HUD.md` |
| Strand HUD and interaction prompts | `docs/ui_ux/STRAND_HUD_AND_PROMPTS.md` |
| Shrine interface | `docs/ui_ux/SHRINE_INTERFACE.md` |
| Technique rewards, replacement, and reserve interface | `docs/ui_ux/TECHNIQUE_REWARDS.md` |
| Shared hub-interface language | `docs/ui_ux/HUB_INTERFACES.md` |
| Blood Mirror and trial interface | `docs/ui_ux/BLOOD_MIRROR_TRIALS.md` |
| Run-results and Strand-return interface | `docs/ui_ux/RUN_RESULTS.md` |
| Pause/build overview | `docs/ui_ux/PAUSE_OVERVIEW.md` |
| Contractor exports | `docs/external/` and `contractor_docs/` |

## Conflict rule

When two files conflict, use the file assigned authority here. Update dependent summaries after resolving the authoritative file. If authority is unclear, record the conflict in `OPEN_QUESTIONS.md` instead of inventing a resolution.

## Duplication rule

Detailed definitions belong only in their authoritative file. Indexes own families, rosters, and navigation; linked files own individual identities or systems. Milestone documents specify production scope and dependencies; they do not replace gameplay, lore, character, content, UI, or VFX definitions.
