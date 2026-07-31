---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-31
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
- player-directed attack movement,
- health damage and enemy-posture pressure,
- stagger,
- commitment and recovery,
- target handling through authored arcs and collision,
- modest approved defensive properties,
- and Blood-katana presentation.

No Aspect uses corrective tracking, hidden homing, or post-input target correction. Attacks follow the player's chosen direction and their authored geometry and travel.

## Shared action slots

| Shared slot | Responsibility |
|---|---|
| Basic Attack | Primary attack sequence and ordinary swordplay |
| Held Attack | Major secondary or committed sword action |
| Dash Attack | Offensive follow-up after the universal neutral dash |
| Parry Counter | Offensive response after the universal parry |
| Blood Art | Tier II Blood-powered signature action or state |

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

Aspect selection does not create a weaker or stronger neutral dash. No launch Aspect removes block or parry from ordinary combat, changes parry success conditions, becomes immune to posture break during ordinary combat, or receives automatic counters.

A Blood Art may temporarily commit Akio to authored action-specific defense and control rules while it resolves. Wraith's Tier II Blood Art is the current approved example: Akio cannot block or parry during the spin, enemy attacks deal direct Health damage instead of player-posture damage, and enemy attacks cannot interrupt the Art.

Modest ordinary defensive differences may use player-posture capacity, block posture efficiency, posture recovery direction, defensive access after attacks, and Parry Counter payoff. These differences must remain subordinate to the shared defense system.

## Approved roster

| Aspect | Basic sequence | Held identity | Primary strength | Firm tradeoff |
|---|---|---|---|---|
| Wolf | Fang Slash → Rending Cross → Raking Fang → Blood Cleave | Predator's Passage — pursuit | Fast sustained close pressure, player-directed pursuit, and nearby target transfer through attack geometry | Missed pursuit and extended pressure create dangerous overcommitment and punish windows |
| Wraith | Veil Cut → Passing Arc | Pale Lance — reach and focused rapid thrusts after Tier I | Longest melee reach, frontal control, short ordinary commitments, concentrated multi-hit punishment, and an earned movable spinning Blood Art after Tier II | Point-blank pressure, cramped spaces, attacks from several directions, overlong focused commitments, and direct Health exposure during the Blood Art undermine its advantage |
| Ronin | Severing Cut → Crushing Cross → Bloodfall | Stillness Draw — power | Highest per-hit impact, posture chunks, ordinary-enemy stagger, and strongest guard profile | Slow startup, severe recovery, and slow posture recovery punish bad commitments |

Supporting actions:

| Aspect | Dash Attack | Parry Counter |
|---|---|---|
| Wolf | Hunting Slash | Fang Reversal |
| Wraith | Ghostline Slash | Veil Reversal |
| Ronin | Breaching Slash | Answering Steel |

The roster deliberately does not include a dedicated teleport, projectile, full-circle crowd-clear, or pure evasion neutral weapon kit. Wraith's Tier II spinning Blood Art is an earned full-meter signature action rather than the identity of its ordinary kit. Mobility, ranged utility, broad crowd control, and defensive specialization otherwise remain shared-system, Technique, and prosthetic territory.

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

The player's choice is whether to advance now, not which branch of upgrades to select.

Wolf's current working progression is approved for scoping:

- **Tier I — Blood Tempo:** successful Basic Attacks accelerate the next Basic input; successful Held, Dash Attack, and Parry Counter hits may flow into Rending Cross; Hunting Slash can cross eligible ordinary enemies and empower the immediate rear Rending Cross.
- **Tier II — Dire Hunt:** unlocks Blood, immediate activation recovery, an empowered transformation, and Blood Fang.
- **Tier III — Fanged Guard:** charging Predator's Passage or Blood Fang blocks one frontal blockable attack without cancelling the charge.
- **Tier IV — Apex Feast:** deathblows create a nearby Blood eruption, restore limited health, and fully charge the next Held Attack.

Wraith's current working progression is approved through Tier II:

- **Tier I — Pale Barrage:** continuing to hold after Pale Lance's initial thrust unleashes a rapid series of lower-impact spectral jabs. The player may release early, while longer use delivers greater combined pressure at the cost of a longer focused commitment.
- **Tier II — Blood Art, name unresolved:** a full Blood meter activates a fixed sequence of identical spectral spinning hits. Akio may steer slightly slower than ordinary movement, retains ordinary enemy collision and is body-blocked, each hit interrupts ordinary enemies without knockback, and the Art applies repeated Health and posture pressure across a radius of roughly four to five Akio body widths.

