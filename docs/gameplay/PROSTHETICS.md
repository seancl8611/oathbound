---
id: GAMEPLAY-PROSTHETICS
title: Prosthetic Tools
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - prosthetics
  - spirit-emblems
  - combat-tools
  - first-attempt
  - forge-progression
  - scrolls
  - implementation
  - first-playtest
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-FIRST-ATTEMPT
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-COMBAT-IMPLEMENTATION-BASELINE
  - ART-PROSTHETIC-VFX
  - CHAR-AKIO
  - ART-MILESTONE-04
---

# Prosthetic Tools

Akio carries eight ritualized combat tools. Each solves a distinct tactical problem rather than serving as a generic damage button.

This file owns both the approved Prosthetic roster/progression rules and the **first-playtest implementation values** for the eight base tools and nineteen permanent upgrades.

These values are prototype implementation targets, not immutable final balance law. Once implemented, ordinary magnitude/cooldown/timing tuning belongs to Godot playtesting unless a structural problem appears.

# Launch roster

| Tool | Tactical role | Core boundary |
|---|---|---|
| Beast-Bane Whistle | Area interrupt / anti-beast stagger | Short-radius pulse; stronger beast reaction |
| Thunder Rod | Precision line attack / Shock setup | Hits first target in aimed line and applies Shock |
| Smoke Gourd | Target break / temporary control zone | Short-lived smoke field disrupts targeting |
| Fang Harpoon | Interrupt / modest enemy reposition | Medium-range shot modestly pulls eligible target |
| Mirror Umbrella | Timed protection / stored-posture release | Active guard stores pressure then releases posture impact |
| Flame Vent | Close-range HP damage / Burn | Short forward cone with Burn |
| Mist Raven | Invulnerable blink / reposition | Very short fixed-distance vanish/reappearance |
| Bloodletting Gourd | Risky recovery / aggression sustain | Trades Spirit for healing + short healing-on-hit window |

One Prosthetic is equipped at a time in the current launch structure.

## Starting Prosthetic

**Beast-Bane Whistle is the default starting Prosthetic** and is equipped on Akio's first attempt.

It is used as the opening tool because its short-radius interrupt / anti-beast stagger role is simple, broadly readable, useful without a specialized build, and does not pre-select a later Blood Aspect or Technique-family identity.

# Shared Spirit and repeat-use model

Akio uses the shared **100 Spirit** combat baseline in `COMBAT_IMPLEMENTATION_BASELINE.md` and has no passive Spirit regeneration unless another approved effect explicitly restores Spirit.

Prosthetics use **Spirit plus cooldown**, not charge inventories.

Shared rules:

- Spirit is spent when Prosthetic activation is committed.
- Cooldown begins when the Prosthetic action finishes and control returns.
- A Prosthetic cannot be activated without its full Spirit cost.
- Prosthetic damage and status damage have **0 ordinary Technique-family proc coefficient** unless an explicit future rule says otherwise.
- Burn and Shock refresh their own duration rather than stacking magnitude.
- Directional tools use the player's chosen direction and do not home or correct toward targets after activation.
- Bosses and protected heavy enemies may still receive Health/posture/status effects while ignoring ordinary pull, target-break, or forced-interrupt behavior.
- Upgrades improve the base tool's existing role; they do not create new Technique-family interactions or alternate attacks.

# First-playtest summary

| Prosthetic | Spirit | Cooldown | Startup | Recovery | Core result |
|---|---:|---:|---:|---:|---|
| Beast-Bane Whistle | **16** | **3.0 s** | **0.18 s** | **0.25 s** | 110 px posture/interrupt pulse; stronger vs beasts |
| Thunder Rod | **22** | **3.0 s** | **0.24 s** | **0.32 s** | 260 px first-target line; 22 Health / 18 posture + Shock |
| Smoke Gourd | **24** | **7.0 s** | **0.25 s** | **0.30 s** | 115 px targeting-disruption field for 3.0 s |
| Fang Harpoon | **18** | **2.5 s** | **0.22 s** | **0.32 s** | 220 px shot; 10 Health / 20 posture + 45 px eligible pull |
| Mirror Umbrella | **20** | **4.5 s** | **0.10 s** | **0.25 s** | up to 1.25 s frontal guard storing block-posture pressure |
| Flame Vent | **20** | **3.5 s** | **0.25 s** | **0.35 s** | 100 px / 70° cone; 18 Health / 8 posture + Burn |
| Mist Raven | **26** | **4.5 s** | **0.06 s** | **0.16 s** | 72 px fixed-direction invulnerable blink |
| Bloodletting Gourd | **30** | **8.0 s** | **0.30 s** | **0.30 s** | heal 15 + 4.0 s healing-on-hit window |

