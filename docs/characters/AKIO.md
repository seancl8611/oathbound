---
id: CHAR-AKIO
title: Akio
category: character
status: approved
authority: primary
last_reviewed: 2026-07-14
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

Akio is Oathbound's player character: a disciplined Order swordsman, the first known bearer of Returning Blood, and the only known person with genuine control over Beast Blood.

## One-sentence fantasy

A quiet, disciplined swordsman who uses the same corrupting power that destroyed the island while preserving the ability to reject its rule.

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
- pouches and ritual tags,
- anti-corruption seals and warding marks.

Cloth, cords, and tags support motion and identity without obscuring the upper-body line, weapon direction, or facing.

## Weapon and gear

The katana is the primary identity weapon. Supporting gear may include utility blade, pouches, seals, vials, cords, and unlockable beast-hunting or prosthetic tools tied to Order methods.

The base body supports add-on tools without requiring a full character redesign.

## Personality and narrative presentation

Akio is a quiet protagonist. He should not explain every theme or discovery through long speeches.

His character is communicated through:

- short, deliberate responses,
- silence and restraint,
- actions and refusals,
- changing relationships with Strand NPCs and the Order,
- physical signs of Returning Blood,
- and major decisions during the campaign.

His exact personal motivation, emotional arc, and relationship to the Shogun remain part of the story-spine design lock.

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

Akio is not immune to Beast Blood. His resolve and the Order's anti-corruption warding are the current required ingredients in the unprecedented condition that becomes Returning Blood.

The exact event and mechanism remain under design lock. Resolve is necessary, but it is no longer treated as the complete explanation by itself.

Other bearers may retain intelligence, humanity, ambitions, martial skill, or the ability to trigger mutations deliberately. Those qualities do not equal true control. Ordinary bearers ultimately lose the ability to reject Beast Blood or act against its continuation.

Akio remains uniquely capable of choosing how the Blood is expressed. He can Resist escalation, consciously Embrace power, express different Blood Aspects, return toward a controlled baseline, and continue opposing the Heart itself.

Returning Blood rebuilds and empowers him, but repeated use preserves the danger that his control may fail and that he may approach the beast, wraith, hollow, or unstable states seen elsewhere on the island.

## Revival identity

Akio is the first known warrior to return from Beast Blood death with body and identity intact.

- On failed runs, Returning Blood reforms him at the Strand.
- On successful runs, he defeats the Shogun, reaches the protected Heart, damages one persistent layer, and is destroyed or expelled before reforming at the Strand.
- Temporary run-state is burned away; permanent progression and persistent campaign damage survive.

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
- Akio is the only known bearer with genuine control over Beast Blood.
- Do not equate another character's retained intelligence or deliberate mutation use with Akio's sovereignty.
- Akio should not become a heavily expositional protagonist.
