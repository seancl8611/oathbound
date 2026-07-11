---
id: META-DOCUMENT-MAP
title: Document Review Hints
category: meta
status: approved
authority: summary
last_reviewed: 2026-07-11
---

# Document Review Hints

This file provides common review starting points. It is deliberately non-exhaustive and must never replace live repository search.

Use it to seed search terms and likely review areas, then inspect the current repository for actual references, synonyms, outdated wording, UI consequences, production scope, and contractor-facing summaries.

## Returning Blood change

Primary authority:
- `docs/lore/RETURNING_BLOOD.md`

Likely review areas:
- Beast Blood canon
- Akio
- Blood Aspects
- Corruption and Shrines
- progression and run structure
- Bloodwell and Blood Mirror content
- Eclipse Shogun
- HUD and Shrine interface
- Milestones 2–4

Suggested live-search terms:
- `Returning Blood`
- `Beast Blood`
- `Akio`
- `return after death`
- `revive`
- `Blood Aspect`
- `Shrine`

## Blood Aspect or Corruption change

Primary authority:
- `docs/gameplay/BLOOD_ASPECTS.md`
- `docs/gameplay/CORRUPTION_AND_SHRINES.md`

Likely review areas:
- Akio and Returning Blood
- progression and run structure
- HUD and Shrine interface
- Blood Aspect VFX
- Strand interactibles
- asset inventory
- Milestones 2–4

## Combat-system change

Primary authority:
- `docs/gameplay/COMBAT.md`

Likely review areas:
- core loop
- affected enemies, minibosses, and bosses
- Akio animation requirements
- HUD and shared combat VFX
- technical standards
- asset inventory
- milestone animation and VFX scope

## Player build-system change

Primary authority:
- `docs/gameplay/STANCES.md`
- `docs/gameplay/PROSTHETICS.md`
- `docs/gameplay/ITEMS_AND_REWARDS.md`

Likely review areas:
- Blood Aspects and Corruption
- Run HUD and damage/status feedback
- stance, prosthetic, Aspect, and item-art briefs
- progression and currency ownership
- Akio animation hooks
- asset inventory
- Milestone 4

Suggested live-search terms:
- affected stance or tool name
- status name such as `Shock`, `Burn`, `Frost`, or `Hex`
- `Spirit`
- `cooldown`
- `currency`
- `icon`
- `Milestone 4`

## Character, enemy, or boss change

Primary authority:
- `docs/characters/` for recurring named characters
- relevant `docs/content/area_*` file for combatants

Likely review areas:
- story and lore relationships
- regional overview
- encounter rules
- animation and VFX requirements
- UI nameplates or portraits
- asset inventory
- assigned milestone

## Area roster or environment change

Primary authority:
- relevant `docs/content/area_*` folder

Likely review areas:
- full-game scope
- production roadmap
- cross-area room types
- asset inventory
- assigned milestone
- story progression
- room, UI, and regional VFX needs

## Room-type change

Primary authority:
- `docs/content/ROOM_TYPES.md`

Likely review areas:
- regional environment and room files
- run structure
- Shrine and shop interfaces
- miniboss and boss arena requirements
- environment asset inventory
- Milestones 1, 2, 5, and 6

## Strand service change

Primary authority:
- `docs/content/strand/INTERACTIBLES.md`
- `docs/characters/STRAND_NPCS.md` when an NPC is affected

Likely review areas:
- progression
- currencies and item ownership
- Returning Blood or Blood Aspects when relevant
- hub interfaces and Strand HUD
- Milestone 3
- asset inventory

## Art milestone change

Primary authority:
- relevant `docs/art_production/milestones/MILESTONE_*.md`

Likely review areas:
- production roadmap
- asset inventory
- technical standards
- outsourcing workflow
- authoritative gameplay and content files
- contractor brief index and export history

## New system or region

Create an authoritative file and stable document ID. Then determine impact through live search before updating:
- `SOURCE_OF_TRUTH.md`
- full-game scope
- production roadmap
- asset inventory
- relevant milestone
- terminology
- open questions and decision log

## Reliability rule

The absence of a file from this guide does not mean it is unaffected. The presence of a file here does not mean it requires editing. Current repository content determines the real impact set.
