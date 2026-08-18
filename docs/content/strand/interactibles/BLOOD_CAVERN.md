---
id: CONTENT-STRAND-BLOOD-CAVERN
title: Blood Cavern and Blood Mirror
category: content
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - strand
  - blood-cavern
  - blood-mirror
  - training
  - aspect-trials
  - technique-trials
  - aspect-progression
related:
  - CONTENT-STRAND-INTERACTIBLES
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-ITEMS-REWARDS
  - UI-BLOOD-MIRROR-TRIALS
  - CHAR-STRAND-UNDEAD-SAMURAI
---

# Blood Cavern and Blood Mirror

## Strand function

The Blood Cavern is the Strand's training, tutorial-refresh, combat-trial, Aspect-trial, Technique-demonstration, mastery, and build-testing space. The deeper **Blood Mirror** owns permanent Blood Aspect progression after the player's **first Keeper defeat**.

The outer training space may function before the Blood Mirror becomes available.

## Lore / spatial role

The cavern is an Order training and anti-corruption site. The outer hall is practical and scarred; the inner Mirror chamber is older, quieter, reflective, and unsettling.

The Blood Mirror has a clear sealed state before the first Keeper defeat.

## Interaction fantasy

The player moves from learning execution to proving how much Beast Blood can be controlled. Trials may temporarily assign fixed Aspect/Technique/Prosthetic/Relic loadouts for teaching or mastery, but temporary trial loadouts never become the player's run build.

## System states

- **Training Hall:** fundamentals, refreshers, Technique demos, general mastery trials.
- **Blood Mirror — locked:** unavailable until first Keeper defeat.
- **Blood Mirror — unlocked:** Aspect progression, Aspect trials/previews, approved Technique-pool unlocks, mastery/completion rewards.

## Permanent Aspect progression boundary

Launch Blood Mirror scope is exactly **3 nodes per Aspect / 9 total**:

1. **Tier 0 Handling**
2. **Signature Reliability**
3. **Blood Discipline**

Campaign availability:

- Node 1 after first Keeper,
- Node 2 after first Twin Maws,
- Node 3 after first Shogun / first Binding clear.

Every normal run still begins at Tier 0. Blood Mirror permanent progression cannot:

- grant Tier mechanics early,
- unlock Blood before Tier II,
- replace Resist / Embrace decisions,
- remove an Aspect's core commitments/tradeoffs,
- create uncapped permanent versions of run Tier growth.

Regional boss materials are **not** used by normal Blood Mirror nodes at launch. The six approved boss-material permanent gates belong to the Bloodwell.

Exact individual Aspect-node effects, values, final Mist costs if any, and any trial-completion prerequisites remain later tuning under `PROGRESSION.md`.

## Environment / animation needs

- practical outer training ambience,
- still reflective inner water,
- restrained mineral/red resonance,
- sealed/dormant Mirror state,
- reusable trial-start / trial-complete states,
- clear locked / available / active / completed / mastered presentation.

## Technical requirements

- Repeatable trials support fixed standardized conditions/loadouts.
- Temporary trial Techniques clear after the trial.
- Trial completion/reward/unlock/mastery flags persist.
- Blood Mirror locked/unlocked campaign state persists and keys to first Keeper defeat.
- Progression UI supports exactly three staged permanent nodes per Aspect without hard-coding final balance values.
- Blood Mirror functions remain distinct from Boat confirmation, Shrine Tier progression, run Technique rewards, Bloodwell Akio/Run Infrastructure progression, and Forge Prosthetic/Relic progression.
