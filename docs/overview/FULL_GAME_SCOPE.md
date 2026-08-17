---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: draft
authority: primary
last_reviewed: 2026-08-17
topics:
  - full-scope
  - techniques
  - relics
  - prosthetics
  - progression
  - boss-materials
  - areas
  - strand
  - the-heart
  - postgame
  - regional-routing
  - economy
  - survival
related:
  - ART-ASSET-INVENTORY
  - OVERVIEW-PRODUCTION-ROADMAP
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-ITEMS-REWARDS
  - META-OPEN-QUESTIONS
---

# Full Game Scope

This document summarizes Oathbound's current production-level shape. Detailed mechanics live in their gameplay/content authorities. Prototype percentages and values may change through playable validation without reopening the underlying architecture.

# Master scope

| Asset / system group | Planned count | Current boundary |
|---|---:|---|
| Player character | 1 | Akio; base sword kit + three Aspect combat libraries |
| Blood Aspects | 3 | Wolf, Wraith, Ronin |
| Direct Technique slots | 5 | Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow |
| Direct Techniques | 25 | Five families × five direct slots |
| Supporting Techniques | 15 | Three per family |
| Cross-family Techniques | 5 | Rare hybrid effects |
| Legendary Techniques | 5 | One family capstone each |
| Refinements | 10 | One small eligible parent upgrade each |
| Total Technique roster | 50 + 10 refinements | 10 Common / 18 Uncommon / 17 Rare / 5 Legendary |
| Prosthetic tools | 8 | One equipped at a time; 19 permanent Forge upgrades |
| Relic roster | 10 | One equipped; persistent collection/mastery/progression; no rarity tiers |
| General consumables | 0 | No launch consumable inventory or one-use item reward layer |
| Permanent upgrade stations | 3 | Bloodwell, Forge Bench, later-unlocked Blood Mirror |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, Scribe |
| Area 1 standard enemies | 6 | Hushiro |
| Area 2 standard enemies | 4 | Yomori |
| Area 3 standard enemies | 5 | Kagutsuchi |
| Regional minibosses | 6 authored | Two per region; one optional candidate offered per region/run |
| Regional bosses | 3 | Keeper of the Gate, Twin Maws, Eclipse Shogun |
| Prototype regional chambers | 33 | 12 Hushiro + 10 Yomori + 11 Kagutsuchi |
| Heart Binding campaign | 7 original / 6 player clears | One historical breach, six player-destroyed Bindings |
| True-final Heart | 1 encounter / 2 forms | Unbound Heart, Vessel of Continuance |
| General currencies | 3 | Mist, Scrolls, Gold |
| Regional boss-material families | 3 | One unique low-count permanent material per regional boss; exact item names TBD |

# Player and run build

Akio's combat foundation is sword-first and posture/parry/deathblow driven.

After the relevant systems unlock, a run may build through:

- one selected Blood Aspect beginning at Tier 0,
- optional Shrine/Corruption advancement through Tier IV,
- five direct Technique slots,
- slotless Supporting / Cross-family / Legendary Techniques,
- refinements and rare same-slot replacements,
- one Prosthetic,
- one Relic,
- Gold/Shop decisions,
- temporary Health/Spirit recovery and capacity.

There is **no global Technique inventory cap** beyond the five direct action slots. Mandatory content cannot assume a specific Tier, Blood Art, Technique family, Legendary, Relic, highly upgraded Prosthetic, ideal economy, or ideal survival route.

Oathbound does not add a separate general consumable inventory to this build stack at launch.

Detailed Technique mechanics/roster belong to `TECHNIQUES.md` and `TECHNIQUE_CATALOG.md`. Detailed Aspect packages belong to the Aspect authorities.

# Permanent progression

Launch scope uses exactly three permanent upgrade stations:

## Bloodwell

Owns:

- Akio,
- Run Infrastructure.

Run Infrastructure is one umbrella for approved Rest, Shrine, reward, route, transition, and expedition support. It is not split into separate permanent subsystem trees.

## Forge Bench

Owns:

- Prosthetics,
- Relics.

The eight Prosthetics use shallow linear paths. Relics retain their own mastery/progression logic despite sharing the station.

The old alternate-weapon / weapon-socket Forge direction and separate Relic Reliquary are not current scope.

## Blood Mirror

Owns permanent Blood Aspect progression, begins locked, and becomes available later through campaign/onboarding progression.

Permanent Aspect progression cannot bypass the run's Tier 0–IV Shrine path or unlock Blood before Tier II.

# Persistent resource scope

The current persistent economy is intentionally small:

- **Mist** — broad meta progression,
- **Scrolls** — primarily Prosthetic Forge development,
- **three regional boss materials** — low-count secondary requirements on a small number of major permanent upgrades.

There is **no generic Boss Emblem currency**.

Every Keeper, Twin Maws, and Eclipse Shogun kill awards exactly one boss-specific material. Materials persist immediately even if the run later fails. They use small costs—normally 1–3—and should not turn bosses into farming chores.

Gold remains run-only.

`ITEMS_AND_REWARDS.md` owns payout values; `PROGRESSION.md` owns persistence and spending boundaries.

# Run structure and pacing

Normal successful Binding-run target: approximately **45–50 active minutes**.

