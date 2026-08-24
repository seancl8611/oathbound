---
id: DECISION-YOMORI-REGION-RECONCILIATION
title: Yomori Region Runtime Reconciliation
category: decision
status: approved
authority: implementation-record
last_reviewed: 2026-08-23
topics:
  - yomori
  - region-2
  - runtime
  - route
  - encounters
  - twin-maws
  - playtest
---

# Yomori Region Runtime Reconciliation

## Decision

Region 2 now uses a current Yomori-owned first-playtest runtime rather than treating imported Area 2 prototype routing or Hushiro encounter ownership as authority.

The implementation boundary is the approved Yomori package in `docs/content/area_2/*`, `docs/gameplay/RUN_STRUCTURE.md`, and `docs/gameplay/ITEMS_AND_REWARDS.md`.

## Locked runtime package

- Yomori contains 10 counted chambers.
- Chambers 1–2 are the opening stretch, 3–7 the main stretch, 8–9 the pre-boss stretch, and Chamber 10 is Twin Maws.
- Branching begins immediately; Chamber 1 is not a forced Technique reward.
- The route network provides Shrine, Merchant, Rest, one optional miniboss opportunity, and at least two Technique-reward opportunities while preserving route choice rather than forcing visits.
- The only standard Yomori encounter keys are Lingering Wraith, Lantern Wraith, Mist Shepherd, and Stalker Hound.
- The optional miniboss opportunity uses Embered Pilgrim or Rotwood Host and grants the current premium Technique reward plus the persistent +10 Mist / +1 Scroll bonus.
- Treasure is a genuine reward chamber and no longer aliases to a miniboss room.
- Chamber 10 uses the dedicated Twin Maws scene with explicit Rootfang, Briarthorn, and duo-manager ownership. The first twin death empowers the survivor; the chamber resolves only after both die.
- Twin Maws grants the Region 2 boss reward contract exactly once.
- Normal and debug Region 2 entry activate current Yomori SceneRegistry ownership.

## Validation boundary

Automated validation covers:

- 256 seeded Yomori route contracts;
- the four-enemy standard roster and encounter catalog;
- SceneRegistry Region 2 ownership;
- current post-import Yomori actor/texture loadability;
- Twin Maws explicit twin registration, serialized special behavior, survivor empowerment, and final defeat ordering;
- a complete generated 10-counted-chamber structural traversal;
- Hushiro combat regressions discovered while reaching the Region 2 checkpoint, including Archer deathblow resolution and room-removal lifecycle safety.

The final Yomori implementation head also passed the full Godot 4.7.2 project gate, Yomori region gate, and focused Hushiro combat regression gate.

## Manual checkpoint evidence

Targeted manual sessions confirmed that a normal run can clear Hushiro Chamber 1 and enter Chamber 2 without the previous EncounterSpawner orphan-tree crash. The matching Godot session log contains no `ERROR` or `SCRIPT ERROR` entries during that checkpoint.

A complete manual Hushiro -> Yomori -> Twin Maws run is intentionally **not** a merge prerequisite for this content package. Full-route duration and interacting balance are deferred until the remaining region content is present.

## Playtest workflow decision

During content buildout, manual testing should be short and variable-focused rather than requiring repeated full runs.

The backtick Playtest Lab therefore owns targeted region controls for current Yomori combat, Miniboss, Twin Maws, Treasure, Shrine, Merchant, and Rest rooms, plus isolated Yomori actor spawns. Region debug warps must use the current regional route/SceneRegistry authority instead of imported generic routing.

A complete end-to-end route run becomes a milestone validation after Hushiro, Yomori, Kagutsuchi, Shogun, and Heart content are all integrated.

## Explicitly deferred tuning

The following remain playtest/tuning work and are not reasons to reopen Yomori planning:

- final damage and posture values;
- final attack/frame timing and hitbox/VFX synchronization;
- final encounter volume and wave timing;
- final Corruption/Blood pacing;
- final route/reward/economy percentages;
- exact 12–14 minute Yomori duration validation;
- final presentation art replacing temporary prototype visual scaffolding.

## Next implementation package

Proceed to Kagutsuchi / Shogun / Heart reconciliation from the merged Yomori baseline.
