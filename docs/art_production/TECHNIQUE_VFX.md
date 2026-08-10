---
id: ART-TECHNIQUE-VFX
title: Technique VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-08-09
topics:
  - techniques
  - vfx
  - combat-readability
  - refinements
  - effect-families
related:
  - GAMEPLAY-TECHNIQUES
  - ART-CORE-VFX
  - ART-ASPECT-VFX
  - ART-ITEM-REWARD-ART
  - ART-MILESTONE-04
---

# Technique VFX

Techniques reshape existing sword actions through repeatable family effects. Their VFX should make run growth readable and exciting while preserving sword arcs, enemy tells, posture state, and Akio's final position.

## Production role

Technique presentation has two layers:

- **selection and build communication:** combat-slot identity, rarity, refinement state, supporting-upgrade relationships, and family symbol / color treatment,
- **combat feedback:** readable effects that show buildup, echo slashes, Rupture, seals, altered footprints, or other approved family behavior.

The former elemental stance families remain removed from scope. Prosthetic effects remain in their own visual system and are not part of Technique-family production.

## Reuse hierarchy

Before commissioning a new Technique effect, use this order:

1. approved base sword trail, parry, posture, deathblow, or movement cue,
2. selected Blood Aspect VFX language where compatible,
3. established Returning Blood / Order / wound / ritual language,
4. small modular family overlay, marker, meter, pulse, trail, rupture, seal, or echo,
5. bespoke effect only when the mechanic cannot read correctly through reuse.

## Current family visual needs

### Pale silver / twin slash — Echo

Echoes should read as delayed additional sword slashes, not as Akio literally replaying the full action.

The visual system must support:

- one delayed echo slash,
- multiple delayed echoes,
- echoes following the original authored attack line,
- and later supporting effects that change echo timing, spread, or strength without obscuring the original hit.

### Gold / cracked crest — Rupture

Rupture needs a readable buildup-and-proc language:

- visible enemy Rupture meter or equivalent buildup cue,
- no misleading ticking-damage treatment during partial buildup,
- clear full-meter trigger,
- strong target impact / posture-break cue,
- compact outward posture shockwave for nearby enemies,
- immediate reset after the proc.

Exact meter placement, crack patterns, radius, and intensity remain future UI/VFX design.

### Violet / binding knot — Seal

Do not finalize Seal VFX until the buildup model is decided. The final system must clearly distinguish partial buildup from the completed Seal effect.

### Ivory and crimson families

Do not commission family-specific VFX until each has a stable scalable mechanic.

## Core combat-slot treatment

### Basic Attack Techniques

Frequent effects must stay visually light enough for repeated use. Favor compact echoes, buildup cues, marks, or target-state feedback rather than large bursts on every hit.

### Held Attack Techniques

Held attacks may support larger fixed geometry, stronger impact effects, or other high-commitment payoffs.

### Dash Techniques

Effects must remain tied to the actual dash path, start point, end point, or Dash Attack contact without implying extra invulnerability or hidden movement.

### Parry / Counter Techniques

Never widen the apparent parry timing beyond the implemented rule. Technique feedback should occur after or around the successful defensive read.

### Deathblow Techniques

These may carry larger effects because they trigger less often. The Deathblow cue stays primary, with Technique effects resolving after the execution read is clear.

## Supporting Techniques

Supporting effects should normally modify an existing family cue rather than introduce a new visual language.

This layer is deferred until the five core family mechanics are stable.

## Refinement treatment

A refinement should look like a small improvement to the same Technique, not a second ability. It may slightly strengthen an existing cue or payoff but should not require a new independent VFX package.

## Family recognition

The families do not require formal names in the UI.

Each approved family should eventually receive a consistent symbol, color treatment, motion language, audio language, and gameplay effect that remains recognizable across several combat slots.

Color alone cannot carry family identity.

## Readability constraints

- Technique feedback cannot hide enemy telegraphs, safe zones, projectiles, posture state, or Akio's final position.
- Multiple Technique effects may trigger close together; effects must layer cleanly.
- Frequent Basic Attack effects require lower visual intensity than rarer Held, Parry, Deathblow, or Legendary payoffs.
- Automatic room-wide spectacle is outside the intended combat identity unless explicitly approved as an exceptional effect.
- Exact timing, footprint, trigger, and value remain owned by gameplay and implementation documentation.

## Delivery planning

Do not quote the full set of unique Technique icons or bespoke effects until the five core family mechanics and slotted roster are stable.

Every production-ready Technique must specify its combat slot or supporting role, trigger, target / footprint, existing VFX reuse, added family cue, refinement difference, Aspect interaction, and mixed-build readability risk.
