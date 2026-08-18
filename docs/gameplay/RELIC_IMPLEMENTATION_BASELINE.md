---
id: GAMEPLAY-RELIC-IMPLEMENTATION-BASELINE
title: Relic Implementation Baseline
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - relics
  - implementation
  - first-playtest
  - mastery
  - forge
related:
  - GAMEPLAY-RELICS
  - GAMEPLAY-COMBAT-IMPLEMENTATION-BASELINE
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-BLOOD-ASPECTS
  - META-OPEN-QUESTIONS
---

# Relic Implementation Baseline

This file owns the approved first-playtest numerical values and trigger/reset rules for the existing 10-Relic launch roster.

`RELICS.md` continues to own roster identity, acquisition, one-equipped-slot rules, swapping, and the Base → Mastery I → Mastery II progression structure. These values are prototype implementation targets and remain playtest-tunable without reopening Relic architecture.

# Shared mastery progression

Each Relic tracks its own persistent eligible-kill total while equipped.

- **Mastery I:** 75 cumulative eligible kills.
- **Mastery II / Complete:** 200 cumulative eligible kills.
- Only the currently equipped Relic gains progress.
- Switching Relics redirects future eligible kills without losing prior progress.
- Ordinary authored enemies, minibosses, and bosses may count when they award normal kill credit.
- Endlessly generated, repeated farmable, scripted non-combat, or explicitly `no_mastery` units do not count.
- Mastery ranks unlock automatically when the threshold is crossed and do not cost currency.

# First-playtest roster values

| Relic | Base | Mastery I | Mastery II |
|---|---|---|---|
| **Traveler's Coin** | Start run with **+50 Gold** | **+75 Gold** | **+100 Gold** |
| **Merchant's Seal** | First purchase each region **20% off** | **25% off** | **30% off** |
| **Iron Prayer Bead** | **+15% max Health** | **+20%** | **+25%** |
| **Spirit Tassel** | **+20% max Spirit** | **+25%** | **+30%** |
| **Execution Bead** | Deathblow restores **6 Spirit** | **8 Spirit** | **10 Spirit** |
| **Wayfarer's Charm** | New counted chamber restores **3% max Health** | **4%** | **5%** |
| **Last Oath** | Once/run lethal damage leaves **25 Health** | **35 Health** | **45 Health** |
| **Unbroken Cord** | Clean combat clear grants **+10 Gold** | **+15 Gold** | **+20 Gold** |
| **Scribe's Lens** | First **1** Technique reward/region has +1 choice | First **2** | First **3** |
| **Blood Moon Shard** | Blood Art restores **10 Spirit** | **15 Spirit** | **20 Spirit** |

# Per-Relic implementation rules

## Traveler's Coin

- Applies once during normal run initialization.
- Adds Gold after the normal 0-Gold baseline and before the player can spend Gold.
- Does not trigger again at regional transitions or after Relic swaps.

## Merchant's Seal

- Applies to the first item actually purchased in each region.
- One independent discount state exists for Hushiro, Yomori, and Kagutsuchi.
- An unused discount does not carry into a later region.
- The discount is consumed only by a completed purchase.
- Swapping away from and back to Merchant's Seal does not restore a region's consumed discount.

## Iron Prayer Bead

- Modifies run maximum Health from the normal starting maximum.
- At run start, current Health increases by the same absolute amount as the maximum increase.
- Later temporary-capacity effects stack through the ordinary capacity rules rather than multiplying the Relic again.

## Spirit Tassel

- Modifies run maximum Spirit from the normal starting maximum.
- At run start, current Spirit increases to the new maximum.
- Later temporary-capacity effects stack through ordinary capacity rules.

## Execution Bead

- Triggers once when a successful Deathblow execution completes.
- Associated Technique, AoE, or secondary effects do not create additional triggers.
- Spirit cannot exceed current maximum Spirit.

## Wayfarer's Charm

- Triggers once on first entry into each new counted chamber.
- Backtracking, re-entering the same chamber, transition staging, and non-counted utility spaces do not retrigger it.
- Healing cannot exceed current maximum Health.

## Last Oath

- May trigger once per run when ordinary combat damage would reduce Akio to 0 Health or below.
- Prevents that lethal result and sets current Health to the rank's listed value.
- The Relic is then consumed for the remainder of the run, even if Akio later swaps away and back.
- It does not trigger on scripted deaths, first-return campaign logic, Heart Binding dissolution, deliberate story-state transitions, or other explicitly non-combat death events.

## Unbroken Cord

A combat encounter is clean when Akio takes **no Health damage** from encounter start through successful room-clear resolution.

- Block-posture damage without Health loss does not invalidate the condition.
- Standard Combat, miniboss, and boss encounters may qualify.
- Award once per successfully completed qualifying encounter.
- Environmental or enemy Health damage during the active encounter invalidates the clear.

## Scribe's Lens

- Affected Technique reward screens present **4 choices instead of 3**.
- Counts affected Technique rewards separately in each region.
- Reward source does not matter if it uses the normal Technique reward screen.
- A reroll of an affected screen remains a 4-choice screen.
- The extra card uses the same eligibility/source-quality rules as the rest of the screen.
- Swapping Relics does not reset the number of Lens-affected rewards already consumed in a region.

## Blood Moon Shard

- Triggers once after a committed Blood Art activation successfully spends the full Blood meter.
- Restores the rank's listed Spirit amount.
- Does not trigger per enemy hit, Blood Art stage, delayed effect, or secondary geometry.
- Cannot exceed current maximum Spirit.
- Blood Arts remain unavailable before Tier II under the Blood Aspect authority, so this Relic may have no combat effect in Tier 0-I runs.

# Balance shape

The first-playtest roster intentionally splits across broad support roles:

- **Economy:** Traveler's Coin, Merchant's Seal, Unbroken Cord.
- **Survival:** Iron Prayer Bead, Wayfarer's Charm, Last Oath.
- **Spirit economy:** Spirit Tassel, Execution Bead, Blood Moon Shard.
- **Build consistency:** Scribe's Lens.

No Relic should become a second build system, Technique-family modifier, alternate Aspect progression path, or Prosthetic-specific upgrade layer.

# Planning exit condition

The Relic package is complete for planning at first-playtest depth.

All 10 Relics now have Base / Mastery I / Mastery II values, implementation triggers, persistent mastery thresholds, and reset/exclusivity behavior sufficient for Godot implementation.

Final percentages, mastery pacing, Gold values, recovery values, and reward-frequency strength remain playtest-tunable rather than reasons to create another Relic planning pass.
