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
  - authored-encounters
  - enemy-lineage
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
| Relic roster | 10 | One equipped; Base + 2 mastery ranks each |
| Bloodwell Akio nodes | 10 | 3 foundation + 4 combat-stability + 3 regional mastery nodes |
| Run Infrastructure nodes | 8 | Rest/Shrine/preparation/route/resource support + 3 regional passage nodes |
| Blood Mirror nodes | 9 | 3 per Aspect: Tier 0 Handling / Signature Reliability / Blood Discipline |
| Boss-material-gated permanent nodes | 6 | Two Bloodwell gates per regional boss material |
| General consumables | 0 | No launch consumable inventory or one-use item reward layer |
| Permanent upgrade stations | 3 | Bloodwell, Forge Bench, Blood Mirror after first Keeper |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, Scribe |
| Area 1 standard enemies | 6 | Hushiro-native roster |
| Area 2 standard enemies | 4 | Yomori-native roster; Stalker Hound is evolved Blighted Hound lineage |
| Area 3 standard enemies | 5 | Kagutsuchi-native Court roster |
| Regional minibosses | 6 authored | Two per region; one optional candidate offered per region/run |
| Regional bosses | 3 | Keeper of the Gate, Twin Maws, Eclipse Shogun |
| Prototype regional chambers | 33 | 12 Hushiro + 10 Yomori + 11 Kagutsuchi |
| Heart Binding campaign | 7 original / 6 player clears | One historical breach, six player-destroyed Bindings |
| True-final Heart | 1 encounter / 2 forms | Unbound Heart, Vessel of Continuance |
| General currencies | 3 | Mist, Scrolls, Gold |
| Regional boss-material families | 3 | One unique low-count permanent material per regional boss |

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

# Permanent progression

Launch scope uses exactly three permanent upgrade stations.

## Bloodwell

Owns **10 Akio nodes + 8 Run Infrastructure nodes**.

Akio progression:

- 3 foundation nodes,
- 4 combat-stability nodes,
- 3 regional mastery nodes.

Run Infrastructure:

- Field Rest,
- Shrine Stabilization,
- Expedition Preparation,
- Route Intelligence,
- Salvage Protocol,
- Keeper Passage,
- Twin Passage,
- Heart Passage.

Exactly six Bloodwell nodes use regional boss materials: one Akio mastery node and one passage node per boss material. Mist remains the primary Bloodwell currency.

## Forge Bench

Owns:

- eight Prosthetics with the approved **19 shallow linear upgrades**,
- ten Relics with **Base → Mastery I → Mastery II / Complete** progression.

Relic mastery comes from eligible kills while equipped and does not normally spend Mist, Scrolls, boss materials, duplicate Relics, or a separate mastery currency.

The old alternate-weapon / weapon-socket Forge direction and separate Relic Reliquary are not current scope.

## Blood Mirror

Unlocks after the **first Keeper defeat** and owns exactly **3 permanent nodes per Aspect / 9 total**:

1. Tier 0 Handling,
2. Signature Reliability,
3. Blood Discipline.

Availability advances after first Keeper, first Twin Maws, and first Shogun / first Binding clear respectively.

Permanent Aspect progression cannot bypass the run's Tier 0–IV Shrine path, grant major Tier mechanics early, or unlock Blood before Tier II.

## Campaign progression cadence

- **First return:** Bloodwell opens with foundation Akio nodes plus initial Infrastructure.
- **First Keeper:** second Bloodwell band + Keeper material gates + Blood Mirror Node 1.
- **First Twin Maws:** third Bloodwell band + Twin material gates + Blood Mirror Node 2.
- **First Shogun / first Binding clear:** final Shogun material gates + Blood Mirror Node 3.
- **Remaining Binding clears:** no new foundational progression system; player works toward completion/mastery within established systems.

# Persistent resource scope

- **Mist** — broad meta progression, primarily Bloodwell and approved broad permanent upgrades.
- **Scrolls** — primarily Prosthetic Forge development.
- **three regional boss materials** — low-count secondary requirements on the six approved Bloodwell mastery gates.
- **Gold** — run-only.

There is **no generic Boss Emblem currency**.

Every Keeper, Twin Maws, and Eclipse Shogun kill awards exactly one boss-specific material. Materials persist immediately even if the run later fails. Exact low-count requirements remain tuning within the approved six-gate structure.

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

Standard Combat uses **authored encounters**, not procedural enemy assembly. Each region has a finite pool of deliberately scripted encounter compositions; route bands do not require separate encounter pools, while individual encounters may later receive minimum-chamber restrictions where needed.

Standard enemies are region-native by default. The only approved launch cross-region lineage is **Blighted Hounds → Stalker Hound** in Yomori Grove.

Encounter-pool counts and individual scripts are deferred until the encounter-authoring production pass.

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

# Relic scope

Launch Relics:

- 10 approved items,
- one equipped slot,
- persistent collection,
- **2 mastery ranks after Base per Relic / 20 mastery milestones total**,
- kill-earned mastery for the equipped Relic,
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
- Blood Mirror inside the Cavern after first Keeper.

The Boat remains a fast run-start confirmation point rather than another combined permanent-progression interface.

# Regional roles

- **Hushiro Gate Village / Rupture:** 6 native standard enemies, 2 authored minibosses, Keeper; establishes first Technique/family direction.
- **Yomori Grove / Adaptation:** 4 native standard enemies, including Stalker Hound as evolved Blighted Hound lineage; 2 authored minibosses, Twin Maws; expands/deepens the build.
- **Kagutsuchi Court / False Ascendancy:** 5 native Court standard enemies; 2 authored minibosses, Eclipse Shogun; finalizes the mature build.

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

The run-build, reward/economy, boss-reward, Relic-acquisition, route, standard-encounter architecture, regional enemy-availability rule, and **permanent-progression content structure** are complete at paper-design depth.

The remaining scope closes in dependency order:

1. **Narrative delivery/campaign presentation** — define the authored scene/dialogue/codex/Binding/ending package and production volume.
2. **Endgame/postgame/release package** — define repeat Heart access/rewards, completion goals, and release UI/presentation.

Detailed standard-encounter authoring, encounter-pool counts, clear-time tuning, and full-run time validation remain a later content/playtest pass once those encounters are actually being produced.

`OPEN_QUESTIONS.md` owns the current unresolved agenda.

# Deferred implementation / tuning

Final encounter scripts/counts, frame data, hitboxes, damage/posture values, status durations, Blood values, route percentages, Technique offer rates, economy/recovery values, Mist/Scroll quantities, final upgrade costs, exact Relic mastery thresholds, exact Bloodwell/Blood Mirror percentages, animation timing, VFX density, audio timing, and final HUD layout remain implementation/playtest work under their owning authorities.
