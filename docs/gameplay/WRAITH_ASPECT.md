---
id: GAMEPLAY-WRAITH-ASPECT
title: Wraith Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-26
topics:
  - blood-aspects
  - wraith
  - tier-0
  - combat-foundation
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Wraith Blood Aspect

This document owns Wraith's approved qualitative Tier 0 combat foundation under the expanded Aspect contract.

It does not approve exact numerical values, frame data, hitboxes, Tier progression, drawbacks, Blood Art, Corruption interactions, production counts, or Wraith's final inclusion after the three-Aspect roster audit.

## Tier 0 identity

**Wraith is the mid-range spectral skirmisher.**

Wraith reshapes Akio's shared controls around:

- extended melee reach,
- short offensive sequences,
- lateral attack movement,
- deliberate changes of angle,
- positional punishment,
- and repeated disengagement and re-entry without changing the universal neutral dash.

Wraith fights from the edge of ordinary melee range. It attacks in controlled bursts, finishes in a new position, reassesses the encounter, and enters again from another angle.

Wraith does not require teleportation, automatic invulnerability, a unique meter, a target mark, delayed phantom attacks, or an additional input at Tier 0. Its identity comes from its moveset, attack geometry, finishing positions, and defensive profile.

## Universal movement retained

Wraith uses the same functional neutral movement and dash as every launch Aspect.

Wraith does not receive:

- greater or shorter neutral dash distance,
- faster or slower neutral dash travel,
- different neutral dash startup,
- different neutral dash invulnerability,
- different neutral dash recovery,
- different repeat-dash availability,
- or different ordinary locomotion speed.

Wraith feels mobile because its attacks cross lanes and finish at deliberate offsets, not because its dependable defensive movement is stronger than another Aspect's.

## Shared Wraith attack rules

Wraith's attacks generally have:

- medium-to-long effective melee reach,
- restrained forward pursuit,
- deliberate lateral movement,
- moderate target correction,
- strong line and arc coverage,
- moderate health and enemy-posture damage,
- and meaningful recovery after missed committed attacks.

Wraith should feel controlled while the player maintains favorable spacing and vulnerable when enemies pin Akio at point-blank range or when attack movement ends in a dangerous position.

Wraith does not teleport through enemies, automatically orbit behind targets, gain extra invulnerability during attacks, ignore hazards, or receive extreme target magnetism.

## Wraith basic attack sequence

Repeated basic attack presses produce Wraith's two-hit repositioning sequence:

1. **Veil Cut**
2. **Passing Arc**

There is no third basic combo attack.

The sequence belongs specifically to Wraith. Its shorter structure teaches the player to attack, reposition, and reassess rather than continuously recommit like Wolf.

### Veil Cut

Veil Cut is a narrow extended opening slash.

It should have:

- medium-to-long effective melee reach,
- limited forward movement,
- a narrow diagonal or horizontal attack shape,
- moderate health damage,
- moderate enemy-posture pressure,
- restrained target correction,
- and relatively safe recovery after successful contact.

Primary uses:

- test an opening outside conventional melee range,
- catch an approaching enemy,
- strike before a shorter-ranged enemy begins its attack,
- and establish the angle for Passing Arc.

Veil Cut reaches the enemy without aggressively pulling Wraith into point-blank range. Its narrow shape does not protect Akio from pressure arriving from the sides or rear.

### Passing Arc

Passing Arc is a broader spectral slash combined with controlled lateral movement.

It should have:

- broader coverage than Veil Cut,
- a diagonal or crescent-shaped Blood extension,
- moderate lateral movement chosen by player aim or directional input,
- good coverage along the travel path,
- moderate health and enemy-posture damage,
- limited automatic tracking,
- and a finishing position offset from the original target.

Primary uses:

- complete Wraith's short sequence,
- leave the enemy's direct retaliation lane,
- threaten another enemy positioned along the cut,
- and establish a new angle for the next decision.

Passing Arc always contains a meaningful lateral component. It does not have a separate stationary version at the current concept depth.

Near walls, pits, hazards, blocked geometry, or invalid destinations, the movement shortens or stops rather than carrying Akio into an invalid position. Exact collision handling and movement distance remain implementation and playtesting work.

Passing Arc does not automatically move behind the enemy or guarantee safety. The chosen direction may place Wraith into another attack, hazard, or crowd.

## Sequence ending rule

After Passing Arc, Wraith's sequence ends.

Following a brief and readable recovery, the player may:

- begin another Veil Cut sequence,
- block or parry,
- use the universal neutral dash,
- activate the equipped prosthetic,
- or reposition normally.

