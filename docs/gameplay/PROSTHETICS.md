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
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-FIRST-ATTEMPT
  - GAMEPLAY-ITEMS-REWARDS
  - ART-PROSTHETIC-VFX
  - CHAR-AKIO
  - ART-MILESTONE-04
---

# Prosthetic Tools

Akio carries eight ritualized combat tools. Each solves a distinct tactical problem rather than serving as a generic damage button.

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

The first attempt therefore teaches the shared Spirit/Prosthetic input with a straightforward utility tool while the remaining Prosthetic roster becomes part of later Forge/unlock progression.

# Shared resource model

Prosthetics use Spirit emblems / the project's final shared tool resource. Exact Spirit costs, cooldowns/charges, damage, status values, and timings remain playtest variables.

# Forge progression

Prosthetic Techniques are removed from the run Technique system.

- Forge Bench owns permanent Prosthetic unlocks/upgrades.
- Scrolls are the primary Prosthetic upgrade currency.
- A base Prosthetic is functionally complete when unlocked.
- Upgrades improve properties already present in the base tool.
- Paths are linear with no mutually exclusive branches.
- Two upgrades are the default; a third is used only when another existing property is worth improving.

First prototype Scroll costs:

- **Upgrade 1: 2 Scrolls**
- **Upgrade 2: 4 Scrolls**
- **Upgrade 3 where present: 6 Scrolls**

The current 19-upgrade launch roster therefore has a working full-purchase cost of **66 Scrolls**. Final costs may move through playtesting without reopening the progression structure.

Regional boss materials are **not automatically required** for Prosthetic ranks. A boss-material requirement would need explicit approval for a specific exceptional major Forge gate.

# Locked upgrade paths

## Beast-Bane Whistle

**Base:** short-radius interrupt/stagger pulse; stronger response against beasts.

1. **Reinforced Resonance** — stronger existing interrupt/stagger.
2. **Broad Resonance** — larger existing pulse radius.

## Thunder Rod

**Base:** aimed line strike hitting first target and applying Shock.

1. **Charged Conductor** — stronger direct Health/posture impact.
2. **Lingering Current** — longer existing Shock.

## Smoke Gourd

**Base:** short-lived smoke field disrupting enemy targeting.

1. **Expanded Cloud** — larger field.
2. **Dense Mixture** — longer persistence.

## Fang Harpoon

**Base:** medium-range interrupt with modest pull on eligible targets.

1. **Reinforced Chain** — greater eligible pull distance.
2. **Heavy Barb** — stronger interruption/posture impact.

## Mirror Umbrella

**Base:** protected guard that stores pressure and releases posture pressure on close.

1. **Reinforced Canopy** — greater safe stored-pressure capacity.
2. **Efficient Mechanism** — improved Spirit efficiency.
3. **Weighted Release** — stronger closing posture release.

## Flame Vent

**Base:** short forward cone dealing direct Health damage and Burn.

1. **Pressurized Vent** — modestly greater cone reach.
2. **Refined Fuel** — greater direct Health damage.
3. **Persistent Burn** — longer Burn duration.

## Mist Raven

**Base:** very short fixed-distance invulnerable blink.

1. **Efficient Passage** — improved Spirit efficiency.
2. **Farther Passage** — modestly greater fixed blink distance while remaining short-range repositioning.

## Bloodletting Gourd

**Base:** spends Spirit for immediate healing plus short healing-on-hit window.

1. **Deeper Draught** — stronger immediate heal.
2. **Longer Bloodletting** — longer healing-on-hit window.
3. **Stronger Return** — stronger qualifying healing-on-hit return.

# Guardrails

- Upgrades do not add alternate attacks, new status families, autonomous effects, Technique-family interactions, or new combat roles.
- Base tools must be useful before upgrades.
- Fully upgraded tools should feel more reliable/effective, not like different weapons.
- Direct-damage tools cannot make sword/parry/posture/deathblow play optional.
- Upgrade depth does not need to be identical across tools.
- Pull/blink/interrupt behavior respects boss/elite immunity rules.
- Mist Raven remains distinct from Wraith Aspect.
- Smoke cannot hide essential attack tells.

# Required implementation data per tool

- Spirit cost,
- cooldown/charge rule,
- startup/active/recovery timing,
- valid targets/immunity,
- geometry,
- status behavior,
- Health/posture effects,
- permanent upgrade values,
- icon/world object/VFX/sound/animation dependencies.

The authoritative visual requirements belong in `art_production/PROSTHETIC_VFX.md`.
