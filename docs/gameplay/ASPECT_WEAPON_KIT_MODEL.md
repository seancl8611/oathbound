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
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Blood Aspect Weapon-Kit Model

## Purpose

Blood Aspects should create the kind of playstyle separation produced by distinct melee weapons in a polished action roguelite while preserving one recognizable version of Akio.

The player keeps the same controller layout, neutral movement, enemy rules, posture and deathblow language, Techniques, and prosthetic framework. The selected Aspect changes the Blood-formed katana kit assigned to the shared offensive inputs.

The governing principle is:

> **The moves create the playstyle. The player should not need to maintain a separate objective, combo state, or prescribed movement loop to use an Aspect correctly.**

An Aspect should feel different because its attacks have different timing, reach, geometry, commitment, recovery, damage, enemy-posture pressure, tracking, target handling, and impact.

## Weapon-kit action model

Each Aspect owns a complete kit built from the same action slots:

| Shared action slot | Aspect-owned output |
|---|---|
| Basic Attack | Primary attack sequence, cadence, geometry, reach, movement, and recovery |
| Held Attack | Major secondary sword action or committed option |
| Dash Attack | Offensive action following the universal neutral dash |
| Parry Counter | Direct sword response after the universal parry |
| Blood Art | Possible later high-power signature action if retained by the final system |

The held attack is a genuine secondary action. It does not need to be the same thrust with different statistics and does not need to be only a charged version of a basic strike.

## Universal movement and combat language

The following remain functionally universal across launch Aspects:

- controller layout and input mapping,
- ordinary locomotion speed,
- neutral dash distance, speed, startup, invulnerability, recovery, steering, collision, and repeat availability,
- defense input,
- parry timing and success rules,
- enemy telegraphs and intended responses,
- posture-break, stagger, and deathblow rules,
- deathblow eligibility and execution behavior,
- Spirit and prosthetic controls,
- Technique slots and acquisition rules,
- and combat interface and readability language.

No launch Aspect receives a weaker neutral dash. Neutral movement is not used as a balance penalty.

## Defensive-profile boundary

Block, parry, dodge, player posture, and deathblows remain available to every launch Aspect.

The initial weapon-kit pass may use **modest defensive-profile differences** when they reinforce a complete sword style rather than replace it. Allowed differences include:

- relative player-posture capacity,
- posture damage received while blocking,
- posture recovery direction,
- recovery into defense after an attack,
- and the damage or enemy-posture payoff of the Aspect-specific Parry Counter.

The following remain universal:

- parry timing,
- parry success conditions,
- defense input,
- posture-break consequences,
- and enemy attack-response rules.

A defensive difference cannot be the Aspect's entire identity. No launch Aspect removes block or parry, gains automatic counters, becomes immune to posture break, or receives free posture recovery while actively guarding.

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
- ordinary-enemy stagger strength,
- commitment and whiff risk,
- target-transfer behavior,
- held-attack purpose,
- dash-attack purpose,
- parry-counter purpose,
- modest defensive profile,
- and Returning Blood weapon presentation.

These differences should combine into a coherent weapon kit. One unusual rule or one altered statistic is not sufficient.

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

Doing so should not feel like failing an Aspect minigame.

Sequence length may vary when it serves the kit's cadence and attack shapes. Do not build an Aspect around:

- maintaining a combo state,
- preserving a sequence through unrelated actions,
- reaching a named finisher as the central gameplay goal,
- or forcing the player to repeat one prescribed loop.

## Approved three-kit cadence

The current three launch candidates use different sequence lengths because each length supports a concrete weapon rhythm:

| Aspect | Basic sequence length | Reason |
|---|---:|---|
| Wolf | Four attacks | Supports the longest, fastest sustained pressure pattern and target transfer |
| Wraith | Two attacks | Supports short extended-range pokes and quick return to movement or defense |
| Ronin | Three attacks | Supports slower escalating impact without making the final strike a required objective |

The numbers are not arbitrary roster symmetry. Each sequence must remain useful when interrupted after any attack.

