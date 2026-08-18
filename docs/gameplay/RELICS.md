---
id: GAMEPLAY-RELICS
title: Relics
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - relics
  - run-builds
  - persistence
  - strand
  - forge
  - preparation
  - mastery
  - acquisition
  - swapping
related:
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROSTHETICS
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - CONTENT-STRAND-FORGE-BENCH
  - META-OPEN-QUESTIONS
---

# Relics

Relics are a small supporting system built around collectible objects that provide one simple run-wide benefit while equipped.

They should add personality, discovery, and light strategic choice without becoming another Technique family, Aspect progression path, Prosthetic upgrade layer, or large item-build system.

## Core structure

- Akio may equip **one Relic** at a time.
- Relic ownership is persistent once the Relic is unlocked or discovered.
- The currently equipped Relic's gameplay benefit is active during the run.
- Relics use a separate slot from Techniques and Prosthetics.
- Relics do **not** use Common / Rare / Legendary rarity tiers.
- Relic effects should usually be understandable in one concise sentence.
- Relics may not be freely swapped during active combat or from the pause menu.

## Launch acquisition model

All **10 launch Relics are obtainable before the canonical story ending**. The launch collection is split across dependable campaign progress and less predictable run discovery:

- **4 guaranteed campaign / Strand unlocks** through NPC progression, discoveries, or campaign milestones,
- **2 Blood Cavern / challenge unlocks** tied to authored challenge milestones,
- **4 run-discovered Relics** surfaced through approved Relic opportunities such as Treasure, Keeper/Twin Maws Boss Reward Flex cards, and the occasional Shop Flex slot.

Until all 10 Relics are collected, eligible discovery opportunities prioritize **undiscovered Relics** rather than duplicate discoveries. Relics do not gain a duplicate-copy upgrade system, rarity ladder, or separate acquisition currency.

Working campaign sequencing distributes the four guaranteed Relics across early-to-mid progression rather than awarding them together: one may arrive soon after the first return, one around Keeper progression, one around Twin Maws progression, and one by the first Binding clear. The two challenge Relics should likewise use one earlier and one more advanced authored milestone. Exact Relic identities within these slots remain content sequencing.

When Akio discovers a Relic during a run:

1. the Relic is **immediately added permanently to the collection**,
2. the player may **Equip Now** or **Keep Current Relic**,
3. declining to equip the new Relic does not forfeit the discovery.

## In-run swap rules

Approved swap moments are:

- at the **Forge Bench before starting a run**,
- in the safe regional transition **after Keeper of the Gate**,
- in the safe regional transition **after Twin Maws**,
- immediately when a new Relic is discovered.

Do **not** provide routine Relic swapping at Rest rooms, Shops, ordinary reward rooms, during combat, or through the pause menu.

## Mastery and permanent progression

Relic progression is earned primarily through combat use rather than simply for winning a run.

Each launch Relic has exactly three persistent states:

1. **Base** — effect available immediately when the Relic is acquired.
2. **Mastery I** — first permanent improvement to the same effect.
3. **Mastery II / Complete** — second and final permanent improvement to the same effect.

This creates **2 mastery milestones per Relic / 20 mastery milestones across the 10-Relic launch roster**.

Mastery rules:

- each Relic owns persistent individual mastery progress,
- **only the currently equipped Relic gains mastery**,
- eligible enemy kills earned while that Relic is equipped advance its mastery,
- switching Relics during a run redirects subsequent eligible kill progress to the newly equipped Relic,
- progress already earned on another Relic is permanent,
- Mastery I and II strengthen the Relic's existing benefit rather than adding unrelated mechanics, branching trees, or active abilities,
- normal mastery ranks do **not** cost Mist, Scrolls, regional boss materials, duplicate Relics, or a separate mastery currency,
- exact kill thresholds and numerical improvements remain playtest tuning.

The **Forge Bench** owns Relic collection management, mastery display, permanent progression presentation, and pre-run equipment management alongside Prosthetics.

