---
id: CONTENT-STRAND-BLOOD-CAVERN
title: Blood Cavern and Blood Mirror
category: content
status: approved
authority: primary
last_reviewed: 2026-08-24
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

## Current first-playtest runtime slice

The current implementation intentionally establishes the reusable Cavern boundary before full authored trial volume:

- the Training Hall provides a passive target built on the current Hushiro humanoid combat stack with AI, enemy damage, XP, Gold/drop rewards, and normal enemy-death side effects disabled;
- each live training target identifies its current use in-world. Passive practice and Technique demos are labeled by mode, while the Execution Trial target explicitly communicates **Break Posture → Execute** so the active objective remains visible after the menu closes;
- training-target resets restore Health/Posture and also clear shared Hushiro posture-break timing, deathblow readiness, and any executable target forwarded to Akio. A target can therefore be defeated, reset, posture-broken, and executed repeatedly without stale execution state carrying between attempts;
- the seven approved tutorial refresher topics are available from the Cavern and resolve current keyboard/controller bindings rather than hard-coding stale controls;
- discovered **Action Techniques** can be demonstrated on the passive target by temporarily replacing the active run Technique list; the exact prior list is restored when training ends, the Cavern exits, or the player enters the Blood Mirror;
- **Execution Trial** is the first implemented Basic Combat Trial. It completes only when the target receives a real production deathblow after the player creates the execution opening; an ordinary Health defeat only resets the target and cannot complete the trial;
- successful Execution Trial clears produce immediate non-pausing completion feedback. A first clear names the Relic unlocked by the current prototype mapping; repeat clears explicitly report a practice clear and grant no duplicate Relic;
- the current progression prototype routes the first `execution_trial` clear through the existing challenge-Relic allocation and makes repeat clears practice-only. That specific Relic sequencing remains first-playtest implementation data rather than a new paper-design lock;
- entering the Blood Mirror always terminates active target/demo/trial state before permanent progression UI opens.

This slice does **not** define the final number of trials, final fixed challenge loadouts, full Aspect-trial scripting, final mastery rewards, or final challenge-to-Relic sequencing.

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
- Reusable training targets reset both visible combat meters and shared posture-break/deathblow runtime state between attempts.
- Active training/trial mode and the immediate objective remain readable after the Cavern menu closes.
- Temporary trial Techniques clear after the trial.
- Trial completion/reward/unlock/mastery flags persist.
- First-clear and repeat-clear feedback clearly distinguish permanent unlocks from practice-only clears.
- Blood Mirror locked/unlocked campaign state persists and keys to first Keeper defeat.
- Progression UI supports exactly three staged permanent nodes per Aspect without hard-coding final balance values.
- Blood Mirror functions remain distinct from Boat confirmation, Shrine Tier progression, run Technique rewards, Bloodwell Akio/Run Infrastructure progression, and Forge Prosthetic/Relic progression.
