---
id: UI-PAUSE-OVERVIEW
title: Pause and Build Overview
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-20
topics:
  - pause
  - build-overview
  - techniques
  - relics
  - controls
  - status-effects
  - temporary-capacity
related:
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-RELICS
  - UI-TECHNIQUE-REWARDS
  - UI-HUD
---

# Pause and Build Overview

## Primary purpose

Let the player review the current build and controls without overwhelming combat presentation or creating free mid-run respec behavior.

## Core contents

- active Blood Aspect and current Tier,
- current Corruption state,
- owned Action Techniques, grouped by their Basic / Held / Dash / Parry-Counter / Deathblow trigger where useful,
- owned Supporting / Cross-family / Legendary Techniques,
- Technique refinements,
- equipped Prosthetic and current tool state,
- equipped Relic and its currently active benefit,
- current / maximum Health and Spirit, including any temporary run-only capacity increases,
- run currencies,
- active effects and status conditions,
- control/help section.

The five combat actions are Technique **trigger groupings**, not exclusive Technique slots. Multiple owned Techniques may appear under the same action during one run.

The equipped Relic is a persistent owned object with persistent mastery/progression; only its **equipped run benefit** is part of the current run state.

Temporary maximum Health and Spirit are run-only build state. The overview should make the increased maximum understandable without implying that the capacity persists after the run.

## Technique behavior

The pause screen is read-only for Technique ownership.

It may show full Technique descriptions, associated combat-action trigger, rarity/refinement state, Supporting-family relationships, and current trigger / status / cooldown state where relevant.

It does not permit arbitrary Technique removal or swapping. Techniques are additive run-only knowledge and normally remain owned until the run ends.

Exact player-facing effect-family names, colors, symbols, and grouping remain future UI work.

## Relic behavior

The pause screen may show the equipped Relic, its current effect, and useful mastery/progression context, but it does not become a permanent Relic-upgrade interface.

Permanent Relic progression and Strand-side management belong to the **Forge Bench**. In-run switching is limited to approved transition opportunities rather than free pause-menu swapping.

## Presentation goal

Functional, clean, and more stripped back than the major progression interfaces. The screen should communicate the current run state quickly rather than becoming another ornate progression menu.

## Visual direction

- dark overlay,
- minimal ornament,
- strong hierarchy,
- readable icon-and-text pairings,
- Action Techniques grouped by combat trigger without fixed slot boxes,
- Supporting / Cross-family / Legendary Technique upgrades visually distinguishable from Action Techniques,
- temporary Health/Spirit capacity visually separated from permanent progression,
- clear distinction between equipped, run-active, and persistent information.

## Technical requirements

- Support controller and keyboard navigation.
- Keep the most important current-build information visible without deep submenu navigation.
- Allow Technique, Relic, status, and temporary-capacity complexity to expand without forcing a full layout redesign.
- Do not expose hidden information or imply ownership rules different from the authoritative gameplay files.
- Keep descriptions localization-safe and allow scroll or focus expansion without shrinking critical text.