No separate Relic Reliquary is required.

## Mastery effect rule

Simple numeric Relics become better versions of the same effect: more starting Gold, more maximum Health/Spirit, stronger recovery, or a stronger clean-play payout.

For Relics whose effect is not naturally a single number, mastery may improve the frequency, scope, or reliability of the **same core effect**. It may not introduce an unrelated second passive merely to create a rank.

## System boundaries

Relics support the build rather than define its combat foundation.

They should generally avoid directly upgrading Technique-family mechanics such as Echo, Rupture, Seal, Rift, or Vulnerable; changing an Aspect's authored moveset or Tier rules; or acting as Prosthetic-specific upgrades.

Relics may instead support broad resources, economy, survivability, clean-play rewards, Technique choice consistency, Blood usage, and other simple run-wide advantages.

## Strand management direction

At the Strand, the **Forge Bench** is the approved home for:

- viewing the persistent Relic collection,
- reviewing Base / Mastery I / Mastery II state and progress,
- managing the equipped Relic for run preparation.

The Boat remains focused on quick final run-start confirmation rather than becoming another upgrade interface.

## Approved launch roster

The current launch roster is **10 Relics** at qualitative paper-design depth.

| Relic | Approved effect | Primary role |
|---|---|---|
| **Traveler's Coin** | Begin each run with additional Gold. Exact amount remains later tuning. | Economy |
| **Merchant's Seal** | The first purchase in each region costs **20% less Gold** in the current economy prototype. | Economy |
| **Iron Prayer Bead** | Increase Akio's maximum Health. | Survival |
| **Spirit Tassel** | Increase Akio's maximum Spirit capacity. | Prosthetic-resource support |
| **Execution Bead** | Deathblows restore a small amount of Spirit. | Combat sustain |
| **Wayfarer's Charm** | Entering a room restores a small amount of Health. | Steady recovery |
| **Last Oath** | Once per run, lethal damage instead leaves Akio at **25 HP**. | Emergency survival |
| **Unbroken Cord** | Clearing a combat room without taking Health damage grants bonus Gold. | Clean-play reward |
| **Scribe's Lens** | The first Technique reward in each region presents one additional choice. | Build consistency |
| **Blood Moon Shard** | Using a Blood Art restores a small amount of Spirit. | Blood / Spirit interaction |

### Merchant's Seal prototype rule

The 20% discount applies to the **first item actually purchased in each region**. It does not reduce all prices for the region and does not carry an unused regional discount into a later region.

Examples under the current Shop prototype:

- 100-Gold Technique reward → **80 Gold**,
- 140-Gold Relic opportunity → **112 Gold**,
- 65-Gold max-Health purchase → **52 Gold**.

This value is a prototype economy target and may be tuned after Shop behavior is playable.

## Roster guardrails

- A Relic does not need to be equally transformative to every other Relic.
- Simple reliability options such as maximum Health are valid alongside more conditional effects.
- No Relic is labeled higher rarity merely because its effect is more unusual.
- Effects should remain broadly usable across Wolf, Wraith, and Ronin.
- Relics should not require a specific Technique family or exact multi-system combination to function.
- Relics should not invalidate encounter mechanics, remove core combat risk, or replace player execution.
- Numerical balance should ensure no Relic becomes an automatic choice for every run.
- Mastery should reward using a Relic rather than create a reason to perform disruptive combat-time swapping.

## Production boundary

The 10 approved Relics, 4 / 2 / 4 acquisition structure, and Base → Mastery I → Mastery II progression may guide icon, object, discovery, Forge collection/mastery display, run-reward, and transition-swap interface planning.

Do not create Relic rarity-badge families, duplicate-copy upgrades, branching mastery trees, or mastery currency. Exact object designs, exact Relic-to-source assignment, numerical mastery values, kill thresholds, mastery-state art treatment, and final Forge presentation remain later production/tuning decisions.
