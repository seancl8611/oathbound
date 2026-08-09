---
id: UI-PAUSE-OVERVIEW
title: Pause and Build Overview
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-09
topics:
  - pause
  - build-overview
  - techniques
  - controls
  - status-effects
related:
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - UI-TECHNIQUE-REWARDS
  - UI-HUD
---

# Pause and Build Overview

## Primary purpose

Let the player review the current build and controls without overwhelming combat presentation or creating free mid-run respec behavior.

## Core contents

- active Blood Aspect and current Tier,
- current Corruption state,
- five core Technique slots: Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow,
- owned slotless supporting Techniques,
- Technique refinements,
- equipped Prosthetic and current tool state,
- equipped run-scoped Relic,
- currencies,
- active effects and status conditions,
- control/help section.

## Technique behavior

The pause screen is read-only for Technique loadout management.

It may show full Technique descriptions, affected combat slot, rarity, refinement state, supporting-family relationships, and current trigger / stack / cooldown state where relevant.

It does not permit arbitrary Technique replacement. A filled combat slot is changed only through a valid replacement reward or another explicitly approved system.

Exact player-facing effect-family names, colors, symbols, and grouping remain future UI work.

## Presentation goal

Functional, clean, and more stripped back than the major progression interfaces. The screen should communicate the current run state quickly rather than becoming another ornate progression menu.

## Visual direction

- dark overlay,
- minimal ornament,
- strong hierarchy,
- readable icon-and-text pairings,
- five core combat slots visually grouped together,
- supporting Technique upgrades visually separated from the five core slots,
- clear distinction between equipped, temporary, and persistent information.

## Technical requirements

- Support controller and keyboard navigation.
- Keep the most important current-build information visible without deep submenu navigation.
- Allow supporting Technique, Relic, and status complexity to expand without forcing a full layout redesign.
- Do not expose hidden information or imply ownership rules different from the authoritative gameplay files.
- Keep descriptions localization-safe and allow scroll or focus expansion without shrinking critical text.
