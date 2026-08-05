---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-05
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

These three identities are the complete current launch space. A fourth or fifth Aspect is not part of current launch paper design or production scope and requires later playable evidence of a genuinely missing identity.

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
- fixed Tier progression,
- Blood Art,
- and Blood-katana presentation.

An Aspect's weaknesses and limits emerge from these weapon properties. Higher Tiers may strengthen an action while preserving or emphasizing its movement, positioning, speed, direction, commitment, recovery, or defensive-access costs.

No Aspect uses corrective tracking, hidden homing, or post-input target correction. Attacks follow the player's chosen direction and their authored geometry and travel. Limited direct steering during a sustained authored attack is permitted only when explicitly approved and must not snap toward or automatically follow enemies.

## Shared action slots

| Shared slot | Responsibility |
|---|---|
| Basic Attack | Primary attack sequence and ordinary swordplay |
| Held Attack | Major secondary or committed sword action |
| Dash Attack | Offensive follow-up after the universal neutral dash |
| Parry Counter | Offensive response after the universal parry |
| Blood Art | Tier II Blood-powered signature action or state |

A sequence is a set of available attacks rather than a completion objective. The player may stop, defend, dash, redirect, use a Prosthetic, or abandon the sequence whenever the encounter demands it.

A Tier may reward successfully connected sequence positions without turning sequence completion into a required objective. Wolf's Feral Momentum is the approved example: later Basic Attacks receive a modest deterministic payoff only when reached through successful Blood Tempo continuations, but each attack remains independently useful and the player may stop at any time.

## Universal combat layer

Every launch Aspect retains the same functional:

- controller layout,
- ordinary locomotion,
- neutral dash distance, speed, startup, invulnerability, recovery, steering, collision, and repeat availability,
- Defense input and parry timing,
- enemy telegraphs and response rules,
- posture-break, stagger, and deathblow language,
- Spirit and Prosthetic controls,
- Technique inventory and refinement rules,
- and combat interface language.

Aspect selection does not create a weaker or stronger neutral dash. No launch Aspect removes block or parry from ordinary combat, changes ordinary parry success conditions, becomes immune to posture break during ordinary combat, or receives automatic counters.

A Blood Art may be an immediate authored action, a temporary state, or another clearly defined combat expression. Blood Arts are not required to share one form:

- Wolf's **Blood Hunt** is an immediate player-directed pursuit action.
- Wraith's current **Wraith's Reach** draft is a temporary reach-and-afterimage state under later review.
- Ronin's **Falling Mountain** is an immediate planted slam with a delayed rupture.

Modest ordinary defensive differences may use player-posture capacity, block posture efficiency, posture recovery direction, defensive access after attacks, and Parry Counter payoff. These differences remain subordinate to the shared defense system. Wolf's Fanged Guard is an approved action-specific example: one frontal blockable hit may preserve selected high-risk Wolf commitments while using ordinary block posture and posture-break rules.

## Approved roster

| Aspect | Basic sequence | Held identity | Primary strength | Inherent tradeoffs |
|---|---|---|---|---|
| Wolf | Fang Slash → Rending Cross → Raking Fang → Blood Cleave | Predator's Passage — pursuit | Fast sustained close pressure, player-directed pursuit, and nearby target transfer through attack geometry | Short reach, forward commitment, unsafe misses, and dangerous final positioning after poorly aimed pursuit |
| Wraith | Veil Cut → Passing Arc | Pale Lance — reach and focused commitment | Longest melee reach, frontal control, concentrated multi-hit punishment, delayed spectral pressure, skilled defense during its defining Held action, and broad non-stacking lane control | Slower and less versatile than Wolf, restrained movement, fixed attack lines, point-blank pressure, stationary barrage commitment, and vulnerability outside its focused front |
| Ronin | Severing Cut → Crushing Cross → Bloodfall | Stillness Draw — power | Highest per-hit impact, posture chunks, ordinary-enemy stagger, and strongest guard profile | Slow startup, severe recovery, minimal attack movement, and slow posture recovery |

Supporting actions:

| Aspect | Dash Attack | Parry Counter |
|---|---|---|
| Wolf | Hunting Slash | Fang Reversal |
| Wraith | Ghostline Slash | Veil Reversal |
| Ronin | Breaching Slash | Answering Steel |

The roster deliberately does not include a dedicated teleport, projectile, full-circle crowd-clear, or pure evasion neutral weapon kit. Mobility, ranged utility, broad crowd control, and defensive specialization remain shared-system, Technique, and Prosthetic territory.

