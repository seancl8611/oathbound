---
id: ART-PROSTHETIC-VFX
title: Prosthetic Tool VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-08-15
topics:
  - prosthetics
  - tools
  - vfx
  - forge-progression
related:
  - GAMEPLAY-PROSTHETICS
  - GAMEPLAY-TECHNIQUES
  - CHAR-AKIO
  - ART-TECHNIQUE-VFX
  - ART-MILESTONE-04
---

# Prosthetic Tool VFX

Each prosthetic solves a specific combat problem. Effects must communicate the tool's footprint, target, status, and active window immediately. Most tools use Akio's shared `prosthetic_use` pose plus tool-specific layered objects and effects.

## Beast-Bane Whistle

**Purpose:** short-range interrupt and stagger pulse, with stronger feedback on beast-type enemies.

**Visual language:** one clean outward hunting-whistle ring centered on Akio, with faint air distortion or spirit resonance rather than a magical explosion.

**Readability:** the radius and every affected enemy must be obvious. Optional beast-specific reaction accents may be stronger, but the base pulse remains simple.

**Technical:** fast cast, one outward burst, short fade. Keep the ring above the ground plane and characters without smoke or heavy particles.

## Thunder Rod

**Purpose:** precise line strike that hits the first target and applies Shock.

**Visual language:** a narrow lightning path in the aimed direction, followed by a sharp electric hit and compact lingering Shock marker on the struck enemy.

**Readability:** distinguish the line, first target hit, and Shocked state from sword trails and normal hit sparks.

**Technical:** fast and responsive, but visible long enough to read. Keep electricity localized to the line and target rather than filling the room.

## Smoke Gourd

**Purpose:** creates a temporary area that breaks enemy targeting and disrupts or confuses enemies.

**Visual language:** practical shinobi-style dark smoke, deployed rapidly into a low circular ground cloud.

**Readability:** the full footprint must be visible while enemy and player silhouettes remain trackable inside or around it.

**Technical:** use a clear circular edge and contained density. The initial burst reads immediately; the field persists briefly as a control zone beneath characters and projectiles but above the floor.

## Fang Harpoon

**Purpose:** fast medium-range interrupt that pulls the struck target slightly toward Akio.

**Visual language:** narrow mechanical harpoon line, sharp impact, and modest body tug.

**Readability:** shot direction, target hit, interruption, and displacement must all be clear. The pull must not resemble a full grapple or teleport.

**Technical:** fire from Akio's prosthetic side. Keep projectile travel and pull reaction snappy and controlled.

## Mirror Umbrella

**Purpose:** enters a protected guard state that negates incoming hits, then releases stored posture damage when the umbrella closes.

**Visual language:** compact snap-open reflective umbrella shape around Akio's front/upper body, followed by a small radial shock on closure.

**Readability:** open equals protected; closed equals release. The active guard window and its ending must never be ambiguous.

**Technical:** avoid a magical barrier bubble or oversized shield. The held state remains stable; the release is brief and distinct from a normal hit.

## Flame Vent

**Purpose:** short-range cone damage and Burn application.

**Visual language:** forceful mechanical flame burst from Akio's tool side, compact and directional rather than a large fantasy fire spell.

**Readability:** cone range and facing must be obvious. Burned targets receive a simple persistent status treatment that does not obscure body lines.

**Technical:** fast startup, short active burst, quick clear. Minimize smoke and preserve nearby attack telegraphs.

## Mist Raven

**Purpose:** brief invulnerable blink and short fixed-distance reposition.

**Visual language:** Akio breaks into a few dark feathers and mist shapes, then reforms clearly at the destination.

**Readability:** disappearance point, reappearance point, and body transition must be unmistakable and distinct from normal dash and Wraith Aspect effects.

**Technical:** extremely fast and compact. Use a few strong shapes rather than a large feather cloud. Positional clarity is the primary acceptance criterion.

## Bloodletting Gourd

**Purpose:** sacrifices Spirit for immediate healing, then grants a short life-steal window in which sword hits restore small HP.

**Visual language:** sharp restrained blood-red heal pulse, followed by a subtle blood-marked body overlay during the life-steal state.

**Readability:** instant heal and temporary healing-on-hit state must read as separate beats and remain distinct from Corruption, Burn, or generic buffs.

**Technical:** activation may be strong; the sustained state stays quiet. Use contained red accents, not holy healing waves.

## Forge upgrade presentation

Permanent Forge upgrades strengthen properties that already belong to the base tool. They do not commission alternate attacks, new status families, unrelated active effects, or a second Technique-style VFX package.

Approved upgrade presentation may proportionally strengthen existing visual language when gameplay readability requires it:

- Beast-Bane Whistle may show a larger existing resonance ring when pulse radius increases.
- Thunder Rod retains the same line strike and Shock marker; stronger impact or longer Shock should use intensity/timing changes rather than a new effect family.
- Smoke Gourd retains the same cloud language while its approved footprint or persistence changes.
- Fang Harpoon retains the same projectile, chain, impact, and pull language while displacement or impact strength changes.
- Mirror Umbrella retains its open-guard and close-release states while storage, efficiency, or release strength improves.
- Flame Vent retains the same directional cone and Burn treatment while reach, direct damage, or Burn duration improves.
- Mist Raven retains the same vanish/reappear language while Spirit efficiency or short fixed-distance range improves.
- Bloodletting Gourd retains the same immediate heal pulse and healing-on-hit overlay while their existing values or duration improve.

Forge progression should therefore reuse the base tool asset set wherever possible. A numerical or bounded geometric upgrade does not justify a new animation or unrelated VFX concept by itself.

## Shared production rules

- Tool effects remain below parry, posture break, deathblow, Shrine choice, and boss-transition cues in the global hierarchy.
- Tool footprints must remain readable over all three area palettes.
- Status markers require consistent active, expiring, and cleared states.
- Any tool that cannot work with the generic activation pose must be identified before quotation as additional animation scope.
- Any Forge upgrade that unexpectedly requires a unique full-body animation or substantially new VFX family is an explicit scope increase and must be separately approved.
- Exact costs, Spirit values, damage, posture, status durations, footprints, and timing remain tunable gameplay values owned by the Prosthetic gameplay documentation.
