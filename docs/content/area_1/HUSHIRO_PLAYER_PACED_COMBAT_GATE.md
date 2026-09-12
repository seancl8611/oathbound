---
id: CONTENT-AREA1-PLAYER-PACED-COMBAT-GATE
title: Hushiro Player-Paced Combat Implementation Gate
category: content
status: approved
authority: primary
last_reviewed: 2026-09-12
topics:
  - area-1
  - hushiro
  - combat-v2
  - player-paced
  - hack-and-slash
  - encounter-pacing
related:
  - CONTENT-AREA1-COMBAT-PLAYTEST-TARGET
  - GAMEPLAY-COMBAT-V2-DIRECTION
---

# Hushiro Player-Paced Combat Implementation Gate

This file clarifies that the numerical/wave-flow package in `HUSHIRO_COMBAT_PLAYTEST_TARGET.md` is **not by itself the manual-playtest gate**. Area 1 should not be presented as ready for the intended combat-feel playtest until the runtime also supports the player-side pressure loop below.

## Target feel

Normal Area 1 combat should read primarily as a fast supernatural hack-and-slash / action-roguelite fight rather than a sequence of isolated duels.

A skilled player may choose to play aggressively and quickly:

1. dash into an engagement,
2. commit to a sustained basic-sword pressure string,
3. redirect between nearby targets while the string is still flowing,
4. kill a normal Area 1 Swordsman in roughly five to six clean base-katana hits if none are guarded,
5. fail to secure that kill when a meaningful guard removes enough damage from the string,
6. either continue pressure, branch into another action, or disengage with movement/dash once the player decides the commitment is over.

The player is not required to play this quickly. The point is that the controller must **permit** the fast style instead of inserting an artificial neutral reset after a short combo.

## Base-katana pressure string

The pre-awakening base-katana kit still uses the approved three sword actions:

- Quick Slash: 9 Health damage
- Cross Cut: 12 Health damage
- Heavy Cleave: 21 Health damage

Those moves should now form a **six-hit pressure commitment** rather than one rigid three-hit combo followed by forced neutral downtime:

`Quick -> Cross -> Heavy -> Quick -> Cross -> Heavy`

The first Heavy Cleave is a midpoint punctuation, not a mandatory disengage. If the player has already queued the next tap, the controller should flow into the second three-hit phrase without applying the old final-combo restart lockout.

The second Heavy Cleave is the natural end of the six-hit commitment. The player can also stop after any earlier hit, so practical commitments may be five hits when the player chooses to disengage before the last swing.

Damage remains 84 across all six clean hits. This deliberately preserves the Area 1 Swordsman 80-HP target:

- six clean hits kill,
- one meaningful Swordsman guard normally lets it survive,
- player execution and enemy defense both matter without turning every engagement into a block duel.

## Movement and retargeting during pressure

The pressure string must preserve Combat V2 ownership:

- `PlayerMotor` composes locomotion through attacks,
- `CombatActionRunner` owns startup/commit/active/recovery movement permissions,
- each new swing may reacquire aim before its own commitment point,
- dash remains a valid disengage/cancel only at the authored cancel point,
- no parallel damage pipeline or second sword hit system is introduced.

The goal is not animation-cancel spam. The goal is that Akio can advance through a group and redirect the next swing without being forced to stand still or wait for a hidden combo reset.

## Enemy durability and defense in Area 1

Initial standard targets remain:

- Hollow: 45 HP, roughly 4 clean hits
- Hound: 50 HP, roughly 4 clean hits
- Archer: 60 HP, roughly 5 clean hits
- Swordsman: 80 HP, 6 clean hits
- Bilemass: 80 HP, roughly 6 clean hits
- Warden: 140 HP, roughly 10-11 clean hits

Defensive frequency is enemy-authored rather than universal per-hit RNG:

- Hollow/Hound/Bilemass: no traditional guard,
- Archer: low-frequency weak reactive guard,
- Swordsman: moderate tactical guard that becomes more attractive under sustained Health/Posture pressure,
- Warden: highest standard Area 1 defensive resistance through short guard windows, Health, control pressure, and committed Poise.

Later areas/difficulties may increase lifetime guard frequency through intent bias, readiness, cooldowns, or variants. Area 1 should establish the readable low-to-moderate baseline first.

## Wave and encounter contract

Normal progression remains:

`clear current wave -> immediately begin next authored arrival script`

A 120-second anti-stall timer may begin the next wave with survivors, but this is a fail-safe, not normal pacing.

A wave is a scripted encounter beat, not a requirement that every member spawn together. Area 1 may use:

- burst arrivals,
- short staggered arrivals,
- clearly sequenced reinforcements.

Whole encounters are the balance unit. Individual waves may intentionally be unequal. Examples that are valid:

- two fast waves followed by one difficult spike,
- a difficult opener followed by cleanup/reinforcement waves,
- a mostly even encounter,
- a substantial two-wave room,
- a four-wave room where some waves disappear in seconds but the whole room remains appropriate for its point in the run.

The current Hushiro catalog already contains 2-, 3-, and 4-wave encounters with varied totals and burst/staggered/sequence scripts. Preserve that variety; do not normalize every wave to the same population or duration.

## Manual-playtest gate

Do **not** call Area 1 ready for the intended player-paced combat playtest until automated/runtime validation proves at minimum:

1. the base-katana basic pressure string can flow through six taps without an artificial neutral restart after hit three,
2. its clean damage remains 9 -> 12 -> 21 -> 9 -> 12 -> 21 = 84,
3. the player may stop after hit five or continue into hit six,
4. the first Heavy Cleave can queue the second phrase while still retaining its heavier commitment/recovery feel,
5. the second Heavy Cleave remains the natural pressure-string endpoint,
6. movement/aim ownership continues through PlayerMotor + CombatActionRunner,
7. Swordsman/Archer/Warden durability targets and guard-survival semantics remain intact,
8. immediate clear-driven wave chaining, 120-second anti-stall, and arrival-script variety remain intact,
9. no regression reintroduces legacy whole-turn serialization for migrated Hushiro enemies.

Only after those conditions are implemented should the next manual playtest primarily judge feel rather than obvious missing controller behavior.