# Forge progression

Prosthetic Techniques are removed from the run Technique system.

- Forge Bench owns permanent Prosthetic unlocks/upgrades.
- Scrolls are the primary Prosthetic upgrade currency.
- A base Prosthetic is functionally complete when unlocked.
- Upgrade paths are linear with no mutually exclusive branches.
- Two upgrades are the default; a third is used only when another existing property is worth improving.

First prototype Scroll costs remain:

- **Upgrade 1: 2 Scrolls**
- **Upgrade 2: 4 Scrolls**
- **Upgrade 3 where present: 6 Scrolls**

The 19-upgrade launch roster therefore has a working full-purchase cost of **66 Scrolls**.

Regional boss materials are **not automatically required** for Prosthetic ranks. A boss-material requirement would need explicit approval for a specific exceptional major Forge gate.

# Beast-Bane Whistle

## Base

- Spirit: **16**
- cooldown: **3.0 s**
- startup / recovery: **0.18 / 0.25 s**
- radius: **110 px**
- Health damage: **0**
- normal posture pressure: **18**
- beast posture pressure: **28**
- eligible ordinary enemies receive a short interrupt/stagger response
- beasts receive the stronger authored beast reaction
- elites/bosses receive posture pressure but ignore forced interruption where protected

Use an enemy `beast` classification rather than per-enemy hardcoded exceptions.

## Upgrades

1. **Reinforced Resonance** — normal posture pressure **18 → 24**; beast posture pressure **28 → 38**.
2. **Broad Resonance** — pulse radius **110 → 145 px**.

# Thunder Rod

## Base

- Spirit: **22**
- cooldown: **3.0 s**
- startup / recovery: **0.24 / 0.32 s**
- aimed line range: **260 px**
- hits the first valid enemy intersecting the line
- Health damage: **22**
- posture damage: **18**
- applies **Shock for 3.0 s**

### Shock

Shock is a setup status, not a stun.

The next direct sword hit against the Shocked enemy:

- consumes Shock,
- deals **+12 posture damage**,
- receives no extra Health damage from Shock.

If Shock expires first, no bonus occurs. Reapplication refreshes the duration rather than stacking multiple charges.

## Upgrades

1. **Charged Conductor** — direct impact **22 → 28 Health** and **18 → 24 posture**.
2. **Lingering Current** — Shock duration **3.0 → 5.0 s**.

# Smoke Gourd

## Base

- Spirit: **24**
- cooldown: **7.0 s**
- startup / recovery: **0.25 / 0.30 s**
- field radius: **115 px**
- persistence: **3.0 s**
- no Health/posture damage

Ordinary enemies inside the field:

- cannot begin new player-targeted attacks from beyond approximately **50 px**,
- lose normal player targeting after approximately **0.25 s** in smoke,
- continue already-committed attacks normally.

Smoke never hides or cancels essential attack telegraphs.

Bosses and protected elites ignore the target-break effect unless an encounter explicitly allows it.

## Upgrades

1. **Expanded Cloud** — radius **115 → 155 px**.
2. **Dense Mixture** — persistence **3.0 → 4.5 s**.

# Fang Harpoon

## Base

- Spirit: **18**
- cooldown: **2.5 s**
- startup / recovery: **0.22 / 0.32 s**
- range: **220 px**
- projectile speed target: approximately **700 px/sec**
- fixed firing direction; hits first valid target
- Health damage: **10**
- posture damage: **20**
- eligible pull distance: **45 px toward Akio**
- eligible ordinary enemies receive an interrupt response

Heavy/protected enemies and bosses remain stationary but still take applicable Health/posture damage.

## Upgrades

1. **Reinforced Chain** — eligible pull distance **45 → 65 px**.
2. **Heavy Barb** — posture damage **20 → 28** and increases eligible ordinary-enemy interrupt strength.

# Mirror Umbrella

Mirror Umbrella is a timed guard/conversion tool, not a second parry system.

## Base

- Spirit: **20**
- cooldown: **4.5 s**
- startup / recovery: **0.10 / 0.25 s**
- frontal coverage: approximately **180°**
- maximum active hold: **1.25 s**
- stored-pressure capacity: **50 incoming block-posture damage**

While active against a valid blockable frontal hit:

- Akio takes **0 Health damage**,
- Akio receives only **25% of the hit's normal block-posture damage**,
- the incoming hit's normal block-posture value is added to Umbrella storage, up to capacity.

