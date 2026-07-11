---
id: META-DOCUMENT-MAP
title: Document Dependency Map
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-10
---

# Document Dependency Map

Use this map to identify which files require review after a change.

## Returning Blood change

Update first:
- `docs/lore/RETURNING_BLOOD.md`

Review:
- `docs/lore/BEAST_BLOOD.md`
- `docs/characters/AKIO.md`
- `docs/gameplay/BLOOD_ASPECTS.md`
- `docs/gameplay/CORRUPTION_AND_SHRINES.md`
- `docs/gameplay/PROGRESSION.md`
- `docs/content/strand/INTERACTIBLES.md`
- `docs/lore/ECLIPSE_SHOGUN.md`
- `docs/ui_ux/HUD.md`
- `docs/ui_ux/SHRINE_INTERFACE.md`
- Milestones 2, 3, and 4
- Terminology and decision log

## Blood Aspect or Corruption change

Update first:
- `docs/gameplay/BLOOD_ASPECTS.md`
- `docs/gameplay/CORRUPTION_AND_SHRINES.md`

Review:
- Akio
- Progression and run structure
- HUD and Shrine interface
- Bloodwell and Blood Mirror
- Asset inventory
- Milestones 2, 3, and 4

## Combat-system change

Update first:
- `docs/gameplay/COMBAT.md`

Review:
- Core loop and encounter design
- Akio
- Every affected enemy, miniboss, and boss file
- HUD
- Technical standards
- Asset inventory
- Relevant milestone animation/VFX scope

## Character, enemy, or boss change

Update first:
- `docs/characters/` for named recurring characters
- Relevant `docs/content/area_*` file for combatants

Review:
- Story and lore relationships
- Regional overview and encounters
- Animation/VFX requirements
- UI nameplates or portraits
- Asset inventory
- Assigned milestone

## Area roster or environment change

Update first:
- Relevant `docs/content/area_*` folder

Review:
- `docs/overview/FULL_GAME_SCOPE.md`
- Production roadmap
- Asset inventory
- Assigned milestone
- Story progression
- Regional UI/VFX needs

## Strand service change

Update first:
- `docs/content/strand/INTERACTIBLES.md`
- `docs/characters/STRAND_NPCS.md` when an NPC is affected

Review:
- Progression
- Blood Aspects/Returning Blood when relevant
- Hub interfaces
- Milestone 3
- Asset inventory

## Art milestone change

Update first:
- Relevant `docs/art_production/milestones/MILESTONE_*.md`

Review:
- Production roadmap
- Asset inventory
- Technical standards
- Authoritative gameplay/content files
- Contractor brief index/export history

## New system or region

Create an authoritative file and stable document ID, then update:
- `SOURCE_OF_TRUTH.md`
- This dependency map
- `FULL_GAME_SCOPE.md`
- Production roadmap
- Asset inventory
- Relevant milestone
- Open questions and decision log as needed
