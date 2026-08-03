---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-03
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

These three identities are the complete current launch space. A fourth or fifth Aspect is not part of current paper design, production, animation, VFX, UI, trial, catalog, or milestone scope. Expansion requires later playable evidence of a missing identity that cannot be covered by the three kits, universal combat, Techniques, or Prosthetics.

## Governing rule

Blood Aspects are distinct katana weapon kits, not passive stances, branching classes, or behavioral minigames.

> **The moves create the playstyle. The player should not need to maintain a combo goal, forced movement loop, separate Aspect-specific meter, or player-facing drawback checklist to use a kit correctly.**

Each kit may differ through:

- Basic Attack sequence and cadence,
- Held Attack,
- Dash Attack,
- Parry Counter,
- reach and hit geometry,
- player-directed attack movement,
- Health damage and enemy-posture pressure,
- stagger,
- commitment and recovery,
- target handling through authored arcs and collision,
- modest approved defensive properties,
- and Blood-katana presentation.

An Aspect's weaknesses and limits should emerge from these weapon properties. Higher Tiers may strengthen an action while preserving or emphasizing its existing commitment, positioning requirement, speed, reach, or defensive access. Tiers do not require separate named drawback families or unrelated penalty attributes.

No Aspect uses corrective tracking, hidden homing, or post-input target correction. Attacks follow the player's chosen direction and their authored geometry and travel. A sustained authored attack may allow limited direct player steering only when explicitly approved; that steering must not snap toward or automatically follow enemies.

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
- Spirit and Prosthetic controls,
- Technique inventory and refinement rules,
- and combat interface language.

Aspect selection does not create a weaker or stronger neutral dash. No launch Aspect removes block or parry from ordinary combat, changes parry success conditions, becomes immune to posture break during ordinary combat, or receives automatic counters.

A Blood Art may be an immediate authored action or a temporary state. Duration states should normally deepen the existing weapon kit and shared combat decisions rather than replace the entire kit with an autonomous or locked sequence. Wolf's Dire Hunt and Wraith's Reach both preserve ordinary dash, block, parry, attacks, deathblows, and Prosthetic access while strengthening different Aspect identities.

Modest ordinary defensive differences may use player-posture capacity, block posture efficiency, posture recovery direction, defensive access after attacks, and Parry Counter payoff. These differences must remain subordinate to the shared defense system. A later Tier may preserve a normal defensive input during a specific committed action when the player still performs the ordinary timing and eligibility check; Wraith's Veiled Guard is the approved example.

## Approved roster

| Aspect | Basic sequence | Held identity | Primary strength | Inherent tradeoffs |
|---|---|---|---|---|
| Wolf | Fang Slash → Rending Cross → Raking Fang → Blood Cleave | Predator's Passage — pursuit | Fast sustained close pressure, player-directed pursuit, and nearby target transfer through attack geometry | Short reach, forward commitment, unsafe misses, and dangerous final positioning after poorly aimed pursuit |
| Wraith | Veil Cut → Passing Arc | Pale Lance — reach, focused rapid thrusts after Tier I, one preserved spectral parry after Tier III, and a steerable three-lane barrage after Tier IV | Longest melee reach, frontal control, concentrated multi-hit punishment, delayed spectral attack echoes during Wraith's Reach, skilled defense during its defining Held commitment, and broad non-stacking lane control | Slower and less versatile than Wolf, restrained movement, fixed attack lines, point-blank pressure, vulnerability outside its focused front, stationary barrage commitment, and no protection after Veiled Guard is spent or mistimed |
| Ronin | Severing Cut → Crushing Cross → Bloodfall | Stillness Draw — power | Highest per-hit impact, posture chunks, ordinary-enemy stagger, and strongest guard profile | Slow startup, severe recovery, minimal attack movement, and slow posture recovery |

Supporting actions:

| Aspect | Dash Attack | Parry Counter |
|---|---|---|
| Wolf | Hunting Slash | Fang Reversal |
| Wraith | Ghostline Slash | Veil Reversal |
| Ronin | Breaching Slash | Answering Steel |

The roster deliberately does not include a dedicated teleport, projectile, full-circle crowd-clear, or pure evasion neutral weapon kit. Mobility, ranged utility, broad crowd control, and defensive specialization remain shared-system, Technique, and Prosthetic territory.

