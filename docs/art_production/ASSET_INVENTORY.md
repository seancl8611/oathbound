---
id: ART-ASSET-INVENTORY
title: Asset Inventory
category: art-production
status: draft
authority: primary
last_reviewed: 2026-07-10
topics:
  - asset-counts
  - characters
  - environments
  - ui
  - vfx
related:
  - OVERVIEW-FULL-SCOPE
---

# Asset Inventory

This is the high-level production inventory. Individual character, system, regional, encounter, and milestone files own detailed animation and state lists.

## Master counts

| Asset group | Planned count | Notes |
|---|---:|---|
| Player character | 1 | Akio concept, final sprite, full combat animation set |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, Scribe |
| Area 1 enemies | 6 | Village/garrison and raw-corruption set |
| Area 2 enemies | 4 | Forest, spirit, and predator set |
| Area 3 enemies | 5 | Court and inner-sanctum set |
| Minibosses | 6 | Two per main area |
| Bosses | 3 | One principal boss encounter per main area |
| Environment sets | 4 | Strand and Areas 1–3; Blood Cavern is a Strand interior subset |
| VFX groups | 12 | High-level grouping; individual cue count is more granular |
| UI / room-art groups | 12 | High-level grouping; screen list is more granular |
| Item / consumable groups | 7 | Must be reviewed against revised currency families |

## Player

- Akio concept and final base sprite
- Complete base combat animation library
- Core sword trails and combat feedback
- Wolf, Wraith, and Ronin VFX families
- Tier I–IV modular mutation overlays
- Five stance VFX families
- Eight prosthetic VFX families

## Strand characters

| Character | Required production direction |
|---|---|
| Keeper | Concept, final humanoid noble-spirit sprite, restrained idle/talk variants |
| Peddler | Concept, seated merchant sprite, modular salvage spread, shop-facing behaviors |
| Smith | Concept, final working-smith sprite, forge ambient and interaction loops |
| Raven | Perched design, harness/tags, idle, present-item, arrival/takeoff/landing states |
| Undead Samurai | Concept, final archaic Order-samurai sprite, training/instruction states |
| Scribe | Concept, final recorder sprite, book/board interactions, writing and talk states |

## Combatants

- **Area 1:** 6 standard enemies, Village Ogre, The Collector, Keeper of the Gate
- **Area 2:** 4 standard enemies, Embered Pilgrim, Rotwood Host, Twin Maws encounter
- **Area 3:** 5 standard enemies, Blood Lotus, Eternal Swordsman, Eclipse Shogun

Pages 36–70 establish the standard-enemy production briefs. Pages 71–105 complete the Area 3 standard roster and establish all six miniboss briefs plus all three principal boss encounters.

## Environment sets

- Strand hub, docks, role-specific NPC stations, shoreline atmosphere, and Blood Cavern/Mirror interior
- Hushiro Gate Village base kit, functional rooms, miniboss spaces, and old-gate boss arena
- Yomori Grove base kit, failed purification site, Rotwood arena, Twin Maws arena, rooms, hazards, and props
- Kagutsuchi Court base kit, Blood Lotus fissure arena, duel court, Wellspring throne-space, rooms, transitions, and props

## Strand interactible art

- Boat and departure lantern/dock presentation
- Forge Bench, forge props, ember/heat layers, and upgrade-screen language
- Merchant Stall, stock spread, salvage props, and shop-screen language
- Discovery Board, papers, diagrams, codex presentation, and unlock states
- Bloodwell landmark, carved channels, contained blood surface, progression screen, and reformation effects
- Blood Cavern outer hall and Blood Mirror inner chamber

## UI/UX

- Combat HUD
- Corruption meter and Blood Aspect Tier indicator
- Shrine Resist/Embrace interface
- Boat run-start screen
- Forge, merchant, Discovery Board, Bloodwell, and Blood Mirror screens
- Trial states and run-results presentation
- Pause/build overview
- Miniboss and boss health/posture presentation
- Blood Lotus multi-cycle Heart/posture support
- Settings, controls, save/loading, and front end

## Shared VFX briefs established through page 105

- Parry Spark
- Posture Break Cue
- Deathblow Cue
- Corruption Full Cue
- Embrace Transformation Cue
- Resist Stabilization Cue

The Wolf Prey Mark brief starts on page 105 but continues beyond the current source boundary and remains for the next migration batch.

## Enemy and encounter production dependencies

### Standard enemies

- Corrupted Archer projectile and retreat states
- Cellar Bilemass projectile and puddle readability
- Warden restraint stages and outcomes
- Area 1 hound attack-token support
- Area 2 spirit targetability, lantern, buff-link, mist, and pounce states
- Court Guard and Court Caster one-time revival states
- Elite Defender shield orientation and guard-break states
- Hollow Vessel spawn ownership, Spillborn emergence, and progressive damage states
- Court Sentinel composed/frenzy state transition

### Area 1 major encounters

- Village Ogre shield coverage, charge, sweep warning, impacts, and gate-yard support
- Collector fog dimming, chain, snare, ground masses, and audio layers
- Keeper Phase 1 duel, rupture transition, Phase 2 corruption, shockwave, sweep, and lane-charge effects

### Area 2 major encounters

- Embered Pilgrim channel-state flame, smoke, root-feed, and failed-rite arena changes
- Rotwood shell crack, shell break, exposed core, roots, fungus, and blood-sap effects
- Twin Maws simultaneous role readability, shell/anchor states, soul-transfer transition, and survivor empowerment

### Area 3 major encounters

- Blood Lotus Heart, three Stalks, fissure states, punishment projectiles, core exposure, and multi-cycle UI
- Eternal Swordsman restrained spirit haze, duel trails, and reposition cues
- Eclipse Shogun three complete phase presentations, polearm continuity, Wellspring arena evolution, eclipse motif, and ending transition dependencies

## Items and rewards

- Boons
- Relics
- Consumables
- Currencies and upgrade materials
- Boss Emblems
- Chests, pickups, and breakables

The current item/consumable count remains provisional because currency-family changes may require the seven-group estimate to be split or renamed.

## Inventory rule

When a system, enemy, boss, room type, item family, UI screen, or VFX family is added or removed, update this inventory and its assigned milestone in the same change.
