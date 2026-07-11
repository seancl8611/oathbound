---
id: ART-ASSET-INVENTORY
title: Asset Inventory
category: art-production
status: draft
authority: primary
last_reviewed: 2026-07-11
topics:
  - asset-counts
  - characters
  - environments
  - ui
  - vfx
  - items
  - techniques
related:
  - OVERVIEW-FULL-SCOPE
---

# Asset Inventory

This is the high-level production inventory. Individual character, system, regional, encounter, VFX, item, UI, and milestone files own detailed animation and state lists.

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
| Environment sets | 4 | Strand and Areas 1–3; specialized interiors and arenas remain subsets |
| Blood Aspect families | 3 | Wolf, Wraith, Ronin plus modular Tier escalation |
| Prosthetic families | 8 | One approved tool family each |
| Technique loadout UI | 4 active + 1 reserve | Final Technique catalog and unique icon count remain open |
| Run-scoped Relic capacity | 1 initial slot | Final Relic catalog remains open |
| Currency families | 4 current | Mist, Scroll, Boss Emblem, Gold |
| Relic rarity tiers | 4 | Common, Uncommon, Rare, Legendary |

The former five stance families are removed. High-level counts for Technique icons, unique Technique VFX, Relics, consumables, and room variants remain granular and should be finalized when catalog size is locked.

## Player and player-system art

- Akio concept and final base sprite
- Complete base combat animation library
- Separate ground shadow
- Core sword trails and combat feedback
- Wolf Prey Mark and pressure states
- Wraith afterimage, perfect-dodge, and Mist-Step states
- Ronin parry, Counter Cut, and Focus states
- Tier I–IV modular mutation overlays
- Eight prosthetic tool VFX and icons
- Reusable Technique category, card, active-slot, reserve-slot, refinement, replacement, warning, decline, and reroll art
- Unique Technique icons for approved catalog entries
- Bespoke Technique combat VFX only where existing combat, Aspect, or prosthetic language cannot communicate the mechanic

## Combatants

- **Area 1:** 6 standard enemies, Village Ogre, The Collector, Keeper of the Gate
- **Area 2:** 4 standard enemies, Embered Pilgrim, Rotwood Host, Twin Maws encounter
- **Area 3:** 5 standard enemies, Blood Lotus, Eternal Swordsman, Eclipse Shogun

## Environment sets and rooms

- Strand hub, docks, NPC stations, Blood Cavern, and Blood Mirror
- Hushiro modular base kit, functional rooms, miniboss spaces, and old-gate boss arena
- Yomori base kit, functional rooms, failed-purification site, Rotwood arena, and Twin Maws arena
- Kagutsuchi base kit, functional rooms, Blood Lotus arena, duel court, and Wellspring throne-space

Cross-area room types:

- combat,
- Shrine,
- rest,
- shop,
- treasure/miniboss,
- boss.

Shared route-reward markers are required for Technique, Gold, Mist, Scroll, Health, Spirit, temporary capacity, Shrine, rest, shop, treasure, miniboss, and boss categories. Regional skins adapt material treatment without changing the symbol.

## UI and UX art

- Run HUD: HP, posture, ten Spirit segments, prosthetic cooldown, contextual Technique state, currency, status, Corruption, Aspect, and Tier
- Technique reward screen with three-card offers
- Four active Technique slots and one reserve slot
- Technique replacement, reserve movement, reserve overwrite warning, decline, and reroll states
- Technique refinement and active/reserve comparison states
- Rest-room active/reserve swap interface
- Pause/build overview with read-only active and reserve Technique details
- Damage-number style family
- Standard-enemy health/posture indicators
- Miniboss and boss bars with name and phase support
- Deathblow prompt and persistent cue integration
- Strand HUD and persistent currency counters
- Interaction prompts and locked/available states
- Route reward-preview markers
- Shrine, Boat, Forge, Merchant, Discovery Board, Bloodwell, Blood Mirror, results, and pause screens
- Blood Lotus multi-cycle UI support
- Front end, settings, controls, save/loading, credits, and completion presentation

## Shared VFX families

### Core combat and Corruption

- Parry Spark with standard/perfect grades
- Hit Spark
- Sword Trail variants
- Posture Break Cue
- Deathblow Cue
- Corruption Full Cue
- Embrace Transformation Cue
- Resist Stabilization Cue

### Blood Aspects

- Wolf target mark, healthy/wounded/finishable states, and pressure buildup
- Wraith afterimage, vanish/reappear, and Mist-Step
- Ronin enhanced contact, Counter Cut, and Focus

### Prosthetics

- Beast-Bane Whistle
- Thunder Rod
- Smoke Gourd
- Fang Harpoon
- Mirror Umbrella
- Flame Vent
- Mist Raven
- Bloodletting Gourd

### Techniques

- Reused base-combat, Aspect, and prosthetic effects where sufficient
- Modular trigger, threshold, resource-return, mark, footprint, and refinement accents
- Unique effects only for approved Technique mechanics that cannot read correctly through reuse
- Mixed-build readability examples across all three regional palettes

The removed Storm, Frost, Ember, Hex, and Shadow stance VFX families are no longer planned. Burn and Shock remain supported by approved prosthetics. Frost and Hex are not baseline player status requirements.

## Item and reward art

- Mist, Scroll, Boss Emblem, and Gold world/HUD pairs
- Health and Spirit pickups
- Temporary Health/Spirit capacity reward treatments
- Route reward markers
- Technique card template, categories, tags, active/reserve states, refinement state, replacement comparison, and warning states
- Unique Technique icons for locked catalog entries
- Relic cards, separate Relic slot, and rarity frames
- Area-specific breakables with intact/broken states
- Area-specific treasure and reward objects with unopened/opened states
- Consumables and future item families as their mechanics are approved

## Milestone 1 production lock

The polished Milestone 1 brief establishes exact delivery subsets, working frame counts, source-file requirements, review gates, batch folders, and acceptance criteria for Akio, Corrupted Swordsman, Blighted Hound, Hollow, VFX-001 through VFX-004, Combat HUD, and Hushiro Combat Room Kit.

The separate Posture Break Cue exists in the broader inventory, but its exact Milestone 1 contractor batch assignment remains unresolved because it is absent from the polished four-effect bundle.

## Inventory rule

When a system, enemy, boss, room type, item family, UI screen, or VFX family is added, removed, or reassigned, update this inventory and its assigned milestone in the same change.
