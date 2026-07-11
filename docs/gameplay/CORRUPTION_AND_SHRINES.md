---
id: GAMEPLAY-CORRUPTION-SHRINES
title: Corruption and Shrines
category: gameplay
status: draft
authority: primary
last_reviewed: 2026-07-10
depends_on:
  - LORE-RETURNING-BLOOD
  - GAMEPLAY-BLOOD-ASPECTS
---

# Corruption and Shrines

Corruption represents the pressure and accumulation of Returning Blood during a run. It is a gameplay system tied to Akio's controlled mutation, not a morality score.

## Shrine-ready state

When Corruption reaches its threshold, the player should receive a clear but non-disruptive indication that a Shrine decision is available.

## Resist

Resist represents Akio stabilizing the Returning Blood rather than permitting further mutation.

Current design intent:

- Provides an immediate stabilizing or support reward
- Does not increase Blood Aspect Tier
- Visually communicates containment, restraint, and reduction of pressure

## Embrace

Embrace permits Returning Blood to advance.

Current design intent:

- Advances the active Blood Aspect toward the next Tier
- Grants a stronger or more specialized benefit
- Introduces or intensifies a drawback or visible mutation
- Communicates controlled danger rather than uncontrolled explosion

## Presentation requirements

- Resist and Embrace must be distinguishable before text is read.
- Current Aspect, current Tier, next benefit, and next drawback should be legible.
- Full Corruption must not visually compete with low-health or posture-break warnings.
- Shared Shrine effects may be produced before final Aspect-specific VFX, but should avoid locking final Wolf, Wraith, or Ronin identities prematurely.

## Open design work

The following require confirmation before final balancing documentation:

- Exact Corruption gain sources and rates
- Whether Resist reduces, clears, or converts Corruption
- Exact reward tables
- Whether Aspect choice is fixed before a run or can change during a run
- Tier persistence after death or area completion
