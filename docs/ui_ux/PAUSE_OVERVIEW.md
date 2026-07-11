---
id: UI-PAUSE-OVERVIEW
title: Pause and Build Overview
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-11
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

Let the player review the current build and controls without overwhelming the combat presentation or bypassing the Technique reserve rules.

## Core contents

- active Blood Aspect and current Tier,
- current Corruption state,
- four active Techniques and their refinements,
- one inactive reserve Technique,
- equipped prosthetic and current tool state,
- equipped run-scoped Relic,
- currencies,
- active effects and status conditions,
- control/help section.

## Technique behavior

The pause screen is read-only for Technique loadout management.

It may show:

- full Technique descriptions,
- combat-verb tags,
- category and affinity,
- refinement state,
- active versus reserve state,
- current trigger, stack, or cooldown state where relevant.

It does not permit active/reserve swapping. Swapping remains restricted to Technique reward screens and rest rooms.

The screen must not imply that lost or declined Techniques remain stored elsewhere.

## Presentation goal

Functional, clean, and more stripped back than the major progression interfaces. The screen should communicate the current run state quickly rather than becoming another ornate progression menu.

## Visual direction

- dark overlay,
- minimal ornament,
- strong hierarchy,
- readable icon-and-text pairings,
- four active slots visually grouped together,
- one reserve slot clearly separated and marked inactive,
- clear distinction between equipped, active, temporary, and persistent information.

## Technical requirements

- Support controller and keyboard navigation.
- Keep the most important current-build information visible without deep submenu navigation.
- Allow Technique, Relic, and status complexity to expand without forcing a full layout redesign.
- Do not expose hidden information or imply ownership rules different from the authoritative gameplay files.
- Keep descriptions localization-safe and allow scroll or focus expansion without shrinking critical text.
