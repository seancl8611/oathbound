---
id: GAMEPLAY-WOLF-ASPECT
title: Wolf Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-26
topics:
  - blood-aspects
  - wolf
  - tier-0
  - weapon-kits
  - combat-foundation
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Wolf Blood Aspect

## Status

This document owns Wolf's approved qualitative Tier 0 weapon kit for roster comparison.

It does not approve exact numerical values, frame data, hitboxes, chain windows, animation counts, Blood Art, Tier progression, drawbacks, Corruption interactions, production scope, or Wolf's final inclusion after the roster audit.

Wolf is currently the strongest reference example for the approved [Blood Aspect Weapon-Kit Model](ASPECT_WEAPON_KIT_MODEL.md).

## Core weapon identity

**Wolf is the fast close-range pressure kit.**

Its swordplay is defined by:

- short effective reach,
- fast attack cadence,
- forward movement within attacks,
- strong correction toward nearby aimed enemies,
- moderate per-hit damage,
- strong sustained health and enemy-posture output,
- fast offensive follow-ups,
- and significant risk after missed forward commitments.

The player does not need to complete or maintain Wolf's combo to use the Aspect correctly. The attacks naturally support pressure, but the player may stop, defend, dash, change targets, use a Prosthetic, or abandon the sequence whenever the encounter demands it.

## Universal systems retained

Wolf uses the same functional:

- ordinary movement speed,
- neutral dash distance, speed, startup, invulnerability, recovery, steering, and repeat availability,
- block rules and baseline efficiency,
- player-posture capacity and recovery,
- parry timing,
- deathblow rules and standard positioning,
- Technique system,
- and prosthetic system

as the other launch candidates during the roster identity pass.

Wolf's aggressive identity comes from its sword attacks, not from a weaker backward dash, altered player-posture bar, unique deathblow, or different block rules.

## Basic attack sequence

Repeated Basic Attack presses produce:

1. **Fang Slash**
2. **Rending Cross**
3. **Blood Cleave**

This is Wolf's primary attack sequence, not a mandatory objective.

### Fang Slash

Fang Slash is a fast advancing opener with:

- short reach,
- a narrow diagonal or forward arc,
- a small forward step,
- moderate nearby target correction,
- fast startup,
- and moderate health and enemy-posture pressure.

Primary uses:

- test a close opening,
- begin pressure,
- catch a nearby retreating enemy,
- and enter Wolf's broader attacks.

Its narrow coverage leaves Wolf vulnerable to side pressure.

### Rending Cross

Rending Cross is a broader returning cut with:

- continued forward movement,
- a wider arc than Fang Slash,
- practical nearby-enemy coverage,
- stronger redirection toward a second close threat,
- and balanced health and enemy-posture pressure.

Primary uses:

- continue attacking the current target,
- catch nearby interference,
- transfer into another close enemy,
- and threaten a small group in front of Akio.

It is not a full-circle crowd-clear attack.

### Blood Cleave

Blood Cleave is a committed frontal or diagonal finishing cut with:

- the broadest coverage in Wolf's basic sequence,
- strong enemy-posture damage,
- meaningful health damage,
- strong forward commitment,
- and severe recovery after a miss.

Primary uses:

- punish a large opening,
- hit the main target and nearby enemies in front of Akio,
- and push elites or bosses toward posture break.

Reaching Blood Cleave does not guarantee that using it is safe.

## Sequence flow

Wolf's attack recoveries should allow the three attacks to feel fast and connected, especially on successful contact.

A completed sequence may return smoothly to Fang Slash, but this is a responsiveness property rather than a combo-maintenance goal.

The player remains free to:

- stop after Fang Slash,
- stop after Rending Cross,
- defend before Blood Cleave,
- redirect the next attack,
- or leave the sequence entirely.

Missed attacks, especially Blood Cleave, receive meaningful recovery and expose Wolf to retaliation.

## Held Attack — Predator's Passage

Holding and releasing Attack produces **Predator's Passage**, a long piercing pursuit lunge.

Its purpose is to convert distance into close engagement rather than deal safe ranged damage.

Working properties:

- long committed travel along a narrow line,
- limited correction after release,
- strong single-target health and enemy-posture pressure,
- no additional invulnerability,
- and severe recovery after a miss.

Against valid ordinary enemies, Wolf may pass through the target and finish immediately behind or beside it, provided the destination is safe and valid.

