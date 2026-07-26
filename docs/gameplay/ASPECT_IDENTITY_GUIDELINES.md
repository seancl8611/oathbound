---
id: GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
title: Blood Aspect Identity Guidelines
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-26
topics:
  - blood-aspects
  - aspect-roster
  - wolf
  - wraith
  - encounter-design
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - META-OPEN-QUESTIONS
---

# Blood Aspect Identity Guidelines

This document records the approved lens for evaluating Blood Aspect identities and the approved working directions for Wolf and Wraith.

The complete qualitative Tier 0 foundations are owned by:

- [Wolf Blood Aspect](WOLF_ASPECT.md)
- [Wraith Blood Aspect](WRAITH_ASPECT.md)

These approvals do not lock exact numerical values, frame data, hitboxes, animations, Blood Arts, progression packages, production counts, or final inclusion after the three-Aspect roster audit.

## Encounter assumption

Oathbound combines disciplined posture, parry, block, dodge, counter, and deathblow combat with Hades-like roguelite room encounters.

A normal combat room may include:

- multiple waves,
- mixed melee and ranged enemies,
- several simultaneous threats,
- target-priority decisions,
- crowd pressure,
- elites or minibosses,
- hazards and area denial,
- and bosses or other sustained single-target encounters.

Aspect design must therefore be tested against both single-target and multi-target play. An Aspect may be best at one situation, but every launch Aspect must remain viable, active, and fun against groups, ranged pressure, hazards, elites, and bosses.

Do not design an Aspect as though the game consists only of Sekiro-like one-on-one duels. Likewise, do not remove the posture, defensive, and execution framework merely to imitate a broader action roguelite.

## Shared-controls principle

Blood Aspects share one control layout, neutral movement standard, enemy-response language, and combat interface. They do not need to share one identical moveset.

Every launch candidate must preserve recognizable access to:

- repeated basic attack input,
- held attack input,
- block and parry input,
- universal neutral dodge and dash,
- post-parry attack,
- dash-to-attack input,
- posture pressure,
- deathblows,
- Techniques,
- and the equipped prosthetic.

An Aspect may reinterpret the actions assigned to those inputs through different sequence lengths, names, attack geometry, movement, tracking, commitment, recovery, target interaction, damage profile, posture profile, and transitions.

`Quick Slash`, `Cross Cut`, `Heavy Cleave`, `Hold Thrust`, `Counter Cut`, and `Dash Slash` are not mandatory shared move names or roles.

The universal neutral dash retains the same functional distance, speed, startup, invulnerability, recovery, steering, collision, and repeat availability across launch Aspects. Movement identity should come primarily from attacks and offensive transitions rather than weakening dependable evasion.

## Aspect identity evaluation lens

Define each Aspect first through a clear player-facing role and relative combat properties.

Every candidate should state directly:

- **Known as:** the simple playstyle label a player would understand,
- **fantasy:** the form of controlled Returning Blood Akio expresses,
- **basic sequence:** what repeated attack presses produce and why that structure teaches the playstyle,
- **held attack:** the committed option produced by hold and release,
- **counterattack:** how a universal parry returns to Aspect-specific offense,
- **dash attack:** how the universal neutral dash converts into Aspect-specific offense,
- **range:** close, medium, flexible, or another justified relative profile,
- **attack rhythm:** fast, sustained, deliberate, burst-oriented, variable, or another clear direction,
- **damage profile:** relative per-hit damage and sustained output,
- **enemy-posture profile:** how strongly and consistently it pressures enemy posture,
- **player-posture profile:** how much pressure Akio can absorb and how posture recovers,
- **movement:** how offense moves, holds, crosses, or repositions Akio,
- **coverage:** how attacks handle nearby and multiple enemies,
- **tracking:** how readily attacks stay connected to moving targets,
- **commitment and recovery:** where the Aspect is safe or punishable,
- **target handling:** how it prioritizes, transfers between, or controls enemies,
- **defensive use:** how shared parry, block, and neutral dash support the playstyle,
- **natural risk:** the gameplay weakness created by those strengths,
- **encounter viability:** mixed-wave, crowd, ranged, hazard, elite, and boss behavior,
- **Technique space:** how universal Techniques reinforce, broaden, compensate, or hybridize the foundation,
- **visual identity:** how the Blood-katana form communicates the moveset,
- and **production cost:** what unique animation, VFX, audio, UI, or trial work is required.

Exact numbers are not needed during identity approval. The goal is to establish clear relative tradeoffs and a recognizable roguelite playstyle before locking implementation values.

## Design-discussion guidance

When proposing or reviewing an Aspect:

