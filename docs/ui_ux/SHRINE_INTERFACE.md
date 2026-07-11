---
id: UI-SHRINE
title: Shrine Interface
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - shrine
  - resist
  - embrace
  - blood-aspects
  - corruption
related:
  - GAMEPLAY-CORRUPTION-SHRINES
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - UI-TECHNIQUE-REWARDS
  - ART-CORE-VFX
---

# Shrine Interface

The Shrine screen presents a focused in-run decision about how far Akio permits Returning Blood to change him. It is visually and functionally separate from Technique-card rewards.

## Required information

- Active Blood Aspect
- Current Tier
- Current Corruption state
- Current benefits and drawbacks
- Resist result
- Embrace next-Tier benefit
- Embrace next-Tier drawback
- Maximum-Tier state
- Controller and keyboard navigation states

## Resist presentation

Resist keeps the current Aspect Tier, reduces Corruption to approximately 75%, and provides a short-term support reward such as healing or Spirit recovery.

It should feel:

- controlled,
- stabilizing,
- contained,
- quieter than Embrace,
- valuable in its own right rather than a weaker version of the other choice.

The confirmed choice uses the [Resist Stabilization Cue](../art_production/CORE_VFX.md#resist-stabilization-cue): a cooler, paler ritual pulse that pushes Returning Blood pressure back and resolves like an exhale.

Resist does not grant a normal Technique selection.

## Embrace presentation

Embrace advances the selected Aspect by one Tier, empties Corruption, and applies the next benefit and drawback immediately.

It should feel:

- intensifying,
- mutating,
- dangerous,
- more visually assertive,
- controlled rather than explosive,
- consequential without reading as a generic evil choice.

The confirmed choice uses the [Embrace Transformation Cue](../art_production/CORE_VFX.md#embrace-transformation-cue): a controlled surge from Shrine to Akio that settles into the new Aspect Tier presentation.

Embrace does not consume or create a Technique slot.

## Support state when Corruption is not full

The Shrine provides an approved support result so the room never feels dead. The screen may present Health, Spirit, or another stabilizing result from the Shrine table without imitating the three-card Technique-selection layout.

## Interface states

- Default
- Focused
- Selected
- Disabled
- Confirmed
- Cancel/back
- Maximum Tier
- Tier-preview state
- Corruption-not-full support state

A no-active-Aspect state should not be required during normal post-unlock runs because the Boat confirms one unlocked Aspect before departure. Pre-unlock and tutorial cases may use a simplified flow.

## Information hierarchy

The player should understand, before confirming:

1. current Tier,
2. what Resist does now,
3. what Embrace adds now,
4. what new drawback Embrace introduces,
5. whether the Aspect is already at Tier IV.

Technique slots and reserve management do not belong on this screen. A small read-only current-build summary may be accessible through the normal pause input, but it should not compete with the Shrine decision.

## Production boundary

Milestone 2 may establish the shared screen framework and generic Shrine effects. Final Wolf, Wraith, and Ronin iconography and complete Tier-specific mutation presentation belong to Milestone 4.

Technique reward and reserve UI also belongs to Milestone 4 but uses its own screen language.

## Accessibility

Benefit and drawback cannot rely on color alone. Text areas must remain localization-safe, and focus/confirmation states must be clear with controller or keyboard input. Shrine support, Resist, and Embrace must remain distinguishable from Technique reward cards before text is read.
