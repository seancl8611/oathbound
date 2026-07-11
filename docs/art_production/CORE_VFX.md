---
id: ART-CORE-VFX
title: Core Combat and Corruption VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - vfx
  - parry
  - hit-spark
  - sword-trail
  - posture-break
  - deathblow
  - corruption
  - shrine
related:
  - GAMEPLAY-COMBAT
  - GAMEPLAY-CORRUPTION-SHRINES
  - UI-HUD
  - UI-SHRINE
  - ART-MILESTONE-01
  - ART-MILESTONE-02
  - ART-ASPECT-VFX
---

# Core Combat and Corruption VFX

Shared combat and corruption cues strengthen readability without obscuring silhouettes, telegraphs, recovery frames, or safe space. Frequent effects stay compact and directional. Stronger presentation is reserved for posture breaks, execution openings, Shrine choices, and boss transitions.

## Milestone 1 combat bundle

### VFX-001 — Parry Spark

**Gameplay purpose:** confirms a successful deflect immediately.

**Working frames:** 4–6.

**Visual fantasy:** refracted steel-on-steel contact at the exact weapon intersection, not a generic spark cloud.

**Grades:**

- standard deflect: medium burst,
- perfect parry: brighter core, slightly larger rays, and stronger punctuation.

**Readability:** instantly distinguishable from Hit Spark without requiring sound. The brightest point remains tight to contact; small sparks follow the incoming strike angle.

**Constraints:** no smoke, broad circular explosion, blood-heavy accent, or magical glyph.

### VFX-002 — Hit Spark

**Gameplay purpose:** workhorse confirmation for ordinary damage.

**Working frames:** 3–5.

**Visual fantasy:** quick restrained impact burst.

**Readability:** smaller, quieter, and more frequent than Parry Spark. It must never compete with parry, posture break, deathblow, or boss-transition cues.

**Constraints:** avoid oversized flashes and long-lived particles.

### VFX-003 — Deathblow Cue

**Gameplay purpose:** marks a valid execution opening.

**Working frames:** 3–4 loop for the persistent window.

**Visual fantasy:** ritual blood seal, sharp spectral pulse, or restrained execution mark anchored above the enemy's upper body. It must feel diegetic to Oathbound rather than like a generic exclamation icon.

**Readability:** visible across a crowded screen and unmistakable from posture break or status effects. It persists until consumed or the valid window closes and works with the HUD input prompt.

**Constraints:** red is the primary accent, but shape and placement also carry the read.

### VFX-004 — Sword Trail

**Gameplay purpose:** clarifies Akio's base combo arcs.

**Working frames:** approximately 4–6 per swing family.

**Visual fantasy:** disciplined blade-path reinforcement rather than decorative energy.

**Required variants:**

- Quick Slash: shortest and lightest,
- Cross Cut: wider diagonal coverage,
- Heavy Cleave: weightiest trail, stronger follow-through, and clearest commitment.

**Readability:** the trail clarifies where the blade traveled and clears before it obscures recovery or the next attack.

## Posture Break Cue

**Gameplay purpose:** shows that an enemy's posture has fully broken and a vulnerability state has begun.

**Visual fantasy:** quick body-centered break flash with a compact cracked ring and sharp metallic fragments.

**Timing:** slightly larger and longer than Parry Spark, but fast to clear.

**Readability:** distinct from normal hit, parry, hurt, death, and Deathblow Cue. The cue says the enemy is opened; the persistent Deathblow Cue says execution is available.

**Scope note:** this effect is part of the broader core VFX language, but the polished Milestone 1 brief lists only VFX-001 through VFX-004. Its exact contractor batch assignment remains an open production-scope question.

## Corruption Full Cue

**Gameplay purpose:** shows that Corruption is full and may be resolved at the next Shrine.

**Visual fantasy:** low-frequency dark-crimson pressure around Akio and the HUD meter.

**Timing:** continuous while full, ending immediately after Shrine resolution.

**Readability:** distinct from low HP, depleted Spirit, Burn, Focus, boss empowerment, and other urgent states.

## Embrace Transformation Cue

**Gameplay purpose:** communicates an increase in Blood Aspect Tier.

**Visual fantasy:** controlled blood-red surge travels from Shrine to Akio, briefly ignites the full body, then settles into the new Aspect/Tier overlay.

**Timing:** one short ritual beat: Shrine flare, player ignition, state settlement.

**Readability:** clearly empowerment through acceptance rather than stabilization.

## Resist Stabilization Cue

**Gameplay purpose:** communicates Corruption being restrained without Tier advancement.

**Visual fantasy:** cooler pale ritual pulse that pushes pressure outward and ends in a brief recovery beat.

**Timing:** one short stabilizing exhale.

**Readability:** clearly holding the line, not gaining power. It may echo Health pickup language without looking identical.

## Related player-system VFX

- [Blood Aspect VFX](ASPECT_VFX.md)
- [Prosthetic Tool VFX](PROSTHETIC_VFX.md)
- [Combat Stance VFX](STANCE_VFX.md)

## Delivery and testing

Source files are required. Each effect receives transparent frames or sheets, timing notes, palette continuity, and in-engine testing over Hushiro, Yomori, and Kagutsuchi backgrounds. Effects must remain readable with screen shake, damage numbers, HUD state, multiple enemies, and environmental atmosphere active.
