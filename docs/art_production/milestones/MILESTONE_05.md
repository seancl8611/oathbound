---
id: ART-MILESTONE-05
title: Milestone 5 — Complete Area 2
category: art-production
status: draft
authority: primary
last_reviewed: 2026-08-16
---

# Milestone 5 — Complete Area 2

## Goal

Produce Yomori Grove as a complete regional combat, environment, VFX, room, miniboss, and boss package.

## Authoritative design sources

- [Yomori Grove](../../content/area_2/OVERVIEW.md)
- [Area 2 Enemy Family](../../content/area_2/ENEMIES.md)
- [Lingering Wraith](../../content/area_2/enemies/LINGERING_WRAITH.md)
- [Lantern Wraith](../../content/area_2/enemies/LANTERN_WRAITH.md)
- [Mist Shepherd](../../content/area_2/enemies/MIST_SHEPHERD.md)
- [Stalker Hound](../../content/area_2/enemies/STALKER_HOUND.md)
- [Area 2 Minibosses](../../content/area_2/MINIBOSSES.md)
- [Twin Maws](../../content/area_2/BOSS.md)
- [Run Structure](../../gameplay/RUN_STRUCTURE.md)
- [Combat System](../../gameplay/COMBAT.md)
- [Room Types](../../content/ROOM_TYPES.md)
- [Art Direction](../ART_DIRECTION.md)
- [Technical Standards](../TECHNICAL_STANDARDS.md)

## Planned scope

- Lingering Wraith
- Lantern Wraith
- Mist Shepherd
- Stalker Hound
- The Embered Pilgrim
- Rotwood Host
- Rootfang and Briarthorn paired boss
- Spirit, mist, lantern, root, fungal, predator, fire-rite, shell-break, and soul-transfer effects
- Yomori environment kit, functional rooms, props, hazards, miniboss arenas, Twin Maws arena, and UI extensions
- Enough reusable Yomori room foundations and variants to support the approved **10-counted-chamber** prototype route without requiring unique art for every chamber

## Approved route production boundary

The current Yomori prototype structure is:

- Chambers **1–2** opening
- Chambers **3–7** main
- Chambers **8–9** pre-boss
- Chamber **10** Twin Maws

One optional miniboss opportunity is generated during Chambers 4–7, selecting either The Embered Pilgrim or Rotwood Host for that run. Production therefore needs both encounters available to the generator, but a normal individual run is not expected to fight both.

The route network also supports Shrine, Shop, Rest, Technique, combat, and other reward opportunities through reusable functional-room language. Exact percentage weights and encounter compositions remain implementation/playtest work.

## Suggested internal order

1. Region visual development and base environment kit
2. Standard enemies and dependent effects
3. Embered Pilgrim + failed-purification arena
4. Rotwood Host + shell/core VFX and arena
5. Rootfang base production
6. Briarthorn base production
7. Paired encounter, soul-transfer, survivor empowerment, and arena integration
8. Functional rooms and full regional pass

## Dependency rules

- Pilgrim channel states must be defined before final escalation VFX.
- Rotwood shell/core state readability must be approved before exposed-phase polish.
- Rootfang and Briarthorn need separate role reads before paired integration.
- Soul-transfer timing, invulnerability, health/posture handling, and inherited move behavior require implementation/playtest confirmation.
- Ground-control effects must preserve safe-space information under simultaneous boss pressure.
- Room production should prioritize modularity and route reuse rather than one bespoke environment per counted chamber.

## Completion test

- Spirit targetability, flicker, and reappearance states remain readable.
- Lantern casts communicate through the lantern focal point.
- Mist Shepherd buff ownership is understandable through audio and restrained links.
- Stalker Hound pounce remains fair and clearly telegraphed.
- Pilgrim escalation reads as channel progress, not random power gain.
- Rotwood shell and exposed-core states are unmistakable.
- Twin Maws communicates active roles, shared bond, first death, transfer, empowerment, and final defeat.
- The modular Yomori kit can support the 10-chamber prototype route, optional miniboss branch, and pre-boss convergence without bespoke art for every node.
- Environmental ambiguity never becomes unfair and the region inherits project-wide scale and UI rules.
