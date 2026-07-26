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

## Current evaluation principle

Blood Aspects are evaluated as complete sword weapon kits that share one control and combat language.

> **Define concrete moves first. Let timing, range, geometry, damage, posture, stagger, tracking, commitment, and recovery create the playstyle naturally.**

Do not begin by prescribing a behavioral loop such as:

- maintain pressure forever,
- reposition after every sequence,
- preserve a combo through defense,
- reach a specific finisher,
- or use movement direction to select attacks.

Those descriptions may emerge as observations after the kit exists. They should not substitute for the kit.

The authoritative system model is [Blood Aspect Weapon-Kit Model](ASPECT_WEAPON_KIT_MODEL.md).

## Encounter assumption

Oathbound combines disciplined posture, parry, block, dodge, counter, and deathblow combat with roguelite room encounters containing:

- multiple waves,
- mixed melee and ranged enemies,
- simultaneous threats,
- target-priority decisions,
- crowd pressure,
- elites and minibosses,
- hazards and area denial,
- and sustained boss encounters.

Every launch kit must remain active, viable, and enjoyable across those situations. No Aspect may be designed only for one-on-one sword duels or only for large groups.

## Universal layer

The initial launch candidates share:

- controller layout,
- neutral locomotion,
- neutral dash properties,
- defense input,
- parry timing and success rules,
- posture-break and deathblow language,
- deathblow eligibility and execution behavior,
- enemy responses,
- Technique rules,
- prosthetic controls,
- and combat interface language.

No candidate receives a weaker or stronger neutral dash.

## Defensive-profile guidance

Every launch kit retains block, parry, dodge, player posture, and deathblows.

Modest differences may be used in:

- player-posture capacity,
- block posture efficiency,
- posture recovery direction,
- recovery into defense after attacks,
- and Parry Counter payoff.

These differences must support a complete weapon kit rather than become the only reason to select it.

Do not change:

- parry timing,
- parry success conditions,
- defense input,
- posture-break consequences,
- or enemy attack-response rules.

Do not grant automatic counters, posture-break immunity, free guarding, or posture recovery while actively blocking.

## Shared offensive slots

Every candidate must define:

1. **Basic Attack:** the primary sequence produced by one or repeated presses.
2. **Held Attack:** the major secondary or committed sword action.
3. **Dash Attack:** the offensive follow-up after the universal neutral dash.
4. **Parry Counter:** the direct attack after the universal parry.
5. **Blood Art:** later only, if retained by the final progression system.

The Held Attack should be treated as a genuine secondary action. It may be a lunge, extension, draw cut, impale, heavy sweep, or another coherent sword move.

## Combo guidance

Combo structure is a weapon property, not an objective.

A good kit allows the player to:

- stop after one hit,
- continue the sequence,
- defend,
- dash,
- redirect,
- use a Prosthetic,
- or abandon the sequence.

Avoid making the player feel that they failed the Aspect because they did not:

- complete every sequence,
- loop the final hit,
- preserve a combo state,
- or reach one named attack.

## Approved sequence cadence

| Aspect | Sequence length | Cadence purpose |
|---|---:|---|
| Wolf | Four attacks | Sustained close pressure and target pursuit |
| Wraith | Two attacks | Extended pokes and quick return to movement or defense |
| Ronin | Three attacks | Slow escalating impact and heavy direct damage |

Sequence length must serve the moves themselves rather than exist only to make the roster numerically different.

## Movement guidance

Attack movement may reinforce a kit, but movement should not substitute for the kit.

Avoid:

- forced lateral movement on every sequence,
- mandatory offset finishing positions,
- automatic orbiting behind targets,
- every counter relocating Akio,
- and directional movement input choosing unrelated sword attacks.

A spacing-focused style can emerge from long reach, broad geometry, short commitments, low tracking, and whiff recovery without forcing Akio to move after each attack.

## Candidate evaluation template

### Kit definition

- **Player-facing label:** What simple weapon style is this?
- **Fantasy:** How does Returning Blood alter the katana?
- **Basic Attack:** What physically happens on one press and repeated presses?
- **Held Attack:** What major secondary action does hold and release provide?
- **Dash Attack:** What attack follows the universal dash?
- **Parry Counter:** What direct response follows a universal parry?

### Weapon properties

- **Range:** How far do normal and committed attacks reach?
- **Cadence:** Fast, sustained, measured, slow, burst-oriented, or variable?
- **Geometry:** Narrow lines, wide arcs, frontal coverage, or another shape?
- **Attack movement:** How much does Akio move because the sword action requires it?
- **Tracking:** How strongly do attacks correct toward moving targets?
- **Damage:** What is the relative per-hit and sustained health output?
- **Enemy posture:** Is pressure repeated, focused, heavy per hit, or situational?
- **Stagger:** How strongly do ordinary enemies react to clean hits?
- **Commitment:** Which attacks are safe tests and which are major decisions?
- **Recovery:** What happens after contact, block, and a miss?
- **Target handling:** How does the kit deal with one target, nearby enemies, and target transfer?
- **Defense:** Do modest posture or block differences support the kit without replacing it?