On release/close:

- emit a compact approximately **90 px frontal posture release**,
- release posture pressure equals **75% of stored pressure**,
- base release is capped at **38 posture damage**.

If an incoming hit exceeds the Umbrella's remaining storage capacity, the Umbrella fails against that hit and normal defense/block consequences resolve instead.

Mirror Umbrella does not automatically answer grabs, perilous attacks, or authored unblockables.

## Upgrades

1. **Reinforced Canopy** — storage capacity **50 → 70**.
2. **Efficient Mechanism** — Spirit cost **20 → 15**.
3. **Weighted Release** — release becomes **100% of stored pressure**, capped at **55 posture damage**.

# Flame Vent

## Base

- Spirit: **20**
- cooldown: **3.5 s**
- startup / recovery: **0.25 / 0.35 s**
- cone reach: **100 px**
- cone angle: approximately **70°**
- immediate Health damage: **18**
- posture damage: **8**
- applies **Burn for 4.0 s**

### Burn

- **3 Health damage/sec**
- base duration **4.0 s** = **12 total Burn damage** if uninterrupted
- Burn does not stack magnitude
- reapplication refreshes duration
- Burn damage has **0 ordinary Technique proc coefficient**

## Upgrades

1. **Pressurized Vent** — cone reach **100 → 130 px**.
2. **Refined Fuel** — immediate Health damage **18 → 25**.
3. **Persistent Burn** — Burn duration **4.0 → 6.0 s**, for **18 total Burn damage** at the unchanged tick rate.

# Mist Raven

## Base

- Spirit: **26**
- cooldown: **4.5 s**
- startup / recovery: **0.06 / 0.16 s**
- fixed-direction blink distance: **72 px**
- Akio is invulnerable from disappearance through reappearance, approximately **0.20 s** total
- may pass through enemies
- cannot pass through solid world geometry
- deals no damage
- does not automatically place Akio behind a target or create backstab classification

Mist Raven remains a short tactical reposition and does not replace the shared 96 px dash as the normal mobility foundation.

## Upgrades

1. **Efficient Passage** — Spirit cost **26 → 20**.
2. **Farther Passage** — blink distance **72 → 92 px**.

# Bloodletting Gourd

## Base

- Spirit: **30**
- cooldown: **8.0 s**
- startup / recovery: **0.30 / 0.30 s**
- immediate heal: **15 Health**
- healing-on-hit duration: **4.0 s**

During the healing-on-hit window:

- direct sword Health damage heals Akio for **12% of actual direct Health damage dealt**,
- additional healing from the window is capped at **12 Health per activation**,
- healing cannot exceed Akio's current maximum Health.

Excluded from healing-on-hit:

- Technique-created secondary damage,
- Echo/Rift/Burn and other proc/status damage,
- Prosthetic damage,
- Deathblow execution damage.

## Upgrades

1. **Deeper Draught** — immediate heal **15 → 22 Health**.
2. **Longer Bloodletting** — healing-on-hit window **4.0 → 6.0 s**.
3. **Stronger Return** — healing-on-hit **12% → 18%** and per-activation window cap **12 → 18 Health**.

# Implementation guardrails

- Upgrades do not add alternate attacks, new status families, autonomous effects, Technique-family interactions, or new combat roles.
- Base tools must be useful before upgrades.
- Fully upgraded tools should feel more reliable/effective, not like different weapons.
- Direct-damage tools cannot make sword/parry/posture/deathblow play optional.
- Upgrade depth does not need to be identical across tools.
- Pull/blink/interrupt behavior respects boss/elite immunity rules.
- Mist Raven remains distinct from Wraith Aspect.
- Smoke cannot hide essential attack tells.
- Mirror Umbrella remains distinct from the universal parry and does not bypass perilous-response rules.
- Shock and Burn are Prosthetic statuses unless another authority explicitly creates a separate interaction.

# Planning exit condition

The Prosthetic package is **complete for planning** at first-playtest depth.

The eight base tools and nineteen upgrades now have enough Spirit, repeat-use, timing, geometry, Health/posture, status, control, and upgrade data to instantiate in Godot.

Do not create a follow-up Prosthetic planning pass merely to refine final cooldowns, hitboxes, VFX synchronization, projectile speed, status magnitudes, or balance. Those values should move through implementation/playtesting unless a genuine missing rule or structural incompatibility appears.

The authoritative visual requirements remain in `art_production/PROSTHETIC_VFX.md`.
