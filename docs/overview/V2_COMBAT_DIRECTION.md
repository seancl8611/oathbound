---
id: OVERVIEW-V2-COMBAT-DIRECTION
title: Oathbound V2 Combat Direction
category: overview
status: approved
authority: primary
last_reviewed: 2026-09-10
topics:
  - v2
  - combat-direction
  - player-movement
  - enemy-pressure
  - stagger
  - bosses
  - blood-aspects
  - hunter-fantasy
related:
  - OVERVIEW-GAME
  - OVERVIEW-DESIGN-PILLARS
  - GAMEPLAY-COMBAT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
---

# Oathbound V2 Combat Direction

This document is the approved high-level transition authority for Oathbound's **Combat V2** redesign. It records the direction being locked from current playtest findings before exact implementation values, move-by-move cancel rules, enemy statistics, or Aspect capability assignments are finalized.

The existing gameplay authorities and current Godot runtime remain the operative V1 implementation contract until a specific V2 package is designed, implemented, validated, and reconciled into its owning authority. When deciding what Combat V2 should become, this document owns the transition direction.

# V2 identity

Oathbound remains a Japanese supernatural dark-fantasy action roguelite. The Japanese setting, characters, architecture, weapons, folklore, Blood Moon, Beast Blood, spirits, corrupted warriors, and samurai-derived visual language remain part of the game's identity.

The player fantasy shifts away from **formal samurai dueling as the dominant combat experience** and toward **Akio as an aggressive supernatural hunter**.

Akio may still be a skilled swordsman and may still encounter disciplined samurai, warriors, and martial bosses. However, the normal combat loop should feel like a hunter moving through corrupted warriors, spirits, monsters, and beasts rather than a sequence of miniature Sekiro-style duels.

The target combat fantasy is:

> **Move aggressively, attack into openings, stagger and interrupt vulnerable enemies, reposition through danger, switch targets fluidly, use defensive mechanics when they are valuable, and keep momentum through a room.**

Parry, posture, block, deathblow, and disciplined swordplay remain available design ingredients. They are no longer required to carry the entire combat identity.

# Reference direction

Combat V2 should borrow principles rather than copy systems from its references:

- **Hades / Hades II:** free-flow player locomotion, fast target switching, readable multi-enemy encounters, individually simple enemies that become interesting in combination, and boss phases that change the spatial problem.
- **Curse of the Dead Gods:** physical commitment, deliberate attack geometry, strong hit reaction, readable danger, and multiple valid defensive responses.
- **Sekiro:** selective posture, parry, counter, execution, and elite-duel ideas where they add value rather than defining every encounter.
- **Oathbound:** Blood Aspects, Returning Blood, Beast Blood horror, Techniques, Prosthetics, Corruption, posture, deathblows, positional attacks, and the Japanese supernatural setting remain the game's own foundation.

The goal is not "Hades with a katana" or "top-down Sekiro." The goal is an Oathbound-specific hunter combat language that uses the strengths of a high-angle action roguelite.

# Locked V2 combat direction

## 1. Player movement becomes free-flow and continuously expressive

Akio should feel responsive while moving through combat. Neutral locomotion must no longer feel like a separate mode that repeatedly shuts off when attacks or defensive actions begin.

Combat V2 should support a layered motion model in which locomotion, authored action displacement, steering, and external impulses can contribute to final movement according to the current action.

Different attacks may intentionally preserve different amounts of movement and steering. A fast Wolf strike may retain substantial motion; a committed Ronin heavy may plant Akio much more firmly. The important rule is that movement restriction belongs to the authored action, not to one global `ATTACKING` state that makes most attacks stationary.

Dashes should work as aggressive repositioning as well as defense. Target changes, attack continuation, and legal defensive reactions should feel immediate and intentional rather than robotic or state-bound.

## 2. Normal combat shifts from duel chains to room pressure

Standard rooms should generally contain **more active enemies that are individually easier to damage, stagger, interrupt, and kill** than the current duel-oriented baseline.

The game should not create difficulty by making every standard enemy behave like a miniature boss with long Health/posture exchanges.

Normal combat should create difficulty through:

- target prioritization,
- movement and positioning,
- overlapping enemy intentions,
- attack geometry,
- ranged or spatial pressure,
- enemy combinations,
- and maintaining offensive momentum safely.

The player should often be able to kill or neutralize a weak enemy quickly and immediately redirect toward the next threat.

## 3. Enemy tiers become clearer

Combat V2 should distinguish encounter roles more strongly.

### Fodder / light enemies

