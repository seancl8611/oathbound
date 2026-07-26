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
  - encounter-design
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - META-OPEN-QUESTIONS
---

# Blood Aspect Identity Guidelines

This document records the approved lens for evaluating Blood Aspect identities and Wolf's approved working direction. Wolf's qualitative Tier 0 combat foundation is owned by [Wolf Blood Aspect](WOLF_ASPECT.md).

It does not approve exact numerical values, frame data, animations, Blood Art, progression package, production scope, or final inclusion in the three-Aspect roster.

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

Wolf may be particularly strong at pursuing a priority target, but it is not a pure single-target stance. Its foundation must also support fighting through groups, catching nearby enemies, moving between threats, surviving mixed waves, reaching ranged enemies, and remaining effective against bosses.

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
| Attack rhythm | Fast, continuous, and forward-driving rather than slow and heavy |
| Per-hit damage | Moderate rather than automatically highest |
| Sustained output | Strong while the player maintains contact and pressure |
| Enemy-posture pressure | Consistent through repeated contact rather than only one large hit |
| Attack movement | Strong forward movement during offense |
| Coverage | Narrow opener with broader follow-up and finisher for nearby threats |
| Tracking | Strong against nearby or retreating enemies once Akio commits |
| Commitment | Higher once an offensive sequence is underway |
| Recovery | More favorable while attacks connect; more punishable after misses or poor commitment |
| Target handling | Strong priority-target pursuit with effective transfer into nearby enemies |
| Defense | Parry, block, and dash help Wolf stay engaged rather than functioning only as retreat tools |
| Natural risk | Overextension, short range, target fixation, missed attacks, and group pressure |

### Roguelite room-combat requirement

Wolf's encounter pattern is not "mark one enemy and ignore everything else."

The intended high-level experience is:

- enter close range,
- pressure an important enemy,
- affect or account for nearby enemies while doing so,
- use shared defense and neutral movement to survive continued engagement,
- and move pressure into the next threat as the room or wave changes.

Wolf remains viable when enemies surround Akio, ranged enemies require target prioritization, hazards make constant pressure unsafe, or a boss provides only limited attack windows. These situations challenge Wolf's strengths without invalidating the Aspect.

### Damage and balance direction

Wolf does not automatically have the highest individual-hit damage. Its offensive advantage comes from sustained contact, reduced downtime, movement through attacks, repeated health and posture pressure, and effective continuation between targets.

Wolf must not simultaneously own the best attack speed, damage, range, safety, posture pressure, tracking, and crowd coverage. Its strengths are purchased through short reach and commitment risk—not through a weaker neutral dash.

### Technique build space

Universal Techniques retain the same rules used by every Aspect.

Under Wolf, they may naturally support:

- **reinforce:** closer pursuit, sustained offense, repeated contact, chain continuation, and momentum,
- **broaden:** crowd coverage, ranged-enemy handling, alternate sequence routes, or better control of mixed waves,
- **compensate:** safer recovery, defense, spacing, reach, or disengagement,
- **hybridize:** posture, deathblow, counter, finisher, held-attack, movement, or prosthetic-focused Wolf builds.

Wolf must not own all aggressive Techniques, and no Technique is required to make its foundation functional.

## Next roster question

Wolf's revised concept-level Tier 0 identity pass is complete for comparison.

The next roster step is to define Wraith through the same expanded criteria:

- Wraith-specific basic sequence,
- held attack,
- parry counter,
- dash attack after the universal neutral dash,
- player-posture and blocking direction,
- attack movement and spacing pattern,
- mixed-encounter viability,
- Technique build space,
- and natural risk.

Wraith must remain distinct from both Wolf and Mist Raven without becoming only a dash, teleport, or invulnerability style.