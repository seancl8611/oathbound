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

This document records the current production-level shape of Oathbound. Exact balance values, frame counts, room counts, catalog sizes, and implementation details remain subject to playtesting.

## Master scope summary

| Asset group | Planned count | Current scope note |
|---|---:|---|
| Player character | 1 | Akio concept, final sprite, and complete combat animation library |
| Blood Aspects | 3 | Wolf, Wraith, and Ronin with Tier 0–IV progression |
| Prosthetic tools | 8 | Distinct tactical tools using shared activation where practical |
| Combat stances | 5 | Storm, Frost, Ember, Hex, Shadow |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, and Scribe |
| Area 1 standard enemies | 6 | Grounded village/garrison corruption roster |
| Area 2 standard enemies | 4 | Forest, spirit, and predator roster |
| Area 3 standard enemies | 5 | Preserved court and inner-sanctum roster |
| Miniboss encounters | 6 | Two per main area |
| Major bosses | 3 | One principal progression boss per area |
| Environment sets | 4 | Strand plus Areas 1–3 |
| Cross-area room types | 6 | Combat, Shrine, rest, shop, treasure/miniboss, boss |
| Current currency families | 4 | Mist, Scroll, Boss Emblem, Gold |
| Relic rarity tiers | 4 | Common, Uncommon, Rare, Legendary |

## Player

- Akio base character and full combat animation library
- Quick Slash, Cross Cut, Heavy Cleave, Hold Thrust, Counter Cut, and Dash Slash
- Katana combat, posture, parry, block, dash, deathblow, and prosthetic activation
- Blood Aspects: Wolf, Wraith, and Ronin
- Tier 0 through Tier IV run-only mutation progression
- Prosthetics: Beast-Bane Whistle, Thunder Rod, Smoke Gourd, Fang Harpoon, Mirror Umbrella, Flame Vent, Mist Raven, Bloodletting Gourd
- Stances: Storm, Frost, Ember, Hex, Shadow

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

Standard enemies:

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

Standard enemies:

- Lingering Wraith
- Lantern Wraith
- Mist Shepherd
- Stalker Hound

Minibosses:

- The Embered Pilgrim
- Rotwood Host

Boss:

- Twin Maws — Rootfang and Briarthorn

Both twins begin active. The first defeated transfers its half of the corrupted bond to the survivor. Exact transition invulnerability, health/posture handling, inherited move timing, and difficulty normalization remain implementation questions.

## Area 3 — Kagutsuchi Court

Standard enemies:

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

## Environment and room structure

Top-level environment sets:

- The Strand
- Hushiro Gate Village
- Yomori Grove
- Kagutsuchi Court

Each run area adapts six common room functions: combat, Shrine, rest, shop, treasure/miniboss, and boss. Specialized spaces such as Blood Cavern, Blood Mirror, authored miniboss arenas, and Wellspring remain subsets of their hub or region.

## Items and rewards

Current families include:

- Mist, Scroll, Boss Emblem, and Gold,
- Health and Spirit pickups,
- run-scoped boons,
- relics with Common, Uncommon, Rare, and Legendary presentation,
- area-specific breakables,
- treasure and major reward objects,
- future consumables and catalog entries as mechanics are approved.

## Interface and presentation

- Run HUD and combat feedback
- Corruption meter, Aspect icon, and Tier indicator
- Stance and prosthetic modules
- Damage numbers and status types
- Enemy health/posture indicators
- Deathblow prompt
- Strand HUD and persistent resources
- World interaction prompts
- Shrine Resist/Embrace screen
- Boat Aspect-selection/run-start screen
- Blood Mirror trial screen
- Boss and miniboss presentation
- Hub progression interfaces
- Functional room presentation
- Pause, overview, results, settings, controls, save/loading, credits, and completion presentation

## Art-production structure

The current plan uses seven top-level art milestones with independently quoted internal batches. Milestones are dependency and playtest groupings, not equal-size contracts.

See [Production Roadmap](PRODUCTION_ROADMAP.md), [Asset Inventory](../art_production/ASSET_INVENTORY.md), and [Art Milestones](../art_production/milestones/README.md).
