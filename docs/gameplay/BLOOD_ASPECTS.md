---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: draft
authority: primary
last_reviewed: 2026-07-26
topics:
  - blood-aspects
  - blood-arts
  - blood-resource
  - wolf
  - wraith
  - ronin
  - corruption
  - run-progression
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-COMBAT
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - GAMEPLAY-CORRUPTION-SHRINES
  - GAMEPLAY-PROGRESSION
  - LORE-RETURNING-BLOOD
  - META-OPEN-QUESTIONS
---

# Blood Aspect System

## Approved foundation

The player selects one Blood Aspect before a run. The selected Aspect is active from Tier 0 and establishes the run's immediate sword-combat identity before any Technique is acquired.

The current launch baseline contains three Aspects.

Every launch Aspect:

- represents Akio shaping Returning Blood through the same physical katana,
- uses the same controller layout,
- uses the same neutral movement and dash,
- participates in the same block, parry, posture, deathblow, Technique, and prosthetic systems,
- remains viable against groups, ranged pressure, hazards, elites, and bosses,
- and owns a complete sword kit assigned to the shared offensive input slots.

The authoritative design model is [Blood Aspect Weapon-Kit Model](ASPECT_WEAPON_KIT_MODEL.md).

## Current design correction

Blood Aspects should be designed like distinct weapon kits, not like passive stances or behavioral challenges.

The governing rule is:

> **The moves create the playstyle. The player should not need to maintain a separate combo goal, forced movement loop, or Aspect-specific minigame in order to use the kit correctly.**

An Aspect's identity should emerge from connected differences in:

- basic attack sequence,
- held attack,
- dash attack,
- parry counter,
- attack timing,
- range,
- hit geometry,
- movement attached to attacks,
- tracking,
- damage,
- enemy-posture pressure,
- commitment,
- recovery,
- and Blood-katana presentation.

## Shared action slots

Every Aspect receives the following offensive action slots:

| Shared slot | Aspect responsibility |
|---|---|
| Basic Attack | Primary attack sequence and normal swordplay |
| Held Attack | Major secondary or committed sword action |
| Dash Attack | Offensive follow-up after the universal neutral dash |
| Parry Counter | Offensive response after the universal parry |
| Blood Art | Possible later signature activation if retained |

`Quick Slash`, `Cross Cut`, `Heavy Cleave`, `Hold Thrust`, `Counter Cut`, and `Dash Slash` are not mandatory universal move names or roles.

Different Aspects may use:

- different sequence lengths,
- different attack names,
- different attack rhythms,
- different secondary actions,
- and different offensive follow-ups.

## Universal launch framework

During the initial roster identity pass, the following remain functionally universal:

- input layout and control scheme,
- ordinary locomotion speed,
- neutral dash distance, speed, startup, invulnerability, recovery, steering, collision, and repeat availability,
- block rules and baseline block efficiency,
- player-posture capacity and recovery rules,
- parry timing and success rules,
- enemy telegraphs and response logic,
- posture break, stagger, and deathblow rules,
- deathblow eligibility and standard execution positioning,
- Spirit and prosthetic controls,
- Technique slots, acquisition, reserve, replacement, and refinement rules,
- and combat interface and readability language.

These are not current Aspect identity levers.

Do not define a launch Aspect through:

- a weaker or stronger neutral dash,
- a different base player-posture bar,
- uniquely efficient or inefficient sustained block,
- removal of block or parry,
- or a unique deathblow system.

Such changes may be reconsidered only after the weapon kits are playable and a demonstrated need justifies the additional compatibility, balance, onboarding, and production burden.

## Combo and sequence rule

A basic attack sequence is a set of available attacks, not the required objective of the Aspect.

The player may stop after any attack, defend, dash, switch targets, use a Prosthetic, or abandon the sequence. A candidate should not be built around:

- preserving a combo through unrelated actions,
- reaching a finisher as its central goal,
- looping a sequence as a mandatory success condition,
- or following one prescribed behavioral cycle.

Sequence length remains a valid weapon property when it creates a clear cadence and attack shape.

## Movement rule

Attack-bound movement remains valid when it naturally belongs to the attack.

Avoid using forced repositioning as a substitute for a complete weapon identity. An Aspect should not require:

- ordinary attacks to move laterally every time,
- every counter to move off-axis,
- every dash attack to end at a special offset,
- automatic movement behind enemies,
- or directional movement input to select unrelated basic attacks.

Spacing and movement should usually emerge from the kit's reach, geometry, commitment, and recovery.

## Aspect and Technique responsibilities

### Aspects own the foundation

An Aspect is:

- chosen before the run,
- active from Tier 0,
- always present during combat,
- responsible for the complete starting sword kit,
- and the owner of any later Aspect-specific vertical progression that survives final system approval.

An Aspect must function before finding a particular Technique.

### Techniques own modular development

Techniques are temporary, replaceable run rewards. The current inventory model remains four active Techniques plus one inactive reserve.

Ordinary Techniques modify universal action tags such as:

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

A Technique uses one rule across every Aspect. The result may differ naturally because the underlying kit differs.

Technique builds may:

1. **Reinforce** the selected kit's strengths.
2. **Broaden** it into an adjacent combat pattern.
3. **Compensate** for a natural weakness at the cost of a slot.
4. **Hybridize** it with another combat emphasis.

