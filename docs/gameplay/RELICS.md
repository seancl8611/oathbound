---
id: GAMEPLAY-RELICS
title: Relics
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-15
topics:
  - relics
  - run-builds
  - persistence
  - strand
  - preparation
  - mastery
related:
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROSTHETICS
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
- Exact acquisition sources, mastery thresholds, transition-swap timing, and numerical values remain later content / implementation work.

## Mastery progression

Relic progression is earned through combat use rather than purchased at the Forge or granted simply for winning a run.

- Each Relic owns persistent individual mastery progress.
- **Only the currently equipped Relic gains mastery.**
- Eligible enemy kills earned while that Relic is equipped advance its mastery.
- Switching Relics during a run redirects subsequent eligible kill progress to the newly equipped Relic.
- Progress already earned on another Relic is permanent and is not lost when the player switches.
- Relic mastery is **not** purchased with Scrolls, Mist, Boss Emblems, Gold, or another Forge currency.
- Relics are **not upgraded at the Forge Bench**.
- Exact kill requirements, enemy weighting, rank count, rank thresholds, mastery presentation, and numerical improvement per rank remain later tuning and implementation work.

Relic mastery should strengthen the Relic's existing benefit rather than add unrelated mechanics, branching trees, or a second active ability.

## System boundaries

Relics support the build rather than define its combat foundation.

They should generally avoid directly upgrading Technique-family mechanics such as Echo, Rupture, Seal, Rift, or Vulnerable; changing an Aspect's authored moveset or Tier rules; or acting as Prosthetic-specific Forge upgrades.

Relics may instead support broad resources, economy, survivability, clean-play rewards, Technique choice consistency, Blood usage, and other simple run-wide advantages.

## Strand selection direction

Relics are selected through a dedicated physical **Relic Reliquary** or equivalent small Strand interactible.

The Boat remains focused on a simple run-start confirmation and does not become a general loadout screen.

The broader Strand direction uses separate physical preparation interactibles for Aspect, Prosthetic, and Relic selection rather than combining all run setup into one large menu.

The Reliquary or another approved transition presentation may also support Relic switching opportunities during a run when the run structure provides them. Exact locations remain later integration work.

## Approved launch roster

The current launch roster is **10 Relics** at qualitative paper-design depth.

| Relic | Approved qualitative effect | Primary role |
|---|---|---|
| **Traveler's Coin** | Begin each run with additional Gold. | Economy |
| **Merchant's Seal** | The first purchase in each region costs less Gold. | Economy |
| **Iron Prayer Bead** | Increase Akio's maximum Health. | Survival |
| **Spirit Tassel** | Increase Akio's maximum Spirit capacity. | Prosthetic-resource support |
| **Execution Bead** | Deathblows restore a small amount of Spirit. | Combat sustain |
| **Wayfarer's Charm** | Entering a room restores a small amount of Health. | Steady recovery |
| **Last Oath** | Once per run, lethal damage instead leaves Akio at **25 HP**. | Emergency survival |
| **Unbroken Cord** | Clearing a combat room without taking Health damage grants bonus Gold. | Clean-play reward |
| **Scribe's Lens** | The first Technique reward in each region presents one additional choice. | Build consistency |
| **Blood Moon Shard** | Using a Blood Art restores a small amount of Spirit. | Blood / Spirit interaction |

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

The 10 approved Relics may guide icon, object, Reliquary, mastery-display, and basic selection-interface planning.

Do not create Relic rarity-badge families. Exact object designs, acquisition scenes, mastery-state art, numerical values, kill thresholds, and transition-swap presentation remain later production decisions.
