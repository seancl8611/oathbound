---
id: CONTENT-STRAND-BOAT
title: The Boat
category: content
status: approved
authority: primary
last_reviewed: 2026-07-13
topics:
  - strand
  - boat
  - run-start
  - blood-aspect-selection
  - prosthetic-summary
  - blood-moon
related:
  - CONTENT-STRAND-INTERACTIBLES
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROSTHETICS
  - LORE-BARRIER-BLOOD-MOON
---

# The Boat

## Strand function

The Boat is the run-start point, island-crossing point, and final loadout-confirmation threshold between safety and the run.

## Lore role

The Boat carries Akio through the narrow path opened when the once-per-decade Blood Moon weakens the barrier. Before Akio, every departure was considered one-way.

Returning Blood allows Akio to reform at the Strand and make repeated departures during the active campaign period. The exact magical explanation belongs to [Returning Blood](../../../lore/RETURNING_BLOOD.md) and no longer requires a technical Wellspring/Bloodwell anchor link.

## Visual identity

A dark wooden boat with soaked grain, rope wear, old repairs, and one warm lantern that reads from a distance as the point of departure.

## Interaction fantasy

The player commits to another crossing and confirms which unlocked Blood Aspect will be stabilized for the run. The screen also confirms the currently equipped prosthetic when that system is available.

Technique slots are not configured here. They begin empty and are filled through run rewards.

## Screen behavior

After Blood Aspects are unlocked, the compact run-start screen shows:

- selected Blood Aspect,
- short Aspect identity text,
- current equipped prosthetic summary when available,
- four empty Technique slots and one empty reserve only as a concise run-start expectation when useful,
- `Start Run`,
- `Change Aspect`,
- `Cancel`.

The Boat does not provide a permanent Technique loadout or allow pre-equipping run Techniques.

Before Aspects are unlocked, the Boat may start the run directly or show only `Start Run` and `Cancel`.

Only unlocked Aspects may be selected.

The final location for changing the equipped prosthetic remains owned by the Forge/loadout implementation. The Boat may link back to that service later, but should not invent a second permanent upgrade interface.

## Animation and environment needs

- water lapping against the hull,
- lantern sway,
- rope tension,
- dock creak,
- offshore fog drift,
- restrained departure beat if the camera lingers.

## Technical notes

- Repeated departures must remain fast.
- Selected Aspect and equipped prosthetic must be clear before confirmation.
- Empty Technique capacity should be understandable without creating an unnecessary pre-run menu step.
- Dock alignment, lantern placement, and interaction marker must make the station immediately readable.