Wraith's Reach extends and repeats authored melee geometry without becoming a projectile field, autonomous companion, or replacement combat mode. Veiled Guard preserves one normal parry during Pale Lance or Pale Barrage rather than granting passive protection. Pale Procession creates two reduced-power adjacent shade streams and limited direct steering, but streams cannot stack on one enemy and the shades do not select targets independently.

## Aspect and Technique responsibilities

### Aspects

An Aspect is:

- selected before the run,
- active from Tier 0,
- always present during combat,
- responsible for the complete starting sword kit,
- and the owner of an optional fixed vertical Tier path during that run.

An Aspect must function before a specific Technique is acquired and before the player advances it. Tier 0 is a complete weapon foundation rather than an intentionally weak prerequisite state.

### Techniques

Techniques are temporary, replaceable run rewards. The approved inventory is four active Techniques plus one inactive reserve, with at most one refinement per Technique.

Ordinary Techniques use universal action tags such as Basic Attack, Held Attack, Dash Attack, Parry Counter, Block, Parry, Deathblow, Prosthetic, Health, Enemy Posture, Player Posture, and Movement.

One Technique uses one rule across every Aspect. Its value may differ naturally because the underlying weapon kits differ. Builds may reinforce, broaden, compensate for, or hybridize the selected kit.

Ordinary Techniques are not hard-locked to one Aspect or Tier. Affinity may affect weighting or amplification after those rules are approved; it does not determine basic eligibility.

## Optional Tier-investment contract

Aspect progression is fixed rather than a branching package selection, but investing deeply in that path is optional.

- Every run begins at **Tier 0**.
- Corruption fills through approved combat and progression events.
- At a full threshold, a Shrine offers **Resist** or **Embrace**.
- **Resist** keeps the current Tier, lowers Corruption, and grants approved immediate support.
- **Embrace** advances the selected Aspect by one fixed Tier and empties Corruption.
- Each Tier presents one headline improvement and at most one minor supporting rule.
- Each Tier must be clearly net-positive and preserve the Aspect's inherent limitations through the upgraded action itself.
- **Tier IV** is the maximum.
- At Tier IV, a full threshold offers **Stabilize** rather than Tier V or more permanent power.

The player chooses how much of the run to invest in Aspect advancement versus Techniques, refinements, Relics, economy, survival, and other rewards. The main opportunity cost occurs through route selection: choosing a Shrine can mean foregoing another valuable reward room.

Expected viability:

- Tier 0-I plus a strong Technique build can complete a run.
- Tier II plus a solid Technique build is a common hybrid outcome.
- Tier III is a deliberate deeper Aspect investment.
- Tier IV is occasional rather than expected.
- Mandatory encounters are not balanced around a required Tier or Blood Art.

The player's choice inside the Aspect path remains whether to advance now, not which branch of upgrades to select.

Wolf's current working progression is approved for scoping:

- **Tier I — Blood Tempo:** successful Basic Attacks accelerate the next Basic input; successful Held, Dash Attack, and Parry Counter hits may flow into Rending Cross; Hunting Slash can cross eligible ordinary enemies and empower the immediate rear Rending Cross.
- **Tier II — Dire Hunt:** unlocks Blood, immediate activation recovery, an empowered transformation, and Blood Fang.
- **Tier III — Fanged Guard:** charging Predator's Passage or Blood Fang blocks one frontal blockable attack without cancelling the charge.
- **Tier IV — Apex Feast:** deathblows create a nearby Blood eruption, restore limited Health, and fully charge the next Held Attack.

Wraith's current working progression is approved through Tier IV:

- **Tier I — Pale Barrage:** continuing to hold after Pale Lance's initial thrust unleashes a rapid series of lower-impact spectral jabs. The player may release early, while longer use delivers greater combined pressure at the cost of a longer focused commitment.
- **Tier II — Wraith's Reach:** a full Blood meter begins a duration state that extends Veil Cut, Passing Arc, and Pale Lance. Each qualifying attack leaves one delayed spectral afterimage strike along its original player-directed line or arc while Akio retains the full ordinary combat kit.
- **Tier III — Veiled Guard:** each Pale Lance use permits one manually timed spectral parry against an eligible incoming attack from any direction without cancelling the charge, interrupting Pale Barrage, changing its direction, or adding fallback protection when mistimed.
- **Tier IV — Pale Procession:** Pale Barrage creates two reduced-power adjacent shade streams and permits slow player-directed steering within a limited frontal arc. An enemy can receive only one stream's hit per barrage beat, with Akio's central stream taking priority, so the formation cannot multiply single-target damage.

