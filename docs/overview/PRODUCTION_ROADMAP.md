---
id: OVERVIEW-PRODUCTION-ROADMAP
title: Production Roadmap
category: overview
status: approved
authority: primary
last_reviewed: 2026-08-07
---

# Production Roadmap

Oathbound production is organized by dependency order and meaningful playtest groups. Top-level milestones do not need equal asset counts.

## Pre-milestone gate — Paid Style Test

Before Milestone 1, a separately paid Style Test locks practical sprite scale, palette, detail density, high-angle perspective, outline treatment, ground shadow, Hushiro tone, and Godot import quality.

## Milestone 1 — Combat vertical slice

Establish Akio, core combat readability, three representative Area 1 enemies, five shared combat VFX, Combat HUD, and the base Hushiro environment kit.

The Posture Break Cue remains grouped with the Corrupted Swordsman and Deathblow Cue so the posture-break-to-execution loop is reviewed together.

## Milestone 2 — Complete Area 1

Complete the remaining Area 1 roster, both minibosses, Keeper of the Gate, character-dependent VFX, Hushiro functional-room skins, regional props, Shrine/Corruption foundations, and boss/miniboss UI.

Exact room counts and routing remain prototype work unless they create additional asset requirements.

## Milestone 3 — The Strand

Produce the six recurring NPCs, Strand environment, physical interactibles, training spaces, revival presentation, and permanent-progression interfaces.

Final node counts, trials, unlock flows, mastery states, and permanent-progression depth depend on the persistent progression/onboarding package.

No duplicate Aspect-specific Blood Art progression tree is assumed.

## Milestone 4 — Player combat depth and run-build expression

Complete the approved Wolf, Wraith, and Ronin combat-presentation families; Tier/Blood states; eight Prosthetic families; Technique reward/build interfaces; Relic presentation; and broad currency/pickup/reward-object art.

### Locked Aspect production packages

| Aspect | Tier I | Tier II | Tier III | Tier IV | Repeated growth |
|---|---|---|---|---|---|
| Wolf | Blood Tempo | Blood Hunt | Fanged Guard | Apex Mauling | Feral Momentum |
| Wraith | Pale Barrage | Wraith's Reach | Spectral Passage | Beyond the Veil | Spectral Edge |
| Ronin | Steadfast Reprisal | Falling Mountain | Unbroken Resolve | Shattering Wake | Maximum player-posture capacity |

All three Tier 0-IV packages now support high-level production planning. Final frame counts, VFX counts, timings, collision, and reuse decisions still require implementation briefs and playable validation.

Wolf production needs include successful-contact continuation, Feral Momentum escalation, Blood Hunt activation/howl/pursuit/Blood Fang, Fanged Guard one-hit protection, Apex Mauling, and Blood resource states.

Wraith production needs include distinct Tier 0 geometry, Pale Barrage continuation, Spectral Edge contact feedback, Wraith's Reach sweep/corridor/echo, Spectral Passage formation penetration, Beyond the Veil range/deathblow/Veilstride states, and Blood resource states.

Ronin production needs include distinct Tier 0 heavy actions, strong guard/posture readability, Steadfast Reprisal opportunity/counter, Falling Mountain posture relief/slam/burst/Deep Rupture, Unbroken Resolve plus Measured/Perfect Weight, Shattering Wake, posture-capacity growth reflected through existing posture UI, and Blood resource states.

Ronin's repeated posture growth should reuse the normal player-posture HUD and capacity language rather than create a separate buff icon or VFX state.

Final unique Technique icons and bespoke Technique effects depend on the launch run-build catalog.

## Milestone 5 — Complete Area 2

Produce Yomori Grove, its enemy/encounter roster, regional hazards, functional rooms, VFX, and integration pass.

Exact routing and Twin Maws transition values remain implementation/playtest work.

## Milestone 6 — Area 3 and endgame

Produce Kagutsuchi Court, its roster, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Heart chamber, extraction apparatus, reusable Heart Binding ritual, six Binding states, fully exposed Heart, two-form true-final Heart encounter, ending presentation, and repeat-clear presentation.

The Shogun's high-level identity is approved. Exact attacks, phase structure, transformation anatomy, animation list, and bespoke VFX require later encounter approval.

The Binding package uses one reusable ritual after each of the first six successful clears. The seventh story run continues from the Shogun into the Heart without ending the active build.

## Milestone 7 — Release presentation and cohesion

Complete front-end UI, approved narrative delivery, achievements/store art, missing-asset audit, cross-game readability, and final production cleanup.

Final quotation depends on the authored-content inventory, voice/cinematic boundary, postgame access/rewards, and required release UI—not on reopening approved story canon.

## Production rules

- Character concepts and key poses precede specialized VFX.
- Base character art precedes Tier/Blood overlays.
- Wolf, Wraith, and Ronin are the fixed launch Aspect families.
- All Aspect attacks remain player-directed; presentation must not imply corrective tracking or homing.
- All three qualitative Tier 0-IV packages may guide high-level scope; final asset counts require implementation briefs.
- Reuse existing attack, deathblow, locomotion, and HUD families whenever a Tier modifies geometry or values rather than creating a new action.
- Ronin posture-capacity growth uses existing posture presentation rather than a new status family.
- Spectral Passage should primarily reuse existing attack geometry/trails with extended collision and impact handling.
- Beyond the Veil should reuse Pale Lance, Ghostline Slash, shared deathblow, and locomotion presentation.
- Pale Procession shade/steering/three-lane assets are excluded.
- Reusable Technique UI may precede final catalog lock; unique icons and bespoke effects require approved entries.
- The standard successful-run pacing target is 45–50 minutes, with exact room/encounter budgets deferred to playtesting.
- The base Heart Binding ritual is one reusable package.
- Additional Aspects, challenge modifiers, variants, and deferred route algorithms remain outside the initial quote unless explicitly promoted.
- Each milestone uses separately quoted, payable, reviewable internal batches.
- Markdown remains the internal source of truth; Word/PDF files are exports.

## Current pre-production dependency

Complete the final cross-roster Aspect comparison, then proceed to the launch run-build catalog and the remaining production-scope packages in `docs/_meta/OPEN_QUESTIONS.md`.