## Aspect and Technique responsibilities

### Aspects

An Aspect is:

- selected before the run,
- active from Tier 0,
- always present during combat,
- responsible for the complete starting sword kit,
- and the owner of an optional fixed vertical Tier path during that run.

Tier 0 is a complete weapon foundation rather than an intentionally weak prerequisite state.

### Techniques

Techniques are temporary, replaceable run rewards. The approved inventory is four active Techniques plus one inactive reserve, with at most one refinement per Technique.

Ordinary Techniques use universal action tags such as Basic Attack, Held Attack, Dash Attack, Parry Counter, Block, Parry, Deathblow, Prosthetic, Health, Enemy Posture, Player Posture, and Movement.

One Technique uses one rule across every Aspect. Its value may differ naturally because the underlying weapon kits differ. Builds may reinforce, broaden, compensate for, or hybridize the selected kit.

## Optional Tier-investment contract

Aspect progression is fixed rather than a branching package selection, but investing deeply in that path is optional.

- Every run begins at **Tier 0**.
- At a full Corruption threshold, a Shrine offers **Resist** or **Embrace**.
- **Resist** keeps the current Tier and provides approved stabilization support.
- **Embrace** advances the selected Aspect by one fixed Tier and empties Corruption.
- Each Tier presents one headline improvement and at most one minor supporting rule.
- An Aspect may use one small repeated growth rule across several Tiers when it reinforces the kit without becoming generic stat inflation; Wolf's Feral Momentum is the approved example.
- Each Tier must be clearly net-positive and preserve the Aspect's inherent limitations through the upgraded action itself.
- **Tier IV** is the maximum.
- At Tier IV, a full threshold offers **Stabilize** rather than Tier V.

Expected viability:

- Tier 0-I plus a strong Technique build can complete a run.
- Tier II plus a solid Technique build is a common hybrid outcome.
- Tier III is a deliberate deeper Aspect investment.
- Tier IV is occasional rather than expected.
- Mandatory encounters are not balanced around a required Tier or Blood Art.

## Current fixed progression packages

### Wolf

- **Tier I — Blood Tempo:** successful Wolf contact may continue earlier into the Basic sequence through approved optional routes.
- **Feral Momentum — Tier growth:** Rending Cross, Raking Fang, and Blood Cleave gain increasing deterministic Health and enemy-posture payoff when reached through successful Blood Tempo continuations; the payoff strengthens modestly at every Tier.
- **Tier II — Blood Hunt:** a full meter restores limited Health, releases a short disruptive howl, and launches one long player-directed pursuit through eligible ordinary enemies before ending in Blood Fang.
- **Tier III — Fanged Guard:** one normal posture-costing frontal block may preserve Predator's Passage charge, or one connected Raking Fang or Blood Cleave startup per Basic sequence.
- **Tier IV — Apex Feast:** the current deathblow-triggered draft erupts, restores Health, and primes Predator's Passage; it must be broadened or replaced during Wolf Tier redistribution.

Blood Tempo no longer includes additional Raking Fang or Hunting Slash travel and no longer grants a Hunting Slash rear-Rending-Cross damage bonus. Feral Momentum is deterministic rather than random critical-hit chance and uses no separate combo meter or persistent timer. Tier III advances Feral Momentum by its normal one-Tier step rather than adding a separate critical or combo statistic.

### Wraith

- **Tier I — Pale Barrage:** continuing to hold after Pale Lance's initial thrust unleashes rapid lower-impact spectral jabs while Akio remains stationary and committed.
- **Tier II — Wraith's Reach:** the current full-meter draft begins a temporary state that extends core attacks and gives qualifying attacks one delayed spectral afterimage along their original geometry.
- **Tier III — Veiled Guard:** each Pale Lance use permits one manually timed spectral parry without cancelling the charge or barrage.
- **Tier IV — Pale Procession:** Pale Barrage creates two reduced-power adjacent streams and permits slow player-directed steering without allowing stream stacking on one enemy.

### Ronin

- **Tier I — Steadfast Reprisal:** a qualifying block creates a temporary optional Reprisal Cut.
- **Tier II — Falling Mountain:** activation clears meaningful accumulated posture and powers a planted monumental slam, immediate impact burst, and delayed Deep Rupture.
- **Tier III — Unbroken Resolve:** selected commitments may survive one costly eligible hit, while disciplined clean attacks may create Measured Weight and Perfect Weight.
- **Tier IV — Shattering Wake:** qualifying direct heavy impacts transfer reduced Health damage and strong posture force through the primary target into enemies behind it.

