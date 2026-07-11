---
id: UI-STRAND-HUD-PROMPTS
title: Strand HUD and Interaction Prompts
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - strand-hud
  - currencies
  - interaction-prompts
related:
  - UI-HUD
  - UI-HUB-INTERFACES
  - GAMEPLAY-ITEMS-REWARDS
  - CONTENT-STRAND-OVERVIEW
---

# Strand HUD and Interaction Prompts

## Strand HUD

The Strand HUD displays persistent resources while removing combat-state modules. The absence of HP, posture, Spirit, stance, prosthetic, and run-status elements should immediately communicate that Akio is in the hub rather than an active run.

### Required modules

- Mist
- Scrolls
- Boss Emblems
- any future approved persistent currency

Gold is run-only under the current progression rules and should not appear as a persistent Strand wallet.

Current currency icons reuse their Run HUD language but may appear slightly larger and calmer. Counters sit in an upper corner so the lower combat area remains clear.

### State transition

Switching between Strand HUD and Run HUD must be clean. Do not allow partial overlap, stale run state, or combat resources to remain visible after return.

## Interaction prompts

Interaction prompts identify usable NPCs, stations, doors, reward objects, and world interactibles in the Strand and during runs.

### Visual language

- small and ink-inspired,
- screen-readable but quiet,
- anchored above or near the interactible,
- consistent input-glyph treatment,
- hidden or suppressed during active combat when interaction is unavailable.

### Required states

- available,
- focused/in range,
- unavailable,
- locked,
- requires resource or condition,
- hold or confirm where applicable.

Use one shared template across NPCs and stations. Context-specific variants should be added only where the interaction rule is materially different.

## Accessibility and implementation

Prompts cannot rely on color alone. Input glyphs must update for controller or keyboard use. Godot owns proximity checks, focus priority, prompt text, lock conditions, and show/hide timing; art owns the reusable frame, glyph treatment, and state examples.
