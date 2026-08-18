---
id: GAMEPLAY-FIRST-ATTEMPT
title: First Attempt
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - first-attempt
  - onboarding
  - returning-blood
  - run-structure
  - techniques
  - prosthetics
  - shrines
  - death
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROSTHETICS
  - GAMEPLAY-CORRUPTION-SHRINES
  - LORE-RETURNING-BLOOD
  - NARRATIVE-DELIVERY
---

# First Attempt

The first attempt is **not a scripted prologue route**. It is a real Oathbound run using the normal regional route, chamber structure, route generation, authored encounters, room functions, rewards, miniboss opportunities, bosses, and full three-region destination.

The design expectation is that a new player will usually die early because they have limited knowledge, no permanent progression, no Blood Aspect, and only the core starting kit. The game does not force that death at a predetermined room or enemy.

A highly skilled player may progress arbitrarily far on the first attempt, including defeating Keeper, Twin Maws, the Eclipse Shogun, and reaching the Heart. The game is not tuned to prevent this outcome merely to preserve onboarding.

# Start presentation

The player's first playable control should begin directly in the normal Hushiro route, at or immediately before Hushiro Chamber 1. Do not require a bespoke tutorial dungeon, fixed introductory encounter sequence, forced early boss loss, or long opening cutscene.

Any initial mission framing from the Order, Strand Keeper, Raven, environment, or UI should be brief and non-blocking. The player learns primarily by playing the same route they will later repeat.

# First-attempt loadout

Akio begins with:

- the **base katana core combat kit**,
- the normal five empty Technique-bearing combat actions,
- **Beast-Bane Whistle** as the single default equipped Prosthetic,
- normal Health, posture, Spirit, dash, block, parry, counter, deathblow, and other universal combat rules.

Akio does **not** begin with:

- a Blood Aspect,
- Aspect Tier progression,
- Corruption,
- Blood or a Blood Art,
- a Relic,
- permanent Bloodwell/Blood Mirror/Forge upgrades,
- or later campaign unlocks.

Beast-Bane Whistle is the working default starting Prosthetic because its short-radius interrupt / anti-beast stagger role is simple, broadly useful, and does not pre-select a later Aspect or Technique-family identity.

# Normal run interaction

The first attempt preserves the normal run loop wherever the required system is already meaningful.

## Techniques

Technique rewards are fully available. Direct Techniques modify the equivalent base-katana combat actions before Blood Aspects unlock, using the same universal Basic / Held / Dash / Parry-Counter / Deathblow action tags.

Hushiro Chamber 1 therefore keeps its normal guaranteed three-choice Direct Technique reward. Supporting, Cross-family, refinement, replacement, and Legendary eligibility continues to follow the normal Technique rules if the player somehow develops a qualifying first-attempt build.

All first-attempt Techniques remain run-only and are lost when the attempt ends.

## Rooms, routing, and economy

The player may use normal:

- previewed route choices,
- Combat rooms,
- Rest rooms,
- Shops and Gold,
- Treasure,
- miniboss routes,
- Technique rewards,
- Mist and Scroll rewards,
- recovery and temporary-capacity rewards where normally eligible.

Persistent rewards earned before the first death are saved under the normal persistence rules even though their spending interfaces may not yet be available.

Reward types that require a still-locked persistent system remain ineligible until that system unlocks; their normal unavailable-weight redistribution rules apply rather than creating special first-attempt substitutes.

## Shrines before Returning Blood

Shrines remain valid route rooms before Returning Blood awakens.

Because Akio has no active Returning Blood, Corruption, or selected Aspect on the first attempt:

- **Embrace is unavailable**,
- no Aspect Tier can be gained,
- no Corruption meter is shown,
- and the Shrine uses its approved below-full support behavior rather than an Aspect progression decision.

The current support prototype remains Health or Spirit recovery according to the normal Shrine support rules. This lets the room remain useful without pretending that Akio can evolve a Blood Aspect he does not yet possess.

# First death and awakening

The first death may occur in any legal combat situation on the route. It is not tied to a particular enemy, chamber, miniboss, or boss.

When Akio dies for the first time:

1. his current body is genuinely destroyed,
2. dormant inherited Beast Blood awakens as Returning Blood,
3. he reconstructs at the Strand,
4. the first return establishes the normal stable return pattern,
5. run-only first-attempt state is lost,
6. already-earned persistent rewards remain,
7. the normal repeated-run preparation/progression loop begins.

The first reconstruction is a narrative presentation beat, not a separate gameplay tutorial.

# Exceptional first-attempt full clear

A sufficiently skilled player is allowed to clear the entire normal regional route before dying.

If this happens:

- Keeper and Twin Maws resolve normally as bosses,
- the Eclipse Shogun may use a rare pre-awakening first-encounter dialogue state,
- defeating the Shogun opens the normal Heart approach,
- the player may physically reach the Heart chamber,
- but **no Heart Binding can be destroyed yet**, because the Binding-rejection ritual specifically requires awakened Returning Blood.

At the Heart, the dormant condition is finally forced into its awakening state when the Heart destroys Akio's current body. This becomes his first death and first Returning Blood reconstruction. No Binding is counted as destroyed, and the normal six-Binding campaign begins afterward.

This exceptional endpoint exists only to keep the full first attempt mechanically honest. The game does not insert an earlier forced loss or invisible difficulty wall to stop a mastery-level player.

# Onboarding principle

The first attempt follows the same philosophy as the rest of Oathbound:

- teach through the real game rather than a disposable tutorial route,
- allow player skill to exceed expected progression,
- do not fake an unwinnable encounter merely to trigger the roguelite loop,
- and let the first death feel personal because it happened where the player's actual skill carried them.

Exact first-attempt balance, expected death chamber distribution, tutorial prompts, and rare no-death telemetry remain implementation/playtest work.