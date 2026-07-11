---
id: ART-MILESTONE-01
title: Milestone 1 — Combat Vertical Slice
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-10
---

# Milestone 1 — Combat Vertical Slice

## Goal

Prove final-quality player and enemy readability, parry/posture/deathblow feedback, Hushiro mood, and the technical art pipeline in a playable combat room.

## Authoritative design sources

- [Akio](../../characters/AKIO.md)
- [Combat System](../../gameplay/COMBAT.md)
- [Hushiro Gate Village](../../content/area_1/OVERVIEW.md)
- [Area 1 Enemy Family](../../content/area_1/ENEMIES.md)
- [Corrupted Swordsman](../../content/area_1/enemies/CORRUPTED_SWORDSMAN.md)
- [Blighted Hounds](../../content/area_1/enemies/BLIGHTED_HOUNDS.md)
- [Hollow](../../content/area_1/enemies/HOLLOW.md)
- [Combat HUD](../../ui_ux/HUD.md)
- [Core Combat and Corruption VFX](../CORE_VFX.md)
- [Art Direction](../ART_DIRECTION.md)
- [Technical Standards](../TECHNICAL_STANDARDS.md)

## Included

- PLY-001 Akio full base sprite and combat animation set
- EN-A1-001 Corrupted Swordsman
- EN-A1-002 Blighted Hound
- EN-A1-003 Hollow
- VFX-001 Parry Spark
- VFX-002 Hit Spark
- VFX-003 Deathblow Cue
- VFX-004 Sword Trail
- Core Posture Break Cue
- UI-001 Combat HUD
- ENV-A1-001 Hushiro Combat Room Kit

## Internal batches

1. Akio + parry, hit, posture-break, and sword-trail VFX
2. Corrupted Swordsman + deathblow cue
3. Blighted Hound + Hollow
4. Combat HUD + Hushiro combat room kit

## Dependencies created

- Approved player scale and silhouette
- Character palette and outline treatment
- Animation and pivot standard
- Core VFX intensity hierarchy
- HUD language
- Hushiro base material and environment language

## Completion test

Akio and all three enemies remain readable at gameplay scale in the Hushiro test room. Parry Spark, Posture Break Cue, and Deathblow Cue must be immediately distinguishable from normal hits and from one another, with clean Godot 4 import and no effect obscuring attack follow-through.
