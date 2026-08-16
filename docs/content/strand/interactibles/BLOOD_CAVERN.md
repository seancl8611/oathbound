---
id: CONTENT-STRAND-BLOOD-CAVERN
title: Blood Cavern and Blood Mirror
category: content
status: approved
authority: primary
last_reviewed: 2026-08-16
topics:
  - strand
  - blood-cavern
  - blood-mirror
  - training
  - aspect-trials
  - technique-trials
  - aspect-progression
related:
  - CONTENT-STRAND-INTERACTIBLES
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROGRESSION
  - UI-BLOOD-MIRROR-TRIALS
  - CHAR-STRAND-UNDEAD-SAMURAI
---

# Blood Cavern and Blood Mirror

## Strand function

The Blood Cavern is the Strand's training, tutorial-refresh, combat-trial, Aspect-trial, Technique-demonstration, mastery, and build-testing space. It moves from practical instruction in the outer hall to self-confrontation in the deeper Blood Mirror chamber.

The **Blood Mirror is not available at the beginning of the game**. It remains locked until later campaign/onboarding progression. The exact unlock event is intentionally deferred.

## Lore role

The cavern is an Order training and anti-corruption site. Its deeper chamber contains the Blood Mirror, an older artifact used to reveal corruption within body and soul. The Undead Samurai serves as the primary martial instructor and trial-giver.

The outer training space may function before the Blood Mirror itself becomes available.

## Spatial structure

### Outer training hall

- scarred wooden platforms,
- training dummies and weapon racks,
- old ropes and restraint fixtures,
- dim practical lanterns,
- controlled space for repeatable fundamentals and standardized challenges.

### Inner mirror chamber

- raw black stone,
- shallow reflective water,
- red mineral seams,
- sparse ritual architecture,
- colder and stranger light than the outer hall,
- strong visual separation between practical training and Blood-based self-examination.

The inner chamber must support a clear locked / unavailable state before its campaign unlock.

## Interaction fantasy

The player descends from learning how to fight into proving how much of the Beast Blood can be controlled. The outer hall teaches and tests execution; once unlocked, the Blood Mirror reveals, previews, tests, and permanently improves Blood Aspects within the approved capped progression boundary.

Fixed-loadout demonstrations may temporarily assign approved Techniques to teach one of the five direct combat-slot modifications, family behavior such as Echo, Rupture, Seal, Rift, or Crimson Vulnerable / backstab / direct Health damage, and approved Supporting or mixed-build interactions. Prosthetic behavior remains part of the separate Prosthetic system rather than a temporary Prosthetic-Technique layer. Temporary trial loadouts do not become an equipped run build.

## System states

- **Training Hall:** basic combat lessons, refreshers, Technique demonstrations, and general mastery trials.
- **Blood Mirror — locked:** unavailable during the opening portion of the game until later campaign/onboarding progression.
- **Blood Mirror — unlocked:** Blood Aspect unlocks or access where assigned, Aspect trials, Tier previews, permanent Aspect progression, approved Technique-pool unlocks, and completion rewards.

## Progression ownership

The Blood Mirror is the Strand station that owns **Blood Aspect permanent progression**.

Permanent Aspect progression must remain distinct from the run-only Shrine path:

- every run still begins at Tier 0,
- permanent progression cannot grant Tier abilities early,
- Blood cannot become available before Tier II,
- and permanent upgrades cannot replace Resist / Embrace decisions or remove an Aspect's core tradeoffs.

Exact permanent Aspect upgrades, mastery ranks, unlock conditions, and values remain later detailed design.

## Environment and animation needs

- restrained training ambience in the outer hall,
- still reflective water in the inner chamber,
- subtle mineral pulse,
- faint red reflection and resonance,
- a clear sealed / dormant presentation before Blood Mirror unlock,
- standardized trial-start and trial-complete presentation,
- clear visual state for locked, available, loadout-previewed, active, completed, and mastered trials.

Stillness is important. The inner chamber should feel older, more intimate, and more unsettling than a shop or upgrade station.

## Technical requirements

- Repeatable trials must support fixed conditions and standardized Aspect, Technique, Prosthetic, and Relic loadouts.
- Temporary trial Techniques clear when the trial ends.
- Trial completion, reward, unlock, Technique-pool access, and mastery flags must persist.
- Blood Mirror availability must support a persistent campaign-gated locked/unlocked state.
- The system should allow future challenge ladders, boss rematches, or score-based modes without requiring the space or data structure to be rebuilt.
- Blood Mirror functions must remain distinct from Boat confirmation, Shrine Tier progression, Technique rewards during runs, Bloodwell Akio/Run Infrastructure progression, and Forge Prosthetic/Relic progression.