Wolf Tiers I-III, Wolf's Feral Momentum growth rule, and Ronin's Tier I-IV package are approved through the current audit. Wolf Tier IV and Wraith's full Tier package remain working drafts pending the ordered cross-roster questions.

## Blood contract

Blood is a run-only combat resource owned by the selected Aspect.

Approved shared boundaries:

- Blood is unavailable before Tier II.
- Blood is not a persistent wallet, shop currency, route currency, or campaign collectible.
- Stored Blood persists between rooms until spent or the run ends.
- Blood and Blood Art state reset after death or successful completion.
- Blood progression must deepen the selected weapon kit without replacing ordinary swordplay or making Techniques secondary.
- Blood Arts provide clear practical value when activated rather than depending entirely on ideal follow-up play.
- A run that does not reach Tier II remains viable without a Blood Art.

Working launch defaults:

- The launch Aspects use one shared Blood-meter framework, including capacity, readiness language, activation input, and core HUD states.
- Meaningful katana Health damage, enemy-posture pressure, successful Parry Counters, posture breaks, and deathblows form the shared generation foundation.
- Generation is weighted around meaningful combat contribution rather than granting an equal flat amount for every hit.
- A Blood Art normally requires a full meter and activates manually.
- Activation consumes the Art's Blood cost.
- A duration-based Art normally does not generate Blood while active.
- An immediate Art does not generate Blood while resolving; generation resumes after the action finishes.

### Wolf Blood direction

- meaningful sword damage, enemy-posture contribution, Fang Reversal after a parry, posture breaks, and deathblows generate Blood,
- Blood Hunt requires a full meter and activates manually,
- activation consumes the stored Blood,
- Blood Hunt immediately restores limited Health and releases a short disruptive howl,
- the pursuit follows one fixed player-selected line and cannot track or correct,
- eligible ordinary enemies may be passed through under authored collision and destination rules,
- the action ends in Blood Fang against a stopping target, obstacle, or maximum-distance endpoint,
- light ordinary hits do not interrupt the launched pursuit but still deal full Health, posture, status, and other valid effects,
- overriding attacks and posture break may interrupt normally,
- Blood Hunt generates no Blood while resolving,
- and exact capacity, gain values, preparation, travel, collision, damage, posture, recovery, and anti-farming thresholds remain tuning work.

### Wraith Blood direction

Wraith's Reach remains the current working draft pending the dedicated Wraith Blood Art review.

- it requires a full meter, activates manually, consumes the stored Blood, and does not generate Blood while active,
- Veil Cut, Passing Arc, and Pale Lance gain additional spectral reach,
- each qualifying action creates one delayed spectral afterimage along its original player-selected geometry,
- afterimages do not track, home, rotate, independently select enemies, or generate Blood,
- Pale Barrage's additional jabs gain range but do not each create another full echo,
- and afterimage damage, posture pressure, interruption, guard response, and Technique or healing triggers are separately weighted from the physical strike.

### Ronin Blood direction

- meaningful heavy Health damage, large posture contributions, Answering Steel, successful Reprisal Cuts, posture breaks, and deathblows generate Blood,
- Falling Mountain requires a full meter, activates manually, consumes the stored Blood, and generates no Blood from the Art,
- activation clears a meaningful portion of accumulated player posture even when the later slam misses,
- the brief planted channel resists interruption from ordinary attacks while preserving full incoming damage and overriding counters,
- the direct slam breaks posture on most non-boss enemies and inflicts a severe posture hit on bosses,
- and Deep Rupture erupts at the fixed original impact location approximately three seconds later.

## Remaining design package

Resolve the ordered questions in `docs/_meta/OPEN_QUESTIONS.md`:

1. decide Wolf Tier IV around Blood Tempo, Feral Momentum, Blood Hunt, and Fanged Guard,
2. review Wraith's Blood Art form,
3. redistribute Wraith's later Tiers,
4. decide Wraith and Ronin small-growth structures,
5. audit minor supporting benefits,
6. recheck Ronin against the approved standards,
7. perform the final cross-roster production lock.

After the Aspect audit, resolve shared affinity, limited direct Aspect-, Tier-, or Blood-Technique exceptions, and final animation, VFX, audio, HUD, Shrine, trial, selection, and persistent-progression requirements.

Exact frame data, hitboxes, chain windows, damage, posture, stagger, movement, recovery, Feral Momentum scaling, Fanged Guard timing and reset rules, resource values, collision details, and numerical growth values remain implementation and playtesting work in the owning files.

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