---
id: UI-PAUSE-OVERVIEW
title: Pause and Build Overview
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-10
topics:
  - pause
  - build-overview
  - controls
  - status-effects
related:
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - UI-HUD
---

# Pause and Build Overview

## Primary purpose

Let the player review the current build and controls without overwhelming the combat presentation.

## Core contents

- current stance,
- equipped prosthetics,
- relics,
- currencies,
- active effects and status conditions,
- active Blood Aspect and Tier,
- control/help section.

## Presentation goal

Functional, clean, and more stripped back than the major progression interfaces. The screen should communicate the current run state quickly rather than becoming another ornate progression menu.

## Visual direction

- dark overlay,
- minimal ornament,
- strong hierarchy,
- readable icon-and-text pairings,
- clear distinction between equipped, active, temporary, and persistent information.

## Technical requirements

- Support controller and keyboard navigation.
- Keep the most important current-build information visible without deep submenu navigation.
- Allow status and relic complexity to expand without forcing a full layout redesign.
- Do not expose hidden information or imply ownership rules different from the authoritative gameplay files.
