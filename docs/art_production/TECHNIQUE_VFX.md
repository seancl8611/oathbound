---
id: ART-TECHNIQUE-VFX
title: Technique VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-08-11
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
- **combat feedback:** readable effects that show buildup, echo slashes, Rupture, Seal stacks, Rift development, Burst readiness / recharge, altered footprints, or other approved family behavior.

The former elemental stance families remain removed from scope. Prosthetic effects remain in their own visual system and are not part of Technique-family production.

## Reuse hierarchy

Before commissioning a new Technique effect, use this order:

1. approved base sword trail, parry, posture, deathblow, or movement cue,
2. selected Blood Aspect VFX language where compatible,
3. established Returning Blood / Order / wound / ritual language,
4. small modular family overlay, marker, meter, pulse, trail, rupture, seal, fracture, burst, or echo,
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

Seal uses visible discrete marks on the enemy rather than a meter.

The visual progression should read clearly as:

1. one violet seal mark appears,
2. a second mark appears and a faint binding line or pattern connects them,
3. the third mark completes the symbol,
4. the completed pattern visibly closes or tightens while the enemy is Bound,
5. the pattern breaks or fades when Bind ends and the stacks reset.

The player must be able to distinguish one, two, and three Seals without relying on violet color alone. The completed Bind cue must not resemble a stun, posture break, or Rupture proc.

### Ivory / blade circle — Rift

Rift must read as **one supernatural fracture mark becoming increasingly unstable**, not as literal sword penetration, a projectile, or a visible stack counter.

The visual progression should support:

1. a thin ivory fracture-line appears across the enemy sprite after a qualifying application,
2. further Rift intensity makes that same line spread / branch and become more prominent,
3. a developed Rift may briefly pulse or flash as its opening approaches,
4. the Rift opens through a short violent split / internal flash centered on the target,
5. the mark disappears immediately after the Health-damage burst.

Rift must not depend on perfect sprite alignment or make it look as if Akio's sword literally passes through the enemy. It also must not resemble Echo: there is no second sword swing or delayed slash traveling across the scene.

Exact line shape, branch count, pulse timing, fuse readability, and intensity tiers remain future VFX / tuning work.

### Crimson / split blood drop — Burst

Burst needs an immediate, heavy close-range AoE language plus a readable target-specific ready / recharge state.

Working presentation:

1. a compact split-blood-drop marker or equivalent family cue indicates that the target is Burst-ready,
2. a qualifying trigger flashes that cue and forms a concentrated crimson impact on / under the target,
3. a short, heavy radial blast expands from the target and disappears immediately,
4. after Burst, the target's marker becomes visibly dim / separated / incomplete during recharge,
5. the marker closes or brightens back into the ready state as recovery completes.

The primary target remains visibly inside the blast so the effect reads as useful against isolated enemies and bosses, not only groups.

The base Burst effect is **not** a persistent damage zone. Persistent crimson ground effects may be introduced later by supporting or higher-rarity Techniques.

Exact marker placement, radial shape, blast radius, recharge animation, and audio timing remain future UI/VFX work. Ready versus recharging must remain readable without relying only on crimson color.

## Core combat-slot treatment

### Basic Attack Techniques

Frequent effects must stay visually light enough for repeated use. Favor compact echoes, buildup cues, marks, target-state feedback, or cooldown-gated bursts rather than uncontrolled large effects on every hit.

### Held Attack Techniques

Held attacks may support larger fixed geometry, stronger impact effects, stronger Rift application, heavier Burst variants, or other high-commitment payoffs.

### Dash Techniques

Effects must remain tied to the actual dash path, start point, end point, or Dash Attack contact without implying extra invulnerability or hidden movement.

### Parry / Counter Techniques

Never widen the apparent parry timing beyond the implemented rule. Technique feedback should occur after or around the successful defensive read.

### Deathblow Techniques

These may carry larger effects because they trigger less often. The Deathblow cue stays primary, with Technique effects resolving after the execution read is clear.

## Supporting Techniques

Supporting effects should normally modify an existing family cue rather than introduce a new visual language.

This layer is deferred until the five-by-five direct Technique matrix is stable.

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
- Seal marks must remain readable on moving enemies and must not obscure essential enemy animation cues.
- Rift marks must remain readable without requiring exact attacker / target alignment and must not be mistaken for an Echo slash.
- Burst readiness and recharge must be readable per affected target while keeping marker clutter low in groups.
- Burst spectacle must stay bounded so several nearby enemies do not create unreadable chain explosions.
- Automatic room-wide spectacle is outside the intended combat identity unless explicitly approved as an exceptional effect.
- Exact timing, footprint, trigger, and value remain owned by gameplay and implementation documentation.

## Delivery planning

Do not quote the full set of unique Technique icons or bespoke effects until the direct five-by-five family roster is stable.

Every production-ready Technique must specify its combat slot or supporting role, trigger, target / footprint, existing VFX reuse, added family cue, refinement difference, Aspect interaction, and mixed-build readability risk.
