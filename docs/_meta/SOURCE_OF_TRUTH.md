---
id: META-SOURCE-OF-TRUTH
title: Source of Truth
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-10
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
| Persistent and run progression | `docs/gameplay/PROGRESSION.md` |
| Beast Blood canon | `docs/lore/BEAST_BLOOD.md` |
| Returning Blood canon | `docs/lore/RETURNING_BLOOD.md` |
| The Order | `docs/lore/THE_ORDER.md` |
| Barrier and Blood Moon | `docs/lore/THE_BARRIER_AND_BLOOD_MOON.md` |
| Eclipse Shogun canon | `docs/lore/ECLIPSE_SHOGUN.md` |
| Akio | `docs/characters/AKIO.md` |
| Strand NPC roster | `docs/characters/STRAND_NPCS.md` |
| Individual Strand NPC identities | `docs/characters/strand/*.md` |
| Area 1 regional content | `docs/content/area_1/` |
| Area 2 regional content | `docs/content/area_2/` |
| Area 3 regional content | `docs/content/area_3/` |
| Strand hub identity | `docs/content/strand/OVERVIEW.md` |
| Strand interactible roster | `docs/content/strand/INTERACTIBLES.md` |
| Individual Strand service definitions | `docs/content/strand/interactibles/*.md` |
| Art direction | `docs/art_production/ART_DIRECTION.md` |
| Art technical standards | `docs/art_production/TECHNICAL_STANDARDS.md` |
| Character/enemy brief requirements | `docs/art_production/CHARACTER_BRIEF_STANDARD.md` |
| Art asset inventory | `docs/art_production/ASSET_INVENTORY.md` |
| Outsourcing process | `docs/art_production/OUTSOURCING_WORKFLOW.md` |
| Milestone scope | `docs/art_production/milestones/MILESTONE_*.md` |
| Combat HUD | `docs/ui_ux/HUD.md` |
| Shrine interface | `docs/ui_ux/SHRINE_INTERFACE.md` |
| Hub interfaces | `docs/ui_ux/HUB_INTERFACES.md` |
| Contractor exports | `docs/external/` and `contractor_docs/` |

## Conflict rule

When two files conflict, use the file assigned authority here. Update dependent summaries after resolving the authoritative file. If authority is unclear, record the conflict in `OPEN_QUESTIONS.md` instead of inventing a resolution.

## Duplication rule

Detailed definitions belong only in their authoritative file. Indexes own rosters and navigation; linked files own individual identities or systems. Milestone documents specify production scope and dependencies; they do not replace gameplay, lore, character, or content definitions.
