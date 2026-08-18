---
id: OVERVIEW-GAME
title: Oathbound Game Overview
category: overview
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - project-identity
  - combat
  - returning-blood
  - techniques
  - relics
  - blood-aspects
  - progression
  - boss-materials
  - authored-encounters
  - enemy-lineage
  - heart-bindings
related:
  - OVERVIEW-DESIGN-PILLARS
  - OVERVIEW-FULL-SCOPE
  - GAMEPLAY-COMBAT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-ITEMS-REWARDS
  - LORE-RETURNING-BLOOD
---

# Oathbound Game Overview

Oathbound is a high-angle 2D action roguelite built around disciplined katana combat, posture pressure, precise parries, stagger, deathblows, previewed branching routes, and run-based build progression.

The game should feel disciplined, dangerous, elegant, and cursed. Combat readability and player execution take priority over spectacle or automatic build power.

# Premise

Akio is a warrior of the Order sent through a containment barrier onto a cursed Japanese-gothic island whose kingdom once used Beast Blood from the Heart to survive a plague.

Akio unknowingly descends from the royal bloodline that escaped containment. He begins without active Blood powers; his first death during the Blood Moon awakens inherited **Returning Blood** and reconstructs him at the Strand.

His lineage explains why the power awakens. His discipline and inherited expression explain why he can preserve agency and direct it differently from other Beast Blood users.

# Core player fantasy

Akio remains a swordsman first. Blood Aspects reshape the weapon kit, Techniques customize core sword actions and supporting synergies, Prosthetics provide one equipped tactical tool, and Relics provide one smaller run-wide support effect.

The build should strengthen decisions the player already makes—timing, spacing, posture pressure, parries, movement, deathblows, targeting, and resource use—rather than replace combat fundamentals.

# Current gameplay shape

- Introductory attempt with base katana combat and no active Blood powers.
- Returning Blood awakens after the first death and begins the repeated-run loop.
- Shared combat includes parry, Health/posture, block, dash, stagger, deathblow, genuine rear-hit/backstab classification, and Prosthetic support.
- Launch Blood Aspects: **Wolf, Wraith, Ronin**.
- Every normal run begins at Aspect Tier 0; optional Shrine Resist/Embrace progression reaches Tier IV maximum.
- Blood/Blood Art becomes available only from Tier II onward.
- Five direct Technique slots: **Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow**.
- Technique roster: **50 actual Techniques + 10 refinements** across Echo, Rupture, Seal, Rift, and Crimson Vulnerable/backstab/direct-Health identities.
- Supporting / Cross-family / Legendary Techniques are slotless; no global Technique inventory cap exists.
- One equipped Prosthetic from an eight-tool roster with persistent Forge progression.
- One equipped Relic from a 10-item persistent collection with individual kill-earned mastery/progression.
- Relic acquisition uses 4 campaign/Strand + 2 Blood Cavern/challenge + 4 run-discovered unlocks, with limited regional-transition swapping.
- No general launch consumable inventory or one-use item reward layer.
- Permanent stations: **Bloodwell = Akio + Run Infrastructure**, **Forge Bench = Prosthetics + Relics**, **Blood Mirror = Blood Aspects** after later unlock.

# Persistent progression economy

Oathbound keeps the permanent resource model deliberately small:

- **Mist** — broad persistent meta progression,
- **Scrolls** — primarily Prosthetic Forge progression,
- **three regional boss materials** — one unique low-count material from Keeper, Twin Maws, and Eclipse Shogun, used sparingly as secondary requirements on selected major permanent upgrades,
- **Gold** — run-only Shop economy.

There is no generic Boss Emblem currency.

Boss materials are earned every time their boss is defeated and are saved immediately, so defeating Keeper or Twin Maws still advances persistent progression even when the run later fails. They are mastery gates rather than a monster-part crafting economy.

# Run structure

The approved first regional prototype contains **33 counted chambers**:

