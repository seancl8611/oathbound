---
id: GAMEPLAY-RELICS
title: Relics
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-16
topics:
  - relics
  - run-builds
  - persistence
  - strand
  - forge
  - preparation
  - mastery
related:
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROSTHETICS
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
- Relics may be switched during a run through approved transition opportunities rather than freely during active combat.
- Exact acquisition sources, mastery thresholds, transition-swap timing, and most numerical values remain later content / implementation work.

## Mastery and permanent progression

Relic progression is earned primarily through combat use rather than simply for winning a run.

- Each Relic owns persistent individual mastery progress.
- **Only the currently equipped Relic gains mastery.**
- Eligible enemy kills earned while that Relic is equipped advance its mastery.
- Switching Relics during a run redirects subsequent eligible kill progress to the newly equipped Relic.
- Progress already earned on another Relic is permanent and is not lost when the player switches.
- Mastery should strengthen the Relic's existing benefit rather than add unrelated mechanics, branching trees, or a second active ability.

The **Forge Bench** is the Strand station that owns Relic collection management, permanent progression, and upgrade presentation alongside Prosthetics.

Sharing the Forge does **not** mean Relics must use Scrolls or the same linear path structure as Prosthetics. Relic mastery remains a distinct progression source. Exact mastery rank count, thresholds, Forge interaction flow, costs if any, and numerical improvement per rank remain later tuning and implementation work.

No separate Relic Reliquary is required in the approved Strand upgrade-station scope.

## System boundaries

Relics support the build rather than define its combat foundation.

They should generally avoid directly upgrading Technique-family mechanics such as Echo, Rupture, Seal, Rift, or Vulnerable; changing an Aspect's authored moveset or Tier rules; or acting as Prosthetic-specific upgrades.

Relics may instead support broad resources, economy, survivability, clean-play rewards, Technique choice consistency, Blood usage, and other simple run-wide advantages.

## Strand management direction

At the Strand, the **Forge Bench** is the approved home for:

- viewing the persistent Relic collection,
- reviewing mastery / permanent progression,
- managing the equipped Relic for run preparation,
- and presenting later approved Relic upgrade states.

The Boat remains focused on quick final run-start confirmation rather than becoming another upgrade interface.

In-run Relic switching may still use approved transition opportunities. Exact transition locations and presentation remain later integration work and do not require a second permanent hub station.

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

The 10 approved Relics may guide icon, object, Forge collection/mastery display, and basic selection-interface planning.

Do not create Relic rarity-badge families. Exact object designs, acquisition scenes, mastery-state art, numerical values beyond explicitly approved prototypes, kill thresholds, Forge upgrade presentation, and transition-swap presentation remain later production decisions.