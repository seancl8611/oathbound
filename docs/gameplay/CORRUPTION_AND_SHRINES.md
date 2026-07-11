---
id: GAMEPLAY-CORRUPTION-SHRINES
title: Corruption and Shrines
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - corruption
  - shrine
  - resist
  - embrace
  - blood-aspects
related:
  - LORE-RETURNING-BLOOD
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-ITEMS-REWARDS
  - UI-SHRINE
  - UI-HUD
---

# Corruption and Shrines

Corruption represents the run-only accumulation and pressure of Returning Blood. It is tied to controlled mutation and Shrine decisions; it is not a morality score, currency, or Technique resource.

## System role

Corruption and Shrines control the vertical escalation of the selected Blood Aspect. Techniques are acquired through the separate room-reward framework and provide horizontal build customization.

Shrines should remain focused on the Blood Aspect decision rather than also functioning as ordinary Technique reward rooms.

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
- receive a short-term support reward such as healing or Spirit recovery,
- communicate containment, restraint, and reduced pressure.

The exact reduction percentage and support table may be tuned, but Resist does not advance Tier or grant a normal Technique selection.

## Embrace

Embrace permits Returning Blood to advance.

Current rule:

- increase the active Blood Aspect by one Tier, up to Tier IV,
- empty the Corruption meter,
- apply the new benefit and drawback immediately,
- communicate controlled danger rather than uncontrolled explosion.

Embrace does not consume or create a Technique slot. It amplifies the build through the selected Aspect's fixed Tier progression.

## Shrine behavior when Corruption is not full

A Shrine room must still provide normal support so it never feels dead. The support may include:

- Health recovery,
- Spirit recovery,
- a small stabilizing benefit,
- another approved support result from the Shrine table.

It should not normally present a three-card Technique offer. Exceptional narrative or scripted events require explicit documentation rather than using ordinary Shrine ownership.

## Run behavior

- The player confirms an unlocked Aspect before departure at the Boat.
- The run begins at Tier 0.
- Tier changes occur during the run through Shrine Embrace choices.
- The selected Aspect remains available between runs, but its Tier resets after death or successful completion.
- Corruption and temporary Tier state are burned away during death, return, or Wellspring sacrifice.
- Active and reserve Techniques reset separately under the Technique system.

## System ownership

- **Blood Mirror:** unlocks, teaches, previews, tests, and lightly improves Aspects.
- **Boat:** equips or confirms the selected Aspect before a run.
- **Shrine:** handles in-run Resist/Embrace Tier decisions and ordinary Shrine support.
- **Technique reward framework:** owns new Techniques, replacements, refinements, and reserve decisions.
- **Bloodwell:** owns broader permanent meta progression and does not replace the Shrine Tier loop.

## Presentation requirements

- Resist and Embrace must be distinguishable before text is read.
- Current Aspect, current Tier, next benefit, and next drawback must be legible.
- Resist should feel controlled and stabilizing, not merely like a weaker Embrace.
- Embrace should feel more forceful and dangerous without becoming a generic evil option.
- Shared Shrine effects may be produced before final Aspect-specific VFX, but should avoid prematurely locking the final Wolf, Wraith, or Ronin identity.
- The Shrine interface should not resemble the Technique card-selection screen.

## Balance variables still open

- exact Corruption gain values,
- exact full-meter threshold and pacing,
- final Resist percentage and support-reward table,
- final benefit/drawback values for every Tier,
- Shrine frequency across a full run.
