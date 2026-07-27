---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: approved
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
  - GAMEPLAY-CORRUPTION-SHRINES
  - GAMEPLAY-PROGRESSION
  - LORE-RETURNING-BLOOD
  - META-OPEN-QUESTIONS
---

# Blood Aspect System

## Approved launch foundation

After Returning Blood awakens, the player selects one Blood Aspect before each run. The selected Aspect begins at Tier 0 and immediately replaces the introductory sword moveset with a complete Blood-formed katana weapon kit.

The approved launch roster is:

- **Wolf** — fast close-range pressure and pursuit,
- **Wraith** — extended spectral reach and frontal control,
- **Ronin** — slow heavy impact and defensive stability.

These three identities are the complete current launch space. A fourth or fifth Aspect is not part of current paper design, production, animation, VFX, UI, trial, catalog, or milestone scope. Expansion requires later playable evidence of a missing identity that cannot be covered by the three kits, universal combat, Techniques, or prosthetics.

## Governing rule

Blood Aspects are distinct katana weapon kits, not passive stances, branching classes, or behavioral minigames.

> **The moves create the playstyle. The player should not need to maintain a combo goal, forced movement loop, or separate Aspect-specific meter to use a kit correctly.**

Each kit may differ through:

- Basic Attack sequence and cadence,
- Held Attack,
- Dash Attack,
- Parry Counter,
- reach and hit geometry,
- attack-bound movement and tracking,
- health damage and enemy-posture pressure,
- stagger,
- commitment and recovery,
- target handling,
- modest approved defensive properties,
- and Blood-katana presentation.

## Shared action slots

| Shared slot | Responsibility |
|---|---|
| Basic Attack | Primary attack sequence and ordinary swordplay |
| Held Attack | Major secondary or committed sword action |
| Dash Attack | Offensive follow-up after the universal neutral dash |
| Parry Counter | Offensive response after a universal parry |
| Blood Art | Tier II Blood-powered signature action or state, finalized in the Aspect progression package |

A sequence is a set of available attacks, not a completion objective. The player may stop, defend, dash, redirect, use a Prosthetic, or abandon the sequence whenever the encounter demands it.

## Universal combat layer

Every launch Aspect retains the same functional:

- controller layout,
- ordinary locomotion,
- neutral dash distance, speed, startup, invulnerability, recovery, steering, collision, and repeat availability,
- defense input and parry timing,
- enemy telegraphs and response rules,
- posture-break, stagger, and deathblow language,
- Spirit and prosthetic controls,
- Technique inventory and refinement rules,
- and combat interface language.

Aspect selection does not create a weaker or stronger neutral dash. No launch Aspect removes block or parry, changes parry success conditions, becomes immune to posture break, or receives automatic counters.

Modest defensive differences may use player-posture capacity, block posture efficiency, posture recovery direction, defensive access after attacks, and Parry Counter payoff. These differences must remain subordinate to the shared defense system.

## Approved roster

| Aspect | Basic sequence | Held identity | Primary strength | Firm tradeoff |
|---|---|---|---|---|
| Wolf | Fang Slash → Rending Cross → Raking Fang → Blood Cleave | Predator's Passage — pursuit | Fast sustained close pressure, nearby tracking, and target transfer | Missed pursuit and extended pressure create dangerous overcommitment and punish windows |
| Wraith | Veil Cut → Passing Arc | Pale Lance — reach | Longest melee reach, line control, broad spectral arcs, and short commitments | Point-blank pressure, cramped spaces, and attacks from several directions undermine its spacing advantage |
| Ronin | Severing Cut → Crushing Cross → Bloodfall | Stillness Draw — power | Highest per-hit impact, posture chunks, ordinary-enemy stagger, and strongest guard profile | Slow startup, severe recovery, low tracking, and slow posture recovery punish bad commitments |

Supporting actions:

| Aspect | Dash Attack | Parry Counter |
|---|---|---|
| Wolf | Hunting Slash | Fang Reversal |
| Wraith | Ghostline Slash | Veil Reversal |
| Ronin | Breaching Slash | Answering Steel |