- **Hushiro Gate Village:** 12 chambers, Keeper of the Gate at 12, ~14–16 active minutes.
- **Yomori Grove:** 10 chambers, Twin Maws at 10, ~12–14 minutes.
- **Kagutsuchi Court:** 11 chambers, Eclipse Shogun at 11, ~15–17 minutes.

Each region offers one optional miniboss opportunity from two authored candidates. Branches preview room/reward information, normally offer one or two exits, and may reconverge without routine backtracking.

Standard Combat rooms use **deliberately authored encounter scripts**. When a Combat chamber is selected, the game chooses an eligible encounter from that region's authored pool rather than procedurally constructing an enemy mix from a threat budget. Opening/main/final route bands do not require separate encounter pools; individual encounters may later receive minimum-chamber eligibility where their mechanics or teaching role require it.

Standard enemies are region-native by default. Cross-region continuation uses a separately authored evolved regional variant rather than carrying the unchanged enemy forward or simply increasing its statistics. The only approved launch lineage is **Blighted Hounds → Stalker Hound** in Yomori Grove; Kagutsuchi's five standard enemies are all native Court units.

The controlled-generation, Technique-offer, Gold/Shop, survival/capacity, boss-reward, Relic-acquisition, and persistent-resource payout models are approved as prototype implementation targets. Exact values remain playtest-tunable.

A normal successful Binding run targets approximately **45–50 minutes of active time**. Encounter-pool counts and individual encounter scripts remain later content-production/playtest work.

# Campaign structure

The Heart was imprisoned by seven ancient Bindings. The Court destroyed the outermost before the game, leaving six intact.

During each of the first six successful Binding runs, Akio defeats the Eclipse Shogun, reaches the Heart, uses Returning Blood through the Court's extraction apparatus, breaks one remaining Binding, is dissolved by the Heart, and reconstructs at the Strand.

After all six remaining Bindings are destroyed, the seventh successful story run continues directly from the Shogun into the two-form true-final Heart encounter with the same active build.

Destroying the Heart ends Beast Blood, stops Shogun reconstruction, ends the Blood Moon, and leaves Akio mortal in his current human body.

Completed saves remain playable. Repeat normal runs and optional repeat Heart routes do not create additional canon.

# World structure

- **The Strand** — persistent hub, preparation, progression, and return point.
- **Hushiro Gate Village / Rupture** — recent human/community collapse.
- **Yomori Grove / Adaptation** — long-term predator/spirit consequences; includes Stalker Hound as an evolved continuation of the earlier hound lineage.
- **Kagutsuchi Court / False Ascendancy** — disciplined elite mutation mistaken for mastery; uses its own five-enemy Court roster.
- **Heart spaces** — specialized post-Shogun campaign/endgame content outside the 33 counted regional chambers.

# Current design focus

Major run-build, reward/economy, route, boss-reward, Relic, standard-encounter architecture, and regional enemy-availability rules are already scoped.

The remaining sequence is now:

1. **close permanent-progression content scope** — Bloodwell/Blood Mirror content volume, Relic mastery structure, boss-material gates, unlock cadence;
2. **define narrative delivery / campaign presentation**;
3. **define endgame / postgame / release scope**.

The actual standard-encounter roster, encounter counts, enemy wave/count tuning, and full-run clear-time validation are intentionally deferred until encounter production.

Exact final balance values, mastery thresholds, frame data, and final scripts remain later work under their owning authorities.

# Source links

- [Design pillars](DESIGN_PILLARS.md)
- [Full game scope](FULL_GAME_SCOPE.md)
- [Current design questions](../_meta/OPEN_QUESTIONS.md)
- [Combat](../gameplay/COMBAT.md)
- [Blood Aspects](../gameplay/BLOOD_ASPECTS.md)
- [Progression](../gameplay/PROGRESSION.md)
- [Items and rewards](../gameplay/ITEMS_AND_REWARDS.md)
- [Technique System](../gameplay/TECHNIQUES.md)
- [Relics](../gameplay/RELICS.md)
- [Run structure](../gameplay/RUN_STRUCTURE.md)
- [Returning Blood](../lore/RETURNING_BLOOD.md)
