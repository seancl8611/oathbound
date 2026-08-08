---
id: GAMEPLAY-RONIN-ASPECT
title: Ronin Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-07
topics:
  - blood-aspects
  - ronin
  - tier-progression
  - blood-arts
  - weapon-kits
  - combat-foundation
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Ronin Blood Aspect

## Status

Ronin's qualitative Tier 0-IV package is approved for current scoping.

Exact numerical values, frame data, hitboxes, animation timing, VFX density, Blood values, proc weighting, and final recovery windows remain implementation and playtesting work.

## Weapon identity

**Ronin is the slow, precise, heavy-impact and stability kit.**

Ronin is defined by:

- a three-hit heavy Basic sequence,
- conventional medium sword reach,
- the slowest cadence in the launch roster,
- the highest per-hit Health damage,
- the highest or near-highest per-hit enemy-posture pressure,
- the strongest ordinary-enemy stagger,
- minimal attack-bound movement,
- fixed attack lines after commitment,
- severe recovery after missed heavy attacks,
- and the strongest guard profile, balanced by the slowest player-posture recovery.

Ronin does not use tracking, homing, automatic target correction, general armor, or stronger neutral movement. Its power comes from judging openings correctly and accepting meaningful commitment.

## Tier 0 weapon kit

### Basic Attack sequence

1. **Severing Cut** — the most reliable Basic for short openings; compact line, meaningful Health damage, and meaningful posture pressure.
2. **Crushing Cross** — broader frontal coverage, greater commitment, and Ronin's clearest ordinary group-control Basic.
3. **Bloodfall** — the most committed Basic, with the sequence's largest damage, posture, and stagger payoff and severe miss recovery.

Cadence:

> deliberate punish → broader heavy commitment → maximum committed impact

Each attack remains useful when the sequence ends early. Bloodfall is an available heavy option, not a required finisher.

### Held Attack — Stillness Draw

A prepared, narrow single-target punish.

- one fixed preparation threshold rather than multiple charge levels,
- may be held after preparation and manually released,
- holding longer does not increase power,
- major single-hit Health and posture damage,
- strong ordinary-enemy stagger,
- conventional or modestly extended melee reach,
- fixed line after release,
- severe miss recovery,
- no ordinary defense while the readied stance is held.

Stillness Draw is Ronin's strongest prepared single-target punishment tool. Bloodfall remains the Basic sequence's largest impact-and-stagger commitment.

### Dash Attack — Breaching Slash

Ronin's quickest access and re-entry attack after the universal neutral dash.

It has conventional reach and lower damage, posture pressure, and stagger than the main heavy sequence. Its purpose is responsiveness, not pursuit dominance or maximum punishment.

### Parry Counter — Answering Steel

A forceful retaliatory strike after the universal parry.

It provides Ronin's strongest immediate parry conversion through high Health damage, high enemy-posture pressure, and strong ordinary-enemy recoil or stagger, while remaining planted enough to be unsafe against surrounding threats.

### Defensive profile

Ronin has the strongest ordinary guard profile through:

- meaningfully higher player-posture capacity,
- modestly better block-posture efficiency,
- and greater stability during direct exchanges.

This is balanced by:

- the slowest player-posture recovery,
- heavy attacks that delay access to defense,
- no free posture recovery while guarding,
- and no Tier 0 interruption resistance or damage reduction.

Ronin can absorb more direct pressure before breaking, but accumulated posture remains dangerous between exchanges.

## Tier-growth rule — player-posture capacity

Beginning at Tier I, **every Embrace modestly increases Ronin's maximum player-posture capacity**. The increase advances once at Tiers I, II, III, and IV.

This supporting growth rule:

- reinforces Ronin's stability identity across the whole kit,
- does not increase posture-recovery speed,
- does not further improve block-posture efficiency,
- does not reduce Health damage,
- does not grant posture-break immunity,
- and does not change parry timing or defensive inputs.

Exact capacity growth per Tier remains balance work.

# Fixed Tier progression

## Tier I — Steadfast Reprisal

After successfully blocking a blockable enemy attack without suffering a posture break, Akio briefly gains the option to perform **Reprisal Cut** with the Basic Attack input.

### Reprisal Cut

- slow, planted, compact frontal heavy retaliation,
- available only after the relevant block recovery,
- strong Health damage, substantial enemy-posture pressure, and powerful ordinary-enemy stagger,
- stronger payoff than Severing Cut but lower than Answering Steel after a parry,
- standalone attack that does not continue directly into Crushing Cross,
- severe recovery on a miss or poor read.

The retaliation is optional and temporary. Blocking does not accelerate its startup, move Akio into range, protect the counter, restore posture, or correct aim.

**Tier I also applies the first posture-capacity growth step.**

## Tier II — Falling Mountain

Tier II unlocks Ronin's Blood meter and **Falling Mountain**.

Ronin builds Blood through meaningful heavy Health damage, large posture contributions, Answering Steel, successful Reprisal Cuts, posture breaks, and deathblows. Exact weighting remains tuning work.

On committed activation, Falling Mountain clears a meaningful portion of accumulated player posture even if the later strike misses. This is partial relief, not a full posture reset.

### Blood Art

Akio plants his feet, gathers Returning Blood around the katana during a brief channel, and drives the weapon downward in a monumental two-handed slam.

During the brief channel, eligible ordinary hits do not interrupt the action, but they still deal full Health damage, posture damage, status buildup, and other valid effects. Posture break, lethal damage, perilous or unblockable attacks, grabs, launches, and overriding knockdowns interrupt normally.

### Primary slam

- Ronin's largest single committed impact,
- extreme direct Health damage,
- severe enemy-posture damage,
- strongest eligible ordinary-enemy stagger or knockdown,
- compact nearby impact burst with reduced secondary payoff,
- severe recovery,
- no pursuit, tracking, aim correction, healing, or post-strike safety.