## Movement boundary

Attack movement is valid when it naturally belongs to the sword action. Forced repositioning should not substitute for a complete weapon identity.

Avoid designing an entire Aspect around:

- mandatory lateral movement after ordinary attacks,
- automatic movement behind enemies,
- every counter changing position,
- every dash attack ending at a special offset,
- or movement-direction input selecting unrelated sword attacks.

The player may reposition because a kit's reach, recovery, and geometry make spacing valuable. The moves do not need to choreograph that behavior constantly.

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

A Technique modifies the tagged action consistently across Aspects. Its result may feel different because the underlying kit differs.

Examples:

- a Basic Attack Technique affects Wolf's four-hit pressure sequence, Wraith's two-hit spectral sequence, and Ronin's three-hit heavy sequence through one rule,
- a Held Attack Technique applies to Predator's Passage, Pale Lance, and Stillness Draw,
- a Dash Attack Technique modifies Hunting Slash, Ghostline Slash, and Breaching Slash without changing the universal neutral dash,
- and a Parry Counter Technique modifies each Aspect's direct counter without changing parry timing.

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

### Wolf — approved for roster comparison

Wolf is the **fast close-range pressure kit**:

- four-hit sequence: Fang Slash → Rending Cross → Raking Fang → Blood Cleave,
- fastest cadence,
- shortest or near-shortest reach,
- strong forward attack movement and nearby tracking,
- moderate per-hit damage with strong sustained output,
- Predator's Passage as a pursuit lunge,
- Hunting Slash as an advancing dash attack,
- and Fang Reversal as an advancing parry counter.

### Wraith — approved for roster comparison

Wraith is the **extended spectral poke and reach-control kit**:

- two-hit sequence: Veil Cut → Passing Arc,
- medium-to-long melee reach,
- short attack strings and quick return to movement or defense,
- long lines and broad spectral arcs,
- moderate damage,
- restrained tracking and meaningful whiff risk,
- Pale Lance as the longest focused melee reach option,
- Ghostline Slash as a quick extended dash attack,
- and Veil Reversal as a precise long-reaching parry counter.

Wraith's quick-footed feel comes from short commitments and recovery, not a superior neutral dash or mandatory repositioning.

### Ronin — approved for roster comparison

Ronin is the **slow, precise, heavy-hitting kit**:

- three-hit sequence: Severing Cut → Crushing Cross → Bloodfall,
- slowest basic cadence,
- medium sword reach,
- highest per-hit health damage,
- highest or near-highest per-hit enemy-posture pressure,
- strong ordinary-enemy stagger,
- minimal attack-bound movement and restrained tracking,
- Stillness Draw as a defining high-damage Held Attack,
- Breaching Slash as a quicker lower-damage Dash Attack,
- Answering Steel as a high-payoff Parry Counter,
- and a stronger guard profile balanced by slow posture recovery and committed attacks.

## Why the roster changed

The earlier roster work overemphasized prescribed behavior such as looping Wolf, forcing Wraith to reposition, or making Ronin maintain a combo or select attacks through directional inputs.

The approved correction defines each Aspect through concrete sword properties:

- Wolf's longer four-hit string creates sustained pressure through fast connected attacks.
- Wraith's two-hit string creates a poke-oriented rhythm through reach and short commitment.
- Ronin's three-hit string creates escalating heavy impact through slower, more damaging strikes.

The player may still stop any sequence whenever the encounter requires it.

## Future roster capacity

The weapon-kit model creates plausible space for a fourth and possibly fifth Aspect in future development.

Neither is part of current launch paper-design, production, animation, VFX, UI, trial, or milestone scope. Complete and test the three current launch candidates first. Expand only if playable evidence demonstrates a missing combat identity that cannot be covered by revising the roster, Techniques, or prosthetics.

## Required next step

With all three qualitative Tier 0 weapon kits approved for comparison, perform the roster overlap and gap audit before designing exact Tier progression, Blood generation, Blood Arts, drawbacks, or production counts.