---
id: OVERVIEW-GAME
title: Oathbound Game Overview
category: overview
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - project-identity
  - combat
  - returning-blood
  - techniques
  - relics
  - blood-aspects
  - progression
  - narrative-delivery
  - silent-protagonist
  - first-attempt
  - authored-encounters
  - enemy-lineage
  - heart-bindings
  - postgame
related:
  - OVERVIEW-DESIGN-PILLARS
  - OVERVIEW-FULL-SCOPE
  - OVERVIEW-ENDGAME-POSTGAME-RELEASE
  - GAMEPLAY-COMBAT
  - GAMEPLAY-FIRST-ATTEMPT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-ITEMS-REWARDS
  - LORE-RETURNING-BLOOD
  - NARRATIVE-DELIVERY
---

# Oathbound Game Overview

Oathbound is a high-angle 2D action roguelite built around disciplined katana combat, posture pressure, precise parries, stagger, deathblows, previewed branching routes, and run-based build progression.

The game should feel disciplined, dangerous, elegant, and cursed. Combat readability and player execution take priority over spectacle or automatic build power.

# Premise

Akio is a silent warrior of the Order sent through a containment barrier onto a cursed Japanese-gothic island whose kingdom once used Beast Blood from the Heart to survive a plague.

Akio unknowingly descends from the royal bloodline that escaped containment. He begins without active Returning Blood powers; his first death during the Blood Moon awakens inherited **Returning Blood** and reconstructs him at the Strand.

His lineage explains why the power awakens. His discipline and inherited expression explain why he can preserve agency and direct it differently from other Beast Blood users.

# Core player fantasy

Akio remains a swordsman first. Blood Aspects reshape the weapon kit, Techniques customize core sword actions and supporting synergies, Prosthetics provide one equipped tactical tool, and Relics provide one smaller run-wide support effect.

The build should strengthen decisions the player already makes—timing, spacing, posture pressure, parries, movement, deathblows, targeting, and resource use—rather than replace combat fundamentals.

Akio never speaks, supplies dialogue choices, or uses internal monologue. NPCs, intelligent enemies, and bosses carry spoken/written dialogue; Akio is characterized through action, stillness, physical reaction, and refusal.

# First attempt

The first attempt is a **real normal run**, not a scripted prologue route.

- Player control begins directly in the normal Hushiro route.
- The complete 12 / 10 / 11 regional route remains reachable.
- Akio uses the base katana kit and starts with **Beast-Bane Whistle** as the default equipped Prosthetic.
- Blood Aspects, Corruption/Tier progression, Blood, Blood Arts, Relic loadout, and permanent upgrades are not yet active.
- Technique rewards are available and modify the base katana's normal five action tags.
- Rest, Shop, Treasure, miniboss, Gold, Mist/Scroll rewards, routing, and other normal room flow remain active where meaningful.
- Shrines remain usable for their below-full support result, but Embrace/Tier advancement is unavailable before Returning Blood awakens.
- The first death may happen anywhere the player's actual skill allows.

A mastery-level player may theoretically clear all three regions and defeat the Shogun before dying. Such a player may reach the Heart, but cannot break a Binding without awakened Returning Blood; Heart contact causes the first death/awakening and the normal six-Binding campaign begins afterward.

# Current gameplay shape

- Returning Blood awakens after the first death and begins the repeated-run progression loop.
- Shared combat includes parry, Health/posture, block, dash, stagger, deathblow, genuine rear-hit/backstab classification, and Prosthetic support.
- Launch Blood Aspects: **Wolf, Wraith, Ronin**.
- Every post-awakening normal run begins at Aspect Tier 0; optional Shrine Resist/Embrace progression reaches Tier IV maximum.
- Blood/Blood Art becomes available only from Tier II onward.
- Five direct Technique slots: **Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow**.
- Technique roster: **50 actual Techniques + 10 refinements** across Echo, Rupture, Seal, Rift, and Crimson Vulnerable/backstab/direct-Health identities.
- Supporting / Cross-family / Legendary Techniques are slotless; no global Technique inventory cap exists.
- One equipped Prosthetic from an eight-tool roster with 19 permanent Forge upgrades.
- One equipped Relic from a 10-item persistent collection with **Base → Mastery I → Mastery II** use-based progression.
- Relic acquisition uses 4 campaign/Strand + 2 Blood Cavern/challenge + 4 run-discovered unlocks, with limited regional-transition swapping.
- No general launch consumable inventory or one-use item reward layer.

