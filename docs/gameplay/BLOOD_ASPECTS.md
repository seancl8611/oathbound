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
  - GAMEPLAY-RONIN-ASPECT
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

The current launch baseline contains three Aspects:

- Wolf,
- Wraith,
- and Ronin.

Every launch Aspect:

- represents Akio shaping Returning Blood through the same physical katana,
- uses the same controller layout,
- uses the same neutral movement and dash,
- participates in the same block, parry, posture, deathblow, Technique, and prosthetic systems,
- remains viable against groups, ranged pressure, hazards, elites, and bosses,
- and owns a complete sword kit assigned to shared offensive input slots.

The authoritative design model is [Blood Aspect Weapon-Kit Model](ASPECT_WEAPON_KIT_MODEL.md).

## Governing design rule

Blood Aspects are designed like distinct weapon kits, not passive stances or behavioral challenges.

> **The moves create the playstyle. The player should not need to maintain a separate combo goal, forced movement loop, or Aspect-specific minigame to use the kit correctly.**

An Aspect's identity emerges from connected differences in:

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
- stagger,
- commitment,
- recovery,
- modest defensive profile where approved,
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

Different Aspects may use different sequence lengths, attack names, rhythms, secondary actions, and offensive follow-ups.

## Universal launch framework

The following remain functionally universal:

- input layout and control scheme,
- ordinary locomotion speed,
- neutral dash distance, speed, startup, invulnerability, recovery, steering, collision, and repeat availability,
- defense input,
- parry timing and success rules,
- enemy telegraphs and response logic,
- posture-break, stagger, and deathblow language,
- deathblow eligibility and execution behavior,
- Spirit and prosthetic controls,
- Technique slots, acquisition, reserve, replacement, and refinement rules,
- and combat interface and readability language.

Aspect selection must not weaken dependable evasion or arena navigation through a shorter, slower, or less responsive neutral dash.

## Defensive-profile boundary

All launch Aspects retain block, parry, dodge, player posture, and deathblows.

A complete weapon kit may use modest differences in:

- player-posture capacity,
- posture damage received while blocking,
- posture recovery direction,
- defensive access after attacks,
- and the payoff of the Aspect-specific Parry Counter.

Parry timing, parry success conditions, defense input, posture-break consequences, and enemy attack rules remain universal.

No launch Aspect removes block or parry, gains automatic counters, becomes immune to posture break, or recovers posture freely while actively blocking.

## Combo and sequence rule

A basic attack sequence is a set of available attacks, not the required objective of the Aspect.

The player may stop after any attack, defend, dash, switch targets, use a Prosthetic, or abandon the sequence.

A candidate should not be built around:

- preserving a combo through unrelated actions,
- reaching a finisher as its central goal,
- looping a sequence as a mandatory success condition,
- or following one prescribed behavioral cycle.

Sequence length remains a valid weapon property when it creates a clear cadence and attack shape.

## Approved sequence structure and rationale

| Aspect | Sequence | Reason |
|---|---|---|
| Wolf | Four hits | Longest and fastest string supports sustained pressure and nearby target transfer |
| Wraith | Two hits | Short extended-range string supports poking and quick return to movement or defense |
| Ronin | Three hits | Slower escalating strikes support heavy impact without requiring combo completion |

The sequence lengths are not objectives or balance rewards. Each attack must remain useful when the player stops before the sequence ends.

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

Wolf, Wraith, and Ronin are each approved at qualitative Tier 0 weapon-kit depth for roster comparison.

This approval does not yet approve the final combined launch roster. The next step is the three-kit overlap, gap, encounter, Technique-space, and production audit.

### Wolf — fast close-range pressure kit

Approved package:

- **Basic Attack:** Fang Slash → Rending Cross → Raking Fang → Blood Cleave,
- **Held Attack:** Predator's Passage,
- **Dash Attack:** Hunting Slash,
- **Parry Counter:** Fang Reversal,
- shortest or near-shortest normal reach,
- fastest cadence,
- strong forward attack movement,
- strong nearby target correction,
- moderate per-hit damage,
- strong sustained health and enemy-posture output,
- and significant whiff and overcommitment risk.

Wolf changed from three attacks to four because another fast pursuit strike better expresses its sustained pressure identity. The fourth hit does not create a completion requirement.

The authoritative package is [Wolf Blood Aspect](WOLF_ASPECT.md).

### Wraith — extended spectral poke and reach-control kit

Approved package:

