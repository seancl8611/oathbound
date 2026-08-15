---
id: GAMEPLAY-PROSTHETICS
title: Prosthetic Tools
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-15
topics:
  - prosthetics
  - spirit-emblems
  - combat-tools
  - forge-progression
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROGRESSION
  - ART-PROSTHETIC-VFX
  - CHAR-AKIO
  - ART-MILESTONE-04
---

# Prosthetic Tools

Akio carries eight ritualized combat tools operated primarily through a shared generic prosthetic-use animation and tool-specific effects. Each tool solves a distinct tactical problem rather than serving as a generic damage button.

## Launch roster

The eight-tool launch roster is locked at qualitative paper-design depth.

| Tool | Tactical role | Core functional boundary |
|---|---|---|
| Beast-Bane Whistle | Area interrupt and anti-beast stagger | Short-radius pulse; stronger reaction on beast-type enemies |
| Thunder Rod | Precision line attack and Shock setup | Hits the first target in the aimed line and applies Shock |
| Smoke Gourd | Target-break and temporary control zone | Creates a short-lived smoke field that disrupts enemy targeting |
| Fang Harpoon | Interrupt and modest enemy reposition | Medium-range shot that pulls the struck target slightly toward Akio |
| Mirror Umbrella | Timed protection and stored-posture release | Active guard negates hits, then releases stored posture pressure on close |
| Flame Vent | Close-range HP damage and Burn | Short forward cone with readable Burn application |
| Mist Raven | Invulnerable blink and reposition | Very short fixed-distance vanish and reappearance |
| Bloodletting Gourd | Risky recovery and aggression sustain | Trades Spirit for immediate healing and a short healing-on-hit window |

## Loadout boundary

The initial run structure uses one equipped Prosthetic at a time. Any later second-tool loadout is a separate scope decision.

## Shared resource model

Prosthetics use Spirit emblems or the project's final equivalent shared tool resource. Exact costs, cooldowns, charges, and upgrade values remain tuning variables until implementation and playtesting define them.

## Forge progression ownership

Prosthetic Techniques are removed from the Technique reward system.

- **Forge Bench:** owns permanent Prosthetic unlocks and individual tool upgrades.
- **Scrolls:** remain the primary persistent Forge currency for Prosthetic development.
- **Technique system:** modifies Akio's sword build and does not temporarily upgrade a particular Prosthetic.
- **Run rewards:** do not need a separate Prosthetic-Technique layer.

A Prosthetic is functionally complete when unlocked. Forge upgrades make the existing tool better at its approved job; they do not unlock a second moveset, new combat role, alternate weapon class, branching Technique-style build, or unrelated active ability.

The default progression depth is **two sequential upgrades**. A third upgrade is used only when the base tool already contains several distinct properties worth improving. The current launch paths are linear and contain no mutually exclusive branches.

Exact percentages, Scroll costs, unlock thresholds, Spirit values, status values, timing, damage, posture values, and other numerical tuning remain later implementation and playtest work.

## Locked Forge upgrade paths

Each listed upgrade requires the previous upgrade in that tool's path.

### Beast-Bane Whistle

**Base:** short-radius interrupt/stagger pulse with a stronger reaction against beasts.

1. **Reinforced Resonance** — increases the Whistle's existing interrupt and stagger strength while preserving its stronger anti-beast response.
2. **Broad Resonance** — increases the existing pulse radius.

### Thunder Rod

**Base:** precise aimed line strike that hits the first target and applies Shock.

1. **Charged Conductor** — increases the direct Health and posture impact of the existing strike.
2. **Lingering Current** — increases the duration of the existing Shock effect.

### Smoke Gourd

**Base:** short-lived smoke field that disrupts enemy targeting.

1. **Expanded Cloud** — increases the existing smoke-field footprint.
2. **Dense Mixture** — increases how long the existing smoke field persists.

### Fang Harpoon

**Base:** medium-range interrupt that pulls an eligible struck target modestly toward Akio.

1. **Reinforced Chain** — increases the existing pull distance against eligible targets.
2. **Heavy Barb** — increases the existing interruption and posture impact on hit.

### Mirror Umbrella

**Base:** protected guard state that negates incoming hits, stores posture pressure, and releases that pressure when the Umbrella closes.

1. **Reinforced Canopy** — increases how much incoming pressure the existing guard can safely store before release.
2. **Efficient Mechanism** — improves the Spirit efficiency of the existing guard state.
3. **Weighted Release** — increases the posture pressure of the existing closing release.

### Flame Vent

**Base:** short forward flame cone that deals direct Health damage and applies Burn.

1. **Pressurized Vent** — modestly increases the reach of the existing flame cone.
2. **Refined Fuel** — increases the direct Health damage of the existing flame burst.
3. **Persistent Burn** — increases the duration of the existing Burn effect.

### Mist Raven

**Base:** very short fixed-distance invulnerable blink used to reposition.

1. **Efficient Passage** — improves the Spirit efficiency of the existing blink.
2. **Farther Passage** — modestly increases the fixed blink distance while keeping Mist Raven a short-range reposition rather than general traversal.

### Bloodletting Gourd

**Base:** spends Spirit for immediate healing and a short window in which sword hits restore Health.

1. **Deeper Draught** — increases the existing immediate heal.
2. **Longer Bloodletting** — increases the duration of the existing healing-on-hit window.
3. **Stronger Return** — increases the Health restored by qualifying sword hits during that existing window.

## Upgrade guardrails

- Forge upgrades improve properties already present in the base tool.
- Upgrades do not add alternate attacks, new status families, autonomous effects, Technique-family interactions, or separate combo trees.
- A base Prosthetic must feel useful before any permanent upgrades are purchased.
- A fully upgraded Prosthetic should feel more reliable and effective, not like a different tool.
- Direct-damage upgrades must not make sword combat, parry, posture, or deathblow play optional.
- Upgrade depth does not need to be identical across all eight tools.
- A tool should not receive extra nodes merely to match another tool's node count.

## Interaction principles

- Tools should create openings, solve positioning problems, or support tactical decisions.
- Direct-damage tools should not make sword combat, parry, posture, or deathblow play optional.
- Status applications must use the same approved definitions used by enemies and HUD.
- Mist Raven and Wraith Aspect must remain mechanically and visually distinct.
- Mirror Umbrella requires explicit active, inactive, and release states.
- Smoke cannot hide essential silhouettes or attack tells.
- Pull, blink, and interrupt behavior must respect boss and elite immunity rules where applicable.
- Permanent upgrades should deepen the existing tool role rather than transform it into an unrelated weapon class.

## Required implementation data per tool

- Spirit cost
- cooldown or charge rule
- startup, active, and recovery timing
- valid targets and immunity rules
- hitbox, line, cone, or radius data
- status duration and stack behavior
- posture and HP effects
- permanent Forge upgrade values and costs
- icon, world object, VFX, sound, and animation dependencies

## Production rule

Most tools should use Akio's shared `prosthetic_use` pose plus layered tool objects and effects. Forge upgrades should reuse the base tool's production language and only require proportional changes such as stronger intensity, larger approved footprint, or longer existing status presentation where readability requires it.

Any tool or upgrade requiring a unique full-body animation or a substantially new VFX family is an explicit scope increase and must be separately approved before quotation.

The authoritative visual requirements belong in [Prosthetic Tool VFX](../art_production/PROSTHETIC_VFX.md).
