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
  - weapon-kits
  - wolf
  - wraith
  - ronin
  - encounter-design
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - META-OPEN-QUESTIONS
---

# Blood Aspect Identity Guidelines

## Evaluation principle

Blood Aspects are complete katana weapon kits that share one control and combat language.

> **Define concrete moves first. Let timing, range, geometry, damage, posture, stagger, tracking, commitment, and recovery create the playstyle naturally.**

Do not substitute an abstract behavior rule for a weapon kit. Avoid identities based on maintaining pressure forever, repositioning after every sequence, preserving a combo through defense, reaching one required finisher, or selecting attacks through movement-direction input.

## Approved launch roster

| Aspect | Identity | Firm tradeoff |
|---|---|---|
| Wolf | Fast close-range pressure and pursuit | Missed pursuit and extended pressure create dangerous overcommitment |
| Wraith | Extended spectral reach and frontal control | Point-blank, cramped, and multi-directional pressure undermine its spacing advantage |
| Ronin | Slow heavy impact and defensive stability | Slow startup, severe recovery, low tracking, and slow posture recovery punish bad commitments |

The launch roster is final at the current scoping stage. Mobility, evasion, ranged utility, and broader crowd control remain shared-system, Technique, and prosthetic territory rather than requiring a fourth Aspect.

## Encounter assumption

Oathbound combines disciplined posture, parry, block, dodge, counter, and deathblow combat with roguelite encounters containing:

- multiple waves,
- mixed melee and ranged enemies,
- simultaneous threats,
- target-priority decisions,
- crowd pressure,
- elites and minibosses,
- hazards and area denial,
- and sustained bosses.

Every launch kit must remain viable across these situations. No Aspect is designed only for one-on-one sword duels or only for large groups.

## Universal layer

Wolf, Wraith, and Ronin share:

- controller layout,
- neutral locomotion and dash properties,
- defense input,
- parry timing and success rules,
- posture-break and deathblow language,
- enemy responses,
- Technique rules,
- prosthetic controls,
- and combat interface language.

No Aspect receives a weaker or stronger neutral dash.

## Defensive-profile guidance

Every Aspect retains block, parry, dodge, player posture, and deathblows.

Modest differences may use:

- player-posture capacity,
- block posture efficiency,
- posture recovery direction,
- access to defense after attacks,
- and Parry Counter payoff.

These differences support a complete weapon kit; they cannot be the kit's entire identity.

Do not change parry timing, parry success conditions, defense input, posture-break consequences, or enemy response rules. Do not grant automatic counters, posture-break immunity, free guarding, or posture recovery while actively blocking.

## Shared offensive slots

Every Aspect defines:

1. **Basic Attack** — primary sequence and normal swordplay.
2. **Held Attack** — major secondary or committed sword action.
3. **Dash Attack** — offensive follow-up after the universal neutral dash.
4. **Parry Counter** — direct attack after the universal parry.
5. **Blood Art** — Tier II Blood-powered package finalized through fixed Aspect progression.

The Held Attack is a genuine secondary action rather than one universal thrust with different numbers.

## Sequence guidance

A sequence is a weapon property, not an objective.

The player may stop after one attack, continue, defend, dash, redirect, use a Prosthetic, or abandon the sequence. The player should not feel that an Aspect failed because a sequence was not completed.

| Aspect | Sequence | Cadence purpose |
|---|---:|---|
| Wolf | Four attacks | Sustained close pressure and pursuit |
| Wraith | Two attacks | Extended pokes and quick return to movement or defense |
| Ronin | Three attacks | Slow escalating impact and heavy direct damage |

Each attack must remain useful when the sequence ends early.

## Movement guidance

Attack movement may reinforce a kit but must not replace it.

Avoid mandatory lateral movement, special offset finishes, automatic movement behind targets, every counter relocating Akio, or directional movement input selecting unrelated sword attacks.

A spacing identity should usually emerge from reach, geometry, commitment, tracking, and recovery.

## Kit evaluation template

### Concrete actions

- What happens on one and repeated Basic Attack presses?
- What distinct purpose does Held Attack serve?
- What attack follows the universal dash?
- What direct response follows a universal parry?

### Weapon properties

- range and geometry,
- cadence and sequence length,
- attack-bound movement,
- tracking and target correction,
- per-hit and sustained health damage,
- enemy-posture pressure and stagger,
- commitment and miss recovery,
- target handling,
- and modest defensive properties.

### Game-wide fit

- natural strengths and weaknesses,
- groups, ranged pressure, elites, hazards, and boss viability,
- reinforce, broaden, compensate, and hybridize Technique space,
- prosthetic relevance,
- and animation, VFX, audio, UI, and teaching scope.

## Approval standard

A kit is ready when:

- its moves can be explained without abstract behavioral instructions,
- Basic and Held attacks form a coherent weapon style,
- strengths and weaknesses emerge from attack properties,
- Dash Attack and Parry Counter reinforce the kit without rewriting universal controls,
- ordinary defense, deathblows, Techniques, and prosthetics remain relevant,
- the kit works against groups and single targets,
- and it is distinguishable from the other two during the first combat room.

The current roster meets this qualitative Tier 0 standard.

## Cross-roster comparison

| Property | Wolf | Wraith | Ronin |
|---|---|---|---|
| Style | Fast close pressure | Extended spectral poking | Slow heavy direct impact |
| Sequence | Four hits | Two hits | Three hits |
| Range | Close | Longest | Medium |
| Cadence | Fastest | Short quick-to-moderate | Slowest |
| Per-hit damage | Moderate | Moderate | Highest |
| Sustained output | Highest while connected | Moderate | Opening-dependent |
| Attack movement | Strongly forward | Restrained | Minimal |
| Tracking | Strong nearby | Restrained | Low-to-moderate |
| Held purpose | Pursuit | Reach | Power |
| Primary risk | Overextension | Pressure inside preferred range | Missed heavy commitment and slow posture recovery |

## Technique compatibility

Ordinary Techniques target universal action categories rather than separate move-specific versions for each Aspect.

Each Aspect must support reinforce, broaden, compensate, and hybridize builds. No Aspect owns all attack, range, movement, damage, posture, parry, block, or deathblow Techniques.

## Future roster capacity

A fourth or fifth Aspect remains possible only after the initial three are implemented and playable evidence demonstrates a missing combat identity that cannot be solved through the current roster, Techniques, prosthetics, or encounter design.

Neither additional Aspect belongs to current launch paper-design or production scope.

## Next design dependency

Define each approved Aspect's fixed Tier I-IV benefits, evolving drawback family, Tier II Blood rules, Blood Art, and production package. Do not repeat the completed roster audit or reopen the launch identity space without playable evidence.
