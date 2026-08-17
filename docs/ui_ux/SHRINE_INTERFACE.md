---
id: UI-SHRINE
title: Shrine Interface
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-16
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
  - GAMEPLAY-ITEMS-REWARDS
  - UI-TECHNIQUE-REWARDS
  - ART-CORE-VFX
---

# Shrine Interface

The Shrine screen presents a focused in-run decision about whether Akio advances the selected Blood Aspect now. It is visually and functionally separate from Technique-card rewards.

The larger build-path decision primarily occurs through route selection: entering a Shrine can mean giving up a Technique, refinement, Relic, economy, survival, or other previewed reward.

## Required information

- Active Blood Aspect
- Current Tier
- Current Corruption state
- Current Tier benefits
- Resist result
- Embrace next-Tier headline benefit
- Any action-specific movement, commitment, defense, or control change contained within that benefit
- Maximum-Tier state
- Controller and keyboard navigation states

A separate mandatory drawback field is not required. The interface should explain the complete behavior of the next Tier without inventing an additional penalty category.

## Resist presentation

Resist keeps the current Aspect Tier, reduces Corruption to approximately 75%, and provides its approved short-term stabilization support.

It should feel:

- controlled,
- stabilizing,
- contained,
- quieter than Embrace,
- useful as recovery or pacing support.

Resist is not an equal alternate long-term power path. It is a safety valve for a damaged run, a way to remain at a preferred Tier, or a way to postpone advancement until a later Shrine.

The confirmed choice uses the [Resist Stabilization Cue](../art_production/CORE_VFX.md#resist-stabilization-cue): a cooler, paler ritual pulse that pushes Returning Blood pressure back and resolves like an exhale.

Resist does not grant a normal Technique selection. Its exact full-Corruption support result remains separate tuning under the Shrine gameplay authority.

## Embrace presentation

Embrace advances the selected Aspect by one Tier, empties Corruption, and applies the next benefit immediately.

It should feel:

- intensifying,
- mutating,
- visually assertive,
- controlled rather than explosive,
- desirable and consequential without reading as a generic evil choice.

Every Tier is clearly net-positive. The preview may describe an action becoming more committed, slower, more directional, or less defensive only when that behavior is part of how the upgraded action produces its stronger payoff. It should not be framed as a separate added drawback.

The confirmed choice uses the [Embrace Transformation Cue](../art_production/CORE_VFX.md#embrace-transformation-cue): a controlled surge from Shrine to Akio that settles into the new Aspect Tier presentation.

Embrace does not consume or create a Technique slot.

## Support state when Corruption is not full

The Shrine uses the approved survival prototype rather than an open-ended support table. It presents one readable support result:

- **20% max Health recovery**, or
- **25% max Spirit recovery**.

The interface must clearly identify which resource will be restored before confirmation and must not imitate the three-card Technique-selection layout.

These below-full support values do not automatically stack on top of a full-Corruption Resist/Embrace decision.

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
4. how the upgraded action or state behaves,
5. whether the Aspect is already at Tier IV.

Technique loadout management does not belong on this screen. A small read-only current-build summary may be accessible through the normal pause input, but it should not compete with the Shrine decision.

## Production boundary

Milestone 2 may establish the shared screen framework and generic Shrine effects. Final Wolf, Wraith, and Ronin iconography and complete Tier-specific presentation belong to Milestone 4.

Technique reward UI also belongs to Milestone 4 but uses its own three-choice screen language.

## Accessibility

Tier benefit and action-behavior information cannot rely on color alone. Text areas must remain localization-safe, and focus/confirmation states must be clear with controller or keyboard input. Shrine support, Resist, and Embrace must remain distinguishable from Technique reward cards before text is read.