Ronin Tier I-IV remains unresolved.

## Blood contract

Blood is a run-only combat resource owned by the selected Aspect.

Approved shared boundaries:

- Blood is unavailable before Tier II.
- Blood does not exist as a persistent wallet, shop currency, route currency, or campaign collectible.
- Stored Blood persists between rooms until it is spent or the run ends.
- Blood and Blood Art state reset after death or successful completion.
- Blood progression must deepen the selected weapon kit without replacing ordinary swordplay or making Techniques secondary.
- Blood Arts should provide a clear practical payoff when activated rather than depending entirely on ideal follow-up play.
- A Blood Art may be an immediate signature action, a temporary state, or another clearly defined combat expression. Blood Arts are not required to share one form.
- A run that does not reach Tier II must remain viable without a Blood Art.

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

Wraith's working Blood direction is approved through Wraith's Reach:

- Wraith's Reach requires a full meter, activates manually, consumes the stored Blood, and does not generate Blood while active,
- activation begins a temporary empowered state rather than a locked replacement sequence,
- Veil Cut, Passing Arc, and Pale Lance gain additional spectral reach,
- each qualifying attack creates one delayed spectral afterimage along its original player-selected direction and authored geometry,
- afterimages do not track, home, rotate, or independently select enemies,
- the initial Pale Lance creates one afterimage while Pale Barrage's additional jabs gain range but do not each create another full echo,
- Akio retains ordinary locomotion, dash, block, parry, attacks, deathblows, and Prosthetic access,
- the Art adds no Health restoration, Blood refund, damage reduction, posture clearing, interruption resistance, automatic defense, or special parry reward,
- afterimages do not generate Blood,
- and afterimage damage, posture pressure, interruption, guard response, and Technique or healing triggers are weighted separately from the physical strike.

Veiled Guard does not alter the shared Blood defaults. It remains available during Wraith's Reach but does not extend the Art, refund Blood, create another afterimage, or increase the one-parry-per-Pale-Lance limit.

Pale Procession also does not alter the shared Blood defaults. During Wraith's Reach, all three barrage lanes receive the approved extended reach, but only the initial Pale Lance creates one delayed afterimage; shade jabs create no echoes or Blood and remain subject to the non-stacking rule.

No exception to the shared Blood-meter, full-meter activation, consumption, or active-generation defaults is currently required for Wraith.

Still unresolved at system or Aspect-package level:

- Ronin's Blood Art and how it expresses the shared defaults,
- whether Ronin requires a justified exception to a shared default,
- final detailed Blood input and HUD presentation,
- exact Wraith's Reach duration, extended ranges, arc widths, echo delay, damage, posture pressure, guard response, and proc weighting,
- exact Veiled Guard concurrent input handling, buffering, visual timing, and feedback,
- exact Pale Procession shade values, lane geometry, steering speed, steering arc, hit-priority resolution, and presentation,
- exact duration or cooldown behavior for unresolved Arts,
- and limited Tier or Technique interactions.

## Remaining design package

1. Define Ronin's fixed Tier I-IV benefits, Blood Art, and any justified exception to the shared Blood defaults while preserving its inherent commitment and recovery limits.
2. Compare all three packages for power, production cost, accessibility, Technique overlap, inherent tradeoffs, and whether Technique-focused, hybrid, and Aspect-focused runs remain viable.
3. Resolve shared affinity and limited direct Aspect-, Tier-, or Blood-Technique exceptions.
4. Finalize required animation, VFX, audio, HUD, Shrine, selection, trial, and persistent-progression states.

Wolf and Wraith now have complete working Tier I-IV packages. Both remain open to later revision after Ronin is drafted, the cross-roster comparison is performed, or playable testing reveals a problem; neither is an active blank design question.

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