- begin with what the Aspect is known as,
- describe its relative properties plainly,
- define the basic sequence before assuming a universal three-hit combo,
- make the held, counter, and dash attacks reinforce the same identity,
- keep neutral dash functionality universal,
- explain why the playstyle should be enjoyable across room encounters,
- compare strengths and weaknesses against the other roster positions,
- preserve both crowd and single-target viability,
- distinguish a preferred situation from exclusive functionality,
- and defer exact values, frame data, hitboxes, animation counts, and Tier effects until the general identity is approved.

Avoid making the explanation depend on overly formal or heavily authored decision-loop language. Concrete playstyle, sequence, rhythm, range, coverage, movement, damage, posture, commitment, and risk descriptions are preferred.

External roguelite comparisons may be used to test whether a foundation is likely to be fun and replayable, but the final Aspect must remain native to Oathbound's shared sword, posture, defense, deathblow, and encounter systems.

## Wolf — approved identity and revised Tier 0 direction

### Status boundary

Wolf's high-level combat role, relative property direction, and qualitative Tier 0 combat foundation are approved for continued roster design.

The complete action-by-action foundation is recorded in [Wolf Blood Aspect](WOLF_ASPECT.md).

Still unapproved:

- exact frame timing, damage, posture, range, tracking, and recovery values,
- exact hitboxes, chain windows, and passage eligibility,
- exact Blood-katana shape and production treatment,
- whether Wolf needs any later unique mechanic beyond its Tier 0 moveset,
- Tier progression, drawback, Blood Art, and Corruption interactions,
- production counts,
- and Wolf's final inclusion after the three-candidate overlap and gap audit.

### Player-facing role

**Wolf is the close-range aggressive Aspect.**

It is built around fast, forward-moving offense, sustained pressure, and carrying momentum through mixed groups of enemies. It should feel strongest while Akio remains connected to combat, but its short reach and greater commitment punish missed attacks and careless overextension.

### Aspect-specific control expression

| Input or system | Approved Wolf direction |
|---|---|
| Basic attack sequence | Fang Slash → Rending Cross → Blood Cleave |
| Sequence rhythm | Fast escalating pressure; successful completion may restart smoothly |
| Held attack | Predator's Passage, a committed piercing pursuit that may pass through valid ordinary enemies |
| Parry counter | Fang Reversal, advancing return to pressure that enters at Rending Cross |
| Dash attack | Hunting Slash after the universal neutral dash, entering at Rending Cross |
| Neutral dash | Same functional distance, speed, invulnerability, and recovery as every launch Aspect |
| Block | Functional sustained block, not dominant guard specialization |
| Player posture | Moderate-to-high capacity with no automatic attack-based recovery at Tier 0 |
| Main failure state | Missed forward commitment, overextension, or being surrounded |

### Relative property profile

| Property | Approved working direction |
|---|---|
| Range | Shortest or near-shortest normal attack range |
| Attack rhythm | Fast, continuous, and forward-driving |
| Per-hit damage | Moderate rather than automatically highest |
| Sustained output | Strong while the player maintains contact and pressure |
| Enemy-posture pressure | Consistent through repeated contact |
| Attack movement | Strong forward movement during offense |
| Coverage | Narrow opener with broader follow-up and finisher |
| Tracking | Strong against nearby or retreating enemies once Akio commits |
| Commitment | Higher once an offensive sequence is underway |
| Recovery | Favorable while attacks connect; punishable after misses |
| Target handling | Strong priority-target pursuit with transfer into nearby enemies |
| Defense | Parry, block, and dash help Wolf remain engaged |
| Natural risk | Overextension, short range, target fixation, missed attacks, and group pressure |

### Technique build space

Under Wolf, universal Techniques may naturally:

- **reinforce:** pursuit, sustained offense, repeated contact, chain continuation, and momentum,
- **broaden:** crowd coverage, ranged-enemy handling, alternate sequence routes, or mixed-wave control,
- **compensate:** recovery, defense, spacing, reach, or disengagement,
- **hybridize:** posture, deathblow, counter, finisher, held-attack, movement, or prosthetic-focused builds.

Wolf must not own all aggressive Techniques, and no Technique is required to make its foundation functional.

## Wraith — approved identity and Tier 0 direction

### Status boundary

Wraith's high-level combat role, relative property direction, and qualitative Tier 0 combat foundation are approved for continued roster design.

The complete action-by-action foundation is recorded in [Wraith Blood Aspect](WRAITH_ASPECT.md).

Still unapproved:

