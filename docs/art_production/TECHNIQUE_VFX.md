---
id: ART-TECHNIQUE-VFX
title: Technique VFX
category: art-production
status: approved
authority: primary
last_reviewed: 2026-08-20
topics:
  - techniques
  - vfx
  - combat-readability
  - refinements
  - effect-families
  - vulnerable
  - backstabs
related:
  - GAMEPLAY-TECHNIQUES
  - ART-CORE-VFX
  - ART-ASPECT-VFX
  - ART-ITEM-REWARD-ART
  - ART-MILESTONE-04
---

# Technique VFX

Techniques reshape existing sword actions through repeatable family effects. Their VFX should make run growth readable while preserving sword arcs, enemy tells, posture state, and Akio's final position.

## Production role

Technique presentation has two layers:

- **selection and build communication:** action-trigger identity where relevant, rarity/refinement state, Supporting-Technique relationships, and family symbol / color treatment,
- **combat feedback:** readable effects that show Echoes, Rupture, Seal marks, Rift development, Vulnerable state, backstab payoff, altered footprints, or other approved family behavior.

The former elemental stance families remain removed from scope. Prosthetic effects remain in their own visual system.

## Reuse hierarchy

Before commissioning a new Technique effect, prefer:

1. approved base sword trail, parry, posture, deathblow, or movement cue,
2. selected Blood Aspect VFX language where compatible,
3. established Returning Blood / Order / wound / ritual language,
4. small modular family overlays, markers, meters, pulses, trails, seals, fractures, wounds, arcs, or Echoes,
5. bespoke effects only when the mechanic cannot read correctly through reuse.

## Current family visual needs

### Echo

Echoes should read as delayed additional sword slashes, not as Akio literally replaying the full action. The system must support single and multiple delayed Echoes, original authored attack lines, and later supporting variations without obscuring the initial hit.

### Rupture

Rupture needs a visible buildup cue, clear full-meter trigger, strong posture-impact feedback, compact nearby posture shockwave, and immediate reset. Partial buildup must not look like ticking damage.

### Seal

Seal must visibly progress from one mark, to two connected marks, to a completed three-mark pattern during Bind, then clearly break or fade when Bind ends. One, two, and three Seals must remain distinguishable without color alone.

### Rift

Rift must read as one supernatural fracture becoming increasingly unstable, not as a projectile or exposed stack counter. The same mark should appear, spread or branch as intensity rises, pulse as opening approaches when appropriate, then open and disappear.

### Crimson — Vulnerable and direct Health damage

Crimson no longer uses Burst-ready targets or per-target recharge.

The family should communicate opened defense, severe Health damage, and positional backstab payoff.

- **Vulnerable:** compact crimson wound, split-mark, or exposed-guard symbol for the short status duration.
- The mark must not imply slow, root, stun, forced facing, or altered awareness.
- A genuine backstab against a Vulnerable enemy receives a strong brief crimson hit accent.
- **Deep Cut:** concentrated rear-hit treatment without another persistent status marker.
- **Blood Arc:** wide but bounded sword-shaped crimson arc, distinct from Rupture's posture shockwave.
- **Predator's Wake:** clear Vulnerable application feedback to nearby survivors after the Deathblow read is complete.

A later Crimson Legendary may introduce a brief **Unseen** state with its own clear player-state treatment.

## Action-trigger treatment

The five action labels are trigger classifications, **not Technique slots**. Multiple owned Techniques may respond to the same action and their VFX must therefore layer cleanly.

- **Basic Attack:** frequent effects stay visually light.
- **Held Attack:** may support heavier fixed geometry, impact, Rift application, or concentrated payoff.
- **Dash / Dash Attack:** effects stay tied to the actual dash path or contact and must not imply hidden movement or automatic rear positioning.
- **Parry / Counter:** feedback occurs after or around the successful defensive read and never widens the apparent parry window.
- **Deathblow:** Technique effects resolve after the execution read remains clear.

## Later-layer Techniques

The 25 Action-Technique matrix is approved. Supporting, Cross-family, Legendary, and refinement presentation may now be designed.

Supporting effects should normally modify existing family cues. Legendary effects may justify more dramatic presentation when genuinely run-shaping, but enemy telegraphs and core combat reads remain higher priority.

## Refinement treatment

A refinement should look like a small improvement to the same Technique, not a second ability.

## Readability constraints

- Technique feedback cannot hide enemy telegraphs, safe zones, projectiles, posture state, or Akio's final position.
- Multiple Technique effects must layer cleanly, including multiple Techniques triggered by the same combat action.
- Seal marks must remain readable on moving enemies.
- Rift marks must not be mistaken for Echo slashes.
- Vulnerable must not obscure enemy facing because the player still has to genuinely reach the target's back.
- Crimson AoE must remain bounded and sword-shaped enough to stay distinct from Rupture's posture shockwave.
- Exact timing, footprint, trigger, and value remain owned by gameplay and implementation documentation.

## Delivery planning

The approved 25 Action Techniques may now receive high-level unique icon/VFX planning. Do not lock the **final total** Technique icon or bespoke-effect count until the Supporting, Cross-family, Legendary, and refinement layers are production-audited.

Every production-ready Technique must specify its action trigger or Supporting/Cross/Legendary role, trigger condition, target / footprint, existing VFX reuse, added family cue, Aspect interaction, and mixed-build readability risk. Nothing in the art specification should imply exclusive Technique slots or a global Technique inventory cap.
