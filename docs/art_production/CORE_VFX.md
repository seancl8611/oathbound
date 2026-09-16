---
id: ART-CORE-VFX
title: Core Combat and Corruption VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-09-16
topics:
  - vfx
  - hit-confirmation
  - sword-trail
  - guard-impact
  - interruption
  - danger-telegraphs
  - corruption
  - shrine
related:
  - GAMEPLAY-COMBAT
  - OVERVIEW-V2-COMBAT-DIRECTION
  - GAMEPLAY-CORRUPTION-SHRINES
  - UI-HUD
  - UI-SHRINE
  - ART-MILESTONE-01
---

# Core Combat and Corruption VFX

Shared combat cues must strengthen readability without obscuring silhouettes, weapon direction, recovery, escape space, or enemy intent.

Combat V2 does **not** use a universal player-Posture / enemy-Posture / Deathblow loop and does not require every player kit to expose the same timed parry/counter presentation. Core VFX therefore covers only genuinely shared feedback. Kit-, enemy-, and encounter-specific responses belong to their owning packages.

## Shared combat bundle

### VFX-001 — Hit Spark

**Purpose:** immediate ordinary damage/contact confirmation.

Working frame range: approximately 3–5 frames at the current sprite treatment.

- compact and directional;
- clears quickly;
- supports weapon-path readability rather than hiding it;
- may vary modestly by material/target type without becoming a separate effect family for every enemy;
- must remain visually below major boss, Blood Art, corruption, and special-response events.

### VFX-002 — Sword Trail

**Purpose:** clarify Akio's katana path at the small accepted gameplay scale.

The trail follows the actual presented attack geometry and must not imply extra reach or a different hitbox.

Intro/base-katana examples include:

- Quick Slash — shortest/lightest;
- Cross Cut — wider continuation path;
- Heavy Cleave — weightiest/most committed.

Aspect-specific trails may replace or extend this language while remaining subordinate to the weapon/body silhouette.

### VFX-003 — Guard / Protected Contact

**Purpose:** show that an incoming strike contacted an authored guard/protected state instead of landing as an ordinary unguarded hit.

- compact contact flash at the weapon/guard region;
- visibly different from an ordinary Health hit;
- does not imply a universal block meter;
- may communicate stronger recoil/break response for authored enemy guards or Ronin-specific guard states;
- exact Health-chip behavior remains gameplay-owned.

This effect family is reusable, but guard availability/coverage/outcome remains specific to the owning player kit or enemy profile.

### VFX-004 — Interruption / Stagger Confirmation

**Purpose:** make meaningful loss of control readable when hidden Poise/interruption rules cause it.

This is not a meter-break effect.

- short body-centered interruption accent or recoil punctuation;
- stronger than a normal hit reaction only when gameplay actually enters an authored interruption/stagger state;
- no persistent universal icon;
- heavy enemies may take Health damage without showing this response when their current action resists interruption.

### VFX-005 — Dangerous Attack / Spatial Threat Language

**Purpose:** support learnable enemy pressure without covering the screen in generic warnings.

Shared language should be semantic rather than one universal icon:

- direct committed melee may use concise late timing emphasis;
- projectile threats use projectile-local geometry/ETA cues;
- ground AoEs use their landing/impact area;
- grabs, restraints, sweeps, or unblockable/perilous attacks use distinct authored silhouette/VFX language where the owning combat design requires it.

The presentation must describe the actual threat geometry/timing. It must not promise a block/parry response that the active kit does not own.

## Specialized responses are not global core VFX

The following may exist, but they are **not universal shared-combat requirements**:

- Ronin Reprisal opportunity/response;
- a kit-specific parry or counter spark;
- enemy-specific guard break;
- boss/miniboss stagger or vulnerability cue;
- execution-like encounter mechanics;
- Technique-created statuses;
- Aspect-specific protected-commitment states.

These belong to the relevant Aspect, enemy, boss, Technique, or encounter authority.

Do not recreate the retired universal Parry Spark + Posture Break Cue + Deathblow Cue hierarchy as the default combat language.

## Corruption and Shrine cues

### Corruption Full Cue

Shows that Corruption is full and may be resolved at the next Shrine.

- low-frequency dark-crimson pressure around Akio and/or the meter;
- ends immediately after Shrine resolution;
- distinct from low Health, depleted Spirit, Blood readiness, or boss empowerment.

### Embrace Transformation Cue

Communicates a Blood Aspect Tier increase.

- Shrine flare;
- controlled blood-red surge into Akio;
- brief full-body ignition/transformation punctuation;
- settlement into the new Aspect/Tier state.

### Resist Stabilization Cue

Communicates stabilization without Tier advancement.

- cooler/paler ritual pulse;
- outward release of pressure;
- brief recovery beat;
- clearly reads as restraint/stabilization rather than empowerment.

### Stabilize at Tier IV

When the selected Aspect can no longer advance, the full-Corruption Shrine result should reuse the established stabilization language rather than inventing a fake Tier V transformation.

## Layering and directional-actor boundary

Core combat VFX stay separate from the directional character body frames wherever practical.

This allows:

- body art to be rerendered without rebuilding hit feedback;
- clean-prerender and pixel/downsample character treatments to use the same gameplay VFX;
- attack timing/telegraphs to remain authoritative even while character art changes;
- frequent effects to be tuned independently for screen clutter.

A body animation may visually imply impact, guard, or recoil, but critical gameplay feedback should not depend on one baked frame that disappears when the actor sprite set is replaced.

## Delivery and testing

Every production effect requires the relevant source files, transparent frames/textures/shader data, timing notes, palette continuity, and clean Godot import.

Effects must be tested with:

- the accepted `0.50` Hushiro camera zoom and `0.72` ground-compression presentation;
- multiple enemies on screen;
- directional actor sprites at their intended screen size;
- HUD and damage feedback active;
- Hushiro, Yomori, and Kagutsuchi value ranges;
- environmental atmosphere/foreground occluders;
- both clean-prerender and pixel/downsample actor treatments while that style decision remains open.

The test is successful when the player can tell **what happened and what threat remains** without the effect obscuring the next decision.
