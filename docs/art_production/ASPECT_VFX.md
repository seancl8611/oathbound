---
id: ART-ASPECT-VFX
title: Blood Aspect VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - blood-aspects
  - wolf
  - wraith
  - ronin
  - vfx
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - CHAR-AKIO
  - ART-MILESTONE-04
---

# Blood Aspect VFX

These effects communicate the equipped Blood Aspect's tactical identity. They are information cues first and spectacle second. All three families layer onto Akio's approved base animation library and must preserve attack direction, enemy telegraphs, and the player's final position.

## Wolf Aspect — Prey Mark

### Gameplay purpose

Shows the selected prey target and the buildup of pressure from consecutive attacks.

### Visual fantasy

A restrained red predator mark over one enemy, with a faint blood-scent trail or pressure streak connecting Akio's aggression to that target.

### Timing and states

- Appears when prey is selected.
- Persists while the target lives or until the mark expires or changes target.
- Pressure intensity swells with consecutive hits.
- Supports distinct healthy, wounded, and finishable states so wounded-prey bonuses remain readable.

### Readability requirements

The marked enemy must remain unmistakable in mixed encounters. The cue cannot be confused with Burn, Shock, Hex, deathblow availability, or generic damage marks.

### Layering and usage

Attach the primary mark above the target's upper body or head. Optional pressure streaks remain faint and close to Akio's blade path. The effect is active only while Wolf Aspect is equipped.

### Technical notes

Use one consistent target-mark language with clearly stepped intensity. Avoid large rings, full-body red washes, or long screen-spanning trails.

## Wraith Aspect — Afterimage and Mist-Step

### Gameplay purpose

Communicates perfect-dodge and reposition identity, including where Akio disappeared and where he finished.

### Visual fantasy

A pale-red body afterimage at the starting point, a compact mist-step trace, and a short reappearance cue at the final position.

### Timing and escalation

- Perfect dodge uses a very fast vanish-and-reappear blip.
- Higher-Tier reposition effects may linger slightly longer or travel farther, while remaining compact.
- The reappearance point must become readable immediately.

### Readability requirements

The player must always know Akio's final position. The effect cannot obscure incoming attacks, enemy silhouettes, backstrike windows, or hazard boundaries. It must remain distinct from the Mist Raven prosthetic and ordinary dash effects.

### Layering and usage

Place the first afterimage on Akio's starting body position, a subtle mist bridge between positions, and a compact re-form cue at the destination. Active only while Wraith Aspect is equipped.

### Technical notes

Use a few strong body-shaped afterimages rather than a broad fog smear. Positional clarity takes priority over particle density.

## Ronin Aspect — Parry, Counter, and Focus Cues

### Gameplay purpose

Communicates Ronin's disciplined parry, Counter Cut, and deathblow-triggered Focus effects.

### Visual fantasy

- A clean steel-bright enhancement on successful parry.
- A brighter, brief flash on Counter Cut.
- A calm restrained red Focus aura after deathblow.

### Timing and escalation

- Parry enhancement is instantaneous.
- Counter Cut flash follows the riposte blade path and clears quickly.
- Focus is a short post-deathblow aura whose duration may increase by Tier.

### Readability requirements

Parry, Counter Cut, and Focus must never collapse into one generic red effect. Ronin additions layer on top of the shared Parry Spark and Deathblow Cue rather than replacing them.

### Layering and usage

Parry and Counter Cut effects anchor to weapon contact and blade path. Focus attaches to Akio's body after a successful deathblow. Active only while Ronin Aspect is equipped.

### Technical notes

Ronin is the least visually noisy Aspect. Favor precision, timing, and clean contact emphasis over persistent aura volume.

## Shared constraints

- Aspect effects use modular overlays and VFX, not separate complete character sheets.
- Tier escalation should increase clarity and intensity without turning the three Aspects into color swaps.
- Wolf owns marked-target pressure, Wraith owns displacement and afterimage, and Ronin owns disciplined contact and Focus.
- Effects must remain readable over every regional palette and during boss encounters.
