---
id: CHAR-AKIO
title: Akio
category: character
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - akio
  - player-character
  - returning-blood
  - animation
  - order
related:
  - LORE-RETURNING-BLOOD
  - LORE-THE-ORDER
  - GAMEPLAY-COMBAT
  - GAMEPLAY-BLOOD-ASPECTS
  - ART-MILESTONE-01
---

# Akio

Akio is Oathbound's player character: a disciplined Order swordsman and the first known bearer of Returning Blood.

## One-sentence fantasy

A disciplined swordsman who forced Beast Blood to obey him and now uses its mutations without surrendering his identity.

## Gameplay role

Akio carries the complete player combat language:

- katana combo and contextual attack kit,
- block and timed parry,
- posture pressure and deathblows,
- dash and Dash Slash,
- Counter Cut after a successful deflect,
- prosthetic/tool activation,
- run-shaping Blood Aspect mutation.

## Visual silhouette

Akio should read as lean, dark, layered, functional, and quietly dangerous. He is a working warrior of a religious-military Order, not a noble hero or flamboyant anime swordsman.

His silhouette combines:

- wrapped limbs and layered working clothes,
- weathered outer cloth and restrained scarf elements,
- compact reinforcement rather than heavy plate,
- practical cords, pouches, seals, and tags,
- a strong readable katana at the hip,
- a subtle tool pouch, strap, or hip slot suggesting prosthetic capacity without depicting one specific tool.

## Armor and clothing

Akio wears worn Order field gear built for repeated crossings and survival rather than ceremony:

- layered robes,
- battered outer cloth,
- scarf wrapping,
- light lamellar reinforcement,
- leather and cords,
- pouches and ritual tags.

Cloth, cords, and tags support motion and identity without obscuring the upper-body line, weapon direction, or facing.

## Weapon and gear

The katana is the primary identity weapon. Supporting gear may include utility blade, pouches, seals, vials, cords, and unlockable beast-hunting or prosthetic tools tied to Order methods.

The base body supports add-on tools without requiring a full character redesign.

## Personality in motion

Akio moves with disciplined efficiency and pressure-held control:

- measured readiness,
- compact attack mechanics,
- controlled recovery,
- minimal wasted motion,
- clear one-handed and two-handed sword presentation,
- quick directional dashes without acrobatic flourish.

His gait is grounded and weighted rather than sneaking. His combat stance is compact, not theatrical. He always reads as a trained hunter rather than a showy swordsman.

## Corruption relationship

Akio is not immune to Beast Blood. It claimed him deeply enough to transform him, but his resolve prevented the loss of identity. The Blood submitted and became Returning Blood.

Returning Blood rebuilds and empowers him, but repeated use creates the danger that he may approach the same beast, wraith, hollow, or servant states that consumed others.

## Revival identity

Akio is the first known warrior to return from Beast Blood death with body and identity intact.

- On failed runs, Returning Blood reforms him at the Strand.
- On successful runs, it reconstructs him after the Wellspring sacrifice and the severing of one layer of the Shogun's blood-oath.
- Temporary run-state is burned away; permanent progression survives.

## Combat readability

The player must read Akio's weapon path, facing, stance direction, parry and block posture, attack startup and recovery, deathblow setup, current Aspect/Tier influence, and prosthetic activation.

The three base combo attacks increase visibly in commitment:

1. Quick Slash — short, clean, low commitment.
2. Cross Cut — wider diagonal coverage and medium commitment.
3. Heavy Cleave — slower windup, heavier follow-through, and longer recovery.

The deathblow is decisive and slightly longer than the combo finisher, serving as the learned payoff at the end of an exchange.

## Required base animation library

- `idle`
- `walk`
- `dash`
- `quick_slash`
- `cross_cut`
- `heavy_cleave`
- `hold_thrust_charge`
- `hold_thrust_release`
- `counter_cut`
- `dash_slash`
- `block`
- `parry`
- `prosthetic_use`
- `hurt`
- `death`
- `deathblow`
- `chained`
- `attack_recovery`

Working prosthetic-specific hooks:

- `mirror_umbrella_guard`
- `mist_raven_vanish`
- `mist_raven_appear`

## Milestone 1 animation delivery baseline

| Animation | Working frames | Readability purpose |
|---|---:|---|
| `idle` | 4–6 | Neutral combat loop; katana orientation stays clear |
| `walk` | 6–8 | Grounded weighted locomotion |
| `dash` | 4–6 | Strong directional commitment, distinct from walk |
| `quick_slash` | 5–7 | Fast opener and shortest trail |
| `cross_cut` | 6–8 | Wider diagonal second hit |
| `heavy_cleave` | 8–12 | Slowest windup, strongest follow-through, longest recovery |
| `hold_thrust_charge` | 4–6 + loop | Visible tension buildup |
| `hold_thrust_release` | 5–7 | Decisive forward lunge |
| `counter_cut` | 5–7 | Fast post-parry riposte |
| `dash_slash` | 5–7 | Dash momentum continues into the cut |
| `block` | 2–3 loop | Sustained guard, distinct from idle and parry |
| `parry` | 3–5 | Sharp defensive timing pose |
| `prosthetic_use` | 4–6 | Generic off-hand activation pose |
| `hurt` | 2–3 | Quick recoil, not a stance change |
| `death` | 8–12 | Clear fall with held final frame |
| `deathblow` | 10–14 | Decisive execution with a clean payoff frame |

Frame counts are working contractor estimates. Final timing is tuned in Godot and may use held or repeated frames without requiring redraws.

## Milestone 1 approval criteria

- Akio reads clearly at gameplay scale.
- Quick Slash, Cross Cut, and Heavy Cleave have unmistakably different arc weight.
- Heavy Cleave visibly communicates commitment and recovery.
- Block, parry, hurt, and idle cannot be confused.
- Deathblow has weight, decision, and punctuation.
- Hurt and death do not look interchangeable.

## Technical and production notes

- Design for top-down/high-angle readability first.
- Working sprite height is 96–128 px.
- Prefer a separate or exceptionally clear katana layer so guard state, direction, and parry timing remain visible.
- Prioritize key poses over costume micro-detail.
- Keep base corruption subtle so later Tier overlays have visual room.
- Support modular eye changes, veins, mist, blood trails, blade glow, aura, and limited silhouette distortion.
- Use a separate soft elliptical ground-shadow sprite.
- Do not produce separate complete character sheets for every Aspect Tier.

## Canon restrictions

- Akio is not naturally immune.
- Returning Blood is not routine Order practice.
- Blood Aspects are controlled mutations of Returning Blood, not unrelated magical classes.
