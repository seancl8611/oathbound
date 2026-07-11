---
id: UI-HUD
title: Combat HUD
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - hud
  - posture
  - corruption
  - deathblow
  - boss-ui
related:
  - GAMEPLAY-COMBAT
  - GAMEPLAY-CORRUPTION-SHRINES
  - ART-CORE-VFX
---

# Combat HUD

## Core elements

- Player health
- Player posture
- Spirit emblem resource
- Enemy posture indicators
- Damage-number style guidance
- Deathblow input prompt
- Status-effect slots
- Corruption meter extension
- Active Blood Aspect and Tier indicator
- Miniboss and boss health/posture presentation

## Hierarchy

Health and immediate survival remain primary. Posture is visually distinct from health. Corruption and build information remain secondary until they require a decision. Boss UI establishes hierarchy without covering combat space.

## State requirements

- Normal, low-health, full/broken posture, full/empty resource
- Corruption hidden/locked, filling, near-full, full/Shrine-ready, post-choice, and maximum Tier
- Enemy posture appearing during pressure and fading out of combat
- Deathblow-ready state compatible with the world-space Deathblow Cue
- Boss phase transition without replacing the entire HUD
- Multi-cycle encounter support where applicable, including Blood Lotus Heart vulnerability and deathblow-chunk progression

## World-space cue relationship

The HUD must complement rather than duplicate the [Core Combat and Corruption VFX](../art_production/CORE_VFX.md). Parry, Posture Break, Deathblow, and Corruption Full cues originate in world space or on Akio, while the HUD provides persistent confirmation and resource context.

## Delivery rule

The artist supplies modular frames, fills, icons, markers, and state examples. Layout, values, animation timing, and responsiveness are assembled in Godot.

## Readability target

Critical state should be understood in under one second without pulling attention away from attack telegraphs.