Prototype region budgets:

- **Hushiro:** 12 chambers / ~14–16 min,
- **Yomori:** 10 / ~12–14 min,
- **Kagutsuchi:** 11 / ~15–17 min.

The complete regional route is **33 counted chambers** before specialized Heart-route spaces.

Current controlled-generation prototype includes:

- opening: 50% one exit / 50% two exits,
- main: 25% one / 70% two / 5% three,
- pre-boss/final: 45% one / 55% two,
- roughly 17–19 multi-exit decisions,
- roughly 20–22 standard Combat chambers,
- roughly 7–9 Technique pickups for a Technique-invested successful run,
- roughly 4–5 visible Shrine opportunities,
- roughly 1–2 normally visited Shops, Rests, Treasures, and minibosses.

Exact route rules and safeguards belong to `RUN_STRUCTURE.md`.

# Reward / economy prototype

Approved first-pass reward integration includes:

- region-specific Combat reward weights,
- three-choice Technique reward generation with region/source quality weighting,
- 60 / 70 / 80 regional Gold primary rewards,
- three-item Shops with stable regional prices,
- percentage-based recovery/capacity values,
- automatic post-Keeper / post-Twin-Maws viability recovery,
- partial Shogun→Heart recovery on the final story run,
- Mist primary rewards of 20 / 25 / 30,
- Scroll primary rewards of 1 / 1 / 2,
- premium Treasure persistent-resource bundles,
- +10 Mist / +1 Scroll per defeated miniboss,
- regional boss Mist + boss-material drops,
- Keeper/Twin Maws three-card current-run Boss Rewards,
- persistent resources retained when earned even if the run later fails.

General one-use consumables are excluded from Shops, Treasure, route rewards, and inventory scope at launch.

These are prototype implementation targets, not immutable final balance law.

# Relic scope

Launch Relics:

- 10 approved items,
- one equipped slot,
- persistent collection,
- kill-earned mastery for the equipped Relic,
- run-active benefit,
- no Relic rarity tiers,
- Forge Bench progression/management,
- acquisition split of **4 campaign/Strand + 2 Blood Cavern/challenge + 4 run-discovered**,
- all 10 obtainable before the canonical story ending,
- routine swaps at the Forge before a run and after Keeper/Twin Maws, plus immediate equip-or-keep on a new discovery.

# The Strand

Persistent NPCs:

- Keeper,
- Peddler,
- Smith,
- Raven,
- Undead Samurai,
- Scribe.

Primary services/landmarks:

- Boat / run confirmation,
- Forge Bench,
- Merchant Stall,
- Discovery Board,
- Bloodwell,
- Blood Cavern,
- later-unlocked Blood Mirror.

The Boat remains a fast run-start confirmation point rather than another combined permanent-progression interface.

# Regional roles

- **Hushiro Gate Village / Rupture:** 6 standard enemies, 2 authored minibosses, Keeper; establishes first Technique/family direction.
- **Yomori Grove / Adaptation:** 4 standard enemies, 2 authored minibosses, Twin Maws; expands/deepens the build.
- **Kagutsuchi Court / False Ascendancy:** 5 standard enemies, 2 authored minibosses, Eclipse Shogun; finalizes the mature build under the most layered normal pressure.

Each region generates one optional miniboss opportunity from its two candidates.

# Heart Binding campaign and ending

The Court historically destroyed one of seven Heart Bindings. Six remain when Akio begins.

The first six successful Binding runs each destroy one remaining Binding. After all six are gone, the seventh successful story route continues from the Eclipse Shogun into the true-final Heart with the same active build.

Heart approach, Binding-completion spaces, and the Heart encounter are outside the 33 counted regional chambers.

The true-final Heart has two conceptual forms:

1. The Unbound Heart,
2. The Vessel of Continuance.

Destroying the Heart ends Beast Blood, stops the Shogun's reconstruction, ends the Blood Moon, and leaves Akio mortal.

Completed saves remain playable; repeat normal/Heart runs do not create additional canon.

# Current open production scope

The run-build, reward/economy, boss-reward, Relic-acquisition, and major route architecture are complete at paper-design depth.

The remaining scope closes in dependency order:

1. **Playable full-run integration and pacing** — define regional enemy-composition/threat rules, elite pressure, clear-time budgets, boss/miniboss budgets, service overhead, and validate the 33-chamber route against 45–50 minutes.
2. **Permanent-progression content scope** — define Bloodwell/Blood Mirror node counts and roles, Relic mastery rank structure, boss-material gate assignments, and unlock cadence without final balance tuning.
3. **Narrative delivery/campaign presentation** — define the authored launch package and production volume.
4. **Endgame/postgame/release package** — define repeat Heart access/rewards, completion goals, and release UI/presentation.

`OPEN_QUESTIONS.md` owns the current unresolved agenda and should not duplicate resolved prototype tables.

# Deferred implementation / tuning

Final frame data, hitboxes, damage/posture values, status durations, Blood values, route percentages, Technique offer rates, economy/recovery values, Mist/Scroll quantities, final upgrade costs, exact mastery thresholds, animation timing, VFX density, audio timing, and final HUD layout remain implementation/playtest work under their owning authorities.