### Game-wide fit

- **Natural strengths:** What do the moves make easier?
- **Natural weaknesses:** What do the same moves make harder?
- **Encounter coverage:** How does it handle groups, ranged enemies, elites, hazards, and bosses?
- **Technique space:** How can Techniques reinforce, broaden, compensate, and hybridize it?
- **Production scope:** What unique animations, VFX, audio, and teaching content are required?

## Approval standard

A candidate is ready for comparison when:

- the moves can be described without relying on abstract behavioral instructions,
- the basic and held attacks form a coherent weapon kit,
- its strengths and weaknesses emerge from attack properties,
- its dash attack and parry counter reinforce the kit without rewriting universal controls,
- it supports ordinary defense, deathblows, Techniques, and prosthetics,
- it works in both crowds and single-target encounters,
- and it can be distinguished from the other candidates during the first combat room.

Exact frame data, hitboxes, values, animation counts, Blood Arts, and progression remain later work.

## Current candidate status

All three candidates are approved at qualitative Tier 0 weapon-kit depth for comparison. Final combined roster approval remains pending the overlap and gap audit.

### Wolf — fast close-range pressure kit

Concrete direction:

- Fang Slash → Rending Cross → Raking Fang → Blood Cleave,
- four-hit fastest sequence,
- short reach,
- forward attack movement,
- strong nearby tracking,
- moderate per-hit damage,
- strong sustained health and enemy-posture output,
- Predator's Passage as the Held Attack,
- Hunting Slash as the advancing Dash Attack,
- and Fang Reversal as the advancing Parry Counter.

Wolf changed from three to four attacks because an additional fast pursuit strike better expresses sustained pressure. The sequence remains optional at every step.

See [Wolf Blood Aspect](WOLF_ASPECT.md).

### Wraith — extended spectral poke and reach-control kit

Concrete direction:

- Veil Cut → Passing Arc,
- two-hit short sequence,
- longest effective melee reach,
- narrow extended opener and broad spectral follow-up,
- quick return to movement or defense,
- moderate damage,
- restrained tracking,
- Pale Lance as the longest focused Held Attack,
- Ghostline Slash as a quick extended Dash Attack,
- and Veil Reversal as a long-reaching Parry Counter.

Wraith's spacing emerges from attack reach and geometry. Mandatory lateral movement, special offset finishes, and a required repositioning loop remain rejected.

See [Wraith Blood Aspect](WRAITH_ASPECT.md).

### Ronin — slow precise heavy-hitting kit

Concrete direction:

- Severing Cut → Crushing Cross → Bloodfall,
- three-hit slow sequence,
- conventional medium sword reach,
- highest per-hit health damage,
- highest or near-highest per-hit enemy-posture pressure,
- strongest ordinary-enemy stagger,
- minimal attack movement,
- restrained tracking and severe whiff recovery,
- Stillness Draw as the defining high-damage Held Attack,
- Breaching Slash as a quicker lower-power Dash Attack,
- Answering Steel as a high-payoff Parry Counter,
- and a stronger guard profile balanced by slow posture recovery and committed attacks.

Ronin is not built around maintaining a combo or reaching Bloodfall. Each heavy strike remains useful independently.

See [Ronin Blood Aspect](RONIN_ASPECT.md).

## Cross-roster comparison lens

| Property | Wolf | Wraith | Ronin |
|---|---|---|---|
| Style | Fast close pressure | Long-range spectral poking | Slow heavy direct damage |
| Sequence | Four hits | Two hits | Three hits |
| Range | Close | Longest | Medium |
| Cadence | Fastest | Short and quick-to-moderate | Slowest |
| Per-hit damage | Moderate | Moderate | Highest |
| Sustained output | Highest while connected | Moderate | Opening-dependent |
| Attack movement | Forward | Restrained | Minimal |
| Tracking | Strong nearby | Restrained | Low-to-moderate |
| Held Attack purpose | Pursuit | Reach | Power |
| Primary risk | Overextension | Pressure inside preferred range | Missed heavy commitment |

## Technique compatibility lens

Techniques should target universal action categories:

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

Do not create a separate Wolf, Wraith, and Ronin version of each ordinary Technique. The underlying move differences create different results.

Each kit must support:

- **reinforce** builds,
- **broaden** builds,
- **compensate** builds,
- and **hybridize** builds.

No Aspect owns all attack, range, movement, damage, posture, parry, block, or deathblow Techniques.

## Future roster capacity

The weapon-kit model may eventually support a fourth and fifth Aspect.

They remain outside current launch paper-design and production scope. First complete, implement, and test the three current candidates. Additional Aspects require evidence of a missing combat identity that cannot be addressed through the existing roster, Techniques, or prosthetics.

## Next design task

Perform the three-Aspect roster overlap and gap audit.

The audit should confirm:

- concrete separation between all three kits,
- mixed-wave, crowd, ranged, hazard, elite, and boss viability,
- several Technique build directions per kit,
- retained Prosthetic and Technique design space,
- acceptable animation, VFX, audio, UI, and teaching scope,
- and whether any kit needs revision before final roster approval.