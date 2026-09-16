---
id: META-TERMINOLOGY
title: Oathbound Terminology
category: meta
status: approved
authority: primary
last_reviewed: 2026-09-16
---

# Oathbound Terminology

Use these terms as canonical search anchors. When older files use a retired term, reconcile the owning system instead of preserving the old wording as a parallel rule.

## Combat

| Preferred term | Current meaning |
|---|---|
| **Health** | Normal survival/defeat resource for Akio and standard enemies. |
| **Poise / interruption resistance** | Hidden combat state used for flinch, stagger, recoil, and action interruption. Not a universal visible meter. |
| **Guard** | Authored defensive behavior. Player Guard is kit-specific where appropriate; Ronin owns the strongest explicit Guard identity. |
| **Reprisal** | Ronin-owned retaliation relationship after qualifying Guard behavior. |
| **backstab** | Genuine positional hit delivered from the target's rear according to authoritative gameplay facing. |
| **Vulnerable** | Crimson status that increases payoff from genuine backstabs; it does not fabricate rear position or alter facing. |
| **Rupture** | Technique-family buildup mark that culminates in direct Health damage plus strong hidden Poise/guard pressure. It is not shared enemy Posture. |
| **Seal** | Technique-family marks that build toward a temporary Bind. |
| **Rift** | Technique-family fracture that opens after a fuse for direct Health damage and can be intensified first. |
| **Echo** | Delayed additional sword slash produced by qualifying Technique effects. |

### Retired shared-combat terms

The following are not current universal gameplay systems:

- player Posture / Posture bar;
- enemy Posture bar as a standard-enemy resource;
- universal posture-break-to-kill loop;
- Deathblow / execution prompt as a shared finishing layer;
- universal parry/counter trigger assumed by every Blood Aspect.

Compatibility fields such as `posture_damage`, old telemetry labels, or legacy save keys may temporarily remain during migration. They are internal compatibility surfaces only and must not be presented as current player-facing mechanics.

## Blood Aspects and build systems

| Preferred term | Current meaning |
|---|---|
| **Blood Aspect** | Returning Blood specialization that defines Akio's run weapon kit. |
| **Wolf / Wraith / Ronin** | Current launch Blood Aspects. |
| **Tier 0 / Tier I-IV** | Fixed Aspect progression labels. |
| **Corruption** | Run-only Shrine pressure meter. |
| **Resist / Embrace** | Shrine choices that stabilize or advance the active Aspect Tier. |
| **Blood** | Aspect-owned run resource unlocked by the approved Tier progression. |
| **Technique** | Temporary run upgrade. Ownership is additive; there are no Technique inventory slots or global inventory cap. |
| **Action Technique** | Technique tied to an approved current shared combat trigger such as Basic, Held, or Dash/Dash Attack. It is not equipment in a slot. |
| **Supporting Technique** | Same-family Technique that deepens an already usable family mechanic. |
| **Cross-family Technique** | Hybrid Technique requiring investment in two families. |
| **Legendary Technique** | Rare family capstone requiring approved native-family investment. |
| **refinement** | One small improvement to a specific eligible Action Technique. |
| **Prosthetic** | One equipped tactical tool with persistent Forge progression. |
| **Relic** | Persistent collectible with one equipped slot and mastery progression. |

Current Technique launch baseline: **40 Techniques + 6 refinements** across Echo, Rupture, Seal, Rift, and Crimson.

## World / campaign

- **the Heart** — ancient living supernatural source of Beast Blood; exact origin remains deliberately ambiguous.
- **Beast Blood** — corrupting supernatural power obtained from the Heart.
- **Returning Blood** — Akio's inherited expression that reconstructs his established human form after death.
- **Heart Binding** — one of the ancient restraints around the Heart.
- **The Strand** — persistent shoreline hub.
- **Hushiro Gate Village / Yomori Grove / Kagutsuchi Court** — Areas 1, 2, and 3.

## Persistent resources

- **Mist** — broad persistent meta currency.
- **Scrolls** — persistent Forge-focused currency.
- **regional boss material** — boss-specific low-count permanent-upgrade material.
- **Gold** — run-only Shop currency.

There is no generic Boss Emblem currency.

## Presentation / production

- **isometric 2D presentation** — fixed high-angle Camera2D composition over authoritative planar 2D gameplay.
- **directional sprite** — one of the eight actor presentation directions `e,se,s,sw,w,nw,n,ne`.
- **rig-rendered 2D** — offline 3D model/rig/animation rendered into directional 2D frames. The source rig is not a runtime actor.
- **feet/contact anchor** — stable ground registration point used for actor placement and Y-depth ordering.

## Canon boundaries

Do not casually introduce environmental/airborne Beast Blood transmission, standard Order Beast Blood dosing, immunity for Akio, true Blood control for ordinary bearers, a resolved cosmic origin for the Heart, live 3D character runtime as current production direction, or retired Posture/Deathblow systems as current combat authority.
