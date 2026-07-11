---
id: ART-PROSTHETIC-VFX
title: Prosthetic Tool VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - prosthetics
  - tools
  - vfx
  - prosthetic-techniques
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

## Prosthetic Technique extensions

Temporary Prosthetic Techniques extend the approved tool identity rather than commission a second unrelated VFX family.

Examples include:

- a clearly bounded scorched zone attached to Flame Vent,
- a stronger stored-posture release attached to Mirror Umbrella,
- a modified pull or marked-target response attached to Fang Harpoon,
- a temporary state marker attached to Bloodletting Gourd.

Each extension must specify its changed footprint, target state, duration, and refinement difference. Reuse the base tool effect wherever the mechanic remains readable.

## Shared production rules

- Tool effects remain below parry, posture break, deathblow, Shrine choice, and boss-transition cues in the global hierarchy.
- Tool footprints must remain readable over all three area palettes.
- Status markers require consistent active, expiring, and cleared states.
- Any tool that cannot work with the generic activation pose must be identified before quotation as additional animation scope.
- Exact costs, cooldowns, permanent upgrades, and Prosthetic Technique behavior belong to gameplay documentation and remain tunable.
