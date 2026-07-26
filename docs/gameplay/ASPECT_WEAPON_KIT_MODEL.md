---
id: GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
title: Blood Aspect Weapon-Kit Model
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-26
topics:
  - blood-aspects
  - weapon-kits
  - combat-foundation
  - shared-controls
  - techniques
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-COMBAT
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Blood Aspect Weapon-Kit Model

## Purpose

Blood Aspects should create the kind of playstyle separation produced by distinct weapons in a polished action roguelite while preserving one recognizable version of Akio.

The player keeps the same controller layout, neutral movement, defensive language, enemy rules, posture system, deathblows, Techniques, and prosthetic framework. The selected Aspect changes the sword kit assigned to the shared offensive inputs.

The governing principle is:

> **The moves create the playstyle. The design should not prescribe a separate objective that the player must maintain in order to use the Aspect correctly.**

An Aspect should feel different because its attacks have different timing, reach, geometry, commitment, recovery, damage, posture pressure, tracking, and target handling. The player should discover the resulting combat style through normal use of the kit.

## Weapon-kit reference model

The intended comparison is closer to choosing a different melee weapon than equipping a passive stance.

Each Aspect owns a complete Blood-formed katana kit built from the same action slots:

| Shared action slot | Aspect-owned output |
|---|---|
| Basic Attack | Primary attack sequence, cadence, geometry, reach, movement, and recovery |
| Held Attack | Major secondary sword action or committed option |
| Dash Attack | Offensive action following the universal neutral dash |
| Parry Counter | Direct sword response after the universal parry |
| Blood Art | Possible later high-power signature action if retained by the final system |

The held attack should be treated as the Aspect's major secondary move. It does not need to be the same thrust with different statistics, and it does not need to be only a charged version of the basic attack.

## Shared universal layer

During the initial three-Aspect identity pass, the following remain functionally universal:

- controller layout and input mapping,
- ordinary locomotion speed,
- neutral dash distance, speed, startup, invulnerability, recovery, steering, collision, and repeat availability,
- block rules and baseline block efficiency,
- player-posture capacity and recovery rules,
- parry timing and success rules,
- enemy telegraphs, defensive responses, hit reactions, stagger, and posture-break behavior,
- deathblow eligibility, execution rules, and standard positioning behavior,
- Spirit and prosthetic controls,
- Technique slots and acquisition rules,
- and combat interface and readability language.

These systems may later receive Techniques, temporary run effects, or explicitly approved exceptional modifications. They are not used now as primary levers to manufacture Aspect identity.

In particular:

- no launch Aspect receives a weaker neutral dash,
- no launch Aspect is defined by a larger or smaller base player-posture bar,
- no launch Aspect is defined by uniquely efficient or inefficient sustained block,
- no launch Aspect receives a unique deathblow system during the identity pass,
- and no launch Aspect removes block, parry, dodge, posture, deathblow, Technique, or prosthetic participation.

## Aspect-owned differentiation

An Aspect may differ substantially through:

- basic attack sequence length,
- attack order and animation,
- startup and recovery,
- attack cadence,
- weapon reach,
- hit shape and arc coverage,
- movement attached to attacks,
- tracking and target correction,
- per-hit health damage,
- enemy-posture pressure,
- commitment and whiff risk,
- target-transfer behavior,
- held-attack purpose,
- dash-attack purpose,
- parry-counter purpose,
- and Returning Blood weapon presentation.

These differences should combine into a coherent weapon kit. One unusual rule is not enough by itself.

## Combo and sequence boundary

A combo is an available attack sequence, not the player's required objective.

The player may:

- stop after one attack,
- continue the sequence,
- defend,
- dash,
- change targets,
- use a Prosthetic,
- or abandon the sequence entirely.

Doing so should not feel like failing a mandatory Aspect minigame.

Sequence length may vary when it serves the weapon kit, but the design should not be built around:

- maintaining a combo state,
- preserving a sequence through unrelated actions,
- reaching a named finisher as the central gameplay goal,
- or forcing the player to repeat one prescribed loop.

