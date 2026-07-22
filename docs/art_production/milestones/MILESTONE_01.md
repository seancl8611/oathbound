---
id: ART-MILESTONE-01
title: Milestone 1 — Playable Combat Readability Vertical Slice
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-21
topics:
  - milestone-1
  - vertical-slice
  - style-test
  - hushiro
related:
  - ART-OUTSOURCING-WORKFLOW
  - ART-TECHNICAL-STANDARDS
  - ART-CORE-VFX
---

# Milestone 1 — Playable Combat Readability Vertical Slice

## Goal

Prove that final-quality art improves Oathbound's combat feel and readability through Akio fighting three representative Area 1 enemies in a modular Hushiro room with core VFX and the basic Run HUD.

The slice must prove:

- player and enemy silhouette separation,
- weapon direction and attack windups,
- hit and parry feedback,
- posture break and execution readability,
- damage and HUD clarity,
- Hushiro's regional mood,
- and clean Godot import.

## Style Test prerequisite

Milestone 1 begins only after a separately paid Style Test establishes:

- sprite scale,
- palette,
- detail density,
- high-angle perspective,
- outline treatment,
- ground shadow,
- tonal match,
- Godot import quality.

Approved Style Test outputs become binding visual targets for the milestone.

## Included scope

| ID | Asset | Milestone purpose |
|---|---|---|
| PLY-001 | Akio | Base sprite and Milestone 1 combat set |
| EN-A1-001 | Corrupted Swordsman | Baseline parry and posture enemy |
| EN-A1-002 | Blighted Hound | Fast lunge and pack-pressure read |
| EN-A1-003 | Hollow | Fragile swarm-pressure read |
| VFX-001 | Parry Spark | Standard and perfect-parry confirmation |
| VFX-002 | Hit Spark | Ordinary damage confirmation |
| VFX-003 | Deathblow Cue | Persistent execution opening |
| VFX-004 | Sword Trail | Base combo path clarity |
| VFX-005 | Posture Break Cue | Vulnerability-state confirmation |
| UI-001 | Combat HUD | HP, posture, Spirit, enemy state, damage, execution prompt |
| ENV-A1-001 | Hushiro Combat Room Kit | Modular combat environment foundation |

## Internal batches

1. Akio + Parry Spark + Hit Spark + Sword Trail
2. Corrupted Swordsman + Posture Break Cue + Deathblow Cue
3. Blighted Hound + Hollow
4. Combat HUD + Hushiro Combat Room Kit

Each batch is quoted, reviewed, approved, and paid separately.

Batch 2 owns the complete baseline posture loop: pressure, posture break, persistent execution opening, and Corrupted Swordsman reactions.

## Delivery requirements

Animated assets require:

- PNG sheet,
- source file,
- timing notes,
- palette continuity,
- clean Godot import.

Environment source files are preferred. PNG-only tile delivery may be accepted if modularity and import quality pass review.

## Dependencies created

- approved player and humanoid scale,
- shared Milestone 1 palette,
- silhouette and outline standard,
- pivot and frame-layout standard,
- ground-shadow standard,
- core combat VFX hierarchy,
- HUD language,
- Hushiro material language.

## Completion test

Milestone 1 is complete when:

- all four combatants remain distinct at gameplay scale,
- Akio's combo weight progresses clearly,
- enemy windup, recovery, parried recoil, posture break, deathblow availability, and defeat remain distinct,
- Hit Spark and Parry Spark cannot be confused,
- Posture Break Cue and Deathblow Cue communicate different stages of the vulnerability loop,
- HUD state remains clear over Hushiro,
- the room kit builds additional spaces without visible seams,
- and all sheets, pivots, names, sources, and notes pass Godot 4 import.