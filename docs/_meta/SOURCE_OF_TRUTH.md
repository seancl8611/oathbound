---
id: META-SOURCE-OF-TRUTH
title: Source of Truth
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-26
---

# Source of Truth

Each major subject has one authoritative file. Other documents should summarize, link, or describe production consequences rather than maintain a competing definition.

| Subject | Authoritative file |
|---|---|
| Game identity and pitch | `docs/overview/GAME_OVERVIEW.md` |
| Design pillars | `docs/overview/DESIGN_PILLARS.md` |
| Full production scope | `docs/overview/FULL_GAME_SCOPE.md` |
| Current unresolved design priorities | `docs/_meta/OPEN_QUESTIONS.md` |
| Top-level production order | `docs/overview/PRODUCTION_ROADMAP.md` |
| Core gameplay loop | `docs/gameplay/CORE_LOOP.md` |
| Combat rules and vocabulary | `docs/gameplay/COMBAT.md` |
| Run structure | `docs/gameplay/RUN_STRUCTURE.md` |
| Blood Aspect system mechanics | `docs/gameplay/BLOOD_ASPECTS.md` |
| Shared Blood Aspect weapon-kit model | `docs/gameplay/ASPECT_WEAPON_KIT_MODEL.md` |
| Blood Aspect evaluation and roster-comparison guidelines | `docs/gameplay/ASPECT_IDENTITY_GUIDELINES.md` |
| Wolf qualitative Tier 0 weapon kit | `docs/gameplay/WOLF_ASPECT.md` |
| Wraith qualitative Tier 0 weapon kit | `docs/gameplay/WRAITH_ASPECT.md` |
| Ronin qualitative Tier 0 weapon kit | `docs/gameplay/RONIN_ASPECT.md` |
| Corruption and Shrine mechanics | `docs/gameplay/CORRUPTION_AND_SHRINES.md` |
| Technique mechanics | `docs/gameplay/TECHNIQUES.md` |
| Individual Technique catalog and refinements | `docs/gameplay/TECHNIQUE_CATALOG.md` |
| Persistent and run progression | `docs/gameplay/PROGRESSION.md` |
| Blood Cavern trial rules | `docs/gameplay/BLOOD_CAVERN_TRIALS.md` |
| Prosthetic mechanics | `docs/gameplay/PROSTHETICS.md` |
| Items, currencies, and rewards | `docs/gameplay/ITEMS_AND_REWARDS.md` |
| World and island setting | `docs/lore/WORLD.md` |
| Story spine | `docs/lore/STORY_OVERVIEW.md` |
| Beast Blood canon | `docs/lore/BEAST_BLOOD.md` |
| Returning Blood canon | `docs/lore/RETURNING_BLOOD.md` |
| The Order | `docs/lore/THE_ORDER.md` |
| Barrier and Blood Moon | `docs/lore/THE_BARRIER_AND_BLOOD_MOON.md` |
| Eclipse Shogun canon | `docs/lore/ECLIPSE_SHOGUN.md` |
| Akio | `docs/characters/AKIO.md` |
| Strand NPC roster | `docs/characters/STRAND_NPCS.md` |
| Individual Strand NPCs | `docs/characters/strand/*.md` |
| Cross-area room identities | `docs/content/ROOM_TYPES.md` |
| Area 1 identity | `docs/content/area_1/OVERVIEW.md` |
| Area 1 enemy roster | `docs/content/area_1/ENEMIES.md` and `docs/content/area_1/enemies/*.md` |
| Area 1 minibosses | `docs/content/area_1/MINIBOSSES.md` |
| Area 1 boss | `docs/content/area_1/BOSS.md` |
| Area 1 rooms | `docs/content/area_1/ENVIRONMENT_AND_ROOMS.md` |
| Area 2 identity | `docs/content/area_2/OVERVIEW.md` |
| Area 2 enemy roster | `docs/content/area_2/ENEMIES.md` and `docs/content/area_2/enemies/*.md` |
| Area 2 minibosses | `docs/content/area_2/MINIBOSSES.md` |
| Area 2 boss | `docs/content/area_2/BOSS.md` |
| Area 3 identity | `docs/content/area_3/OVERVIEW.md` |
| Area 3 enemy roster | `docs/content/area_3/ENEMIES.md` and `docs/content/area_3/enemies/*.md` |
| Area 3 minibosses | `docs/content/area_3/MINIBOSSES.md` |
| Eclipse Shogun encounter | `docs/content/area_3/BOSS.md` |
| True-final Heart encounter | `docs/content/area_3/TRUE_FINAL_HEART.md` |
| Strand identity and services | `docs/content/strand/OVERVIEW.md`, `INTERACTIBLES.md`, and `interactibles/*.md` |
| Art direction | `docs/art_production/ART_DIRECTION.md` |
| Art technical standards | `docs/art_production/TECHNICAL_STANDARDS.md` |
| Character and enemy brief requirements | `docs/art_production/CHARACTER_BRIEF_STANDARD.md` |
| Shared combat and Corruption VFX | `docs/art_production/CORE_VFX.md` |
| Blood Aspect VFX | `docs/art_production/ASPECT_VFX.md` |
| Prosthetic VFX | `docs/art_production/PROSTHETIC_VFX.md` |
| Technique VFX | `docs/art_production/TECHNIQUE_VFX.md` |
| Item and reward art | `docs/art_production/ITEM_REWARD_ART.md` |
| Art asset inventory | `docs/art_production/ASSET_INVENTORY.md` |
| Outsourcing process | `docs/art_production/OUTSOURCING_WORKFLOW.md` |
| Milestone scope | `docs/art_production/milestones/MILESTONE_*.md` |
| Run HUD and combat feedback | `docs/ui_ux/HUD.md` |
| Strand HUD and prompts | `docs/ui_ux/STRAND_HUD_AND_PROMPTS.md` |
| Shrine interface | `docs/ui_ux/SHRINE_INTERFACE.md` |
| Technique rewards and reserve interface | `docs/ui_ux/TECHNIQUE_REWARDS.md` |
| Hub interfaces | `docs/ui_ux/HUB_INTERFACES.md` |
| Blood Mirror and trials UI | `docs/ui_ux/BLOOD_MIRROR_TRIALS.md` |
| Results and Strand return | `docs/ui_ux/RUN_RESULTS.md` |
| Pause and build overview | `docs/ui_ux/PAUSE_OVERVIEW.md` |

## Conflict rule

When files conflict, use the authority listed here. Correct dependent summaries after resolving the authoritative file. If the current design genuinely does not answer the conflict and the decision affects scope, add one concise question to `OPEN_QUESTIONS.md`.

## Duplication rule

Detailed definitions belong only in their authoritative file. Overview files summarize the game. Milestones describe production scope and dependencies. The question tracker contains only unresolved priorities. Historical notes never override current authoritative content.