- Low durability.
- Low stagger resistance.
- Usually one very clear combat job.
- Frequently interruptible by clean offense.
- Exist to create movement, target switching, Blood/build interactions, and room rhythm.

### Standard enemies

- Moderate durability.
- One or two recognizable mechanics or attack patterns.
- Still responsive to player offense and should not feel like miniature duel bosses.
- Can become dangerous when combined with other roles.

### Heavy / elite enemies

- Higher stagger resistance and more meaningful commitments.
- May block, parry, resist interruption, use perilous actions, or demand more deliberate posture play.
- Preserve more of Oathbound's original martial-duel DNA.

### Bosses

- Bespoke scripted encounters with richer pattern sets, arena interaction, transformation, phase changes, and deliberate punish windows.
- May use posture/parry as meaningful layers without reducing the entire encounter to repeated deflection tests.

This hierarchy lets a disciplined samurai or elite swordsman feel special because not every ordinary enemy behaves like one.

## 4. Stagger and interruption become central offensive feedback

Normal enemies should visibly and mechanically react to Akio's attacks.

A clean sword hit against an interruptible enemy should often produce an immediate response: recoil, stagger, attack cancellation, displacement, or another authored reaction. This should make offense feel physical and should reward taking initiative.

Combat V2 should formalize a stagger/interrupt relationship rather than treating it as an enemy-specific exception.

Potential implementation concepts include:

- stagger resistance,
- stagger power,
- interruptible versus committed attack windows,
- protected heavy/elite states,
- and explicit boss resistance rules.

Exact meters, thresholds, values, and UI are not locked here.

## 5. Parry becomes a high-value aggressive option, not the default answer to combat

Parrying remains part of Oathbound, especially for posture pressure, counters, elite enemies, and bosses.

The desired emotional role changes from:

> wait for the enemy's turn -> parry -> repeat

into:

> maintain pressure -> recognize a dangerous committed attack -> parry at the right moment -> gain a strong offensive advantage -> continue the attack flow

Standard enemy attacks should support multiple valid responses where context permits: attack interruption, spacing, dash, block, parry, or another Aspect-specific answer.

The game should not require the player to stop attacking and enter a parry rhythm against every enemy in order to play correctly.

## 6. Blocking is a fallback or kit-specific tool rather than the preferred default posture

Sustained blocking can remain useful, but Combat V2 should generally favor active movement, attack interruption, dashing, repositioning, and well-timed counters over standing still behind guard.

Blocking may remain particularly valuable to specific Aspect identities, Techniques, enemies, or situations.

Exact universal-versus-Aspect ownership is deliberately open and is recorded below.

## 7. Enemy AI should feel purposeful, responsive, and consistent

Enemies should be predictable in the good sense: a player who understands an enemy should understand what its actions mean. They should not be predictable because the encounter director gives one enemy a turn while everyone else waits.

Combat V2 should favor:

- authored enemy roles,
- consistent attack scripts,
- deliberate decision intervals,
- tactical movement goals,
- clear commitment points,
- readable recovery,
- and stable response rules.

Randomness should modify decisions rather than substitute for them. Enemy behavior should not rely on high-frequency frame-by-frame random checks that produce accidental pacing.

## 8. Crowd pressure should overlap intentions without stacking unfair impacts

The existing single-turn melee model is too duel-oriented for the new direction.

Combat V2 should move toward a **pressure / threat / impact scheduler**:

- several enemies may approach, flank, aim, wind up, or reposition simultaneously,
- a primary enemy may create the immediate attack threat,
- a secondary enemy may begin a readable future threat,
- ranged or spatial pressure may remain active,
- but high-severity damaging impact windows should be scheduled to avoid unreadable dogpiles.

The player should read the room rather than wait for the next enemy token.

More enemies should mean more spatial decisions, not unavoidable simultaneous hitboxes.

## 9. Beast and spirit enemies should behave like their fantasy

The Japanese theme stays, but not every enemy should move with disciplined human martial pacing.

Beasts, corrupted animals, spirits, and heavily transformed enemies should be freer to:

- rush,
- circle,
- pounce,
- retreat,
- snap or swipe quickly,
- reposition unpredictably within authored rules,
- use unusual attack geometry,
- and react strongly when struck.

Disciplined samurai and elite human enemies become a contrast to this faster, more predatory combat population.

## 10. Bosses move toward action-roguelite phase design

Bosses should remain mechanically richer than standard enemies, but their pacing should move away from Soulslike endurance duels as the default model.

Boss phases should increasingly change **what the player is solving**, not merely increase attack speed or damage.

