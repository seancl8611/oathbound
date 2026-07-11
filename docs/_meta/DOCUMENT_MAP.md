---
id: META-DOCUMENT-MAP
title: Document Dependency Map
category: meta
status: approved
authority: primary
---

# Document Dependency Map

This file maps common change types to the documents that should be reviewed.

## Lore or canon change

Primary locations:
- `docs/lore/`
- `docs/characters/`

Review dependencies:
- related gameplay systems
- affected area content
- art milestone summaries
- terminology and decision log

## Gameplay system change

Primary location:
- `docs/gameplay/`

Review dependencies:
- UI/UX files
- affected characters and enemies
- art asset inventory
- relevant milestone briefs
- tutorial or onboarding documentation

## Character or boss change

Primary locations:
- `docs/characters/`
- relevant `docs/content/area_*` folder

Review dependencies:
- lore relationships
- encounter design
- animation and VFX requirements
- milestone scope
- UI nameplates or portraits

## Area or roster change

Primary location:
- relevant `docs/content/area_*` folder

Review dependencies:
- full-game scope
- production roadmap
- asset inventory
- milestone assignments
- story progression

## Art-production change

Primary location:
- `docs/art_production/`

Review dependencies:
- affected gameplay/content source files
- technical standards
- contractor export index
- production roadmap

## Returning Blood or Blood Aspect change

Primary locations:
- `docs/lore/RETURNING_BLOOD.md`
- `docs/gameplay/BLOOD_ASPECTS.md`

Review dependencies:
- `docs/characters/AKIO.md`
- corruption and Shrine systems
- Bloodwell and Blood Mirror content
- Eclipse Shogun lore
- UI/UX
- relevant art milestones

Expand this map as the repository is populated.