The roster deliberately does not include a dedicated teleport, projectile, full-circle crowd-clear, or pure evasion Aspect. Mobility, ranged utility, broad crowd control, and defensive specialization remain shared-system, Technique, and prosthetic territory.

## Aspect and Technique responsibilities

### Aspects

An Aspect is:

- selected before the run,
- active from Tier 0,
- always present during combat,
- responsible for the complete starting sword kit,
- and the owner of fixed vertical Tier progression during that run.

An Aspect must function before a specific Technique is acquired.

### Techniques

Techniques are temporary, replaceable run rewards. The approved inventory is four active Techniques plus one inactive reserve, with at most one refinement per Technique.

Ordinary Techniques use universal action tags such as Basic Attack, Held Attack, Dash Attack, Parry Counter, Block, Parry, Deathblow, Prosthetic, Health, Enemy Posture, Player Posture, and Movement.

One Technique uses one rule across every Aspect. Its value may differ naturally because the underlying weapon kits differ. Builds may reinforce, broaden, compensate for, or hybridize the selected kit.

Ordinary Techniques are not hard-locked to one Aspect or Tier. Affinity may affect weighting or amplification after those rules are approved; it does not determine basic eligibility.

## Approved Tier and Shrine contract

Aspect progression is fixed rather than a branching package selection.

- Every run begins at **Tier 0**.
- Corruption fills through approved combat and progression events.
- At a full threshold, a Shrine offers **Resist** or **Embrace**.
- **Resist** keeps the current Tier, lowers Corruption, and grants approved immediate support.
- **Embrace** advances the selected Aspect by one fixed Tier and empties Corruption.
- Each Tier presents one headline improvement and at most one minor supporting rule.
- Each Aspect uses one evolving drawback family rather than accumulating unrelated penalties.
- **Tier IV** is the maximum.
- At Tier IV, a full threshold offers **Stabilize** rather than Tier V or more permanent power.

The player's choice is whether to advance now, not which branch of upgrades to select. Exact Tier I-IV benefits and drawbacks remain to be authored for each Aspect.

## Blood contract

Blood is a run-only combat resource owned by the selected Aspect.

Approved boundaries:

- Blood is unavailable before Tier II.
- Blood does not exist as a persistent wallet, shop currency, route currency, or campaign collectible.
- Blood and Blood Art state reset after death or successful completion.
- Blood progression must deepen the selected weapon kit without replacing ordinary swordplay or making Techniques secondary.

Still unresolved:

- Blood generation and anti-farming rules,
- capacity and retention,
- activation input and conditions,
- duration or cooldown behavior,
- the exact Blood Art for each Aspect,
- and Tier interactions with Blood Art behavior.

## Remaining design package

The roster and fixed progression structure are approved. The next Aspect work is to define:

1. Wolf's fixed Tier I-IV benefits, drawback family, Blood rules, and Blood Art.
2. Wraith's fixed Tier I-IV benefits, drawback family, Blood rules, and Blood Art.
3. Ronin's fixed Tier I-IV benefits, drawback family, Blood rules, and Blood Art.
4. Shared affinity and limited direct Aspect-, Tier-, or Blood-Technique exceptions.
5. Required animation, VFX, audio, HUD, Shrine, selection, trial, and persistent-progression states.

Exact frame data, hitboxes, chain windows, damage, posture, stagger, tracking, recovery, and numerical resource values remain implementation and playtesting work in the owning files.

## Related documents

- [Aspect Weapon-Kit Model](ASPECT_WEAPON_KIT_MODEL.md)
- [Aspect Identity Guidelines](ASPECT_IDENTITY_GUIDELINES.md)
- [Wolf Blood Aspect](WOLF_ASPECT.md)
- [Wraith Blood Aspect](WRAITH_ASPECT.md)
- [Ronin Blood Aspect](RONIN_ASPECT.md)
- [Corruption and Shrines](CORRUPTION_AND_SHRINES.md)
- [Progression](PROGRESSION.md)
- [Technique System](TECHNIQUES.md)
- [Current Design Questions](../_meta/OPEN_QUESTIONS.md)