The sequence does not restart with Wolf-like continuity. Wraith is rewarded for reading the new position before attacking again.

## Held attack — Pale Lance

Holding and releasing the attack input produces **Pale Lance**.

Wraith aligns the physical katana and briefly extends it into a long, narrow spectral point.

Pale Lance should have:

- Wraith's longest effective sword reach,
- a very narrow attack line,
- slight or moderate forward glide,
- limited tracking after release,
- strong focused health damage,
- meaningful enemy-posture pressure,
- and substantial recovery after a miss.

Primary uses:

- punish a long enemy recovery,
- strike through an open lane,
- threaten a ranged enemy behind the front line,
- attack a boss from the edge of danger,
- and reach an enemy that expects Akio's sword to fall short.

Pale Lance remains attached to Akio's physical sword motion. It is not a projectile, does not continue independently, and does not carry Wraith through the target.

Wolf uses its held attack to force close engagement. Wraith uses its held attack to exploit preserved distance.

## Dash attack — Ghostline Slash

Attacking during the approved late-dash window or shortly after the universal neutral dash produces **Ghostline Slash**.

Ghostline Slash is an offensive repositioning cut with:

- the universal dash's unchanged defensive behavior before the attack begins,
- modest additional attack-bound movement,
- a diagonal or lateral travel line,
- broader line coverage than Wolf's Hunting Slash,
- moderate health and enemy-posture damage,
- and a finishing position offset from the target.

Ghostline Slash is a terminal action. It does not automatically enter Veil Cut, Passing Arc, or another uninterrupted sequence.

After normal recovery, the player may begin another action. This keeps Wraith's rhythm distinct from Wolf's pressure-restoring dash attack.

Ghostline Slash receives no additional invulnerability. It may place Wraith into another enemy's attack, against a wall, near a hazard, or beyond the intended target.

## Parry counterattack — Veil Reversal

After a successful universal parry, pressing attack produces **Veil Reversal**.

Veil Reversal is a precise spectral counter combined with a short visible shift across the attacker's front.

It should have:

- the same parry requirement and timing rules used by every Aspect,
- short lateral rather than forward movement,
- strong focused enemy-posture pressure,
- moderate health damage,
- limited nearby coverage,
- and a finishing position slightly offset from the attacker.

Veil Reversal is a terminal action. It converts successful defense into positional advantage without automatically entering Wraith's basic sequence.

Veil Reversal does not teleport behind the enemy, gain separate invulnerability, or pass through blocked geometry. Its movement shortens or stops near invalid destinations.

Wolf parries and forces itself back onto the enemy. Wraith parries and moves the exchange off-axis.

## Wraith defensive and player-posture profile

Wraith retains:

- sustained block,
- universal parry timing,
- the universal neutral dash,
- player posture,
- posture break,
- and deathblows.

Its working defensive direction is:

- lower player-posture capacity than Wolf,
- greater player-posture cost while sustaining block,
- universal parry timing and success rules,
- faster natural player-posture recovery after block is released and pressure is escaped,
- and strong positional reward from Veil Reversal.

Wraith can block unfamiliar attacks, projectiles, or dangerous sequences, but it is not intended to remain planted behind sustained guard.

Removing sustained block is not part of Wraith's approved Tier 0 foundation. A parry-only version remains a possible later experiment only if the roster, enemy patterns, bosses, tutorials, accessibility, and encounter compatibility justify it.

## Damage and enemy-posture profile

Wraith applies:

- moderate damage through Veil Cut and Passing Arc,
- strong focused damage through Pale Lance,
- reliable enemy-posture punishment during clear openings,
- lower sustained enemy-posture pressure than Wolf,
- and reduced output when forced into prolonged point-blank defense.

Wraith does not receive an automatic maximum-range or sweet-spot damage bonus at Tier 0. Such a rule may later be considered as a Technique, refinement, or progression mechanic if needed.

## Range and Blood-katana direction

Wraith has medium-to-long effective melee reach.

Its Returning Blood expression should make the katana feel:

- thin,
- spectral,
- elongated during committed motions,
- precise,
- and visually tied to attack direction.

Possible treatment includes a translucent blade extension, narrow crescent trails, or fading afterimages attached to the physical sword motion.

Wraith should not resemble unrestricted spellcasting or permanent ranged combat. Exact shape, color, animation, VFX, and audio treatment remain open.

## Target handling and crowd behavior

Wraith handles targets through spacing and geometry rather than aggressive lock-on pursuit.

