---
id: UI-TECHNIQUE-REWARDS
title: Technique Rewards and Build Management
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-09-16
---

# Technique Rewards and Build Management

Technique rewards use one shared three-choice screen. The owning gameplay authority decides eligibility; the UI explains only choices that are currently usable.

## Persistent context

Show the active Blood Aspect/Tier, current rerolls, relevant owned family context, equipped Relic where useful, and controller/keyboard prompts.

For an Action Technique, show its current trigger classification:

- Basic Attack;
- Held Attack;
- Dash / Dash Attack.

These are **trigger classifications, not Technique slots**. There is **no global Technique inventory cap** and acquiring one Technique never overwrites another merely because both use the same action trigger.

Kit-specific mechanics may appear only on explicitly compatible/restricted offers; the general UI must not assume universal Parry/Counter or Deathblow/execution triggers.

## Card fields

Each card communicates name, rarity/refinement state, family, action trigger when relevant, concise practical effect, and any prerequisite needed to understand why the choice works.

Families are Echo, Rupture, Seal, Rift, and Crimson. Identity cannot rely on color alone.

## Offer rules reflected by the UI

- normally three choices;
- at least one eligible unowned Action Technique when available;
- Supporting/Cross-family/Legendary/refinement cards appear only when their prerequisites are functional;
- duplicate exact Techniques are not shown;
- a specific Technique is normally owned once;
- refinements improve an owned parent rather than becoming separate full abilities;
- rerolling replaces the offered cards without altering owned Techniques;
- decline/fallback appears only where the reward source allows it.

## Build review

Rest/pause screens may review the additive run build. They do not provide routine Technique swapping, slot management, or same-action replacement.

## Accessibility

Rarity, Technique kind, trigger, family, and refinement state must remain understandable without color alone. Descriptions remain localization-safe and should communicate the immediate practical effect before confirmation.
