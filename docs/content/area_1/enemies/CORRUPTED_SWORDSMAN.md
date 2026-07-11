---
id: CONTENT-AREA1-CORRUPTED-SWORDSMAN
title: Corrupted Swordsman
category: content
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - area-1
  - hushiro
  - melee
  - posture
  - parry
related:
  - CONTENT-AREA1-ENEMIES
  - GAMEPLAY-COMBAT
  - ART-MILESTONE-01
---

# Corrupted Swordsman

## Gameplay role

Baseline melee defender and primary posture/parry teacher for Area 1. He blocks, braces, and punishes impatience, establishing the fair disciplined exchange that later enemies complicate.

## One-sentence fantasy

A village garrison soldier whose manhood is gone but whose uniform, sword grip, and drilled motions continue as a degraded mirror of Akio.

## Lore context

Low-ranking Hushiro soldiers were trained to patrol lanes, defend thresholds, hold formation, and answer pressure with simple military swordwork. Beast Blood erased judgment and selfhood but preserved the reflexes of service. They still walk assigned routes, halt at old posts, and meet intruders through conditioned defense.

## Visual identity

- garrison military uniform clearly distinct from Akio's Order clothing,
- cracked dull red-and-black lacquer armor,
- worn cloth and dirty wrappings,
- damaged light helmet or jingasa,
- standard-issue blade cruder than Akio's katana,
- faded garrison insignia,
- restrained corruption through sunken eyes, pallor, blackened veins, and wrong stillness.

The design should read as a real local conscript rather than an elite samurai or boss archetype.

## Silhouette

Compact, medium-height infantry profile with a visible katana, stable lower-body stance, restrained shoulder armor, and exceptionally clear guard poses. He should look standard, grounded, militarized, and slightly stiffer than Akio.

## Weapon and attack language

- guarded basic slash,
- straight thrust,
- cross-cut,
- running overhead,
- early block or brace,
- counter-swing after a successful guard or deflect interaction.

His technique uses proper fundamentals without flourish. Attack movement may adjust facing early in windup, then should lock before active frames so spacing and dodging remain readable.

## Corruption language

Pallid flesh, dim blood-lit eyes, dried blood in armor seams, delayed head turns, and slight shoulder or joint rigidity. Corruption preserves the military role instead of replacing it with overt mutation.

## Personality in motion

Repetitive patrols, exact stops, conditioned turns, automatic guard response, and committed but economical attacks. He is not feral or expressive; he is trained behavior continuing after thought has ended.

## Combat readability

The player should immediately read:

- guard is active,
- patience and posture pressure are required,
- attacks are fair to parry,
- retaliation may follow careless pressure,
- posture break creates the decisive opening.

Idle, attack windup, attack swing, recovery, block, parried recoil, posture-broken, deathblow-ready, hurt, and death states must remain visually distinct.

## Full-game animation set

- idle and guard idle,
- patrol walk and run,
- alert,
- basic slash and windup,
- thrust and windup,
- cross slash,
- running overhead,
- block/react,
- post-block counter options,
- attack recovery,
- hurt,
- parried recoil,
- stagger and posture break,
- deathblow-ready,
- deathblow,
- death.

## Milestone 1 delivery subset

| Animation | Working frames | Readability purpose |
|---|---:|---|
| `idle` | 4–6 | Armed readiness with slightly broken posture |
| `walk` | 6–8 | Mechanical deliberate approach, not a stagger |
| `attack_windup` | 4–6 | Primary reaction tell; unmistakable from idle |
| `attack_swing` | 3–5 | Fast committed punishment |
| `attack_recovery` | 3–5 | Open safe counter window |
| `block` | 2–3 loop | Sustained guard, visibly different from idle |
| `parried_recoil` | 3–4 | Weapon and body snapped wide after player parry |
| `posture_broken` | 3–6 loop | Open vulnerable body, clearly not in stance |
| `deathblow_ready` | 2–4 loop | Held execution opening |
| `hurt` | 2–3 | Quick damage recoil, distinct from parried recoil |
| `death` | 6–10 | Clear fall and held final frame |

## Milestone 1 approval criteria

- Silhouette cannot be mistaken for Akio.
- Attack windup gives a readable decision window.
- Idle, windup, parried recoil, posture-broken, deathblow-ready, hurt, and death are distinct at a glance.
- Posture-broken reads as a temporary opening rather than injury or defeat.

## Technical notes

Working sprite height is 96–128 px, matching Akio's general scale. This enemy is the foundational readability benchmark for humanoid combat. Soldier variants may tune counter chance, lunge distance, thrust frequency, post-block aggression, and whiff recovery while sharing common base logic. Counter decisions should consider range, posture, recent player attacks, and personality rather than triggering after every block.