- **Basic Attack:** Veil Cut → Passing Arc,
- **Held Attack:** Pale Lance,
- **Dash Attack:** Ghostline Slash,
- **Parry Counter:** Veil Reversal,
- longest effective melee reach,
- short quick-to-moderate attack commitments,
- narrow lines and broad spectral arcs,
- moderate damage,
- controlled enemy-posture pressure,
- limited tracking after commitment,
- and weakness when enemies enter inside its preferred range.

Wraith retains a two-hit sequence because short strings reinforce poking and quick return to movement or defense. Mandatory lateral movement, forced offset finishes, and prescribed repositioning are not part of the approved kit.

The authoritative package is [Wraith Blood Aspect](WRAITH_ASPECT.md).

### Ronin — slow precise heavy-hitting kit

Approved package:

- **Basic Attack:** Severing Cut → Crushing Cross → Bloodfall,
- **Held Attack:** Stillness Draw,
- **Dash Attack:** Breaching Slash,
- **Parry Counter:** Answering Steel,
- conventional medium sword reach,
- slowest basic cadence,
- highest per-hit health damage,
- highest or near-highest per-hit enemy-posture pressure,
- strongest ordinary-enemy stagger,
- minimal attack-bound movement,
- restrained tracking,
- severe whiff recovery,
- and a stronger guard profile balanced by slower posture recovery and attack commitment.

Ronin rejects combo preservation and directional attack selection. Its three-hit sequence exists to provide three increasingly committed heavy strikes, not to make Bloodfall the player's required goal.

Stillness Draw is a major identity anchor because Ronin's Held Attack should reinforce raw damage and posture impact rather than extended Wraith-like reach.

Breaching Slash remains faster and more convenient than Ronin's normal heavy attacks, but deals less damage, posture pressure, and stagger so it does not replace the main sequence.

The authoritative package is [Ronin Blood Aspect](RONIN_ASPECT.md).

## Cross-roster distinction

| Property | Wolf | Wraith | Ronin |
|---|---|---|---|
| Player-facing style | Fast close pressure | Long-range spectral poking | Slow heavy direct damage |
| Basic sequence | Four hits | Two hits | Three hits |
| Preferred range | Close | Medium-to-long | Medium |
| Cadence | Fastest and sustained | Short and quick-to-moderate | Slowest and deliberate |
| Per-hit damage | Moderate | Moderate | Highest |
| Sustained output | Highest while connected | Moderate | Opening-dependent |
| Enemy posture | Repeated pressure | Focused extended attacks | Large chunks per strike |
| Attack movement | Strongly forward | Restrained | Minimal and grounded |
| Tracking | Strong nearby | Restrained | Low-to-moderate |
| Held Attack identity | Pursuit | Reach | Power |
| Main failure state | Overextension | Enemy gets inside range | Missed heavy commitment |

## Roster process

1. Treat Wolf, Wraith, and Ronin as approved qualitative comparison kits.
2. Compare all three for overlap and missing combat territory.
3. Confirm mixed-wave, crowd, ranged, hazard, elite, and boss viability.
4. Confirm several four-Technique build directions for each kit.
5. Confirm Techniques and prosthetics retain meaningful design space.
6. Estimate required animation, VFX, audio, UI, and trial scope.
7. Revise, rename, combine, or replace candidates if the audit reveals a problem.
8. Approve the final three-row launch roster.
9. Only then decide exact progression, Blood, Blood Arts, drawbacks, Corruption, affinities, and production packages.

## Roster approval test

The roster is not ready unless:

- each Aspect can be explained as a concrete sword kit,
- each kit feels distinct through ordinary attacks before Techniques,
- no kit depends on one mandatory behavioral loop,
- no kit is merely a stronger or weaker version of another,
- shared controls and enemy rules remain readable,
- neutral movement remains stable,
- defensive differences remain limited and balanced,
- each kit works against groups, ranged pressure, hazards, elites, and bosses,
- each supports several Technique build directions,
- Techniques and prosthetics retain meaningful design space,
- and required animation, VFX, audio, UI, and trial scope remains achievable.

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
- [Ronin Blood Aspect](RONIN_ASPECT.md)
- [Combat](COMBAT.md)
- [Technique System](TECHNIQUES.md)
- [Technique Catalog](TECHNIQUE_CATALOG.md)
- [Current Design Questions](../_meta/OPEN_QUESTIONS.md)
- [Returning Blood](../lore/RETURNING_BLOOD.md)
- [Corruption and Shrines](CORRUPTION_AND_SHRINES.md)