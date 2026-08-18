---
id: GAMEPLAY-BLOOD-ASPECTS
title: Blood Aspect System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-18
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
  - implementation
  - first-playtest
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
  - META-OPEN-QUESTIONS
---

# Blood Aspect System

## Launch foundation

After Returning Blood awakens, the player selects one Blood Aspect before each run. The selected Aspect begins at Tier 0 and replaces the introductory sword moveset with a complete Blood-formed katana weapon kit.

Launch roster:

- **Wolf** — fast close-range pressure and pursuit.
- **Wraith** — extended spectral reach and frontal control.
- **Ronin** — slow heavy impact and defensive stability.

A fourth or fifth Aspect is outside current launch scope.

## Governing rule

Blood Aspects are weapon kits, not passive stances, branching classes, or behavioral minigames.

The three kits share controls, neutral locomotion and dash, ordinary defense/parry rules, posture-break rules, deathblows, Techniques, Prosthetics, and core HUD language. Their identity comes from authored attacks, defensive profile, fixed Tier progression, and Blood Art.

No Aspect uses corrective tracking, hidden homing, or post-input target correction.

## Tier 0 roster

| Aspect | Basic sequence | Held | Dash Attack | Parry Counter | Core identity |
|---|---|---|---|---|---|
| Wolf | Fang Slash → Rending Cross → Raking Fang → Blood Cleave | Predator's Passage | Hunting Slash | Fang Reversal | Fast close pressure and pursuit |
| Wraith | Veil Cut → Passing Arc | Pale Lance | Ghostline Slash | Veil Reversal | Extended reach and frontal control |
| Ronin | Severing Cut → Crushing Cross → Bloodfall | Stillness Draw | Breaching Slash | Answering Steel | Heavy impact and stability |

Tier 0 is complete and viable. The player may stop any Basic sequence early and use another legal action.

## Optional Tier-investment contract

- Every run begins at **Tier 0**.
- Full Corruption creates a Shrine choice between **Resist** and **Embrace**.
- Resist keeps the current Tier and provides approved stabilization support.
- Embrace advances the selected Aspect by one fixed Tier and empties Corruption.
- Tier IV is the maximum; later full thresholds offer Stabilize rather than Tier V.
- A Tier has one headline benefit and at most one minor supporting rule.
- Tier 0-I Technique-focused, Tier II hybrid, and Tier III-IV Aspect-focused builds must all remain viable.
- Mandatory encounters do not assume a required Tier or Blood Art.

## Locked Tier packages

| Tier | Wolf | Wraith | Ronin |
|---|---|---|---|
| **I** | Blood Tempo | Pale Barrage | Steadfast Reprisal |
| **Repeated growth** | Feral Momentum | Spectral Edge | Maximum player-posture capacity |
| **II** | Blood Hunt / Blood Fang | Wraith's Reach | Falling Mountain / Deep Rupture |
| **III** | Fanged Guard | Spectral Passage | Unbroken Resolve / Measured Weight / Perfect Weight |
| **IV** | Apex Mauling | Beyond the Veil | Shattering Wake |

### Wolf progression

- **Blood Tempo:** successful Wolf contact may continue earlier into approved Basic positions.
- **Feral Momentum:** later connected Basic positions gain modest deterministic Health and enemy-posture payoff that increases at each Embrace.
- **Blood Hunt:** full-meter activation restores limited Health and disrupts nearby ordinary enemies before one fixed player-selected pursuit ends in Blood Fang.
- **Fanged Guard:** one normal posture-costing frontal block may preserve selected committed attacks.
- **Apex Mauling:** qualifying major contacts trigger a consolidated Blood-claw follow-up with strong posture pressure and compact secondary coverage.

Wolf remains short-ranged, player-directed, and vulnerable after poor pursuit or missed commitments.

### Wraith progression

- **Pale Barrage:** Pale Lance may continue into rapid lower-impact spectral jabs while Akio remains stationary and committed.
- **Spectral Edge:** eligible spectral-only contact gains modest enemy-posture and guard pressure that increases at each Embrace. Veil Cut, Passing Arc, and Veil Reversal qualify from Tier I; Pale Lance's initial thrust and Ghostline Slash unlock qualification at Tier IV.
- **Wraith's Reach:** full-meter activation performs a compact frontal sweep, one very long fixed corridor strike, and one delayed repetition along the same geometry.
- **Spectral Passage:** qualifying spectral attacks continue through ordinary-enemy bodies across their remaining authored geometry; additional ordinary targets take reduced Health damage and meaningful posture/guard pressure.
- **Beyond the Veil:** Pale Lance and Ghostline Slash gain greater spectral reach, both gain Spectral Edge eligibility, valid deathblows may begin from greater clear-path frontal distance, and a killing deathblow grants brief movement-only Veilstride.

Wraith remains direction-dependent, restrained in movement, and vulnerable to close or lateral collapse.

### Ronin progression

- **Posture-capacity growth:** every Embrace from Tier I through Tier IV modestly increases maximum player-posture capacity. Posture recovery and block efficiency do not scale with it.
- **Steadfast Reprisal:** a qualifying block creates an optional slow standalone Reprisal Cut.
- **Falling Mountain:** full-meter activation clears a meaningful portion of accumulated player posture and powers a planted monumental slam, compact impact burst, and delayed fixed-point Deep Rupture.
- **Unbroken Resolve:** selected late commitments may survive one eligible frontal hit while taking full incoming effects. Clean deliberate strikes may instead create Measured Weight and one Perfect Weight follow-up with stronger posture, guard recoil, and eligible stagger.
- **Shattering Wake:** qualifying direct heavy impacts transfer reduced Health damage and strong posture force through the primary target into enemies behind it.

