---
id: UI-SHRINE
title: Shrine Interface
category: ui-ux
status: draft
authority: primary
last_reviewed: 2026-07-10
depends_on:
  - GAMEPLAY-CORRUPTION-SHRINES
  - GAMEPLAY-BLOOD-ASPECTS
---

# Shrine Interface

The Shrine screen presents a focused in-run decision about how far Akio permits Returning Blood to change him.

## Required information

- Active Blood Aspect
- Current Tier
- Current Corruption state
- Current relevant benefits/drawbacks
- Resist result
- Embrace next-Tier benefit
- Embrace next-Tier drawback
- Controller and keyboard navigation states

## Visual distinction

### Resist

Controlled, stabilizing, contained, and quieter. It should not read as a weaker version of Embrace.

### Embrace

Intensifying, mutating, dangerous, and more visually assertive without becoming a generic evil option.

## Interface states

- Default
- Focused
- Selected
- Disabled
- Confirmed
- Cancel/back
- Maximum Tier
- No active Aspect, if supported

## Production boundary

Milestone 2 may establish the shared screen framework and generic Shrine effects. Final Wolf, Wraith, and Ronin iconography and complete Tier-specific mutation presentation belong to Milestone 4.

## Accessibility

Benefit and drawback cannot rely on color alone. Text areas must remain localization-safe and interaction focus must be clear with controller or keyboard input.
