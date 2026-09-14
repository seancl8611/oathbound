---
id: GAMEPLAY-ASPECT-IMPLEMENTATION-BASELINES
title: Blood Aspect Implementation Baselines
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-09-13
topics:
  - blood-aspects
  - implementation
  - first-playtest
  - wolf
  - wraith
  - ronin
related:
  - GAMEPLAY-COMBAT-IMPLEMENTATION-BASELINE
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
---

# Blood Aspect Implementation Baselines

This file owns the approved first-playtest numerical baselines for Wolf, Wraith, and Ronin.

The qualitative weapon identities, action behavior, Tier rules, collision boundaries, and progression packages remain owned by the individual Aspect authorities. These values are implementation targets, not final balance law. Playtesting may change them without reopening the three-Aspect launch architecture.

All values use the shared normalized combat baseline in `COMBAT_IMPLEMENTATION_BASELINE.md`.

Player-facing Posture is retired. Ordinary player Guard is Health-first and standard enemies use visible Health plus hidden Poise. The `Posture` and `Block posture` attack columns below remain compatibility/authored-pressure values for systems that still consume those channels, including explicit non-standard encounters; they are not a requirement to expose Posture on standard enemies or the player.

# Wolf

Wolf is the fastest, closest-range, highest-connected-pressure kit. Its individual attacks are lighter than Ronin's, but successful continuation produces the strongest sustained output.

## Tier 0 attacks

| Attack | Health | Posture | Block posture | Startup | Recovery | Reach / movement |
|---|---:|---:|---:|---:|---:|---|
| Fang Slash | 12 | 10 | 14 | 0.14 s | 0.20 s | 70 px |
| Rending Cross | 13 | 12 | 16 | 0.16 s | 0.22 s | 80 px broad arc |
| Raking Fang | 15 | 15 | 20 | 0.18 s | 0.26 s | 75 px reach + 55 px authored forward travel |
| Blood Cleave | 22 | 24 | 34 | 0.26 s | 0.42 s | 90 px broad arc |
| Predator's Passage | 28 | 30 | 42 | 0.45 s preparation | 0.50 s | 150 px committed pursuit |
| Hunting Slash | 15 | 13 | 18 | 0.10 s | 0.20 s | 85 px reach + 45 px authored travel |
| Fang Reversal | 16 | 24 | 32 | 0.10 s | 0.24 s | 80 px |

Wolf uses the shared ordinary Guard baseline: a valid frontal block receives **35% of incoming blockable Health damage**.

## Tier baselines

### Tier I — Blood Tempo

On successful qualifying contact, Wolf may cancel approximately the final **40% of the current attack's recovery** into the approved next Basic continuation.

Misses receive no Blood Tempo recovery benefit.

### Feral Momentum

At Tier I, connected sequence positions begin at:

- Rending Cross: approximately **+5% Health and posture/pressure**,
- Raking Fang: approximately **+10% Health and posture/pressure**,
- Blood Cleave: approximately **+15% Health and posture/pressure**.

Each later Embrace modestly increases these three connected-sequence bonuses. Exact Tier II-IV percentages remain first-playtest tuning fields, but the ordering and deterministic growth rule are locked.

### Tier II — Blood Hunt / Blood Fang

First-playtest targets:

- committed activation restores **15 Health**,
- Blood howl radius: approximately **100 px**,
- pursuit distance: approximately **320 px**,
- Blood Fang: **36 Health / 40 authored pressure**,
- ordinary enemies crossed by the pursuit use reduced authored Health damage and meaningful pressure rather than full Blood Fang values.

The qualitative interruption, collision, pass-through, stopping, and ending-recovery rules remain exactly as defined in `WOLF_ASPECT.md`.

### Tier III — Fanged Guard

The approved rule remains one qualifying frontal normal block during the specified Predator's Passage or connected-sequence commitment window. Fanged Guard uses the same Health-first defense contract rather than creating or consuming player Posture.

### Tier IV — Apex Mauling

First-playtest primary-target package:

- **+18 Health damage**,
- **+26 authored pressure**,
- compact reduced secondary coverage,
- approximately **20% movement-speed slow for 1.5 seconds** on the primary target where enemy rules permit.

The mauling remains one consolidated proc package despite multiple visual claw marks.

# Wraith

Wraith trades speed and mobility for the longest ordinary reach, deliberate frontal attack selection, and strong guard/control value at useful spacing.

## Tier 0 attacks

| Attack | Health | Posture | Block posture | Startup | Recovery | Reach / movement |
|---|---:|---:|---:|---:|---:|---|
| Veil Cut | 13 | 12 | 15 | 0.18 s | 0.22 s | 115 px narrow line |
| Passing Arc | 15 | 18 | 26 | 0.24 s | 0.32 s | 110 px broad frontal arc |
| Pale Lance | 24 | 24 | 34 | 0.38 s | 0.42 s | 170 px narrow line |
| Ghostline Slash | 13 | 12 | 16 | 0.12 s | 0.18 s | 125 px spectral reach; minimal extra movement |
| Veil Reversal | 15 | 28 | 38 | 0.12 s | 0.24 s | 130 px |

Wraith uses the shared ordinary Guard baseline: a valid frontal block receives **35% of incoming blockable Health damage**.

## Tier baselines

### Tier I — Pale Barrage

Pale Lance may continue into up to **4 additional jabs**.

First-playtest additional-jab target:

- approximately **7 Health / 6 authored pressure per jab**.

Additional jabs remain restricted multi-hit proc opportunities rather than independent full-power triggers.

### Spectral Edge

Spectral-only qualifying contact gains the following authored posture / guard-pressure bonus where the target supports it:

