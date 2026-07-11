---
id: CONTENT-AREA1-HOLLOW
title: Hollow
category: content
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - area-1
  - hushiro
  - civilian
  - swarm
related:
  - CONTENT-AREA1-ENEMIES
  - GAMEPLAY-COMBAT
  - ART-MILESTONE-01
---

# Hollow

## Gameplay role

Low-health civilian-corruption swarm enemy. Individually fragile, but dangerous through numbers, interruption pressure, and combination with sturdier threats.

## One-sentence fantasy

A ruined civilian whose identity and competence are almost gone, leaving a slumped human shape that still tries to harm the player without remembering how to do it well.

## Lore context

Hollows are Hushiro's ordinary people: fishermen, farmers, laborers, tradespeople, and families. They had no military doctrine for Beast Blood to preserve. Corruption reduced them to appetite, panic, and crude violence. They linger near homes, alleys, and work sites because those places were once familiar.

## Visual identity

- emaciated pallid villagers,
- torn work tunics, aprons, rough robes, and common garments,
- bare feet or wrapped lower legs,
- hunched backs and gaunt arms,
- ruined mouths and blood-dark gums,
- unmistakably civilian rather than military.

The player should feel that each Hollow used to be someone.

## Silhouette

Thin, crooked, slumped, and unstable: narrow torso, jutting shoulders, reaching arms, bent spine, and uneven stance. Groups form a messy human mass rather than a formation.

## Attack language

- slow lurch or shamble,
- crude telegraphed grab or swing,
- full-game variants may add a short rush, bite, or lunge,
- easy interruption and fast defeat.

The threat is quantity and timing disruption, not individual move complexity.

## Corruption language

Hollow cheeks, visible tendon and bone, stretched mouth, inflamed or wrong-bright eyes, pallid skin, and hunger-driven body language. The horror is ordinary personhood collapsing into consumption.

## Combat readability

The player should understand immediately that one Hollow is pitiable and easy to dispatch, while several can interrupt, crowd, and complicate a duel with a stronger enemy.

## Full-game animation set

- idle and cluster/feeding ambient variant,
- wander or shamble,
- run or short rush where used,
- crude attack or grab,
- bite or lunge variants where supported,
- hurt,
- parried recoil,
- stagger,
- deathblow-ready,
- deathblow,
- death.

## Milestone 1 delivery subset

| Animation | Working frames | Readability purpose |
|---|---:|---|
| `idle` | 4–6 | Slumped body language, not individually threatening |
| `walk` | 6–8 | Slow unsteady lurch with a shorter step than the Swordsman |
| `attack` | 4–6 | Crude telegraphed grab or swing |
| `hurt` | 2–3 | Quick feedback and easy interruption |
| `death` | 4–6 | Fast collapse for a fragile swarm unit |

## Milestone 1 approval criteria

- Reads fragile and pitiable rather than formidable.
- Silhouette is distinct from Corrupted Swordsman at similar scale.
- Attack is readable but visibly unskilled.
- Hurt and death resolve quickly enough for group combat.

## Technical notes

Working sprite height is 72–96 px. Keep production modular and inexpensive enough for group use. Crowd spacing should allow messy pressure without unreadable overlap. The polished Milestone 1 brief uses a deliberately small animation set; advanced lunge, parry, deathblow, and ambient variants remain later full-game scope unless separately quoted.