Ordinary Techniques are not hard-locked to one Aspect or minimum Tier. Affinity may later affect weighting or amplification, not eligibility.

## Current roster status

### Wolf — approved for roster comparison

Wolf remains the close-range aggressive kit.

Approved working characteristics:

- fast short-range three-hit attack sequence,
- strong forward movement within attacks,
- strong nearby target correction,
- moderate per-hit damage with strong sustained output,
- repeated enemy-posture pressure,
- Predator's Passage as a committed pursuit lunge,
- Hunting Slash as an advancing dash attack,
- and Fang Reversal as a fast advancing parry counter.

Wolf's sequence is an available pressure pattern, not a required combo-maintenance objective. The player may stop, defend, or redirect whenever the encounter demands it.

The authoritative Wolf package is [Wolf Blood Aspect](WOLF_ASPECT.md).

### Wraith — reopened

Wraith's previous complete Tier 0 approval is partially superseded by the weapon-kit correction.

Retained working identity territory:

- spectral Blood-katana expression,
- medium-to-long melee reach,
- strong line and arc coverage,
- deliberate attack timing,
- Pale Lance as a possible long narrow held attack,
- and natural weakness when enemies collapse inside its preferred range.

Reopened decisions:

- basic sequence length and exact attacks,
- Passing Arc,
- mandatory lateral movement,
- Ghostline Slash's special finishing position,
- Veil Reversal's forced movement,
- defensive-profile differences,
- and reposition-and-reassess as a prescribed gameplay loop.

The next active design task is to rebuild Wraith as a concrete extended spectral weapon kit whose spacing playstyle emerges from attack properties.

See [Wraith Blood Aspect](WRAITH_ASPECT.md).

### Ronin — unresolved

Ronin remains a working roster position with no approved Tier 0 weapon kit.

Discarded directions:

- preserving a combo through defense,
- playing around reaching Judgment Stroke,
- and selecting basic attacks through movement-direction input.

Ronin must become a complete weapon style with a distinct tempo, range, geometry, commitment, damage, and enemy-posture profile. A deliberate high-impact katana remains one possible direction, not an approved answer.

## Roster process

1. Preserve Wolf as the current first comparison kit.
2. Redesign Wraith under the weapon-kit model.
3. Define Ronin under the same model.
4. Compare all three for overlap, missing territory, encounter viability, Technique space, and production cost.
5. Revise, rename, combine, or replace candidates as needed.
6. Approve the final three-row launch identity roster.
7. Only then decide exact progression, Blood, Blood Arts, drawbacks, Corruption, affinities, and production packages.

## Roster approval test

The roster is not ready unless:

- each Aspect can be explained as a concrete sword kit,
- each kit feels distinct through ordinary attacks before Techniques,
- no kit depends on one mandatory behavioral loop,
- no kit is merely a stronger or weaker version of another,
- shared controls and enemy rules remain readable,
- neutral movement, block, player posture, and deathblows remain stable,
- each kit works against groups, ranged pressure, hazards, elites, and bosses,
- each supports several Technique build directions,
- Techniques and prosthetics retain meaningful design space,
- and the required animation, VFX, audio, UI, and trial scope remains achievable.

## Working progression structure — not approved

The previous design used:

- **Tier 0:** immediate combat foundation,
- **Tier I:** deepen the foundation and possibly introduce risk,
- **Tier II:** possibly unlock run-only Blood and one Blood Art,
- **Tier III:** deepen the established specialization,
- **Tier IV:** optional capstone with the strongest expression of the same risk.

Additional working rules included:

- Tier II or III as a common successful-run endpoint,
- Tier IV as difficult and occasional rather than mandatory,
- no Tier V,
- no unrelated mechanic added at every Tier,
- and no progression path that makes Techniques secondary.

This structure remains a candidate. It must not constrain the weapon-kit roster if a simpler system proves stronger.

## Working Blood model — not approved

The previous design treated Blood as:

- run-only,
- inactive before Tier II,
- generated through combat,
- used only for the selected Aspect's Blood Art,
- reset after death or completion,
- and unavailable as a shop, route, Strand, or persistent currency.

Blood capacity, gain rules, activation, retention, boss behavior, anti-farming rules, and individual Blood Arts remain unresolved.

## Future Aspect capacity

The weapon-kit model leaves plausible room for a fourth and possibly fifth Aspect in future development.

Neither is part of current launch paper-design, production, animation, VFX, UI, trial, content-count, or milestone scope.

Complete and test the three current launch candidates first. Expansion requires playable evidence of a missing combat identity that cannot be addressed through the existing roster, Techniques, or prosthetics.

## Related documents

- [Aspect Weapon-Kit Model](ASPECT_WEAPON_KIT_MODEL.md)
- [Aspect Identity Guidelines](ASPECT_IDENTITY_GUIDELINES.md)
- [Wolf Blood Aspect](WOLF_ASPECT.md)
- [Wraith Blood Aspect](WRAITH_ASPECT.md)
- [Combat](COMBAT.md)
- [Technique System](TECHNIQUES.md)
- [Technique Catalog](TECHNIQUE_CATALOG.md)
- [Current Design Questions](../_meta/OPEN_QUESTIONS.md)
- [Returning Blood](../lore/RETURNING_BLOOD.md)
- [Corruption and Shrines](CORRUPTION_AND_SHRINES.md)
