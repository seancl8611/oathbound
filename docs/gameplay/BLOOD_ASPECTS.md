---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-06
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

A Tier may reward authored behavior without turning it into a mandatory objective:

- Wolf's **Feral Momentum** rewards later Basic Attacks reached through successful Blood Tempo continuations.
- Wraith's **Spectral Edge** rewards currently eligible primary attacks that connect through spectral-only reach beyond the physical katana.

Both are deterministic supporting rules rather than meters, timers, random critical systems, or requirements to complete a sequence.

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
- Wraith's **Wraith's Reach** is an immediate frontal sweep and corridor strike followed by one delayed spectral repetition along the same fixed geometry.
- Ronin's **Falling Mountain** is an immediate planted slam with a delayed rupture.

Modest ordinary defensive differences may use player-posture capacity, block posture efficiency, posture recovery direction, defensive access after attacks, and Parry Counter payoff. These differences remain subordinate to the shared defense system.

## Approved roster

| Aspect | Basic sequence | Held identity | Primary strength | Inherent tradeoffs |
|---|---|---|---|---|
| Wolf | Fang Slash → Rending Cross → Raking Fang → Blood Cleave | Predator's Passage — pursuit | Fast sustained close pressure and player-directed pursuit | Short reach, forward commitment, unsafe misses, and dangerous final positioning |
| Wraith | Veil Cut → Passing Arc | Pale Lance — focused reach | Longest average melee reach, deliberate line-and-arc selection, frontal control, stronger posture pressure from correctly spaced eligible spectral contact, delayed corridor control, Tier III penetration through layered ordinary formations, and Tier IV distant engagement and execution | Fewer ordinary actions, restrained movement, deliberate frontal commitments, close and lateral pressure, and severe Pale Lance or Blood Art misses |
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
- An Aspect may use one small repeated growth rule across several Tiers when it reinforces the kit without becoming generic stat inflation.
- Wolf's approved repeated rule is Feral Momentum.
- Wraith's approved repeated rule is Spectral Edge.
- Each Tier must be clearly net-positive and preserve the Aspect's inherent limitations through the upgraded action itself.
- **Tier IV** is the maximum.
- At Tier IV, a full threshold offers **Stabilize** rather than Tier V.

Expected viability:

- Tier 0-I plus a strong Technique build can complete a run.
- Tier II plus a solid Technique build is a common hybrid outcome.
- Tier III is a deliberate deeper Aspect investment.
- Tier IV is occasional rather than expected.
- Mandatory encounters are not balanced around a required Tier or Blood Art.

## Current progression packages

### Wolf — approved through Tier IV

- **Tier I — Blood Tempo:** successful Wolf contact may continue earlier into the Basic sequence through approved optional routes.
- **Feral Momentum — Tier growth:** later connected Basic-sequence positions gain increasing deterministic Health and enemy-posture payoff at every Tier.
- **Tier II — Blood Hunt:** a full meter restores limited Health, releases a short disruptive howl, and launches one long player-directed pursuit before Blood Fang.
- **Tier III — Fanged Guard:** one normal posture-costing frontal block may preserve selected approved commitments.
- **Tier IV — Apex Mauling:** qualifying major contacts trigger a consolidated Blood-claw mauling with strong posture pressure, compact secondary coverage, and a brief movement-only slow.

Wolf's removed rear-hit, generic travel, temporary-transformation, and deathblow-only Apex Feast concepts are not part of fixed progression.

### Wraith — approved through Tier IV

Approved Tier 0 roles:

- **Veil Cut:** precise low-commitment extended line.
- **Passing Arc:** broader, slower, more committed frontal-control follow-up.
- **Pale Lance:** longest narrow focused punish with severe miss recovery.
- **Ghostline Slash:** controlled dash re-entry.
- **Veil Reversal:** strongest ordinary Wraith parry-to-posture conversion.

Approved progression:

- **Tier I — Pale Barrage:** continuing to hold after Pale Lance produces rapid lower-impact stationary spectral jabs along the committed direction; releasing ends the barrage early.
- **Spectral Edge — Tier growth:** eligible primary attacks that connect through spectral-only geometry gain modest enemy-posture and guard pressure. Veil Cut, Passing Arc, and Veil Reversal qualify from Tier I; Pale Lance's initial thrust and Ghostline Slash unlock qualification at Tier IV. The benefit scales slightly at every Embrace and adds no Health damage, tracking, movement, meter, or unrestricted repeated-hit multiplication.
- **Tier II — Wraith's Reach:** a full meter commits one compact broad frontal sweep, one very long fixed corridor strike, and one delayed spectral repetition along the same corridor. The sweep supplies immediate frontal value; the corridor and echo reward line selection and prediction.
- **Tier III — Spectral Passage:** the spectral portion of Veil Cut, Passing Arc, Pale Lance's initial thrust, Ghostline Slash, and Veil Reversal continues through ordinary-enemy bodies across the remaining authored geometry. Additional ordinary targets take reduced Health damage and meaningful posture and guard pressure; elites, bosses, heavy stopping enemies, and solid geometry end further passage.
- **Tier IV — Beyond the Veil:** Pale Lance gains increased maximum spectral reach, Ghostline Slash gains increased spectral attack reach without changing the universal neutral dash, and valid deathblows may begin from greater clear-path frontal distance. Pale Lance and Ghostline Slash unlock Spectral Edge eligibility, and a deathblow kill grants brief non-stacking movement-only Veilstride.