## Movement boundary

Attack movement is valid when it naturally belongs to the sword action. Forced repositioning should not become the main identity unless the attack itself genuinely requires that motion.

Avoid designing an entire Aspect around:

- mandatory lateral movement after ordinary attacks,
- automatic movement behind enemies,
- every counter changing position,
- every dash attack ending at a special offset,
- or movement-direction input selecting unrelated sword attacks.

The player may reposition because the kit's range, recovery, and attack geometry make spacing valuable. The moves do not need to choreograph that behavior constantly.

## Technique compatibility

Ordinary Techniques use universal action tags rather than move names:

- Basic Attack,
- Held Attack,
- Dash Attack,
- Parry Counter,
- Block,
- Parry,
- Deathblow,
- Prosthetic,
- Health,
- Enemy Posture,
- Player Posture,
- and Movement.

A Technique should modify the tagged action consistently across Aspects. Its result may feel different because the underlying Aspect kit differs.

Examples:

- a Basic Attack Technique affects Wolf's pressure chain and Wraith's spectral sequence through one rule,
- a Held Attack Technique applies to Predator's Passage and whatever Wraith or Ronin ultimately use,
- a Dash Attack Technique modifies each Aspect's unique offensive follow-up without changing the universal neutral dash,
- and a Deathblow Technique applies to the shared execution system rather than requiring an Aspect-specific deathblow version.

## Professional kit test

A candidate kit is ready for roster comparison only when a designer can answer:

1. What physically happens when the player presses Basic Attack once and repeatedly?
2. What does Held Attack do that the basic sequence does not?
3. What does Dash Attack do after the universal dash?
4. What does Parry Counter do after the universal parry?
5. What are the kit's range, timing, geometry, damage, posture, tracking, and recovery characteristics?
6. What makes the kit strong without relying on a separate resource or mandatory loop?
7. What natural weaknesses emerge from the moves themselves?
8. Does the kit work against groups, ranged pressure, elites, hazards, and bosses?
9. Can several Technique builds reinforce, broaden, compensate, or hybridize it?
10. Can the kit be explained as a weapon style rather than a behavioral instruction?

## Current roster status

### Wolf

Wolf remains the strongest current example of the weapon-kit model:

- fast short-range attacks,
- forward movement and pursuit,
- strong sustained pressure,
- a lunging held attack,
- an advancing dash attack,
- and a fast parry counter.

Its three-hit sequence is a set of offensive options, not a requirement to complete or loop the combo.

### Wraith

Wraith's high-level spectral long-reach direction remains promising, but its previous Tier 0 package is reopened.

Retained working territory:

- medium-to-long Blood-katana reach,
- strong line and arc coverage,
- deliberate attack timing,
- Pale Lance as a possible long narrow held attack,
- and weaker performance when enemies collapse inside its preferred range.

Reopened territory:

- sequence length,
- Passing Arc,
- mandatory lateral movement,
- Ghostline Slash finishing position,
- Veil Reversal movement,
- defensive-profile differences,
- and any language requiring reposition-and-reassess as a prescribed loop.

### Ronin

Ronin is fully unresolved.

Discarded directions:

- preserving a combo through defense,
- playing around reaching Judgment Stroke,
- and movement-direction input selecting different basic attacks.

Ronin should be explored as a complete weapon kit with a genuinely different tempo, reach, geometry, commitment, damage, and posture profile. A deliberate high-impact katana is one possible direction, not yet an approved answer.

## Future roster capacity

The weapon-kit model creates plausible space for a fourth and possibly fifth Aspect in future development.

Neither is part of current launch paper-design, production, animation, VFX, UI, trial, or milestone scope. Complete and test the three current launch candidates first. Expand only if playable evidence demonstrates a missing combat identity that cannot be covered by revising the roster, Techniques, or prosthetics.

## Required next step

Redesign Wraith under this model before returning to Ronin.

The next Wraith discussion should define concrete attack properties first and allow its spacing playstyle to emerge naturally. Do not begin from forced repositioning, unique deathblow behavior, altered player posture, or weaker block rules.
