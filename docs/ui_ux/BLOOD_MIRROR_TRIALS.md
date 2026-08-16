---
id: UI-BLOOD-MIRROR-TRIALS
title: Blood Mirror and Trials Interface
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-16
topics:
  - blood-mirror
  - trials
  - blood-aspects
  - techniques
  - mastery
  - progression
related:
  - CONTENT-STRAND-BLOOD-CAVERN
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
---

# Blood Mirror and Trials Interface

## Primary purpose

After the Blood Mirror is unlocked later in the game, it supports Blood Aspect permanent progression, Aspect previews, mastery/trial content, and selected Technique-pool unlock rewards.

The Blood Mirror is **locked at the beginning of the game**. The interface therefore needs both a sealed/unavailable state and the later full progression/trial state.

The Blood Cavern's outer training functions may exist independently of the Mirror's availability.

## Core contents

### Locked state

Before campaign/onboarding unlock:

- clear unavailable / sealed state,
- restrained requirement text without narrative spoilers,
- no access to permanent Aspect upgrades,
- no implication that the player can purchase an early unlock.

The exact unlock event remains deferred.

### Unlocked state

- trial categories,
- Blood Aspect list,
- locked and unlocked Aspect/content states,
- Tier I–IV previews,
- trial descriptions,
- recommended mechanical focus,
- standardized Aspect, Technique, Prosthetic, or Relic loadout where applicable,
- rewards,
- completion and mastery state,
- permanent Aspect-progression ranks where applicable,
- Technique-pool unlock state where applicable.

## Permanent Aspect progression boundary

The Blood Mirror is the approved permanent-upgrade station for **Blood Aspects**.

Permanent Aspect upgrades remain small, capped, and reliability-focused. The interface must not imply that permanent progression:

- starts a run above Tier 0,
- grants Tier headline abilities early,
- unlocks Blood before Tier II,
- replaces Shrine Resist / Embrace progression,
- or removes an Aspect's inherent combat tradeoffs.

Exact node count, rank count, mastery requirements, values, and costs remain later detailed design.

## Presentation goal

This screen represents self-confrontation rather than shopping. The Mirror shows what Returning Blood may make possible if Akio proves control. It should feel older, stranger, quieter, and more intimate than the Shrine or Bloodwell.

Technique demonstration loadouts are presented as temporary trial conditions, not as a run-start inventory or permanent equipped build.

## Visual language

- black stone,
- reflective water,
- restrained blood-mineral light,
- sparse framing,
- mirror-like symmetry or reflection motifs,
- sealed/dormant presentation before unlock,
- clear separation between locked potential, active trial, temporary loadout, permanent Aspect progression, and mastered state.

## Interaction states

- campaign-locked,
- available,
- focused,
- selected,
- loadout preview,
- active trial,
- completed,
- reward available,
- rewarded,
- mastered,
- repeatable.

## Technical requirements

- Support a persistent Blood Mirror locked/unlocked campaign state.
- Support multiple trials per Aspect.
- Support repeatable attempts and standardized Aspect, Technique, Prosthetic, and Relic loadouts.
- Preserve unlock, completion, reward, Technique-pool access, and permanent Aspect-progression state.
- Clear temporary trial Techniques when the trial ends.
- Tier previews must explain identity without implying that previewed in-run power is permanently active.
- Technique unlock rewards must state that the Technique enters future reward pools rather than starting every run equipped.
- The layout should allow later challenge ladders, boss rematches, or score content without making them current launch requirements.
