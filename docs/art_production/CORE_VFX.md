---
id: ART-CORE-VFX
title: Core Combat and Corruption VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-21
topics:
  - vfx
  - parry
  - hit-spark
  - sword-trail
  - posture-break
  - deathblow
  - corruption
  - shrine
related:
  - GAMEPLAY-COMBAT
  - GAMEPLAY-CORRUPTION-SHRINES
  - UI-HUD
  - UI-SHRINE
  - ART-MILESTONE-01
---

# Core Combat and Corruption VFX

Shared combat cues must strengthen readability without obscuring silhouettes, attack direction, recovery frames, or safe space. Frequent effects remain compact. Stronger presentation is reserved for posture breaks, execution openings, Shrine decisions, and boss transitions.

## Milestone 1 combat bundle

### VFX-001 — Parry Spark

**Purpose:** immediate confirmation of a successful deflect.

**Working frames:** 4–6.

- Standard deflect: compact directional burst.
- Perfect parry: brighter core and stronger punctuation.
- Must remain distinct from Hit Spark without depending on sound.
- No broad smoke cloud, circular explosion, or magical glyph.

### VFX-002 — Hit Spark

**Purpose:** ordinary damage confirmation.

**Working frames:** 3–5.

- Smaller and quieter than Parry Spark.
- Clears quickly.
- Must not compete with posture break, deathblow, or boss-transition cues.

### VFX-003 — Deathblow Cue

**Purpose:** persistent confirmation that an execution is available.

**Working frames:** 3–4 frame loop for the valid window.

- Anchored above or around the enemy's upper body.
- Uses a ritual blood-seal or restrained execution-mark language.
- Remains visible in crowded combat.
- Must not resemble a generic exclamation icon.

### VFX-004 — Sword Trail

**Purpose:** clarify Akio's base blade paths.

**Working frames:** approximately 4–6 per swing family.

Required variants:

- Quick Slash — shortest and lightest,
- Cross Cut — wider diagonal path,
- Heavy Cleave — weightiest and most committed.

Trails reinforce the weapon path and clear before obscuring recovery or the next attack.

### VFX-005 — Posture Break Cue

**Purpose:** show that enemy posture has fully broken and a vulnerability state has begun.

**Working direction:** quick body-centered break flash with a compact cracked ring and sharp metallic fragments.

- Slightly larger and longer than Parry Spark.
- Clears quickly.
- Distinct from hit, parry, hurt, death, and Deathblow Cue.
- The break cue communicates that the enemy opened; the persistent Deathblow Cue communicates that execution remains available.

VFX-005 is included in Milestone 1 Batch 2 with the Corrupted Swordsman and Deathblow Cue because that batch establishes the complete posture-break-to-execution read on the baseline humanoid enemy.

## Corruption and Shrine cues

### Corruption Full Cue

Shows that Corruption is full and may be resolved at the next Shrine.

- low-frequency dark-crimson pressure around Akio and the meter,
- ends immediately after Shrine resolution,
- distinct from low HP, depleted Spirit, Burn, Shock, or boss empowerment.

### Embrace Transformation Cue

Communicates a Blood Aspect Tier increase.

- Shrine flare,
- controlled blood-red surge into Akio,
- brief full-body ignition,
- settlement into the new Aspect and Tier state.

### Resist Stabilization Cue

Communicates stabilization without Tier advancement.

- cooler pale ritual pulse,
- outward release of pressure,
- brief recovery beat,
- clearly reads as restraint rather than empowerment.

## Delivery and testing

Every effect requires source files, transparent frames or sheets, timing notes, palette continuity, and clean Godot import.

Effects must remain readable across Hushiro, Yomori, and Kagutsuchi backgrounds with HUD, damage numbers, screen shake, multiple enemies, and environmental atmosphere active.