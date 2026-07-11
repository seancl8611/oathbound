---
id: CONTENT-AREA1-BLIGHTED-HOUNDS
title: Blighted Hounds
category: content
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - area-1
  - hushiro
  - hounds
  - pack-pressure
related:
  - CONTENT-AREA1-ENEMIES
  - GAMEPLAY-COMBAT
  - ART-MILESTONE-01
---

# Blighted Hounds

## Gameplay role

Fast, low-health pack fighters that create rush-down pressure through circling, threatening proximity, and one coordinated lunge at a time.

## One-sentence fantasy

A village working dog corrupted into a fast aggressive animal: recognizably canine, recognizably wrong, built to spot, lunge, and die.

## Lore context

These were guard dogs, herders, ratcatchers, and camp animals tied to village routines. They were among the first creatures to turn. Beast Blood preserved functional pack instinct rather than human duty: one presses, one circles, and one waits for weakness.

## Visual identity

- lean half-starved working-dog frame,
- matted dark or patchy fur,
- exposed sinew in restrained areas,
- stretched muzzle and exposed gums,
- wrong-bright eyes,
- ragged collars, rope remnants, and scars.

They remain village dogs rather than giant wolves or fantasy demons.

## Silhouette

Low, angular, coiled, and fast. Pronounced shoulders, long forelimbs, narrow torso, raised hackles, and extended muzzle. Idle and windup compress the body; the lunge stretches it into a clean forward line.

## Attack language

- circling and orbit pressure,
- short snap or bite in the full roster,
- committed readable lunge,
- exposed recovery,
- re-entry into pack behavior.

Only one hound should normally commit to the primary lunge while the others reposition and preserve pressure.

## Corruption language

Widened jaws, blood-dark mouth, wrong-bright eyes, taut facial skin, and sharpened animal instinct. The body is more visibly altered than Hushiro's soldiers but remains grounded.

## Combat readability

The active attacker's crouch must look like a coiled spring. The lunge is fast only after that clear preparation. Recovery must read as a deliberate punish window.

## Full-game animation set

- idle and snarl/intimidation variant,
- walk/stalk/circle locomotion,
- run,
- bite windup and bite,
- lunge windup, lunge, and recovery,
- hurt,
- parried recoil,
- stagger or punish state,
- deathblow-ready,
- deathblow,
- death.

## Milestone 1 delivery subset

| Animation | Working frames | Readability purpose |
|---|---:|---|
| `idle` | 4–6 | Low tense crouch with raised hackles |
| `run` | 6–8 | Fast committed pursuit |
| `lunge_windup` | 4–6 | Unmistakable coiled-spring tell |
| `lunge` | 3–4 | Fast forward airborne commitment |
| `lunge_recovery` | 4–6 | Slow open vulnerable window |
| `hurt` | 2–3 | Quick damage recoil |
| `death` | 6–10 | Clear collapse and held dead frame |

## Milestone 1 approval criteria

- Lunge windup teaches the player when to evade or respond.
- Lunge recovery is visibly punishable.
- Silhouette is fast, low, and distinct from every upright humanoid.
- Run, windup, active lunge, recovery, and death cannot be confused.

## Technical notes

Working sprite height is 64–80 px. Use an AttackDirector or equivalent token system so only one hound performs the main lunge at a time. Orbiting hounds threaten and reposition without unreadable dogpiling. The polished Milestone 1 brief deliberately uses a lean animation subset; bite, parry, stagger, and deathblow-specific states remain full-game scope rather than silently expanding the first contractor batch.
