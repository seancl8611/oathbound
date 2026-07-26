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
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - META-OPEN-QUESTIONS
---

# Blood Aspect Identity Guidelines

## Current evaluation principle

Blood Aspects are evaluated as complete sword weapon kits that share one control and combat language.

The approved design rule is:

> **Define concrete moves first. Let the moves' timing, range, geometry, damage, posture, tracking, commitment, and recovery create the playstyle naturally.**

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

## Universal layer during roster design

The initial three launch candidates share:

- controller layout,
- neutral locomotion,
- neutral dash properties,
- block rules and baseline efficiency,
- player-posture capacity and recovery,
- parry timing,
- deathblow eligibility and execution behavior,
- enemy responses,
- Technique rules,
- prosthetic controls,
- and combat interface language.

The identity pass should not differentiate candidates through:

- weaker or stronger neutral dashes,
- different base player-posture bars,
- different sustained-block efficiency,
- unique deathblow positioning or effects,
- removal of a defensive action,
- or a new resource or input.

These systems may be revisited only after the weapon kits themselves are playable and a demonstrated need exists.

## Shared offensive slots

Every candidate must define:

1. **Basic Attack:** the primary sequence produced by one or repeated presses.
2. **Held Attack:** the major secondary or committed sword action.
3. **Dash Attack:** the offensive follow-up after the universal neutral dash.
4. **Parry Counter:** the direct attack after the universal parry.
5. **Blood Art:** later only, if retained by the final progression system.

The held attack should be treated as a genuine secondary action. It may be a lunge, sweep, draw cut, impale, Blood extension, transformation attack, or another coherent sword move.

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

## Movement guidance

Attack movement may reinforce a kit, but movement should not be the substitute for the kit.

Avoid:

- forced lateral movement on every sequence,
- mandatory offset finishing positions,
- automatic orbiting behind targets,
- every counter relocating Akio,
- and directional movement input choosing unrelated sword attacks.

A spacing-focused style can emerge from long reach, broad geometry, slower timing, low tracking, and whiff recovery without forcing Akio to move after each attack.

## Candidate evaluation template

Evaluate each candidate using concrete gameplay properties.

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
- **Geometry:** Narrow lines, wide arcs, frontal coverage, circular coverage, or another shape?
- **Attack movement:** How much does Akio move because the sword action itself requires it?
- **Tracking:** How strongly do attacks correct toward moving targets?
- **Damage:** What is the relative per-hit and sustained health output?
- **Enemy posture:** Is pressure repeated, focused, heavy per hit, or situational?
- **Commitment:** Which attacks are safe tests and which are major decisions?
- **Recovery:** What happens after contact, block, and a miss?
- **Target handling:** How does the kit deal with one target, nearby enemies, and target transfer?

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
- its dash attack and parry counter reinforce the kit without rewriting universal systems,
- it supports ordinary defense, deathblows, Techniques, and prosthetics,
- it works in both crowds and single-target encounters,
- and it can be distinguished from the other candidates during the first combat room.

Exact frame data, hitboxes, values, animation counts, Blood Arts, and progression remain later work.

## Current candidate status

### Wolf — approved for comparison

**Working label:** fast close-range pressure kit.

Concrete direction:

- Fang Slash → Rending Cross → Blood Cleave,
- short reach,
- fast cadence,
- forward attack movement,
- strong nearby tracking,
- moderate per-hit damage,
- strong sustained health and enemy-posture output,
- Predator's Passage as the held pursuit lunge,
- Hunting Slash as the advancing dash attack,
- and Fang Reversal as the advancing parry counter.

Important correction:

Wolf's three-hit sequence is not a required combo objective. Completing or restarting the chain is one available offensive pattern. The player remains free to stop, defend, redirect, or use another action.

See [Wolf Blood Aspect](WOLF_ASPECT.md).

### Wraith — reopened

**Retained working label:** extended spectral blade or spectral reach-control kit.

Promising territory:

- medium-to-long melee reach,
- Blood-formed blade extensions,
- strong lines and arcs,
- deliberate timing,
- Pale Lance as a possible long narrow held attack,
- and natural weakness when enemies enter inside its preferred range.

No longer approved:

- mandatory lateral movement in Passing Arc,
- a required reposition-and-reassess loop,
- special offset finishing positions for every offensive action,
- forced off-axis parry counter movement,
- weaker base block,
- and lower base player posture.

Wraith must be redesigned before it returns to approved comparison status.

See [Wraith Blood Aspect](WRAITH_ASPECT.md).

### Ronin — unresolved

The following proposals are rejected:

- preserving a combo through defense,
- building play around reaching Judgment Stroke,
- and movement-direction input selecting different basic attacks.

Ronin requires a new complete weapon-kit direction.

A slower, deliberate, high-impact katana with stronger per-hit damage and enemy-posture pressure is a possible exploration path, not an approved concept.

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

Do not create a separate Wolf, Wraith, and Ronin version of each ordinary Technique. The underlying move differences create the different results.

Each kit must support:

- **reinforce** builds,
- **broaden** builds,
- **compensate** builds,
- and **hybridize** builds.

No Aspect owns all attack, range, movement, posture, parry, or deathblow Techniques.

## Future roster capacity

The weapon-kit model may eventually support a fourth and fifth Aspect.

They remain outside current launch paper-design and production scope. First complete, implement, and test the three current candidates. Additional Aspects require evidence of a missing combat identity that cannot be addressed through the existing roster, Techniques, or prosthetics.

## Next design task

Redesign Wraith under the weapon-kit model.

Start with concrete alternatives for:

- basic sequence length and attacks,
- attack cadence,
- reach and geometry,
- held attack,
- dash attack,
- parry counter,
- damage and enemy-posture profile,
- tracking,
- and recovery.

Do not begin from forced repositioning, altered deathblows, altered player posture, or altered block efficiency.