# Permanent progression shape

Permanent progression is intentionally compact and supports execution rather than replacing it.

- **Bloodwell:** 10 Akio nodes + 8 Run Infrastructure nodes.
- **Forge Bench:** 19 Prosthetic upgrades + 20 Relic mastery milestones across 10 Relics.
- **Blood Mirror:** 3 nodes per Aspect / 9 total, focused on Tier 0 Handling, Signature Reliability, and Blood Discipline.
- **Boss materials:** exactly six Bloodwell gates at launch—one Akio mastery node and one regional-passage Infrastructure node per regional boss material.

Unlock cadence:

- first return → Bloodwell foundation,
- first Keeper → second Bloodwell band + Blood Mirror Node 1,
- first Twin Maws → third band + Blood Mirror Node 2,
- first Shogun / first Binding clear → final boss-material gates + Blood Mirror Node 3.

All foundational permanent progression systems are structurally available after the first Binding clear; later Binding clears emphasize completion, mastery, Relic collection, Prosthetic development, trials, and player consistency rather than introducing another meta tree.

# Persistent progression economy

Oathbound keeps the permanent resource model deliberately small:

- **Mist** — broad persistent meta progression,
- **Scrolls** — primarily Prosthetic Forge progression,
- **three regional boss materials** — one unique low-count material from Keeper, Twin Maws, and Eclipse Shogun, used on the six approved Bloodwell mastery gates,
- **Gold** — run-only Shop economy.

There is no generic Boss Emblem currency.

Boss materials are earned every time their boss is defeated and are saved immediately. They are mastery keys rather than a monster-part crafting economy.

# Run structure

The approved first regional prototype contains **33 counted chambers**:

- **Hushiro Gate Village:** 12 chambers, Keeper of the Gate at 12, ~14–16 active minutes.
- **Yomori Grove:** 10 chambers, Twin Maws at 10, ~12–14 minutes.
- **Kagutsuchi Court:** 11 chambers, Eclipse Shogun at 11, ~15–17 minutes.

Each region offers one optional miniboss opportunity from two authored candidates. Branches preview room/reward information, normally offer one or two exits, and may reconverge without routine backtracking.

Standard Combat rooms use **deliberately authored encounter scripts**. When a Combat chamber is selected, the game chooses an eligible encounter from that region's authored pool rather than procedurally constructing an enemy mix from a threat budget. Opening/main/final route bands do not require separate encounter pools; individual encounters may later receive minimum-chamber eligibility where their mechanics or teaching role require it.

Standard enemies are region-native by default. Cross-region continuation uses a separately authored evolved regional variant rather than carrying the unchanged enemy forward or simply increasing its statistics. The only approved launch lineage is **Blighted Hounds → Stalker Hound** in Yomori Grove; Kagutsuchi's five standard enemies are all native Court units.

The controlled-generation, Technique-offer, Gold/Shop, survival/capacity, boss-reward, Relic-acquisition, persistent-resource payout, permanent-progression content-volume, first-attempt, narrative-delivery, and postgame/release models are approved as prototype/paper-design targets. Exact values remain playtest-tunable.

A normal successful Binding run targets approximately **45–50 minutes of active time**. Heart/Suppression routes target approximately **55–60 minutes**. Encounter-pool counts and individual encounter scripts remain later content-production/playtest work.

# Campaign structure

The Heart was imprisoned by seven ancient Bindings. The Court destroyed the outermost before the game, leaving six intact.

After Returning Blood awakens, each of the first six successful Binding runs has Akio defeat the Eclipse Shogun, reach the Heart, use Returning Blood through the Court's extraction apparatus, break one remaining Binding, be dissolved by the Heart, and reconstruct at the Strand.

The same ritual uses six escalating visual/campaign states rather than six different mechanisms or missions.

