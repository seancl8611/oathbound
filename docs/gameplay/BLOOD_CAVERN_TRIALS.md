---
id: GAMEPLAY-BLOOD-CAVERN-TRIALS
title: Blood Cavern Trial System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-17
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

The framework and three-Aspect launch roster are approved. Exact trial counts, scripts, most rewards, and production volume remain later content and implementation work rather than full-game scope blockers. The Relic system reserves **2 of the 10 launch Relics** for authored Blood Cavern / challenge unlock milestones.

The Blood Cavern is a training / trial space, not a separate general permanent-upgrade station. Permanent Aspect progression belongs to the Blood Mirror inside the Cavern.

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

Tier lessons cover Pale Barrage, Spectral Edge, Wraith's Reach, Spectral Passage, and Beyond the Veil while preserving their authored Tier requirements.

### Ronin Trials

Tier 0 lessons:

- choose Severing Cut, Crushing Cross, or Bloodfall according to opening size,
- use Stillness Draw for prepared single-target punishment,
- use Breaching Slash for faster lower-power re-entry,
- use Answering Steel after a universal parry,
- understand strongest-guard stability, accumulated posture, and slow posture recovery,
- respect fixed attack lines and severe miss recovery.

Tier lessons cover posture-capacity growth, Steadfast Reprisal, Falling Mountain, Unbroken Resolve, and Shattering Wake while preserving their authored Tier requirements.

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

Selected trials may use fixed approved Techniques to teach direct slots, family mechanics, refinements, Supporting Techniques, and mixed-family interactions.

Prosthetic behavior is taught through the Prosthetic system rather than a temporary Prosthetic-Technique layer. Temporary trial loadouts do not become persistent equipped builds.

## Advanced and mastery trials

Later challenges may use fixed Aspects, Techniques, Prosthetics, Relics, stricter execution goals, or boss-rematch structures. They should remain deterministic enough that failure teaches a clear lesson.

Two authored Blood Cavern / challenge milestones across the launch progression award **permanent first-time Relic unlocks**. Working sequencing uses one earlier challenge and one more advanced challenge. Exact Relic identities and exact trial assignments remain later content sequencing.

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

The Blood Mirror begins locked and **unlocks after the first Keeper defeat**.

Launch scope is exactly **3 permanent nodes per Aspect / 9 total**:

1. **Tier 0 Handling** — base-kit reliability without removing the Aspect's defining weakness.
2. **Signature Reliability** — support for the Aspect's characteristic run-earned Tier mechanics after they are earned normally.
3. **Blood Discipline** — support for Blood Art reliability/recovery/resource consistency after Tier II/Blood is reached normally.

Availability cadence:

- **after first Keeper:** Node 1 available for each unlocked Aspect,
- **after first Twin Maws:** Node 2 available,
- **after first Shogun / first Binding clear:** Node 3 available.

Permanent Aspect progression remains small, capped, and reliability-focused. It cannot add major Tier mechanics early, bypass fixed progression, unlock Blood before Tier II, grant Wraith Tier-IV reach/deathblow rules early, reproduce Ronin's run-only posture-capacity growth as uncapped permanent scaling, or remove an Aspect's inherent commitments.

Exact individual node effects, values, normal currency costs, and any trial-completion requirements remain later detailed tuning under `PROGRESSION.md` and the relevant Aspect authorities.

## Technical requirements

- Trials are repeatable.
- Fixed Aspect/Technique/Prosthetic/Relic loadouts are supported.
- Progress, unlocks, rewards, and permanent-upgrade ranks persist where applicable.
- The two launch Relic challenge rewards are first-time permanent unlocks rather than repeatable payouts.
- Temporary trial state clears when the trial ends.
- Trial rules do not require random room/reward generation.
- The Blood Mirror supports locked/unlocked campaign state plus three staged node bands per Aspect.
- Framework supports Tier-specific Spectral Edge eligibility, clear-path extended deathblows, Veilstride, Ronin posture-capacity variants, and other approved Tier states where demonstrations require them.