The former Veiled Guard and Pale Procession candidates are removed from fixed progression. Spectral Passage adds no new input, tracking, movement, defense, same-enemy repeat hit, secondary Blood generation, or unrestricted Spectral Edge and proc multiplication. Beyond the Veil adds no teleportation, tracking, universal range increase, stronger neutral dash, attack-speed bonus, or ordinary Spectral Edge movement trigger.

### Ronin — Tier I-IV approved; Tier 0 under review

- **Tier I — Steadfast Reprisal:** a qualifying block creates a temporary optional Reprisal Cut.
- **Tier II — Falling Mountain:** activation clears meaningful accumulated posture and powers a planted monumental slam, immediate impact burst, and delayed Deep Rupture.
- **Tier III — Unbroken Resolve:** selected commitments may survive one costly eligible hit, while disciplined clean attacks may create Measured Weight and Perfect Weight.
- **Tier IV — Shattering Wake:** qualifying direct heavy impacts transfer reduced Health damage and strong posture force through the primary target into enemies behind it.

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

Wraith's Reach is the approved Tier II immediate Blood Art.

- it requires a full meter, activates manually, consumes the stored Blood when committed, and generates no Blood while the Art and delayed echo resolve,
- the player selects one direction during a short readable preparation,
- a compact broad frontal sweep provides modest Health damage, strong posture and guard pressure, and brief stagger against eligible ordinary enemies,
- the sweep provides guaranteed activation value without requiring the later corridor or echo to connect,
- the sweep is frontal rather than full-circle and provides no healing, posture clear, damage reduction, automatic defense, or interruption resistance,
- Akio then performs one very long narrow-to-medium corridor strike along the fixed selected direction,
- the corridor deals moderate Health damage and strong posture and guard pressure without tracking, turning, homing, pursuit, or target correction,
- a delayed spectral Wraith repeats the exact same corridor geometry with lower Health damage and meaningful posture and guard pressure,
- enemies may leave before the echo or enter its geometry before it resolves,
- the Art's stages generate no Blood and do not independently trigger Spectral Edge,
- the echo cannot recursively create another echo and receives restricted Technique, healing, and proc weighting,
- ordinary vulnerability, interruption, commitment, and recovery remain active,
- and exact preparation, sweep, corridor, echo, damage, posture, stagger, interruption, and recovery values remain tuning work.

Spectral Passage is not a Blood Art and does not alter Wraith's Reach. Its additional ordinary-enemy contacts generate no Blood and use restricted Spectral Edge, Technique, healing, status, and proc weighting.

Beyond the Veil is not a Blood Art and does not alter Wraith's Reach. It changes authored Pale Lance, Ghostline Slash, deathblow-initiation, and post-kill movement rules only. Its exact reach, deathblow pathing, and Veilstride values remain tuning work.

### Ronin Blood direction

- meaningful heavy Health damage, large posture contributions, Answering Steel, successful Reprisal Cuts, posture breaks, and deathblows generate Blood,
- Falling Mountain requires a full meter, activates manually, consumes the stored Blood, and generates no Blood from the Art,
- activation clears a meaningful portion of accumulated player posture even when the later slam misses,
- the brief planted channel resists interruption from ordinary attacks while preserving full incoming damage and overriding counters,
- the direct slam breaks posture on most non-boss enemies and inflicts a severe posture hit on bosses,
- and Deep Rupture erupts at the fixed original impact location approximately three seconds later.

## Remaining design package

Resolve the ordered questions in `docs/_meta/OPEN_QUESTIONS.md`:

1. review Ronin's Tier 0 weapon foundation,
2. decide Ronin's small-growth structure,
3. audit minor supporting benefits,
4. recheck Ronin against the approved Wolf and Wraith standards,
5. perform the final cross-roster production lock.

After the Aspect audit, resolve shared affinity, limited direct Aspect-, Tier-, or Blood-Technique exceptions, and final animation, VFX, audio, HUD, Shrine, trial, selection, and persistent-progression requirements.

Exact frame data, hitboxes, chain windows, damage, posture, stagger, movement, recovery, Feral Momentum scaling, Spectral Edge qualification and scaling, Pale Barrage behavior, Fanged Guard timing and reset rules, Apex Mauling behavior, Wraith's Reach behavior, Spectral Passage stopping classifications and secondary weighting, Beyond the Veil reach and deathblow pathing, Veilstride values, resource values, collision details, and numerical growth values remain implementation and playtesting work in the owning files.

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
