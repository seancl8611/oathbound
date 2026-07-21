---
id: UI-RUN-RESULTS
title: Run Results and Strand Return
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-07-20
topics:
  - run-results
  - successful-return
  - bloodwell
  - heart-bindings
  - techniques
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
  - CONTENT-STRAND-BLOODWELL
---

# Run Results and Strand Return

## Primary purpose

Explain what a completed attempt accomplished, what permanent rewards and campaign progress were retained, and which temporary run states were lost before control returns fully to the Strand.

## Successful-return sequence

After a successful Heart Binding completion:

1. load the Strand,
2. spawn Akio near the Bloodwell or approved return point,
3. play a restrained reformation beat,
4. save permanent rewards and destroyed-Binding campaign progress,
5. clear run-only state,
6. present the results summary,
7. trigger relevant NPC, codex, Blood Mirror, Heart-state, or world-state updates.

## Required summary information

- Shogun manifestation defeated,
- one Heart Binding destroyed,
- Boss Emblem or other major reward gained where applicable,
- permanent currencies and rewards gained,
- discoveries, Technique-pool entries, or other unlocks earned,
- final selected Blood Aspect and highest Tier reached,
- final four active Techniques, reserve Technique, refinements, equipped prosthetic, and Relic as a run recap,
- clear indication that active/reserve Techniques, refinements, Corruption, Tier, Gold, temporary capacity, and temporary Relic effects were burned away.

Showing the final build is a record of the completed run, not continued ownership. The layout must not imply that those Techniques remain equipped at the Strand.

The Binding-progress display may show the completed step and increasing Heart exposure, but it must not invent the final total number of Bindings until the campaign clear count is locked.

## Presentation goal

Successful return should feel consequential rather than celebratory in a generic arcade sense. It communicates that Akio defeated the Shogun, used Returning Blood to destroy one ancient restraint around the Heart, was dissolved by the Heart's retaliation, and reconstructed with campaign progress intact.

The final-build recap should help players remember successful combinations without turning into a permanent loadout-save system.

## Reformation treatment

- deeper crimson pulse through the return point,
- blood surface or warding marks reacting,
- mist gathering around the spawn point,
- brief red-black collapse and reconstruction flash,
- optional momentary residue from the equipped Aspect,
- controlled return to normal Strand ambience.

The effect must imply real bodily destruction, danger, and increasing marks on Akio without presenting Returning Blood as effortless immortality.

## Technical requirements

- Results data must be assembled from finalized persistence rules.
- Permanent rewards and Binding progress are saved before the player can leave the screen.
- Run-only state is visibly separated from retained progression.
- The final Technique build may be recorded for run history or summary only if it remains clearly non-equipped and non-recoverable.
- The return flow must remain reusable while the final Binding count and ending presentation are still under design lock.
- Failed-return treatment may share layout components, but successful completion must remain visually and narratively distinct.