- Tier I: **+15%**,
- Tier II: **+20%**,
- Tier III: **+25%**,
- Tier IV: **+30%**.

This bonus does not increase Health damage.

### Tier II — Wraith's Reach

First-playtest stages:

- opening sweep: **8 Health / 22 authored pressure**,
- primary corridor: **24 Health / 30 authored pressure**,
- delayed echo: **14 Health / 18 authored pressure**.

The delayed echo remains restricted for proc, healing, Blood-generation, and recursive interactions.

### Tier III — Spectral Passage

Additional ordinary enemies reached after the primary contact receive:

- **60% of the originating attack's Health damage**,
- **75% of the originating attack's authored posture/guard pressure** where supported.

The attack still stops on elites, bosses, protected heavies, solid geometry, and other authored blockers as defined in `WRAITH_ASPECT.md`.

### Tier IV — Beyond the Veil

First-playtest reach targets:

- Pale Lance maximum spectral reach: approximately **230 px**,
- Ghostline Slash spectral reach: approximately **155 px**,
- extended valid authored execution initiation: approximately **180 px** with the approved clear-path/front-angle restrictions where that encounter supports execution.

### Veilstride

After a qualifying authored execution kill:

- movement speed: **+20%**,
- duration: **2.0 seconds**,
- refreshes rather than stacks.

# Ronin

Ronin is the slowest and most committed kit, with the highest individual Health/pressure impact and strongest ordinary guard profile.

## Tier 0 attacks

| Attack | Health | Posture | Block posture | Startup | Recovery | Reach / movement |
|---|---:|---:|---:|---:|---:|---|
| Severing Cut | 18 | 18 | 24 | 0.24 s | 0.30 s | 85 px |
| Crushing Cross | 22 | 24 | 34 | 0.32 s | 0.38 s | 95 px broad frontal arc |
| Bloodfall | 30 | 34 | 48 | 0.42 s | 0.55 s | 100 px |
| Stillness Draw | 38 | 42 | 58 | 0.60 s preparation | 0.60 s | 110 px |
| Breaching Slash | 14 | 12 | 16 | 0.14 s | 0.22 s | 80 px |
| Answering Steel | 26 | 34 | 46 | 0.16 s | 0.32 s | 90 px |

## Defensive baseline

The shared Tier 0 ordinary Guard passes **35%** of incoming blockable Health damage. Ronin's first-playtest defensive profile instead passes **30%** at Tier 0.

Player Posture, Posture recovery, and player Posture-break rules are retired. Universal authored parry timing, dash, ordinary defense inputs, frontal guard-arc rules, and perilous/unblockable bypass behavior remain unchanged.

## Repeated guard-efficiency growth

Each Embrace reduces Ronin's blocked-Health conversion by **2.5 percentage points**:

- Tier 0: **30%**,
- Tier I: **27.5%**,
- Tier II: **25%**,
- Tier III: **22.5%**,
- Tier IV: **20%**.

Positive blocked attacks still deal at least 1 Health in the current implementation. This growth never makes ordinary Guard free and does not heal the player.

## Tier baselines

### Tier I — Reprisal Cut

First-playtest result:

- **24 Health / 28 authored pressure**.

Its qualitative availability, commitment, and miss-recovery rules remain owned by `RONIN_ASPECT.md`.

### Tier II — Falling Mountain / Deep Rupture

Committed activation has **no defensive-resource clear or heal**. Falling Mountain's payoff is offensive and its Blood cost remains meaningful.

Primary slam:

- **48 Health / 55 authored pressure**.

Deep Rupture:

- approximately **3.0 second delay**,
- **28 Health / 40 authored pressure**,
- fixed to the original impact point.

### Tier III — Measured Weight / Perfect Weight

- Measured Weight duration: **4.0 seconds**.
- Perfect Weight: approximately **+35% authored pressure and guard pressure** on the valid consuming strike.
- Perfect Weight adds **no Health-damage bonus**.

Unbroken Resolve continues to use the approved one-hit late-commitment rule and ordinary incoming Health/status consequences. It does not recreate player Posture.

### Tier IV — Shattering Wake

First-playtest geometry and secondary weighting:

- travel approximately **120 px behind the primary target**,
- secondary enemies receive **50% of the originating strike's Health damage**,
- secondary enemies receive **80% of the originating strike's authored posture/guard pressure** where supported.

The primary target cannot receive Wake damage, and the Wake retains all fixed-direction/non-tracking restrictions from `RONIN_ASPECT.md`.

# Cross-roster balance target

The approved first-playtest relationship is:

- **Wolf:** lowest individual impact, fastest sequence, highest connected sustained output and pursuit pressure.
- **Wraith:** moderate damage, safest ordinary reach, strongest spacing-dependent frontal control value.
- **Ronin:** highest individual Health/pressure impact and defensive stability, balanced by the slowest and most punishable commitments.

Do not equalize these kits by forcing similar per-hit values. Playtest them by output over real openings, safety, geometry, target access, interruption/Poise conversion, guard value, and miss punishment.

# Deferred to playable tuning

The following remain intentionally tunable after implementation:

- exact active-frame windows,
- exact hitbox widths/arcs,
- detailed stagger tiers,
- proc coefficients where not already constrained by qualitative rules,
- cancel windows beyond the approved Wolf Blood Tempo baseline,
- exact Blood generation rates,
- Blood Art startup/ending frames,
- final Tier II-IV Feral Momentum percentage progression,
- boss-specific resistance adjustments,
- Ronin blocked-Health conversion if the 30% → 20% curve proves too weak or too dominant,
- final VFX/animation synchronization.

These are not reasons to reopen the three Aspect identities or the approved first-playtest values before implementation.
