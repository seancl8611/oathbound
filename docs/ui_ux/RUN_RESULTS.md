---
id: UI-RUN-RESULTS
title: Run Results and Strand Return
category: ui-ux
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - run-results
  - first-return
  - successful-return
  - persistent-rewards
  - boss-materials
  - heart-bindings
  - true-final-heart
  - postgame
related:
  - GAMEPLAY-FIRST-ATTEMPT
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-ITEMS-REWARDS
  - NARRATIVE-DELIVERY
  - CONTENT-STRAND-BLOODWELL
  - CONTENT-AREA3-TRUE-FINAL-HEART
---

# Run Results and Strand Return

## Primary purpose

Explain what an attempt accomplished, which permanent rewards/campaign progress were retained, and which temporary run states were lost.

Persistent resources are saved when earned, not only at the results screen. The results presentation summarizes that retained progress.

Oathbound requires distinct presentation states for:

- the **first Returning Blood reconstruction**,
- ordinary failed runs after awakening,
- successful Binding returns,
- the first canonical Heart victory,
- repeat postgame Heart clears.

# First-return sequence

The first death is not a standard failed-run reset because it awakens Returning Blood and establishes the roguelite return loop.

After the unscripted first attempt ends:

1. load/transition to the Strand,
2. play the approved first Returning Blood reconstruction beat,
3. show NPC/environmental reaction without requiring Akio dialogue,
4. save/confirm any persistent rewards earned during the first attempt,
5. clear first-attempt run-only Techniques, Gold, temporary capacity, room progress, and other run-only state,
6. unlock the normal post-awakening progression/preparation flow,
7. present only as much retained/lost information as needed before returning control.

The first-return presentation should not be buried under a dense generic results screen before the reconstruction lands emotionally. A concise summary may follow or be integrated after the main beat.

If an exceptional first-attempt player reaches the Heart before dying, the summary may acknowledge the completed regional route / Shogun defeat as a record, but **no Heart Binding is destroyed** and the six-Binding campaign still begins at six remaining.

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

A failed post-awakening run may use a shorter summary, but it should still make retained progression obvious:

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

Akio remains silent throughout the ending/results presentation.

# Repeat Heart completion

Postgame Heart clears are gameplay challenges only. Results may record build, time, or future approved challenge information without advancing canon again.

# Presentation goal

Returning to the Strand should feel consequential rather than generically celebratory. The player should quickly understand:

1. what permanent progress survived,
2. what campaign progress changed,
3. what temporary build was lost.

The first return adds a fourth message before those three: **Akio actually died and somehow came back.**

# Reformation treatment

Ordinary post-awakening reformation may use:

- deeper crimson pulse through the return point,
- blood surface / warding marks reacting,
- Mist gathering around the spawn point,
- brief red-black collapse and reconstruction flash,
- optional momentary Aspect residue,
- controlled return to Strand ambience.

The **first** reconstruction should be the most narratively emphasized version because the event is unprecedented. Later returns should become faster and more routine without feeling consequence-free.

The canonical Heart ending instead removes Returning Blood and leaves Akio mortal.

# Technical requirements

- Permanent rewards must be saved at acquisition; the results screen summarizes them.
- First-awakening state must be saved before the player regains normal Strand control.
- Binding/story completion is saved before the player can leave the sequence.
- Run-only and persistent information must be visually separated.
- Final Technique build may be recorded for run history only if clearly non-equipped/non-recoverable.
- First return, failed run, Binding return, first Heart clear, and repeat Heart clear require distinct result states.
- The exceptional pre-awakening Shogun/Heart route records no destroyed Binding.