Wraith Tier III-IV and Ronin Tier I-IV remain unresolved.

## Blood contract

Blood is a run-only combat resource owned by the selected Aspect.

Approved shared boundaries:

- Blood is unavailable before Tier II.
- Blood does not exist as a persistent wallet, shop currency, route currency, or campaign collectible.
- Stored Blood persists between rooms until it is spent or the run ends.
- Blood and Blood Art state reset after death or successful completion.
- Blood progression must deepen the selected weapon kit without replacing ordinary swordplay or making Techniques secondary.
- Blood Arts should provide a clear practical payoff on activation rather than depending entirely on ideal follow-up play.
- A Blood Art may be an immediate signature action, a temporary state, or another clearly defined combat expression. Blood Arts are not required to share one form.

Working launch defaults:

- The launch Aspects use one shared Blood-meter framework, including capacity, readiness language, activation input, and core HUD states.
- Meaningful direct katana Health damage, enemy-posture pressure, successful Parry Counters, posture breaks, and deathblows form the shared generation foundation.
- Generation is weighted around meaningful combat contribution rather than granting an equal flat amount for every hit, so different sequence counts do not create an automatic advantage.
- A Blood Art normally requires a full meter and activates manually.
- Activation consumes the Art's Blood cost.
- A duration-based Blood Art does not normally generate Blood while active. Generation resumes after an immediate Art resolves or a duration-based Art ends.

These are defaults rather than absolute restrictions. A specific Aspect may use a different activation cost, trigger, meter behavior, or active-generation rule only when its approved design clearly requires the exception. An exception should not be added only to make an Aspect mechanically different.

Wolf's working Blood direction is approved:

- meaningful sword damage, posture breaks, Fang Reversal after a parry, and deathblows generate Blood,
- Dire Hunt requires a full meter and activates manually,
- activation consumes the stored Blood,
- Blood cannot be generated during Dire Hunt,
- and exact capacity, gain values, duration, and anti-farming thresholds remain tuning work.

Wraith's working Blood direction is approved through its Tier II Art:

- the Art requires a full meter, activates manually, consumes the stored Blood, and does not generate Blood while spinning,
- activation begins a fixed sequence of identical rotations with no separate finishing slash,
- Akio may steer continuously while moving slightly slower than ordinary locomotion,
- Akio retains ordinary collision and cannot pass through enemies; enemies body-block his movement during the Art,
- Akio cannot dash, block, parry, use ordinary attacks, or use Prosthetics until the sequence ends,
- every hit briefly interrupts ordinary enemies without knockback, while elites do not receive this forced interrupt,
- ordinary enemies use their normal automatic guard response after contact and may be posture-broken by the repeated rotations,
- Akio cannot perform a deathblow until the Art ends, but later rotations may continue damaging a deathblow-ready enemy's Health,
- Akio's blocking state remains false; connected enemy attacks deal direct Health damage rather than player-posture damage,
- and Akio has complete resistance to interruption or stagger from enemy attacks without receiving damage reduction.

No exception to the shared Blood-meter, full-meter activation, consumption, or active-generation defaults is currently required for Wraith.

Still unresolved at system or Aspect-package level:

- Ronin's Blood Art and how it expresses the shared defaults,
- Wraith's Blood Art name and later Tier interactions,
- whether Ronin requires a justified exception to a shared default,
- final detailed input and HUD presentation,
- exact Wraith rotation count, duration, spin speed, damage, movement speed, and enemy-response cadence,
- exact duration or cooldown behavior for unresolved Arts,
- and limited Tier or Technique interactions.

## Remaining design package

1. Define Wraith's fixed Tier III-IV benefits, evolving drawback family, final Blood Art name, and later interactions with Pale Barrage or the Art.
2. Define Ronin's fixed Tier I-IV benefits, evolving drawback family, Blood Art, and any justified exception to the shared Blood defaults.
3. Compare all three packages for power, production cost, accessibility, and Technique overlap, including the current Wolf and Wraith working drafts.
4. Resolve shared affinity and limited direct Aspect-, Tier-, or Blood-Technique exceptions.
5. Finalize required animation, VFX, audio, HUD, Shrine, selection, trial, and persistent-progression states.

Wolf's package remains open to later revision after cross-roster comparison or playable testing; it is not an active blank design question. Wraith's Tier I-II package may likewise be adjusted after the remaining Wraith and Ronin packages are drafted or after playable testing.

Exact frame data, hitboxes, chain windows, damage, posture, stagger, movement, recovery, and numerical resource values remain implementation and playtesting work in the owning files.

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