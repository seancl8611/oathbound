---
id: GAMEPLAY-BLOOD-CAVERN-TRIALS
title: Blood Cavern Trial System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-25
topics:
  - trials
  - training
  - blood-aspects
  - techniques
  - blood-mirror
  - mastery
  - relics
related:
  - CONTENT-STRAND-BLOOD-CAVERN
  - GAMEPLAY-COMBAT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-PROGRESSION
---

# Blood Cavern Trial System

## Purpose

Provide repeatable, skill-focused Strand activities that teach approved combat systems, demonstrate selected Technique interactions, and reward mastery without depending on run RNG.

The framework and three-Aspect launch roster are approved. Exact trial counts, scripts, most rewards, and production volume remain later content and implementation work rather than full-game scope blockers. The Relic system reserves **2 of the 10 launch Relics** for authored Blood Cavern / challenge unlock milestones; exact Relic identities and exact challenge assignments remain later content sequencing.

The Blood Cavern is a training / trial space, not a separate general permanent-upgrade station. Permanent Aspect progression belongs to the Blood Mirror inside the Cavern after the Mirror is unlocked following the first Keeper defeat.

## Current first-playtest runtime slice

The current runtime implements the reusable boundary and one real Basic Combat Trial without treating its temporary sequencing choices as final authored volume:

- baseline training uses a passive target backed by current production humanoid hurt, posture, posture-break, and deathblow plumbing while disabling AI, enemy damage, XP, Gold/drop rewards, and normal enemy-death side effects;
- each spawned target communicates its current mode in-world. The first Basic Combat Trial keeps **Execution Trial — Break Posture → Execute** visible while combat is active rather than relying on the closed menu for the objective;
- target reset is a full reusable combat-state boundary: Health/Posture return to baseline, the shared Hushiro posture-break/readability state is cleared, deathblow readiness is removed, and Akio cannot retain the reset target as a stale executable target;
- the seven approved tutorial refresher topics are surfaced from the Cavern with live keyboard/controller binding labels;
- discovered **Action Techniques** are currently the safe standalone Technique-demo subset. A demo temporarily isolates that single Technique in the current run's unlimited Technique collection, then restores the exact prior collection at End Training, Blood Mirror entry, or Cavern teardown. This is temporary sandbox state, not a Technique equipment slot;
- `execution_trial` is the first implemented Basic Combat Trial. Its objective is intentionally minimal and deterministic: create the normal execution opening and land the real deathblow. Health-only defeat resets the target and does not satisfy the trial;
- first-clear persistence routes through the existing Blood Cavern challenge-completion API. The current first-playtest data mapping assigns that challenge to the current Execution Bead slot; repeat clears grant no duplicate Relic or normal run currency;
- trial completion produces immediate non-pausing feedback. First-clear feedback identifies the unlocked Relic from the current prototype mapping, while repeat-clear feedback explicitly identifies the result as practice-only;
- the current challenge-to-Relic identity mapping is **implementation sequencing**, not a replacement for this document's authority that final challenge identities/assignments remain later content work;
- entering the Blood Mirror terminates any active target, Technique demo, or trial before permanent progression UI opens.

Not yet authored by this runtime slice: final trial count, final fixed Aspect/Technique/Prosthetic/Relic challenge loadouts, full Aspect trial scripting, full mastery presentation/rewards, and final sequencing for both challenge-Relic milestones.

For release-completion accounting, only **player-accessible authored trials** count toward required trial completion. A reserved challenge ID or Relic mapping does not become a 100% requirement until a playable trial path exists for it. The currently reserved second challenge milestone therefore remains future authored content rather than an inaccessible completion blocker.

## Trial families

### Basic Combat Trials

Teach or refresh block, timed parry, player/enemy posture, posture break, deathblow, dodge, perilous responses, introductory Parry Counter / Dash Attack use, and Prosthetic activation.

### Wolf Trials

Tier 0 lessons:

- short-range pressure and sequence choice,
- player-directed pursuit through Raking Fang, Hunting Slash, and Predator's Passage,
- choosing when Blood Cleave is safe,
- avoiding overcommitment after misses.

Tier lessons:

- **Blood Tempo:** recognize valid-contact continuation windows.
- **Feral Momentum:** recognize increasing payoff on later connected Basic positions.
- **Blood Hunt/Blood Fang:** use activation healing/disruption, choose a pursuit line, understand pass-through/stopping rules, and respect ending recovery.
- **Fanged Guard:** use one frontal block while respecting normal posture-break rules.
- **Apex Mauling:** trigger the contact-gated mauling and understand compact secondary coverage and movement-only slow.

### Wraith Trials

Tier 0 lessons:

- Veil Cut for short precise openings,
- Passing Arc for broader frontal commitment,
- Pale Lance for confirmed focused punishes,
- Ghostline Slash for controlled re-entry,
- Veil Reversal for posture-focused parry conversion,
- maintaining useful spacing without tracking or teleportation.

Tier lessons:

- **Pale Barrage:** choose between single thrust, partial continuation, and full stationary commitment.
- **Spectral Edge:** distinguish physical contact from eligible spectral-only contact and its Tier-scaled posture/guard payoff.
- **Wraith's Reach:** use the opening sweep, select one valuable corridor, and predict the delayed same-geometry echo.
- **Spectral Passage:** align layered ordinary enemies and learn stopping rules against elites, bosses, protected heavies, and geometry.
- **Beyond the Veil:** use longer Pale Lance/Ghostline geometry, Tier IV Spectral Edge eligibility, valid clear-path extended deathblows, and brief Veilstride movement after a killing deathblow.

### Ronin Trials

Tier 0 lessons:

