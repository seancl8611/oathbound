---
id: UI-RUN-RESULTS
title: Run Results and Strand Return
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-10
topics:
  - run-results
  - successful-return
  - bloodwell
  - wellspring
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-PROGRESSION
  - CONTENT-STRAND-BLOODWELL
---

# Run Results and Strand Return

## Primary purpose

Explain what a completed attempt accomplished, what permanent rewards were retained, and which temporary run states were lost before control returns fully to the Strand.

## Successful-return sequence

After a successful Wellspring completion:

1. load the Strand,
2. spawn Akio near the Bloodwell,
3. play a restrained reformation beat,
4. save permanent rewards and progression,
5. clear run-only state,
6. present the results summary,
7. trigger relevant NPC, codex, Blood Mirror, or world-state updates.

## Required summary information

- boss or major encounter defeated,
- Wellspring Fragment or Boss Emblem gained where applicable,
- permanent currencies and rewards gained,
- discoveries or unlocks earned,
- run-only effects, Corruption, Tier, Gold, and temporary relic effects lost.

## Presentation goal

Successful return should feel consequential rather than celebratory in a generic arcade sense. It communicates that Akio completed the Rite, lost the current body, and reformed with permanent consequences intact.

## Bloodwell reformation treatment

- deeper crimson pulse through the well,
- blood surface rising or rippling upward,
- mist gathering around the spawn point,
- brief red-black collapse and reconstruction flash,
- optional momentary residue from the equipped Aspect,
- controlled return to normal Strand ambience.

The effect must imply danger and increasing marks on Akio without presenting the Bloodwell as effortless immortality.

## Technical requirements

- Results data must be assembled from finalized persistence rules.
- Permanent rewards are saved before the player can leave the screen.
- Run-only state is visibly separated from retained progression.
- The return flow must remain reusable for prototype completion before final ending presentation is locked.
- Failed-return treatment may share layout components, but successful completion must remain visually and narratively distinct.