Useful phase-transition tools include:

- new attack families,
- transformation or mutation,
- arena geometry or hazard changes,
- new movement rules,
- summons/adds when they serve the encounter,
- changed ranges,
- new safe zones or pressure zones,
- changed stagger/posture rules,
- and different punish windows.

A phase transition should be a memorable authored state change. Bosses should remain readable and scriptable enough that the player can learn them without requiring strict Soulslike memorization or constant parry execution.

# Aspect-dependent player mechanics — OPEN V2 DESIGN QUESTION

Combat V2 should **not hard-code the assumption that every Blood Aspect must expose every player mechanic in exactly the same way**.

The current V1 authority gives all launch Aspects universal access to sustained block and parry. That remains the operative rule until specifically revised.

For V2, we want to explore whether some core mechanics should instead be part of an Aspect's identity. Examples to investigate later include:

- one Aspect retaining strong sustained block while another has little or no traditional block,
- one Aspect specializing in parry/counter while another relies more heavily on mobility, interruption, or evasion,
- different defensive actions replacing a shared action where the control layout remains coherent,
- Aspect-specific cancel permissions or defensive transitions,
- and different stagger/poise relationships tied to the kit.

No specific Aspect loses block, parry, dash, or another mechanic through this document alone.

The implementation architecture should, however, avoid assuming that universal block/parry availability can never change. Capability ownership should be data-driven or otherwise cleanly configurable so this decision can be made after the shared V2 movement/action foundation is playable.

# Systems intentionally preserved

Combat V2 is a redesign of feel, pacing, actor control, enemy pressure, and encounter philosophy. It is not permission to discard Oathbound's broader game architecture.

Preserve unless a later explicit design pass changes them:

- Akio and the Japanese supernatural setting,
- Beast Blood and Returning Blood,
- Blood Aspects,
- Techniques,
- Prosthetics,
- Relics,
- Corruption and Shrine progression,
- Health,
- player and enemy posture,
- dash,
- parry and block as available design mechanics,
- deathblows,
- rear-hit/backstab classification,
- Blood generation and Blood Arts,
- run structure and authored regional encounter pools,
- current campaign structure,
- combat telemetry and existing public combat metadata/contracts where they remain useful.

Individual mechanics may later be redistributed between Aspects, but that requires an explicit owning-authority change.

# First V2 implementation priorities

The preferred implementation sequence is dependency-driven rather than a whole-game rewrite.

1. **Player Motor V2** — free-flow vector locomotion, action movement contribution, steering/commitment rules, dash integration, and telemetry.
2. **Combat Action / Intent foundation** — reusable authored actions, input intent buffering/arbitration, phase-aware movement/cancel permissions, and compatibility with existing public combat events.
3. **Reference enemy migration** — rebuild one standard enemy, preferably the Corrupted Swordsman, around shared Enemy Motor + deliberate tactical intent + formal stagger/interrupt rules.
4. **Pressure Director V2** — replace whole-attack single-turn ownership with threat/impact scheduling suitable for higher enemy counts.
5. **Encounter retuning** — raise standard encounter population where readable, reduce ordinary enemy durability, and retune stagger/resistance around the new room-pressure model.
6. **Boss V2 pass** — redesign boss movement, scripts, phase transitions, and spatial pressure around the action-roguelite philosophy after the shared combat engine is stable.
7. **Aspect capability pass** — decide whether block, parry, defensive transitions, stagger behavior, or other mechanics should differ fundamentally by equipped Aspect.

Each phase should be validated in the Playtest Lab and through CombatTelemetry before broad migration.

# Migration rule

Do not implement Combat V2 by globally increasing enemy counts, shortening parry windows, lowering enemy Health, or changing damage numbers on top of the current actor/control architecture.

The first problem to solve is the **movement/action/AI foundation**. Numerical encounter changes should follow once actors move, commit, stagger, interrupt, and coordinate correctly.

Similarly, do not remove current defensive mechanics from any Aspect before the Aspect capability pass explicitly defines the replacement behavior and updates the owning gameplay authorities.

# Success criteria

Combat V2 is succeeding when normal play increasingly feels like:

> **Akio enters a room as a supernatural hunter, moves continuously through several readable threats, kills weaker enemies quickly, staggers or interrupts vulnerable actions, changes targets without fighting the controls, uses parry/block/dash according to the situation and equipped kit, and faces bosses whose phase changes create new movement and attack problems rather than longer versions of the same duel.**

That is the first major V2 direction to preserve as implementation proceeds.
