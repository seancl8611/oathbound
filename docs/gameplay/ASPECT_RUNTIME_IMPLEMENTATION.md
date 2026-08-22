---
id: GAMEPLAY-ASPECT-RUNTIME-IMPLEMENTATION
title: Blood Aspect Runtime Implementation
category: gameplay
status: implementation
authority: secondary
last_reviewed: 2026-08-21
topics:
  - blood-aspects
  - wolf
  - wraith
  - ronin
  - blood
  - implementation
  - playtest
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IMPLEMENTATION-BASELINES
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Blood Aspect Runtime Implementation

## Purpose

This file records the current Godot implementation boundary for the approved Blood Aspect authorities. It does not replace `BLOOD_ASPECTS.md`, the three Aspect files, or `ASPECT_IMPLEMENTATION_BASELINES.md` as design authority.

The runtime now treats Wolf, Wraith, and Ronin as actual weapon kits rather than passive modifiers over the imported generic three-hit sword sequence.

## Active runtime structure

- `Core/Aspects/AspectCatalog.gd` owns first-playtest attack profiles and numerical implementation baselines.
- `Core/Aspects/AspectRuntime.gd` owns selected Aspect, Tier, Blood, applied-contact accounting, Blood Arts, and Tier effect execution.
- `Core/Aspects/AspectRuntimeIntegrated.gd` owns cross-system timing/control hardening.
- `Player/OathboundAspectPlayer.gd` owns Aspect-specific player action routing and Tier mechanics.
- `Player/OathboundAspectPlayerRuntime.gd` adapts the imported controller where its fixed three-hit assumptions conflict with current Aspect rules.
- `Player/aspect_player.tscn` inherits the existing Player scene and replaces its root script with the current Aspect controller.
- `AspectBootstrap.gd` routes GameFlow's player factory to that inherited scene. The old `player.tscn` remains the compatibility base during migration.
- `Utility/AspectHurtBox.gd` transforms and measures direct contacts while preserving the shared HurtBox collision/event contract.
- `AspectTechniqueEffectsRuntime.gd` maps Aspect move IDs back to universal Basic / Held / Dash / Counter Technique triggers.

## Tier 0 kits implemented

### Wolf

- Fang Slash -> Rending Cross -> Raking Fang -> Blood Cleave is a real four-hit Basic sequence.
- Predator's Passage is the Held attack.
- Hunting Slash is the Dash Attack.
- Fang Reversal is the Parry Counter.
- Wolf uses the approved first-playtest damage, posture, guard-pressure, startup, recovery, reach, and movement baselines.

### Wraith

- Veil Cut -> Passing Arc is the complete two-hit Basic sequence.
- Pale Lance is the Held attack.
- Ghostline Slash is the Dash Attack.
- Veil Reversal is the Parry Counter.
- Reach-heavy attacks use narrow/broad hitbox scaling rather than tracking or homing.

### Ronin

- Severing Cut -> Crushing Cross -> Bloodfall is the complete three-hit Basic sequence.
- Stillness Draw is the Held attack.
- Breaching Slash is the Dash Attack.
- Answering Steel is the Parry Counter.
- Ronin starts at 120 maximum posture, receives 15% less posture from valid blocks, recovers posture at 18/sec after a 1.0 sec delay, and gains +10 maximum posture for each Tier I-IV Embrace.

## Tier implementation

### Wolf

- **Tier I — Blood Tempo:** connected approved continuations receive earlier recovery release; Feral Momentum applies deterministic later-sequence Health/Posture growth.
- **Tier II — Blood Hunt / Blood Fang:** full Blood activation heals 15, disrupts nearby ordinary enemies, commits to one player-selected approximately 320px pursuit line, passes through eligible ordinary bodies, and resolves Blood Fang at the stopping point/nearby target.
- **Tier III — Fanged Guard:** selected committed frontal attacks may absorb one normal blockable hit at normal posture cost without cancelling the attack.
- **Tier IV — Apex Mauling:** qualifying major direct contacts add the Blood-claw follow-up, posture pressure, compact nearby coverage, and temporary approximately 20% movement slow.

Blood Hunt ordinary light hits still apply full incoming effects without interrupting the launched pursuit. Posture break and overriding/unblockable categories interrupt it normally.

### Wraith

- **Tier I — Pale Barrage:** holding after Pale Lance can produce up to four lower-impact stationary spectral jabs along the committed line.
- **Tier I-IV — Spectral Edge:** eligible outer spectral contact gains +15 / +20 / +25 / +30% posture/guard pressure. Pale Lance and Ghostline eligibility begins at Tier IV.
- **Tier II — Wraith's Reach:** activation sweep, very long fixed corridor strike, and delayed weaker repetition are separated into their authored stages. The repetition samples enemies when it resolves rather than tracking earlier targets.
- **Tier III — Spectral Passage:** eligible spectral attacks can affect additional ordinary enemies across remaining geometry at 60% Health and 75% posture/guard value. Secondary passage contacts are deliberately prevented from receiving unrestricted ordinary Technique procs.
- **Tier IV — Beyond the Veil:** Pale Lance/Ghostline reach increases, those attacks gain Spectral Edge eligibility, deathblow search distance increases to the approved first-playtest range, and a successful Wraith deathblow grants two seconds of +20% movement-only Veilstride.

