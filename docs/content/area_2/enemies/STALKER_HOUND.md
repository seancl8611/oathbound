---
id: CONTENT-AREA2-STALKER-HOUND
title: Stalker Hound
category: content
status: approved
authority: primary
last_reviewed: 2026-07-10
topics:
  - area-2
  - hound
  - elite
  - mist-stalk
  - pounce
related:
  - CONTENT-AREA2-ENEMIES
  - CONTENT-AREA1-BLIGHTED-HOUNDS
  - GAMEPLAY-COMBAT
  - ART-MILESTONE-05
---

# Stalker Hound

## Gameplay role

Elite Area 2 hound variant. It retains upgraded Blighted Hound pressure and adds an occasional mist-stalk pounce that tests awareness, spacing, dodge timing, and parry confidence. It should usually appear alone or as the room's primary threat.

## One-sentence fantasy

A blood-corrupted forest predator that fights like a familiar hound until it slips into the mist, circles the player, and springs from a new angle.

## Lore context

Older hounds survived long enough to adapt to Yomori's mist, roots, and hunting paths. They became apex scavengers that use obscured space deliberately rather than relying only on pack rushes.

## Visual identity

- leaner and darker than the Blighted Hound,
- stretched limbs and raised spine,
- matted fur and exposed sinew,
- mist-cloaked flanks,
- faint blood-red highlights around eyes, ribs, shoulders, and mouth,
- red-black tissue visible where fur has fallen away.

It must remain recognizably related to the Area 1 hound family.

## Silhouette

Low, long, angular, and constantly coiled. Forward-heavy shoulders, narrow waist, elongated forelimbs, and a head held close to the ground create a stalking rather than charging profile.

## Attack language

Most of the fight uses stronger versions of familiar hound behavior:

- snap bites,
- short lunges,
- claw or shoulder pressure,
- circling and retreat.

Signature mist-stalk sequence:

1. disengage under fair spacing conditions,
2. enter mist with a recognizable cue,
3. circle or relocate,
4. reappear and visibly coil,
5. perform a committed pounce,
6. enter a punishable recovery or heavy recoil after parry.

The pounce is block-breaking and parry-preferred, but remains dodgeable. It is not a true unavoidable attack.

## Corruption language

Predatory refinement rather than random mutation. Mist leaks from mouth and shoulders, thin vein marks run along ribs and legs, and the body appears sharpened by the forest.

## Personality in motion

Cunning, patient, and baiting. It watches, circles, retreats, and chooses its moment instead of continuously rushing.

## Combat readability

The player should first recognize a stronger hound, then learn the special disengage cue. Normal attacks remain familiar. Mist entry clearly warns that a pounce may follow; reappearance and pre-leap coil must provide a fair response window.

## Required animation set

- idle/stalk,
- walk/circle,
- run,
- bite windup and bite,
- lunge windup, lunge, and recovery,
- mist entry,
- mist exit/reappearance,
- pounce windup and pounce,
- hurt,
- parried heavy recoil,
- stagger/long punish state,
- deathblow-ready,
- deathblow,
- death.

## Technical notes

Reuse Blighted Hound locomotion, bite, short-lunge, hurtbox, posture, and general animation structure where possible. The mist-stalk state requires a cooldown, fair minimum spacing, limited frequency, and attack-token gating so multiple Stalker Hounds cannot ambush simultaneously. Successful pounce parry should inflict heavy posture damage and a long punish window.
