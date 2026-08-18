---
id: CONTENT-STRAND-BLOODWELL
title: Bloodwell
category: content
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - strand
  - bloodwell
  - returning-blood
  - permanent-progression
  - run-infrastructure
  - mist
  - boss-materials
  - revival
related:
  - CONTENT-STRAND-INTERACTIBLES
  - LORE-RETURNING-BLOOD
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-ITEMS-REWARDS
  - UI-RUN-RESULTS
---

# Bloodwell

## Strand function

The Bloodwell is the Strand's broad permanent-progression station and the visual return point for Akio's Returning Blood reconstruction.

It owns:

1. **Akio** — universal permanent character growth.
2. **Run Infrastructure** — permanent improvements to future-run support and expedition conditions.

Launch scope is **10 Akio nodes + 8 Run Infrastructure nodes**. `PROGRESSION.md` owns the authoritative node roles, unlock cadence, resource boundaries, and final balance deferrals.

## Lore role

The Bloodwell is a controlled Order ritual site later associated with Akio's unprecedented returns. It does not create Returning Blood, power revival, or function as a physical Heart-connected anchor.

Akio's first reconstruction establishes the Strand as the stable return destination; the Bloodwell is the approved presentation point within that hub.

## Visual identity

A carved stone well in the central Strand with old ritual cuts, anti-corruption seals, faint blood-lit seams, offerings, and restrained red light from below. It should feel sacred and consequential rather than like a generic RPG skill tree.

## Permanent progression ownership

### Akio — 10 nodes

The launch Akio package is organized around:

- **3 foundation nodes:** Vitality, Composure, Spirit Reserve,
- **4 combat-stability nodes:** Posture Recovery, Recovery Efficiency, Deflection Stability, Execution Stability,
- **3 regional mastery nodes:** Body Mastery, Resource Mastery, Returning Blood Mastery.

The three mastery nodes use the appropriate regional boss material plus Mist. Exact values remain tuning work.

### Run Infrastructure — 8 nodes

The launch Infrastructure package is:

- Field Rest,
- Shrine Stabilization,
- Expedition Preparation,
- Route Intelligence,
- Salvage Protocol,
- Keeper Passage,
- Twin Passage,
- Heart Passage.

Keeper Passage, Twin Passage, and Heart Passage use the corresponding regional boss material plus Mist.

Run Infrastructure remains one umbrella and is not split into separate Rest, Shrine, route, reward, or transition permanent trees.

It cannot replace Blood Aspect progression, Prosthetic/Relic progression, Technique build choices, or core execution.

## Unlock presentation

The Bloodwell opens after Akio's first return to the Strand.

- **First return:** foundation Akio nodes plus Field Rest and Expedition Preparation.
- **First Keeper defeat:** second Bloodwell band, including Keeper-material mastery gates and additional combat/support nodes.
- **First Twin Maws defeat:** third band, including Twin-Maws-material mastery gates and remaining midgame support.
- **First Shogun defeat / first Binding clear:** final Shogun-material mastery gates become available.

The remaining Binding clears do not add another Bloodwell branch or new permanent station.

## Resource ownership

- **Mist** is the primary Bloodwell currency.
- Exactly **six launch Bloodwell nodes** also use regional boss materials: one Akio mastery node and one Run Infrastructure passage node per regional boss.
- Regional boss materials are mastery keys rather than routine currency.
- **Scrolls** remain primarily Prosthetic/Forge-focused.
- **Gold** is run-only and is not a Bloodwell currency.
- Generic **Boss Emblems** are not current design.

Current Mist cost calibration lives in `PROGRESSION.md` / `ITEMS_AND_REWARDS.md`; exact node prices remain later balance tuning.

## Screen requirements

The Bloodwell interface must support:

- a clear **Akio** category with 10 nodes,
- a clear **Run Infrastructure** category with 8 nodes,
- campaign-gated node visibility/availability,
- relevant Mist and boss-material costs,
- locked / available / purchased / maxed states,
- selected upgrade details.

The interface does not need to imply a huge branching skill tree. A compact staged layout is preferred.

When a major upgrade requires a regional boss material, the requirement should read as a specific scarce mastery component, not as a generic currency balance.

## Relationship to other progression systems

- **Bloodwell:** Akio + Run Infrastructure.
- **Forge Bench:** Prosthetics + Relics.
- **Blood Mirror:** permanent Blood Aspect progression after first Keeper defeat.
- **Shrines:** run-only Resist/Embrace/Tier progression.
- **Techniques:** run-only build progression plus separately owned pool unlocks.

Bloodwell upgrades cannot grant permanent Aspect Tiers or unlock Blood early.

## Revival / return presentation

After failed death-return or successful Binding completion, Akio reforms near the Bloodwell / approved return point.

Persistent resources are already saved when earned; the return/results flow confirms what was retained and what run-only state was lost.

Visual treatment may include a deeper crimson pulse, surface ripple, Mist gathering, brief red-black reconstruction flash, momentary Aspect residue, and controlled return to Strand ambience.

## Technical notes

- Support exactly 10 Akio and 8 Run Infrastructure launch nodes without hard-coding final numerical values.
- Support campaign-gated node bands.
- Support Mist-only upgrades and the six approved Mist + regional-boss-material gates.
- Persistent rewards must not depend on reaching this screen before being saved.
- Reformation should communicate consequence rather than effortless resurrection.