- choose Severing Cut, Crushing Cross, or Bloodfall according to opening size,
- use Stillness Draw for prepared single-target punishment,
- use Breaching Slash for faster lower-power re-entry,
- use Answering Steel after a universal parry,
- understand strongest-guard stability, accumulated posture, and slow posture recovery,
- respect fixed attack lines and severe miss recovery.

Tier lessons:

- **Posture-capacity growth:** recognize that each Embrace allows Ronin to absorb more posture before breaking while recovery speed remains unchanged.
- **Steadfast Reprisal:** block, read whether pressure has ended, then decide whether Reprisal Cut is safe.
- **Falling Mountain:** use partial posture relief, aim the planted slam, and understand the delayed fixed-point Deep Rupture.
- **Unbroken Resolve:** distinguish the costly one-hit commitment-preservation route from clean Measured Weight → Perfect Weight execution.
- **Shattering Wake:** line enemies behind a directly struck or guarding primary target and understand that the wake cannot double-hit the primary target.

Ronin trials must not teach tracking, required combo completion, generic armor, or a persistent Focus state.

## Fixed Tier and Blood demonstrations

All three Aspect packages may be used for high-level Tier 0-IV trial planning.

Trials may teach:

- Tier headline benefits and supporting growth rules,
- inherent movement, direction, commitment, recovery, collision, and defensive limitations,
- Resist, Embrace, and Stabilize decisions,
- Blood unavailability before Tier II,
- Blood generation/readiness,
- Blood Art activation value and failure states,
- interaction between fixed Aspect progression and temporary Techniques.

A trial preview does not grant persistent run Tier or Blood state.

## Technique demonstrations

Selected trials may use fixed approved Techniques to teach:

- how a direct Technique modifies or responds to one of the five major combat-action **trigger classifications** (Basic Attack, Held Attack, Dash / Dash Attack, Parry / Counter, or Deathblow),
- how Echo, Rupture, Seal, Rift, or Crimson Vulnerable / backstab / direct Health damage reads and resolves in combat,
- how a Technique behaves across different Aspect attack geometry or frequency,
- and approved Supporting, refinement, or mixed-family interactions.

These trigger classifications are not equipment slots. Multiple owned Techniques may modify or respond to the same combat action when their individual effects permit it, consistent with `TECHNIQUES.md`.

Prosthetic behavior is taught through the Prosthetic system rather than a temporary Prosthetic-Technique layer.

Temporary trial loadouts do not become persistent equipped builds.

## Advanced and mastery trials

Later challenges may use fixed Aspects, Techniques, Prosthetics, Relics, stricter execution goals, or boss-rematch structures. They should remain deterministic enough that failure teaches a clear lesson.

Two authored Blood Cavern / challenge milestones across the launch progression award **permanent first-time Relic unlocks**. Working sequencing uses one earlier challenge and one more advanced challenge; exact Relic identities and exact challenge assignments remain later content sequencing.

Repeating those challenges does not create duplicate Relics or another Relic currency.

## Reward philosophy

Trials may award Aspect access, Technique-pool unlocks, persistent currency, the two approved first-time Relic unlocks, approved capped reliability upgrades, cosmetics, lore reflections, and mastery marks.

Trials may not:

- add alternate Aspect Tier branches,
- grant permanent Tier or Blood state,
- permanently pre-equip a run Technique,
- create persistent Blood,
- duplicate the Blood Art system as a permanent tree,
- create duplicate-copy Relic progression,
- or remove a kit's core tradeoffs.

## Blood Mirror permanent progression

Permanent Blood Aspect progression belongs to the **Blood Mirror** and remains small, capped, and reliability-focused.

The Blood Mirror begins locked and **unlocks after the first Keeper defeat**.

Launch scope is exactly **3 permanent nodes per Aspect / 9 total**:

1. **Tier 0 Handling** — base-kit reliability without removing the Aspect's defining weakness.
2. **Signature Reliability** — support for the Aspect's characteristic run-earned Tier mechanics after they are earned normally.
3. **Blood Discipline** — support for Blood Art reliability/recovery/resource consistency after Tier II/Blood is reached normally.

Availability cadence:

- **after first Keeper:** Node 1 available for each unlocked Aspect,
- **after first Twin Maws:** Node 2 available,
- **after first Shogun / first Binding clear:** Node 3 available.

Permanent upgrades must not grant major Tier mechanics early, bypass fixed progression, unlock Blood before Tier II, grant Wraith Tier IV reach/deathblow rules early, reproduce Ronin's run-only Tier posture-capacity growth as uncapped permanent scaling, or remove a kit's core tradeoffs.

Regional boss materials are not normal Blood Mirror progression requirements at launch; the six approved boss-material permanent gates belong to the Bloodwell.

Exact individual Aspect-node effects, values, normal currency costs, and any trial requirements remain later detailed tuning.

## Technical requirements

- Trials are repeatable.
- Reusable target resets clear shared posture-break, deathblow-readiness, and forwarded execution-target state between attempts.
- Active trial objectives remain readable while the player is in combat and the station menu is closed.
- Fixed Aspect/Technique/Prosthetic/Relic loadouts are supported.
- Progress, unlocks, rewards, and permanent-upgrade ranks persist where applicable.
- The two launch Relic challenge rewards are first-time permanent unlocks rather than repeatable payouts.
- First-time unlock feedback and repeat practice feedback are distinguishable without turning trial completion into a reward-farming loop.
- Temporary trial state clears when the trial ends.
- Trial rules do not require random room/reward generation.
- The Blood Mirror supports a persistent locked/unlocked campaign state keyed to the first Keeper defeat.
- The Blood Mirror supports three staged permanent progression nodes per Aspect.
- Framework supports Tier-specific Spectral Edge eligibility, clear-path extended deathblows, Veilstride, Ronin posture-capacity variants, and other approved Tier states where demonstrations require them.