- exact frame timing, damage, posture, range, tracking, and recovery values,
- exact hitboxes and attack-bound movement distances,
- exact collision shortening for lateral actions,
- exact Blood-katana shape and production treatment,
- whether Wraith needs any later unique mechanic beyond its Tier 0 moveset,
- Tier progression, drawback, Blood Art, and Corruption interactions,
- production counts,
- and Wraith's final inclusion after the three-candidate overlap and gap audit.

### Player-facing role

**Wraith is the mid-range spectral skirmisher.**

It is built around extended melee reach, short attack sequences, controlled lateral movement, and positional punishment. It attacks from the edge of danger, finishes in a new position, reassesses the encounter, and enters again from another angle.

### Aspect-specific control expression

| Input or system | Approved Wraith direction |
|---|---|
| Basic attack sequence | Veil Cut → Passing Arc |
| Sequence rhythm | Two-hit burst ending in lateral repositioning and reassessment |
| Held attack | Pale Lance, a long narrow spectral punish with severe miss recovery |
| Parry counter | Veil Reversal, a terminal off-axis counter after a universal parry |
| Dash attack | Ghostline Slash after the universal neutral dash, terminal and position-changing |
| Neutral dash | Same functional distance, speed, invulnerability, and recovery as every launch Aspect |
| Block | Sustained block retained but less efficient than Wolf's |
| Player posture | Lower capacity than Wolf with stronger recovery after escaping pressure |
| Main failure state | Being pinned, missing a committed line attack, or choosing an unsafe finishing position |

### Relative property profile

| Property | Approved working direction |
|---|---|
| Range | Medium-to-long effective melee reach |
| Attack rhythm | Short deliberate bursts rather than continuous pressure |
| Per-hit damage | Moderate with strong focused damage from Pale Lance |
| Sustained output | Lower than Wolf when forced to remain continuously engaged |
| Enemy-posture pressure | Reliable during selected punish windows rather than constant contact |
| Attack movement | Lateral and diagonal repositioning attached to offense |
| Coverage | Strong lines, diagonals, and arcs without full-circle safety |
| Tracking | Moderate and restrained; geometry matters more than target adhesion |
| Commitment | Moderate on sequence actions and high on Pale Lance misses |
| Recovery | Controlled after successful short sequences; vulnerable after poor committed attacks |
| Target handling | Controls formations and attack lanes rather than pursuing one target continuously |
| Defense | Parry and repositioning preferred; sustained block remains a costly fallback |
| Natural risk | Point-blank pressure, constrained arenas, hazards, and dangerous finishing positions |

### Encounter requirement

Wraith must remain viable against:

- mixed waves by fighting around formations and changing angles,
- crowds through line and arc coverage rather than center-of-group safety,
- ranged enemies through Pale Lance and Ghostline Slash,
- elites through spacing and punish windows,
- bosses through measured pressure, parries, and long punish access,
- and hazards through careful destination selection rather than extra dash safety.

### Technique build space

Under Wraith, universal Techniques may naturally:

- **reinforce:** reach, short-sequence damage, lateral movement, line coverage, positional punishment, and recovery after successful repositioning,
- **broaden:** close-range continuation, sustained posture pressure, pursuit, or heavier commitment,
- **compensate:** fragile blocking, lower player-posture capacity, missed Pale Lance recovery, crowd collapse, or unsafe finishing positions,
- **hybridize:** parry counters, deathblows, posture, heavy attacks, attack movement, or prosthetic-focused builds.

Wraith must not own all movement, dash, range, or avoidance Techniques, and it must remain distinct from Mist Raven.

## Future roster capacity

The expanded Aspect contract creates room for additional combat identities beyond the initial three.

A fourth and possibly fifth Aspect may be considered in future development, but neither is part of the current paper-design, launch-production, animation, UI, trial, or content-count baseline.

Additional Aspects should be reconsidered only after:

- Wolf, Wraith, and Ronin are designed and audited together,
- the three-Aspect roster is playable,
- Techniques and prosthetics are tested for coverage,
- and playtesting demonstrates a meaningful missing identity that cannot be solved by revising the existing roster or build systems.

The existence of theoretical design space does not itself justify expanding launch scope.

## Next roster question

Wolf and Wraith are complete at qualitative Tier 0 depth for comparison.

The next roster step is to define Ronin through the same expanded criteria:

- Ronin-specific basic attack structure,
- held attack,
- parry counter,
- dash attack after the universal neutral dash,
- player-posture and blocking direction,
- attack rhythm, reach, commitment, and target handling,
- mixed-encounter viability,
- Technique build space,
- and natural risk.

Ronin must not collapse into the parry-only Aspect, the generic default sword style, or a slower and stronger version of Wolf.
