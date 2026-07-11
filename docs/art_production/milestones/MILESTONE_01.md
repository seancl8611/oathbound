---
id: ART-MILESTONE-01
title: Milestone 1 — Playable Combat Readability Vertical Slice
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - milestone-1
  - vertical-slice
  - style-test
  - hushiro
related:
  - ART-OUTSOURCING-WORKFLOW
  - ART-TECHNICAL-STANDARDS
---

# Milestone 1 — Playable Combat Readability Vertical Slice

## Goal

Prove that final-quality art improves Oathbound's combat feel and readability. The playable test is Akio fighting three representative Area 1 enemies in a modular Hushiro combat room with core VFX and the basic Run HUD.

The gate is passed only when player and enemy silhouettes, weapon direction, attack windups, parry feedback, posture vulnerability, deathblow openings, and Hushiro's regional mood all remain clear at gameplay scale.

## Style Test prerequisite

Milestone 1 does not begin until a separate paid Style Test is delivered and approved. The approved test locks practical targets for:

- sprite scale,
- palette,
- detail density,
- perspective,
- outline treatment,
- ground shadow,
- tonal match,
- Godot import quality.

Later changes to those approved targets are production-direction changes, not ordinary revision notes.

## Authoritative design sources

- [Akio](../../characters/AKIO.md)
- [Combat System](../../gameplay/COMBAT.md)
- [Hushiro Gate Village](../../content/area_1/OVERVIEW.md)
- [Corrupted Swordsman](../../content/area_1/enemies/CORRUPTED_SWORDSMAN.md)
- [Blighted Hounds](../../content/area_1/enemies/BLIGHTED_HOUNDS.md)
- [Hollow](../../content/area_1/enemies/HOLLOW.md)
- [Area 1 Environment and Rooms](../../content/area_1/ENVIRONMENT_AND_ROOMS.md)
- [Run HUD and Combat Feedback](../../ui_ux/HUD.md)
- [Core Combat and Corruption VFX](../CORE_VFX.md)
- [Art Direction](../ART_DIRECTION.md)
- [Technical Standards](../TECHNICAL_STANDARDS.md)
- [Outsourcing Workflow](../OUTSOURCING_WORKFLOW.md)

## Included scope

| ID | Asset | Milestone purpose |
|---|---|---|
| PLY-001 | Akio | Full base sprite and complete Milestone 1 combat animation set |
| EN-A1-001 | Corrupted Swordsman | Parryable, posture-breakable baseline melee enemy |
| EN-A1-002 | Blighted Hound | Fast pack rusher with a readable lunge and punishable recovery |
| EN-A1-003 | Hollow | Fragile civilian-corruption enemy for swarm pressure |
| VFX-001 | Parry Spark | Standard and perfect-parry confirmation |
| VFX-002 | Hit Spark | Quiet workhorse damage confirmation |
| VFX-003 | Deathblow Cue | Persistent ritual execution opening |
| VFX-004 | Sword Trail | Clarifies Akio's three combo arcs |
| UI-001 | Combat HUD | HP, posture, Spirit, damage-number style, enemy posture, deathblow prompt |
| ENV-A1-001 | Hushiro Combat Room Kit | Modular walls, floors, gate, props, lanterns, and fog support |

## Internal batches

1. Akio full set + Parry Spark + Hit Spark + Sword Trail
2. Corrupted Swordsman + Deathblow Cue
3. Blighted Hound + Hollow
4. Combat HUD + Hushiro Combat Room Kit

Each batch is separately quoted, kicked off, reviewed, approved, and paid.

## Review and delivery

- Sheet-level review target: 3–5 business days from delivery.
- In-engine review target: 5–7 business days after provisional sheet approval.
- Baseline revisions: up to two sheet-level rounds and one in-engine readability round.
- Required animated-asset delivery: PNG sheet, source file, timing notes, palette continuity, and clean Godot import.
- Environment source files are preferred; PNG-only tile delivery may be accepted if modularity and import requirements pass.

## Dependencies created

- approved player and humanoid scale,
- shared Milestone 1 palette,
- silhouette and outline standard,
- pivot and frame-layout standard,
- separate ground-shadow standard,
- core VFX hierarchy,
- HUD language,
- Hushiro material and environment language.

## Completion test

Milestone 1 is complete when:

- Akio and all three enemies remain distinct at gameplay scale,
- Akio's combo weight progresses clearly from Quick Slash to Heavy Cleave,
- enemy windup, recovery, parried recoil, vulnerability, and defeat states remain distinct within the contracted subset,
- Parry Spark and Hit Spark cannot be confused,
- Deathblow Cue and input prompt read together without competing,
- Sword Trail clarifies rather than decorates each attack,
- HUD state remains visible over Hushiro,
- the room kit builds additional spaces without seams,
- sheets, pivots, names, source files, and notes pass clean Godot 4 import,
- the complete vertical-slice playtest proves combat readability.

## Scope question

The broader production bible defines a separate Posture Break Cue, but the polished Milestone 1 contractor scope lists only VFX-001 through VFX-004. Its exact milestone assignment remains open and must be confirmed before final quotation rather than silently added to Batch 1.
