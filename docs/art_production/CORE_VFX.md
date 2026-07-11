---
id: ART-CORE-VFX
title: Core Combat and Corruption VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-10
topics:
  - vfx
  - parry
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
  - ART-MILESTONE-02
---

# Core Combat and Corruption VFX

Effects are scoped separately from character art. Shared combat and corruption cues must strengthen readability and system identity without obscuring silhouettes, telegraphs, or safe-space information.

## VFX groups

| Group | Examples |
|---|---|
| Combat core FX | Sword slash, hit spark, parry spark, posture break, deathblow cue |
| Stance / weapon FX | Storm, Frost, Hex, Ember, Shadow, prosthetic or skill FX |
| Boss-specific FX | Phase transitions, arena cues, empowered attacks, special deaths |

Frequent cues stay compact, directional, and fast. Stronger presentation is reserved for posture breaks, deathblow openings, Shrine decisions, phase transitions, and other major state changes.

## Parry Spark

### Gameplay purpose

Confirms a successful parry immediately and communicates that the incoming attack was correctly deflected and the exchange shifted in the player’s favor.

### Visual fantasy

A clean steel-on-steel deflect: a sharp white-hot contact point, bright metallic sparks, and a brief angular flash. It represents precision and weapon contact rather than magic, blood, or explosive force.

### Timing and readability

One strong impact frame followed by a very short falloff. It must be instantly distinguishable from a normal hit spark, weapon trail, or blood impact, including in busy melee situations.

### Layering and usage

Spawn at the exact weapon-contact point above character and weapon layers. Keep the brightest core tight to impact while small sparks follow the strike angle. Use universally for successful melee parries, with only slight intensity scaling for heavy attacks or boss deflects.

### Technical notes

Keep it compact, directional, and gameplay-first. Avoid large circular bursts, smoke, glyphs, blood-heavy accents, or unnecessary color variation.

## Posture Break Cue

### Gameplay purpose

Shows that an enemy’s posture has broken and the enemy is now vulnerable.

### Visual fantasy

A quick body-centered break flash with a small cracked ring and several sharp metallic sparks.

### Timing and readability

Very short, slightly larger and longer than the Parry Spark, but still fast to clear. It must not be mistaken for a normal hit or successful parry.

### Layering and usage

Spawn on the enemy’s chest or center body above the sprite. Use for standard enemies, elites, minibosses, and bosses whenever posture fully breaks.

### Technical notes

Avoid large explosions, heavy smoke, or overly magical presentation. Its single job is to communicate that the enemy has been opened.

## Deathblow Cue

### Gameplay purpose

Shows that an enemy is fully available for execution.

### Visual fantasy

A sharp blood-red mark or flash over the enemy that reads as a final kill opening.

### Timing and readability

Immediate and short, but more noticeable than the Posture Break Cue. It stays only long enough for the player to recognize the opening. It must stand apart from hit, parry, and posture-break effects.

### Layering and usage

Center over the enemy’s upper body, slightly above the sprite. Use whenever a standard enemy, elite, miniboss, or applicable boss becomes deathblow-ready.

### Technical notes

Use red as the main accent and keep the shape clean, sharp, and restrained rather than decorative or oversized.

## Corruption Full Cue

### Gameplay purpose

Shows that Corruption is full and can be resolved at the next Shrine.

### Visual fantasy

A subtle dark-crimson pulse around Akio and the HUD meter, like pressure waiting to be resisted or accepted.

### Timing and readability

A continuous low-frequency pulse while Corruption remains full, ending immediately after Shrine resolution. It must remain distinct from low health, low Spirit, boss empowerment, and other urgent states.

### Layering and usage

Attach to Akio and the HUD Corruption meter. A secondary restrained world tint is optional. The cue remains active across room types until the next Shrine.

### Technical notes

It must be quiet enough not to interfere with combat, but visible enough that the player never misses the Shrine-ready state.

## Embrace Transformation Cue

### Gameplay purpose

Shows Blood Aspect Tier increasing at a Shrine.

### Visual fantasy

A controlled blood-red surge travels from the Shrine into Akio, communicating further acceptance of Beast Blood without loss of composure.

### Timing and readability

One short ritual beat: Shrine flare, player ignition, then settlement into the new Tier-state aura. It must clearly read as accepting more power rather than stabilizing.

### Layering and usage

Begin on the Shrine, briefly cover Akio’s full body, then settle into the equipped Aspect’s new Tier overlay. Trigger only when Embrace is selected.

### Technical notes

The effect must hand off cleanly to the persistent Aspect-specific Tier presentation so the post-choice state remains readable.

## Resist Stabilization Cue

### Gameplay purpose

Shows Corruption being calmed and restrained.

### Visual fantasy

A cooler, paler ritual light that pushes Beast Blood back rather than drawing it inward.

### Timing and readability

A single short stabilizing pulse ending in a brief healing or recovery beat. It should feel like an exhale rather than an intake and must read as holding the line rather than gaining power.

### Layering and usage

Use the Shrine and Akio’s body with a lighter, less invasive presentation than Embrace. Trigger only when Resist is selected.

### Technical notes

Pair with the project’s healing or recovery pickup language so the support reward feels familiar while remaining visually distinct from Embrace.

## Source boundary

The Wolf Prey Mark brief begins on page 105 but continues beyond the requested range. Its detailed migration is deferred to the next source-page batch rather than split across two updates.
