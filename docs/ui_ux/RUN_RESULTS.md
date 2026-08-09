---
id: UI-RUN-RESULTS
title: Run Results and Strand Return
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-09
topics:
  - run-results
  - successful-return
  - bloodwell
  - heart-bindings
  - true-final-heart
  - postgame
  - techniques
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
  - CONTENT-STRAND-BLOODWELL
  - CONTENT-AREA3-TRUE-FINAL-HEART
---

# Run Results and Strand Return

## Primary purpose

Explain what a completed attempt accomplished, what permanent rewards and campaign progress were retained, and which temporary run states were lost before control returns fully to the Strand or an ending sequence.

## Successful Binding-return sequence

After a successful Heart Binding completion:

1. load the Strand,
2. spawn Akio near the Bloodwell or approved return point,
3. play a restrained reformation beat,
4. save permanent rewards and destroyed-Binding campaign progress,
5. clear run-only state,
6. present the results summary,
7. trigger relevant NPC, codex, Blood Mirror, Heart-state, or world-state updates.

## Required Binding summary information

- Shogun manifestation defeated,
- one Heart Binding destroyed,
- current destroyed-versus-remaining count out of six player Bindings,
- Boss Emblem or other major reward gained where applicable,
- permanent currencies and rewards gained,
- discoveries, Technique-pool entries, or other unlocks earned,
- final selected Blood Aspect and highest Tier reached,
- final five slotted Techniques,
- owned supporting Techniques and refinements in a readable recap,
- equipped Prosthetic and Relic,
- clear indication that Techniques, refinements, Corruption, Tier, Gold, temporary capacity, and temporary Relic effects were burned away.

Showing the final build is a record of the completed run, not continued ownership.

The Binding-progress display shows six player-destroyed Bindings plus the historical outer breach. It must clearly distinguish the Court's earlier destruction from Akio's campaign progress.

## Final-story Heart completion

The seventh successful story run does not use the normal Binding-return sequence.

After the player defeats the Shogun's current body and the Heart within the same active run:

1. save story completion and permanent rewards,
2. record the first true-final Heart victory,
3. play the canonical curse-ending and Akio-mortality sequence,
4. trigger the ending and credits,
5. unlock postgame run continuation and repeatable Heart-route access,
6. preserve a completed-story marker on the save.

The first Heart victory should not be presented as one more Binding clear.

## Repeat Heart completion

After story completion, the Heart route may be repeated as a gameplay challenge. A repeat result may record build, time, difficulty, or future challenge information but does not advance the canonical ending again.

## Presentation goal

Successful Binding return should feel consequential rather than celebratory in a generic arcade sense. The final-build recap should help players remember successful combinations without turning into a permanent loadout-save system.

## Reformation treatment

- deeper crimson pulse through the return point,
- blood surface or warding marks reacting,
- mist gathering around the spawn point,
- brief red-black collapse and reconstruction flash,
- optional momentary residue from the equipped Aspect,
- controlled return to normal Strand ambience.

The canonical Heart ending instead removes Returning Blood and leaves Akio mortal.

## Technical requirements

- Results data must be assembled from finalized persistence rules.
- Permanent rewards and Binding progress are saved before the player can leave the screen.
- Story completion is saved before credits begin.
- Run-only state is visibly separated from retained progression.
- The final Technique build may be recorded for run history or summary only if it remains clearly non-equipped and non-recoverable.
- Binding-return, first Heart clear, and repeat Heart clear require distinct result-state flags.
