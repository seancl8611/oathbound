---
id: UI-RUN-RESULTS
title: Run Results and Strand Return
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - run-results
  - successful-return
  - persistent-rewards
  - boss-materials
  - heart-bindings
  - true-final-heart
  - postgame
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-ITEMS-REWARDS
  - CONTENT-STRAND-BLOODWELL
  - CONTENT-AREA3-TRUE-FINAL-HEART
---

# Run Results and Strand Return

## Primary purpose

Explain what an attempt accomplished, which permanent rewards/campaign progress were retained, and which temporary run states were lost.

Persistent resources are saved when earned, not only at the results screen. The results presentation summarizes that retained progress.

# Successful Binding-return sequence

After a successful Heart Binding completion:

1. load the Strand,
2. spawn Akio near the Bloodwell / approved return point,
3. play a restrained reformation beat,
4. confirm saved permanent rewards and Binding progress,
5. clear run-only state,
6. present the results summary,
7. trigger relevant NPC, codex, Blood Mirror, Heart-state, or world-state updates.

# Required Binding summary information

Show:

- Eclipse Shogun defeated,
- one Heart Binding destroyed,
- destroyed-versus-remaining Binding count,
- **Mist gained during the run**,
- **Scrolls gained during the run**,
- **regional boss materials gained during the run**,
- Relic mastery / discoveries / Technique-pool unlocks where applicable,
- other permanent rewards/unlocks,
- final selected Blood Aspect and highest Tier reached,
- final five slotted Techniques,
- slotless Techniques/refinements in a readable recap,
- equipped Prosthetic and Relic,
- clear indication that Techniques, refinements, Corruption, Tier, Gold, temporary capacity, and other run-only state were lost.

There is no generic Boss Emblem reward line.

Showing the final build is a record of the completed run, not continued ownership.

The Binding display must distinguish the Court's historical outer breach from Akio's six player-destroyed Bindings.

# Failed-run summary

A failed run may use a shorter summary, but it should still make retained progression obvious:

- Mist retained,
- Scrolls retained,
- regional boss materials already earned retained,
- Relic mastery/discoveries retained,
- run-only state lost,
- deepest region / major encounter reached where useful.

A player who defeats Keeper or Twin Maws and dies later must clearly understand that the corresponding boss material was already banked.

# Final-story Heart completion

The seventh successful story run does not use the normal Binding-return sequence.

After defeating the Shogun and Heart in the same active run:

1. save story completion and permanent rewards,
2. record the first true-final Heart victory,
3. play the canonical curse-ending / Akio-mortality sequence,
4. trigger ending and credits,
5. unlock completed-save/postgame behavior,
6. preserve a completed-story marker.

The first Heart victory is not presented as another Binding clear.

# Repeat Heart completion

Postgame Heart clears are gameplay challenges only. Results may record build, time, or future approved challenge information without advancing canon again.

# Presentation goal

Binding return should feel consequential rather than generically celebratory. The player should quickly understand:

1. what permanent progress survived,
2. what campaign progress changed,
3. what temporary build was lost.

# Reformation treatment

- deeper crimson pulse through the return point,
- blood surface / warding marks reacting,
- Mist gathering around the spawn point,
- brief red-black collapse and reconstruction flash,
- optional momentary Aspect residue,
- controlled return to Strand ambience.

The canonical Heart ending instead removes Returning Blood and leaves Akio mortal.

# Technical requirements

- Permanent rewards must be saved at acquisition; the results screen summarizes them.
- Binding/story completion is saved before the player can leave the sequence.
- Run-only and persistent information must be visually separated.
- Final Technique build may be recorded for run history only if clearly non-equipped/non-recoverable.
- Failed run, Binding return, first Heart clear, and repeat Heart clear require distinct result states.