Clear-path validation for the extended Tier IV deathblow is still a playtest hardening item; no hidden tracking or post-input target correction is added.

### Ronin

- **Tier I — Steadfast Reprisal:** a valid block opens a short optional standalone Reprisal Cut window.
- **Repeated growth:** maximum player posture rises from 120 at Tier 0 to 160 at Tier IV; recovery speed and guard efficiency do not scale upward.
- **Tier II — Falling Mountain / Deep Rupture:** activation clears 35 player posture, commits to the heavy slam/impact, and creates a delayed fixed-position Deep Rupture after three seconds.
- **Tier III — Unbroken Resolve:** eligible selected late commitments may survive one normal frontal hit while still receiving full incoming damage/posture. Normal attacks outside that rule are now actually interruptible so Resolve has real gameplay meaning.
- **Tier III — Measured / Perfect Weight:** clean deliberate qualifying contact opens a four-second opportunity; the next qualifying heavy gets +35% posture/guard pressure and consumes the state on contact.
- **Tier IV — Shattering Wake:** qualifying direct heavy impacts send 50% Health and 80% posture force through the primary target into enemies behind it within the first-playtest corridor.

## Blood implementation

Blood follows the approved run-only contract:

- unavailable before Tier II,
- 0 / 100 on Tier II unlock,
- no passive decay,
- Ready at 100,
- full meter committed to 0 on manual Blood Art activation,
- no generation while the Art is resolving,
- generation resumes only after the Art finishes,
- reset on a new run/player instance while selected Aspect persists.

For direct eligible katana contact the runtime uses actual post-resolution values:

`(actual Health damage * 0.035 + actual posture/guard pressure * 0.015) * Aspect multiplier`

with Wolf 0.90, Wraith 1.00, and Ronin 1.10. Secondary targets contribute 35% and one originating action is capped at approximately 1.5x the primary contribution. Counter, posture-break, and Deathblow event gains are +2, +4, and +6 respectively.

Blood Art and secondary proc packages do not generate Blood.

## Technique boundary

Aspect attacks publish universal `action_trigger` metadata. The current Technique executor translates those tags rather than knowing Wolf/Wraith/Ronin move names.

- ordinary Aspect Basic/Held/Dash/Counter contacts remain eligible for their matching Techniques,
- Blood Arts do not trigger ordinary Action Techniques,
- Wraith Spectral Passage secondary contacts currently receive zero ordinary Technique proc rather than an unrestricted full proc; this is intentionally conservative until individual restricted interactions are authored/tested,
- Technique-created secondary damage remains outside Blood generation.

## Tier progression dependency

The approved natural progression remains:

**Full Corruption -> Shrine -> Resist or Embrace -> Embrace calls `AspectRuntime.advance_tier()` and empties Corruption.**

This Aspect package implements the receiving Tier contract but does not invent a second progression source. Until the Corruption/Shrine runtime package is connected, the Playtest Lab can set Tier directly for validation.

## Playtest controls

The debug Playtest Lab gains a dedicated **Aspects** tab with:

- Wolf / Wraith / Ronin selection,
- direct Tier 0-I-II-III-IV selection,
- Next Tier,
- Fill Blood,
- Clear Blood.

`Q` uses the existing `special` input and activates the selected Aspect's Blood Art when Blood is Ready.

A lightweight development HUD shows selected Aspect, Tier, Blood amount, and Blood state.

## Temporary presentation / compatibility boundary

The following are intentionally not claimed as final:

- final Aspect-specific animations and VFX,
- final Blood HUD art/placement,
- final pre-run Blood Aspect selection presentation in the Strand,
- final hitbox geometry polish,
- final Blood pacing values after long-run testing,
- clear-path hardening for Wraith's extended deathblow,
- retirement of the imported Player controller and old elemental compatibility systems.

The inherited base Player scene remains in use for locomotion, animation assets, shared defense plumbing, Prosthetics, and other systems not yet migrated. New Aspect behavior should be added only to the current Aspect layers, not to the obsolete generic weapon-kit assumptions.

## Validation target

A long Godot 4.7.2 pass should deliberately test all three Aspects at several Tiers, including:

1. exact Basic sequence lengths,
2. Held / Dash / Counter identity,
3. interruption and recovery behavior,
4. Ronin guard/Posture behavior,
5. Tier I mechanics,
6. Blood unlock/generation at Tier II,
7. all three Blood Arts,
8. Tier III commitment/pass-through rules,
9. Tier IV payoff/reach/wake behavior,
10. Technique interactions with every universal action trigger,
11. Wraith secondary-contact normalization,
12. player death/new-run Blood reset,
13. telemetry/runtime/parser errors.