Against elites, bosses, heavy enemies, walls, hazards, pits, blocked geometry, or invalid destinations, Wolf stops at impact and remains engaged on the near side.

Exact passage eligibility remains implementation and testing work.

## Dash Attack — Hunting Slash

Attacking during the approved window after the universal neutral dash produces **Hunting Slash**.

Hunting Slash is an advancing re-entry cut with:

- quick startup,
- short-to-medium attack reach,
- strong movement toward the aimed nearby enemy,
- moderate target correction,
- a narrow initial hit,
- and a close finishing position.

It may flow naturally into Rending Cross, but the player is not required to continue the sequence.

The universal dash itself is unchanged. Hunting Slash is an optional offensive commitment after it.

## Parry Counter — Fang Reversal

After a successful universal parry, pressing Attack produces **Fang Reversal**.

Fang Reversal is a fast advancing retaliatory cut with:

- universal parry requirements,
- short reach,
- a forward step,
- strong enemy-posture pressure,
- moderate health damage,
- and limited nearby coverage.

It may flow into Rending Cross, but does not force sequence continuation.

The counter does not make the parry easier, add invulnerability, or guarantee safety against another enemy in a crowd.

## Range, damage, and posture profile

Wolf's qualitative profile is:

| Property | Working direction |
|---|---|
| Normal range | Shortest or near-shortest of the initial three |
| Cadence | Fast and sustained |
| Per-hit health damage | Moderate |
| Sustained output | Strong while attacks connect |
| Enemy-posture pressure | Consistent through repeated contact |
| Attack movement | Strong forward movement |
| Tracking | Strong against nearby aimed enemies |
| Coverage | Narrow opener with broader later attacks |
| Whiff risk | High after lunges and committed finishers |

Wolf does not automatically own the highest individual-hit damage, best crowd coverage, longest reach, or safest attacks.

## Natural strengths

- close-range pressure,
- sustained health damage,
- repeated enemy-posture pressure,
- pursuit of nearby or retreating enemies,
- fast return to offense after dash or parry,
- and practical target transfer within a nearby group.

## Natural weaknesses

- short reach,
- forward overcommitment,
- missed attack recovery,
- target fixation,
- side and rear pressure,
- ranged enemies when approach is denied,
- and hazards that make direct pursuit unsafe.

These weaknesses emerge from Wolf's attacks rather than weaker universal movement or defense.

## Encounter viability

### Mixed groups

Wolf pressures an important nearby target while Rending Cross, Blood Cleave, normal aiming, defense, and movement account for surrounding enemies.

### Crowds

Wolf can move pressure through a group but remains unsafe when fully surrounded. It does not receive automatic enemy-to-enemy chaining, full-circle attacks, or attack invulnerability.

### Ranged enemies

Predator's Passage, Hunting Slash, forward attack movement, universal dash, and prosthetics provide approach options. Wolf does not gain permanent ranged attacks solely to erase this weakness.

### Elites and bosses

Wolf performs well during sustained openings but must stop attacking when retaliation begins. Heavy Cleave and Predator's Passage remain punishable commitments.

### Hazards

Forward movement and passage attacks require deliberate aim and destination awareness. Universal dash remains dependable.

## Technique build space

Universal Techniques may naturally:

- **reinforce:** pursuit, fast Basic Attacks, sustained pressure, repeated contact, and enemy-posture continuity,
- **broaden:** crowd coverage, ranged-enemy handling, held-attack use, or target transfer,
- **compensate:** whiff recovery, spacing, reach, defense, or disengagement,
- **hybridize:** parry counters, dash attacks, deathblows, heavy finishers, posture, or prosthetics.

Wolf does not own all aggressive, Basic Attack, posture, pursuit, or dash Techniques.

## Blood-katana presentation

Wolf's Returning Blood should make the katana feel:

- dense,
- predatory,
- forceful,
- close-ranged,
- and visually committed to direct contact.

It should not create a permanently long blade extension that removes Wolf's range weakness.

Exact animation, VFX, color, shape, and audio remain open.

## Remaining Wolf decisions

After Wraith and Ronin are defined and the roster audit is complete, decide:

- exact timing, range, tracking, recovery, damage, and enemy-posture values,
- exact chain windows,
- passage eligibility and collision behavior,
- exact Blood-katana presentation,
- whether any later unique mechanic is required,
- Tier progression,
- drawback and Corruption behavior,
- Blood and Blood Art if retained,
- Technique interactions,
- production counts,
- and trial or persistent-progression requirements.
