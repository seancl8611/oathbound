---
id: CONTENT-AREA1-ENVIRONMENT
title: Area 1 Environment and Rooms
category: content
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - area-1
  - environment
  - rooms
  - hushiro-kit
related:
  - CONTENT-AREA1-OVERVIEW
  - CONTENT-ROOM-TYPES
  - ART-MILESTONE-01
  - ART-MILESTONE-02
---

# Area 1 Environment and Rooms

## Regional fantasy

Hushiro is a wet militarized village threshold. Its guard buildings, gate fixtures, low rooflines, mud, damp stone, and isolated lantern pools remain functionally recognizable. Corruption has not destroyed the village so much as emptied it and left its routines repeating.

## Base material language

- wet timber walls and guard structures,
- packed earth, mud, wet stone, and damp wood floors,
- soot-black tile and low eaves,
- warped clay and paper surfaces,
- lit and unlit lanterns,
- gate fixtures and barricades,
- barrels, crates, debris, banners, broken weapons, and fallen helmets,
- separate fog, runoff, incense, dust, and light-reference overlays.

## ENV-A1-001 — Hushiro Combat Room Kit

### Base grid

32×32 px working tile grid, confirmed or revised during the paid Style Test.

### Required modular pieces

- straight wet-timber walls,
- internal and external corners,
- doorway and gate openings,
- packed-earth and mud floor variants,
- wet-stone floor variants,
- damp wood-plank variants,
- low roof and eave pieces readable from the high-angle camera,
- one clear gate piece,
- lit and unlit lantern states,
- barrels and crates,
- debris clusters,
- hanging banners,
- broken weapons and helmets,
- drifting fog or mist overlay for Godot tiling or scrolling.

### Lighting and contrast

Lantern amber is the primary warmth against cool desaturated architecture. The center combat footprint remains muted and uncluttered enough for Akio, enemies, VFX, and dropped items to read clearly.

### Modularity approval criteria

- New room layouts can be assembled without seams or visible tile breaks.
- Floor and wall variants remain compatible.
- Lantern placement creates readable warm pools rather than washing the full room.
- Props frame the perimeter without blocking gameplay space.
- Pivots, dimensions, and transparency import cleanly into Godot.

## Functional room skins

Cross-area functional rules are owned by [Cross-Area Room Types](../ROOM_TYPES.md). Hushiro adapts them as follows.

### Combat room

Village lane, courtyard, gatehouse interior, or barricaded crossing using the modular Milestone 1 kit.

### Shrine

Weather-worn village Shrine with a central basin, flame, seal, or equivalent focal object. Requires inactive, Corruption-ready, active, and used states.

### Rest

Sheltered guardhouse, boarded room, or hearth space. Warmest and softest Area 1 presentation, with no active threat language.

### Shop

Temporary salvage spread with a reserved merchant position, tagged goods, cloth, shelves, boxes, and a clear purchase focal area. Final merchant character art belongs to the Strand/NPC milestone.

### Treasure / miniboss

Ruined training yard, barricaded courtyard, or mortuary route. Requires landmark framing, reward object, arena-clear state, and enough footprint for Village Ogre or The Collector mechanics.

### Boss

Old gate threshold supporting Keeper of the Gate's two phases, transformation, charge lane, shockwave footprint, and completion transition.

## Production relationship

Milestone 1 establishes the reusable base room kit and one assembled combat example. Milestone 2 extends that language into functional room skins, additional props, miniboss spaces, and the boss arena rather than remaking the regional foundation.

## Delivery baseline

Environment source files are preferred but PNG-only delivery may be accepted if the kit imports cleanly, meets the approved grid, remains modular, and can build new rooms without repair. Deliver one assembled gameplay-scale example in addition to the reusable pieces.
