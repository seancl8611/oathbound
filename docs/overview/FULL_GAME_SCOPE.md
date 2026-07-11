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
  - techniques
related:
  - ART-ASSET-INVENTORY
  - OVERVIEW-PRODUCTION-ROADMAP
---

# Full Game Scope

This document records the current production-level shape of Oathbound. Exact balance values, frame counts, room counts, Technique and Relic catalog sizes, and implementation details remain subject to playtesting.

## Master scope summary

| Asset group | Planned count | Current scope note |
|---|---:|---|
| Player character | 1 | Akio concept, final sprite, and complete combat animation library |
| Blood Aspects | 3 | Wolf, Wraith, and Ronin with Tier 0–IV progression |
| Technique loadout | 4 active + 1 reserve | Run-only Techniques with shallow refinements; final catalog size remains open |
| Prosthetic tools | 8 | Distinct tactical tools using shared activation where practical |
| Run-scoped Relic capacity | 1 initial slot | Final Relic catalog size remains open |
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
- Four empty active Technique slots and one empty reserve at run start
- Standalone Techniques with natural shared-verb synergy
- At most one slotless refinement per Technique
- Blade, Deflection, Execution, Movement, Prosthetic, and General Technique categories
- Prosthetics: Beast-Bane Whistle, Thunder Rod, Smoke Gourd, Fang Harpoon, Mirror Umbrella, Flame Vent, Mist Raven, Bloodletting Gourd
- One equipped prosthetic in the initial run structure
- One initial run-scoped Relic slot

The former Storm, Frost, Ember, Hex, and Shadow stance system is removed. Burn and Shock remain where owned by approved prosthetics or other explicitly documented content. Frost and Hex are not baseline player status families.

## Run-build structure

- Blood Aspect defines the broad run identity.
- Corruption and Shrine Embrace advance the fixed Aspect Tier path.
- Techniques customize specific combat verbs without replacing the Aspect.
- Active Technique capacity is four, with one inactive reserve.
- A full Technique inventory does not exist.
- Reserve swapping occurs only at Technique reward screens and rest rooms.
- Prosthetic Techniques use normal active slots and may receive one slotless refinement.
- Relics use a separate slot.
- Run-only build state resets after death or successful Wellspring completion.

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

Combat routes support previewed primary rewards. Technique-marked combat rooms use the shared combat-room kit rather than requiring a separate full environment family.

## Items and rewards

Current families include:

- Mist, Scroll, Boss Emblem, and Gold,
- Health and Spirit pickups,
- temporary maximum-Health and maximum-Spirit rewards,
- run-scoped Techniques and refinements,
- eligible Prosthetic Techniques,
- run-scoped Relics with Common, Uncommon, Rare, and Legendary presentation,
- area-specific breakables,
- treasure and major reward objects,
- future consumables and catalog entries as mechanics are approved.

Current reward ownership includes:

- previewed standard combat payouts,
- Technique opportunities at selected combat or milestone rewards,
- Shrine Resist/Embrace or support,
- rest-room recovery and reserve swapping,
- Gold-based run shops,
- high-value treasure and miniboss rewards,
- persistent plus current-run rewards after regional bosses,
- Wellspring/results processing after the Eclipse Shogun.

## Interface and presentation

- Run HUD and combat feedback
- Corruption meter, Aspect icon, and Tier indicator
- Contextual active-Technique state indicators
- Equipped prosthetic module
- Technique selection, refinement, replacement, reserve, overwrite-warning, decline, and reroll states
- Four active Technique slots and one reserve in build-overview interfaces
- Damage numbers and approved status types
- Enemy health/posture indicators
- Deathblow prompt
- Strand HUD and persistent resources
- World interaction and route-reward prompts
- Shrine Resist/Embrace screen
- Boat Aspect-selection/run-start screen
- Blood Mirror trial screen
- Boss and miniboss presentation
- Hub progression interfaces
- Functional room presentation
- Pause, overview, results, settings, controls, save/loading, credits, and completion presentation

## Art-production structure

The current plan uses seven top-level art milestones with independently quoted internal batches. Milestones are dependency and playtest groupings, not equal-size contracts.

Removing five stance families reduces unique player-system VFX and status-art scope. Technique production instead requires reusable card templates, category and slot icons, reserve/replacement states, refinement markers, and only the bespoke combat VFX needed for approved Technique mechanics.

See [Production Roadmap](PRODUCTION_ROADMAP.md), [Asset Inventory](../art_production/ASSET_INVENTORY.md), and [Art Milestones](../art_production/milestones/README.md).