Its crowd viability comes from:

- Veil Cut threatening from outside close range,
- Passing Arc cutting across nearby lanes,
- Ghostline Slash crossing a formation,
- Pale Lance reaching through an open line,
- and repeatedly choosing a safer angle.

Wraith does not receive:

- automatic chained attacks between enemies,
- full-circle crowd clearing,
- constant crowd stagger,
- free passage through enemies,
- or safety in the center of a group.

Wraith is strongest along the edge of a formation and weakest when enemies fully surround or pin Akio.

## Encounter behavior

### Mixed groups

Wraith fights around the outside of enemy formations, uses attack geometry to affect several threats, and changes angle before the formation closes.

### Crowds

Wraith has strong natural line and arc coverage but poor stability when surrounded. It should move along or across a crowd rather than stand in its center.

### Ranged enemies

Pale Lance and Ghostline Slash give Wraith strong access to ranged enemies without granting a permanent projectile or superior neutral dash.

### Elites

Wraith operates near the edge of an elite's immediate reach, punishes committed actions, and repositions before the next sequence. Fast elites that continuously close distance challenge its preferred spacing.

### Bosses

Wraith remains fully viable in single-target encounters through measured Veil Cut pressure, Passing Arc angle changes, Pale Lance punish windows, Veil Reversal, universal parry, and universal movement.

Wraith applies less continuous enemy-posture pressure than Wolf but gains more reliable access to selected punish windows.

### Hazards and constrained arenas

Walls, pits, traps, persistent ground danger, and cramped rooms directly challenge Wraith's offensive movement. The universal dash remains dependable, but optional attack follow-ups may still end in dangerous positions.

## Technique build space

Universal Techniques retain the same rules under every Aspect.

Under Wraith they may naturally:

- **reinforce:** extended reach, short-sequence damage, lateral attack movement, line coverage, positional punishment, and recovery after successful repositioning,
- **broaden:** close-range continuation, sustained enemy-posture pressure, more aggressive restarts, pursuit, and heavier single-target commitment,
- **compensate:** fragile blocking, lower player-posture capacity, missed Pale Lance recovery, point-blank crowd pressure, and unsafe finishing positions,
- **hybridize:** parry counters, deathblows, heavy attacks, attack movement, posture, or prosthetic-focused builds.

No Technique is required for Wraith to handle groups, ranged enemies, elites, hazards, or bosses at a basic viable level.

Wraith does not own all movement, dash, range, or defensive Techniques.

## Distinction from Mist Raven

Wraith does not replace the Mist Raven prosthetic.

Wraith's movement is:

- part of ordinary sword attacks,
- visible from beginning to end,
- directional,
- committed,
- constrained by collision and hazards,
- and generally non-invulnerable beyond the universal defensive rules.

Mist Raven may retain a specialized reactive escape, transformation, or avoidance function. Wraith's identity is controlled offensive positioning rather than disappearance on demand.

## Tier 0 summary

Wraith is the mid-range spectral skirmisher.

- **Basic sequence:** Veil Cut → Passing Arc.
- **Sequence rule:** two-hit burst ending in a lateral offset and deliberate reassessment.
- **Held attack:** Pale Lance, a long narrow spectral punish with severe miss recovery.
- **Dash attack:** Ghostline Slash after the universal neutral dash, terminal and position-changing.
- **Parry counter:** Veil Reversal after a universal parry, terminal and off-axis.
- **Neutral movement:** identical functional neutral movement and dash across launch Aspects.
- **Defense:** sustained block retained but less efficient than Wolf's; lower player-posture capacity with stronger recovery after escaping pressure.
- **Enemy posture:** reliable during chosen openings but weaker sustained pressure than Wolf.
- **Main strengths:** reach, attack geometry, ranged-enemy access, positional punishment, and mixed-wave control.
- **Main weaknesses:** point-blank pressure, constrained spaces, missed committed attacks, and dangerous finishing positions.

## Remaining Wraith decisions

After the full three-Aspect roster and overlap audit are approved, decide:

- exact relative attack, player-posture, enemy-posture, range, tracking, recovery, and block-efficiency values,
- exact hitboxes and movement distances,
- exact collision shortening for Passing Arc, Ghostline Slash, and Veil Reversal,
- exact animation and Blood-katana treatment,
- whether Wraith needs any later unique mechanic beyond the Tier 0 moveset,
- shared Tier progression and Wraith's Tier package,
- drawback and Corruption behavior,
- Blood generation and Blood Art if retained,
- production scope,
- and trial or persistent-progression requirements.
