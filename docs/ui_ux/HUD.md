---
id: UI-HUD
title: Combat HUD
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-10
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
- Deathblow-ready state compatible with the world-space deathblow cue
- Boss phase transition without replacing the entire HUD

## Delivery rule

The artist supplies modular frames, fills, icons, markers, and state examples. Layout, values, animation timing, and responsiveness are assembled in Godot.

## Readability target

Critical state should be understood in under one second without pulling attention away from attack telegraphs.