The direct blade result is the main payoff; the surrounding burst must not make a near miss equivalent to a correctly aimed hit.

### Deep Rupture

Approximately three seconds after the primary impact, the original landing point erupts again.

Deep Rupture:

- remains fixed at the original impact point,
- has a smaller radius than the immediate impact field,
- deals strong Health damage and very strong posture damage,
- produces forceful eligible ordinary-enemy stagger or knockdown,
- may hit an enemy struck by the primary slam if that enemy remains in the area,
- persists once the rupture site is successfully established,
- generates no Blood and creates no additional rupture.

**Tier II also applies the second posture-capacity growth step.**

## Tier III — Unbroken Resolve

Tier III rewards both costly commitment and clean execution.

### Resolve window

During the late committed portion of **Bloodfall**, released **Stillness Draw**, **Answering Steel**, or **Reprisal Cut**, the first eligible frontal standard enemy hit does not interrupt the qualifying attack.

The incoming hit still applies full Health damage, player-posture damage, status, and other valid effects. Resolve fails against posture break, lethal damage, perilous or unblockable attacks, grabs, launches, overriding knockdowns, non-frontal pressure, or a second hit.

Resolve exists only during the authored late-commitment window. It does not protect preparation, early startup, or recovery.

### Measured Weight

Landing a qualifying deliberate strike without taking Health damage during that attack grants **Measured Weight** for a short period; the working target remains approximately four seconds.

Qualifying setup strikes:

- Severing Cut,
- Crushing Cross,
- Bloodfall,
- Stillness Draw,
- Answering Steel,
- Reprisal Cut.

Breaching Slash, Falling Mountain, and Deep Rupture do not create Measured Weight.

### Perfect Weight

While Measured Weight is active, the next cleanly landed **Bloodfall**, **Stillness Draw**, **Answering Steel**, or **Reprisal Cut** consumes the state and gains Perfect Weight:

- increased enemy-posture damage,
- stronger guard recoil,
- stronger stagger against eligible ordinary enemies.

Perfect Weight does not increase Health damage, reach, movement, startup speed, or recovery speed.

Measured Weight ends when Akio takes Health damage, the timer expires, a qualifying heavy consuming strike misses, or Perfect Weight is consumed. Blocking, parrying, dashing, moving, or using a Prosthetic does not immediately cancel it, but the timer continues.

If Resolve preserves an attack after Akio takes Health damage, Measured Weight is lost and that strike receives no Perfect Weight benefit. The player therefore receives either the costly fallback or the clean-execution reward, not both.

**Tier III also applies the third posture-capacity growth step.**

## Tier IV — Shattering Wake

When a major Ronin strike directly hits or is guarded by an enemy, the force continues a limited distance behind the primary target along the original player-selected direction.

Qualifying strikes:

- Bloodfall,
- Stillness Draw,
- Answering Steel,
- Reprisal Cut,
- Falling Mountain's direct blade slam.

Shattering Wake deals reduced Health damage, strong enemy-posture damage, strong guard recoil, and forceful eligible ordinary-enemy stagger to enemies behind the primary target.

Boundaries:

- the primary enemy cannot also receive Wake damage,
- a miss or scenery hit creates no Wake,
- the Wake cannot turn, track, home, retarget, or correct aim,
- each qualifying strike creates at most one Wake,
- the Wake generates no Blood,
- Falling Mountain's impact burst and Deep Rupture do not create additional Wakes.

A Perfect Weight originating strike strengthens the Wake's posture, guard-recoil, and eligible stagger payoff without adding a major Health-damage increase.

**Tier IV also applies the fourth and final posture-capacity growth step.**

# Progression summary

| Tier | Headline benefit | Supporting growth |
|---|---|---|
| Tier 0 | Complete heavy-impact weapon kit and strongest baseline guard | Baseline posture profile |
| Tier I | Steadfast Reprisal / Reprisal Cut | Maximum player-posture capacity +1 step |
| Tier II | Falling Mountain / Deep Rupture | Maximum player-posture capacity +1 step |
| Tier III | Unbroken Resolve / Measured Weight / Perfect Weight | Maximum player-posture capacity +1 step |
| Tier IV | Shattering Wake | Maximum player-posture capacity +1 step |

The progression fantasy is:

> absorb direct pressure → answer deliberately → spend Blood on one monumental point impact → master costly versus clean commitments → drive heavy force through enemy formations

## Technique space

Techniques may reinforce or compensate for Ronin's heavy Basics, Stillness Draw, direct damage, posture chunks, stagger, attack speed, pursuit, recovery, fixed lines, posture recovery, mobile enemies, surrounding pressure, blocking, parrying, deathblows, or Prosthetics.

Fixed Ronin progression should not be duplicated wholesale by ordinary Techniques. In particular, Steadfast Reprisal, Falling Mountain, the Measured Weight → Perfect Weight sequence, and Shattering Wake remain Aspect-owned packages.

## Deferred implementation and balance work

Keep the following out of paper-design lock until prototyping and playtesting:

- exact damage, posture, stagger, block pressure, and Health values,
- exact startup, active, recovery, and Resolve windows,
- exact player-posture capacity growth at each Tier,
- Stillness Draw preparation and hold timings,
- Falling Mountain Blood gain, channel, interruption, radius, damage, and rupture timing,
- Measured Weight duration and presentation,
- Shattering Wake distance, width, secondary weighting, and collision,
- hitboxes, targeting, collision, proc weighting, VFX density, animation frames, and audio timing.

Ronin's qualitative package should not be reopened unless prototype play reveals a concrete usability, overlap, or production problem.