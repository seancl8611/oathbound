---
id: GAMEPLAY-CORRUPTION-SHRINES
title: Corruption and Shrines
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-10
topics:
  - corruption
  - shrine
  - resist
  - embrace
  - blood-aspects
related:
  - LORE-RETURNING-BLOOD
  - GAMEPLAY-BLOOD-ASPECTS
  - UI-SHRINE
  - UI-HUD
---

# Corruption and Shrines

Corruption represents the run-only accumulation and pressure of Returning Blood. It is tied to controlled mutation and Shrine decisions; it is not a morality score.

## Corruption gain

The current v1 sources are combat accomplishment and progression events:

- kills,
- elite kills,
- successful parries,
- posture breaks,
- deathblows,
- miniboss progress,
- boss progress.

Taking damage is not a universal Corruption source in v1.

Exact gain values, weighting, and threshold pacing remain balance variables.

## Shrine-ready state

When Corruption reaches full, the player receives a clear but non-disruptive indication that a Shrine decision is available. Full Corruption should not interrupt combat or compete with low-health, posture-break, or deathblow warnings.

## Resist

Resist represents Akio stabilizing Returning Blood without permitting another Tier mutation.

Current rule:

- remain at the current Blood Aspect Tier,
- reduce Corruption to approximately 75%,
- receive a short-term support reward such as healing,
- communicate containment, restraint, and reduced pressure.

The exact reduction percentage and reward values may be tuned, but Resist does not advance Tier.

## Embrace

Embrace permits Returning Blood to advance.

Current rule:

- increase the active Blood Aspect by one Tier, up to Tier IV,
- empty the Corruption meter,
- apply the new benefit and drawback immediately,
- communicate controlled danger rather than uncontrolled explosion.

## Run behavior

- The player confirms an unlocked Aspect before departure at the Boat.
- The run begins at Tier 0.
- Tier changes occur during the run through Shrine Embrace choices.
- The selected Aspect remains available between runs, but its Tier resets after death or successful completion.
- Corruption and temporary Tier state are burned away during death, return, or Wellspring sacrifice.

## System ownership

- **Blood Mirror:** unlocks, teaches, previews, tests, and lightly improves Aspects.
- **Boat:** equips or confirms the selected Aspect before a run.
- **Shrine:** handles in-run Resist/Embrace Tier decisions.
- **Bloodwell:** owns broader permanent meta progression and does not replace the Shrine Tier loop.

## Presentation requirements

- Resist and Embrace must be distinguishable before text is read.
- Current Aspect, current Tier, next benefit, and next drawback must be legible.
- Resist should feel controlled and stabilizing, not merely like a weaker Embrace.
- Embrace should feel more forceful and dangerous without becoming a generic evil option.
- Shared Shrine effects may be produced before final Aspect-specific VFX, but should avoid prematurely locking the final Wolf, Wraith, or Ronin identity.

## Balance variables still open

- exact Corruption gain values,
- exact full-meter threshold and pacing,
- final Resist percentage and reward table,
- final benefit/drawback values for every Tier.