The Shogun relationship uses seven awakened confrontation states: dismissal → fascination → bloodline recognition/recruitment → possessive anger → fear → hatred/desperation → final confrontation. Akio remains silent throughout.

After all six remaining Bindings are destroyed, the seventh successful story run continues directly from the Shogun into the two-form true-final Heart encounter with the same active build.

The first Heart victory **does not erase existing Beast Blood**. Akio destroys the Heart's manifested body and permanently removes its ability to produce, release, or spread new Beast Blood. The Heart survives as a faint regenerating remnant. Existing bearers—including Akio and the Shogun—retain their established Blood and reconstruction.

The main story ends because the curse can no longer expand to anyone new or threaten the mainland through propagation.

# Canonical postgame

After Story Complete, Akio canonically continues containment work on the island.

The Boat offers:

- **Standard Expedition** — ends after the Shogun,
- **Heart Suppression** — continues from the Shogun into the Heart's regenerated manifestation.

Postgame uses existing progression/mastery systems rather than adding another currency/tree. Completion supports full permanent progression, Relic/Prosthetic mastery, Technique/refinement discovery, trials, Discovery Board collection, and Heart victory with all three Aspects.

Launch does not require Heat/Pact-style modifiers, New Game+, endless mode, daily challenges, a fourth Aspect, or another postgame progression layer.

# Narrative production shape

The launch narrative package is intentionally bounded:

- silent Akio with zero dialogue/choice/internal-monologue content,
- approximately **5 major controlled in-engine sequences**,
- **7 awakened Shogun dialogue states + 1 rare pre-awakening fallback**,
- **6 visual states** of one reusable Binding ritual,
- approximately **30–36 major Strand conversations**,
- approximately **4–6 short reactive line sets per Strand NPC**,
- approximately **20–25 substantive Lore / Records entries** beyond normal gameplay-codex descriptions,
- one final pre-Heart conversation/state for each Strand NPC,
- one concise post-ending Heart-regrowth/suppression explanation,
- text-led dialogue with **no full spoken-dialogue VO requirement**,
- approximately **15,000–20,000 narrative words** as a working writing target.

Mandatory campaign information is communicated directly; the Discovery Board carries optional historical depth rather than required plot comprehension.

# World structure

- **The Strand** — persistent hub, preparation, progression, and return point.
- **Hushiro Gate Village / Rupture** — recent human/community collapse.
- **Yomori Grove / Adaptation** — long-term predator/spirit consequences; includes Stalker Hound as an evolved continuation of the earlier hound lineage.
- **Kagutsuchi Court / False Ascendancy** — disciplined elite mutation mistaken for mastery; uses its own five-enemy Court roster.
- **Heart spaces** — specialized post-Shogun campaign/endgame content outside the 33 counted regional chambers.

# Current design focus

Oathbound's **top-level launch architecture is closed at paper-design depth**.

The next work is content realization and playable validation:

1. author the regional standard-encounter pools,
2. define playable miniboss and boss encounter packages,
3. define the two-form Heart moveset/arena package,
4. realize exact narrative/achievement/trial content,
5. tune numbers and validate clear-time/economy/combat targets.

Exact final balance values, mastery thresholds, frame data, detailed scripts, and final localization/audio implementation remain later work under their owning authorities.

# Source links

- [Design pillars](DESIGN_PILLARS.md)
- [Full game scope](FULL_GAME_SCOPE.md)
- [Endgame, postgame, and release](ENDGAME_POSTGAME_RELEASE.md)
- [Current design questions](../_meta/OPEN_QUESTIONS.md)
- [First attempt](../gameplay/FIRST_ATTEMPT.md)
- [Combat](../gameplay/COMBAT.md)
- [Blood Aspects](../gameplay/BLOOD_ASPECTS.md)
- [Progression](../gameplay/PROGRESSION.md)
- [Items and rewards](../gameplay/ITEMS_AND_REWARDS.md)
- [Technique System](../gameplay/TECHNIQUES.md)
- [Relics](../gameplay/RELICS.md)
- [Run structure](../gameplay/RUN_STRUCTURE.md)
- [Returning Blood](../lore/RETURNING_BLOOD.md)
- [Narrative delivery](../narrative/NARRATIVE_DELIVERY.md)