Ronin remains slow, grounded, fixed-direction, and severely punishable on bad heavy commitments.

# Blood contract

Blood is a separate run-only combat resource owned by the selected Aspect. It is unlocked by reaching Tier II through Shrine Embrace; it is not Corruption and never shares Corruption gain or meter state.

## Meter and state

- Blood is unavailable before Tier II.
- Reaching Tier II enables Blood at **0 / 100**.
- maximum / ready threshold: **100 Blood**.
- Stored Blood persists between rooms until spent or the run ends.
- Blood does not passively decay.
- Gain above 100 is discarded.
- At 100, the selected Aspect's Blood Art becomes Ready.
- Manual Blood Art activation commits the full meter and sets Blood to **0**.
- No Blood is generated while the Blood Art is active/resolving.
- Generation resumes only after the Blood Art has completely finished and normal player control returns.
- Blood and Blood Art state reset after death or successful completion.
- Runs that do not reach Tier II remain viable without Blood.

HUD states are: unavailable → empty/building → near-ready → ready → committed/resolving → spent/rebuilding.

## Shared Blood generation

Blood uses actual meaningful katana contribution rather than raw hit count.

For an eligible direct katana contact:

`Blood = (actual direct Health damage × 0.035 + actual posture/guard pressure × 0.015) × Aspect multiplier`

Aspect normalization:

- **Wolf: ×0.90**,
- **Wraith: ×1.00**,
- **Ronin: ×1.10**.

Additional event gain:

- connected Parry Counter: **+2 Blood**,
- enemy posture break: **+4 Blood**,
- successful Deathblow: **+6 Blood**.

Use actual applied Health/posture values, not nominal pre-mitigation damage or overkill/overbreak values.

The normalization multipliers exist only to keep expected fill pace comparable across Wolf's rapid sequence, Wraith's broader geometry, and Ronin's fewer heavy commitments. They are first-playtest tuning values, not part of Aspect identity.

## Multi-target / multi-hit normalization

For one originating sword action:

- primary valid contact contributes normal Blood,
- additional targets contribute **35% of their otherwise-valid Blood generation**,
- total damage-derived Blood from that originating action is capped at approximately **1.5× the primary full-value contribution**,
- repeated subhits use existing proc/multi-hit normalization where already defined.

## Blood-generation exclusions

The following do **not** generate Blood:

- Blood Arts or their secondary stages,
- Echo damage,
- Rift bursts,
- Rupture events,
- Burn or other status damage,
- Prosthetic damage,
- Technique-created secondary proc/AoE damage,
- Shattering Wake secondary targets,
- Apex Mauling's secondary proc package,
- environmental damage,
- enemy-on-enemy damage,
- no-credit summons or farming targets.

A Technique that increases the originating direct sword hit may affect Blood through that hit's actual applied Health/posture result. A separate spawned/secondary damage packet does not.

Deathblows use the fixed **+6 Blood** event value rather than arbitrary execution damage.

## First-playtest pacing target

The working target is roughly one Blood Art every **3–4 meaningful combat chambers** during ordinary mixed play, with skilled posture/deathblow-heavy play sometimes reaching roughly **2–3 chambers**.

Final Blood coefficients and Aspect multipliers are playtest-tuning variables once this coherent shared contract is implemented.

# Blood Art distinction

> **Wolf moves through the battlefield → Wraith controls a chosen corridor → Ronin dominates a chosen point.**

### Blood Hunt

- limited Health recovery and short-range disruption occur on committed activation,
- one player-selected pursuit line follows,
- eligible ordinary enemies may be passed through under authored collision rules,
- Blood Fang resolves at the stopping target, obstacle, or maximum endpoint,
- ordinary light hits during launched pursuit still deal full effects even when they do not interrupt,
- posture break and overriding attacks interrupt normally.

### Wraith's Reach

- compact frontal sweep supplies immediate activation value,
- one very long fixed corridor strike follows,
- one delayed weaker repetition reuses the exact same corridor,
- enemies may leave or enter before the echo resolves,
- no tracking, pursuit, generic defense, Blood generation, or independent Spectral Edge triggers.

### Falling Mountain

- committed activation clears part of Ronin's accumulated posture,
- Akio remains planted through a brief channel and monumental manually aimed slam,
- eligible ordinary hits may fail to interrupt the channel while still applying full damage and posture,
- a compact impact burst provides reduced nearby payoff,
- Deep Rupture erupts later at the fixed original impact point.

## Technique boundary

Techniques are temporary horizontal customization. Ordinary Techniques use universal action tags and may reinforce, broaden, compensate for, or hybridize the selected Aspect.

They should not duplicate Blood Tempo, Feral Momentum, Blood Hunt, Fanged Guard, Apex Mauling, Pale Barrage, Spectral Edge, Wraith's Reach, Spectral Passage, Beyond the Veil, Steadfast Reprisal, Falling Mountain, Unbroken Resolve/Perfect Weight, or Shattering Wake without explicit approval.

# Planning status

The shared Tier/Blood resource contract is **complete for planning** at first-playtest depth.

The three qualitative Tier 0-IV Aspect packages and their Blood Arts remain locked. Blood gain rates, normalization coefficients, and final cadence may be tuned in Godot without creating another shared player-build planning pass unless implementation exposes a structural gap.
