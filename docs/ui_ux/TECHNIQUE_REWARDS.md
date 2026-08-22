---
id: UI-TECHNIQUE-REWARDS
title: Technique Rewards and Build Management
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-20
topics:
  - techniques
  - reward-screen
  - action-techniques
  - refinement
  - supporting-techniques
  - offer-generation
  - rerolls
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-BLOOD-ASPECTS
  - UI-HUD
  - UI-PAUSE-OVERVIEW
  - ART-ITEM-REWARD-ART
---

# Technique Rewards and Build Management

All Technique rewards use one shared reward-screen system regardless of source.

A Technique reward may come from a combat room, Shop, Treasure, miniboss, regional boss, or another approved source. The source affects rarity / quality weighting but does not create a separate refinement-only, Legendary-only, or Supporting-only interface.

The prototype reward screen presents **3 Technique choices**. `TECHNIQUES.md` owns generation rules, rarity weighting, family cohesion/diversity, refinement/Cross-family/Legendary limits, and reroll behavior.

# Required persistent context

Every Technique reward screen must be able to show:

- active Blood Aspect and current Tier,
- the combat-action trigger associated with an Action Technique when relevant: Basic Attack, Held Attack, Dash / Dash Attack, Parry / Counter, or Deathblow,
- owned Supporting and Cross-family Techniques when build review is available,
- current refinements,
- equipped Relic,
- Technique rerolls remaining when available,
- decline / fallback reward when that source explicitly allows declining,
- controller and keyboard prompts.

The five combat actions are **trigger classifications, not Technique slots**. The UI must not imply that selecting one Technique prevents later acquisition of another Technique tied to the same action.

# Technique card fields

Each card should communicate:

- icon when available,
- Technique name,
- rarity or Refinement state,
- effect family or connected families,
- affected combat-action trigger when it is an Action Technique,
- concise practical effect description,
- relevant prerequisite or existing-family interaction.

The current family mechanics are **Echo, Rupture, Seal, Rift, and Crimson Vulnerable / backstab / direct Health damage**. Recognition should use symbol, color treatment, effect behavior, and VFX / audio language. Color cannot be the only identifier.

# Screen composition

Because Oathbound has no Technique slot system, screen composition does not depend on empty combat slots.

A normal three-card screen should contain **at least 1 Action Technique whenever an eligible unowned Action Technique remains**, with the other cards allowed to be eligible Action, Supporting, Cross-family, refinement, or Legendary opportunities.

Hushiro's fixed Chamber 1 Technique reward presents:

- **3 Action Techniques**,
- from **3 different combat-action triggers**,
- and from **3 different families** where the eligible pool permits it.

The player should not need to understand hidden generation math to understand why every displayed card is currently usable.

# Unlimited Technique ownership

There is **no global Technique inventory cap** and no per-action Technique slot.

A player may own multiple Basic Attack Techniques, multiple Dash-related Techniques, or several Techniques tied to any other action during the same run. Each exact Technique is normally acquired once; acquisition never overwrites another Technique merely because both use the same trigger.

The removed same-slot replacement flow must not appear in current UI.

# Supporting Techniques

Supporting Techniques use no special inventory slot and are displayed only when the current build can actually use them.

The reward screen should show which owned family mechanic or interaction they deepen and why the choice is currently functional.

# Cross-family Techniques

Cross-family cards must clearly identify the two existing family mechanics they connect. The interface should communicate the practical interaction rather than exposing the internal 1.5x Rare-pool selection weight.

A screen contains at most one Cross-family Technique under the prototype generator.

# Refinements

A parent Action Technique may receive at most one refinement.

A refinement card must show:

- the specific owned Technique being improved,
- the practical refinement effect,
- and clear Refinement labeling so it does not read as a separate full Technique.

A refinement should read as a **small improvement to the same Technique**, not another major mechanic. A screen contains at most one refinement.

# Legendary / prerequisite presentation

Legendary Techniques remain prerequisite-gated capstones. When an eligible Legendary appears, the UI should present it as a rare high-impact opportunity without exposing the hidden source-specific appearance percentage.

The player should be able to understand why the card functions with the current build from its effect and prerequisite context. A screen contains at most one Legendary.

# Screen-quality safeguards

The presentation layer assumes the gameplay generator has already validated the screen. The UI should never receive or display:

- duplicate exact Techniques,
- an unusable Supporting Technique,
- more than one refinement,
- more than one Cross-family Technique,
- more than one Legendary,
- a three-card single-family screen when another meaningful eligible family option exists,
- or an optimization-only screen when an eligible unowned Action Technique remains.

# Decline and rerolls

When the current reward source explicitly permits declining, the player may reject all Technique choices and take the displayed smaller fallback reward.

When rerolls are available:

- show the remaining count,
- reroll all 3 unselected choices together,
- preserve the same reward source and its quality rules,
- preserve the same eligibility and family-diversity rules,
- do not alter owned Techniques,
- do not guarantee an exact family or higher rarity,
- preserve the decline reward unless gameplay documentation changes it.

Where the eligible pool allows it, the immediately previous three cards should not simply repeat after a reroll.

# Rest-room and pause relationship

Rest and pause interfaces may provide build review but do not provide routine Technique swapping or removal. Techniques are additive run-build knowledge and normally remain owned until the run ends.

# Presentation direction

Technique rewards should feel like temporary martial knowledge rather than modern collectible cards floating without context.

Use readable action-trigger identifiers and strong visual family recognition. Exact family colors, symbols, layout, and card art remain provisional even though the five family mechanics and three-choice reward structure are defined.

# Accessibility and clarity

- Rarity/refinement state, action trigger, Technique kind, and family identity cannot rely on color alone.
- Long descriptions must remain localization-safe.
- The player must understand a Technique's practical immediate effect before confirming.
- The screen must distinguish Action, Supporting, Cross-family, Legendary, and refinement opportunities.
- Nothing in the interface should imply a Technique inventory cap or exclusive action slots.
