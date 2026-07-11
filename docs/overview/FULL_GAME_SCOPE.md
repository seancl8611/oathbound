---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: draft
authority: primary
last_reviewed: 2026-07-11
topics:
  - full-scope
  - asset-counts
  - areas
  - strand
related:
  - ART-ASSET-INVENTORY
  - OVERVIEW-PRODUCTION-ROADMAP
---

# Full Game Scope

This document records the current production-level shape of Oathbound. Exact balance values, frame counts, room counts, and implementation details remain subject to playtesting.

## Master scope summary

| Asset group | Planned count | Current scope note |
|---|---:|---|
| Player character | 1 | Akio concept, final sprite, and complete combat animation library |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, and Scribe |
| Area 1 standard enemies | 6 | Grounded village/garrison corruption roster |
| Area 2 standard enemies | 4 | Forest, spirit, and predator roster |
| Area 3 standard enemies | 5 | Preserved court and inner-sanctum roster |
| Miniboss encounters | 6 | Two per main area |
| Major bosses | 3 | One principal progression boss per area, including the final confrontation |
| Environment sets | 4 | Strand plus Areas 1–3 |
| VFX groups | 12 | Core combat, Blood Aspects, bosses, stances, and prosthetic support within current grouping |
| UI / room-art groups | 12 | Combat, hub, Shrine, room, boss, and Blood Aspect presentation within current grouping |
| Item / consumable groups | 7 | Current count requires later review against the evolving currency families |

Blood Aspect UI and VFX are presently included inside the existing UI/room-art and VFX group counts rather than tracked as entirely separate top-level groups.

## Player

- Akio base character and full combat animation library
- Quick Slash, Cross Cut, Heavy Cleave, Hold Thrust, Counter Cut, and Dash Slash
- Katana combat, posture, parry, block, dash, counter, deathblow, and prosthetic activation
- Blood Aspect system: Wolf, Wraith, and Ronin
- Tier 0 through Tier IV run-only mutation progression
- Five planned stance families
- Eight planned prosthetic-tool effect families
- Boons, relics, consumables, currencies, and upgrade materials

## Persistent hub — The Strand

Six primary recurring NPCs:

- Keeper
- Peddler
- Smith
- Raven
- Undead Samurai
- Scribe

Primary interactibles and services:

- Boat and run-start confirmation
- Forge Bench and permanent combat/tool improvement
- Merchant Stall
- Discovery Board/codex
- Bloodwell permanent meta progression
- Blood Cavern training space and Blood Mirror Aspect trials

## Area 1 — Hushiro Gate Village

Six standard enemies:

- Corrupted Swordsman
- Corrupted Archer
- Blighted Hounds
- Hollow
- Cellar Bilemass
- Warden

Minibosses:

- Village Ogre
- The Collector

Boss:

- Keeper of the Gate — Ashen Duelist and Collapse phases

## Area 2 — Yomori Grove

Four standard enemies:

- Lingering Wraith
- Lantern Wraith
- Mist Shepherd
- Stalker Hound

Minibosses:

- The Embered Pilgrim
- Rotwood Host

Boss:

- Twin Maws — Rootfang and Briarthorn

Both twins begin active. The first twin defeated transfers its half of the corrupted bond to the survivor, creating an empowered second half. Exact transition invulnerability, health/posture handling, inherited move timing, and difficulty normalization remain implementation questions.

## Area 3 — Kagutsuchi Court

Five standard enemies:

- Court Guard
- Court Caster
- Elite Defender
- Hollow Vessel
- Court Sentinel

Minibosses:

- Blood Lotus — Heart and Stalk multi-cycle encounter
- Eternal Swordsman — focused duel encounter

Boss:

- Eclipse Shogun — Sovereign Duelist, Tyrant of the Wellspring, and Eclipse Revealed phases

## Environment sets

- The Strand
- Hushiro Gate Village
- Yomori Grove
- Kagutsuchi Court

Additional specialized spaces, including Blood Cavern/Blood Mirror and the Wellspring, are treated as parts of the relevant hub or regional production packages rather than extra top-level environment sets unless later tracking requires a split.

## Interface and presentation

- Combat HUD
- Corruption meter
- Blood Aspect icon and Tier indicator
- Shrine Resist/Embrace screen
- Boat Aspect-selection/run-start screen
- Blood Mirror trial screen
- Boss and miniboss presentation
- Blood Lotus multi-cycle Heart/Stalk state presentation
- Hub progression interfaces
- Functional room presentation
- Pause, overview, results, settings, controls, save/loading, credits, and completion presentation

## Art-production structure

The current plan uses seven top-level art milestones with independently quoted internal batches. Milestones are dependency and playtest groupings, not equal-size contracts.

See [Production Roadmap](PRODUCTION_ROADMAP.md), [Asset Inventory](../art_production/ASSET_INVENTORY.md), and [Art Milestones](../art_production/milestones/README.md).
