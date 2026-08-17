---
id: UI-STRAND-HUD-PROMPTS
title: Strand HUD and Interaction Prompts
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - strand-hud
  - currencies
  - boss-materials
  - interaction-prompts
related:
  - UI-HUD
  - UI-HUB-INTERFACES
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-PROGRESSION
  - CONTENT-STRAND-OVERVIEW
---

# Strand HUD and Interaction Prompts

## Strand HUD

The Strand HUD shows only persistent information worth monitoring continuously and removes active-combat modules.

### Required persistent wallet modules

- **Mist**
- **Scrolls**

Gold is run-only and does not appear as a persistent Strand wallet.

Regional boss materials are deliberately low-count mastery materials rather than general currencies. They **do not need permanent corner counters**. Show their owned quantity contextually in:

- results summaries,
- upgrade detail/cost panels that require them,
- inventory/collection reference if later needed.

There is no generic Boss Emblem counter.

Mist/Scroll counters may sit in an upper corner with calmer presentation than the Run HUD.

### State transition

Switching between Strand and Run HUD must remove stale run-only state cleanly.

## Interaction prompts

Prompts identify usable NPCs, stations, doors, reward objects, and world interactibles.

### Visual language

- small and ink-inspired,
- readable but quiet,
- anchored near the interactible,
- consistent input-glyph treatment,
- suppressed during active combat when unavailable.

### Required states

- available,
- focused/in range,
- unavailable,
- locked,
- requires resource/condition,
- hold/confirm where applicable.

Use one shared template unless an interaction rule materially differs.

## Accessibility / implementation

Prompts cannot rely on color alone. Input glyphs update for controller/keyboard. Godot owns focus/proximity/lock/show-hide logic; art owns reusable frames, glyph treatment, and state examples.
