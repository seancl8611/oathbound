---
id: CHAR-AKIO
title: Akio
category: character
status: approved
authority: primary
last_reviewed: 2026-07-10
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

Akio should read as lean, dark, layered, and dangerous. His silhouette combines:

- wrapped limbs,
- weathered outer cloth and scarf elements,
- compact armor reinforcement,
- practical cords, pouches, seals, and tags,
- a strong katana read at the hip.

He should feel grounded and restrained rather than noble, ornate, or flamboyant.

## Armor and clothing

Akio wears worn Order field gear built for repeated crossings and survival rather than ceremony:

- layered robes,
- battered outer cloth,
- scarf wrapping,
- light lamellar reinforcement,
- leather and cords,
- pouches and ritual tags.

Cloth, cords, and tags should support motion and identity without obscuring the upper-body line, weapon direction, or facing.

## Weapon and gear

The katana is the primary identity weapon. Supporting gear may include:

- utility blade,
- pouches,
- seals,
- vials,
- cords,
- unlockable beast-hunting or prosthetic tools tied to Order methods.

The base body should support add-on tools without requiring a full character redesign.

## Personality in motion

Akio moves with disciplined efficiency and pressure-held control:

- measured readiness,
- compact attack mechanics,
- controlled recovery,
- minimal wasted motion,
- clear one-handed and two-handed sword presentation,
- quick directional dashes without acrobatic flourish.

He should always read as a trained hunter rather than a showy swordsman.

## Corruption relationship

Akio is not immune to Beast Blood. It claimed him deeply enough to transform him, but his resolve prevented the loss of identity. The Blood submitted and became Returning Blood.

Returning Blood rebuilds and empowers him, but repeated use creates the danger that he may approach the same beast, wraith, hollow, or servant states that consumed others.

## Revival identity

Akio is the first known warrior to return from Beast Blood death with body and identity intact.

- On failed runs, Returning Blood reforms him at the Strand.
- On successful runs, it reconstructs him after the Wellspring sacrifice and the severing of one layer of the Shogun's blood-oath.
- Temporary run-state is burned away; permanent progression survives.

## Combat readability

The player must be able to read Akio's:

- weapon path,
- facing and stance direction,
- parry and block posture,
- attack startup and recovery,
- deathblow setup,
- current Aspect/Tier influence,
- prosthetic/tool activation.

## Required animation library

Core source animation names:

- `idle`
- `walk`
- `quick_slash`
- `cross_cut`
- `heavy_cleave`
- `hold_thrust_charge`
- `hold_thrust_release`
- `counter_cut`
- `dash`
- `dash_slash`
- `parry`
- `block`
- `hurt`
- `death`
- `deathblow`
- `prosthetic_use`
- `chained`
- `attack_recovery`

Working prosthetic-specific hooks currently referenced by the source bible:

- `mirror_umbrella_guard`
- `mist_raven_vanish`
- `mist_raven_appear`

These names may be reconciled with the final prosthetic system before contractor delivery, but the base character must support equivalent layered tool states.

## Technical and production notes

- Design for top-down/high-angle readability first.
- Prefer a separate or exceptionally clear katana layer so guard state, direction, and parry timing remain visible.
- Prioritize key poses over costume micro-detail.
- Keep base corruption subtle so later Tier overlays have visual room.
- Support modular eye changes, veins, mist, blood trails, blade glow, aura, and limited silhouette distortion.
- Do not produce separate complete character sheets for every Aspect Tier.

## Canon restrictions

- Akio is not naturally immune.
- Returning Blood is not routine Order practice.
- Blood Aspects are controlled mutations of Returning Blood, not unrelated magical classes.
