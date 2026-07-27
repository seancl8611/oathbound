---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: draft
authority: primary
last_reviewed: 2026-07-26
topics:
  - full-scope
  - asset-counts
  - areas
  - strand
  - techniques
  - the-heart
  - heart-bindings
  - campaign-clears
  - true-final-heart
  - postgame
related:
  - ART-ASSET-INVENTORY
  - OVERVIEW-PRODUCTION-ROADMAP
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - META-OPEN-QUESTIONS
---

# Full Game Scope

This document defines Oathbound's current production-level shape. It does not lock exact balance values, route algorithms, frame data, final attack timings, or other implementation details that require prototyping and playtesting.

## Master scope

| Asset group | Planned count | Current boundary |
|---|---:|---|
| Player character | 1 | Akio concept, final sprite, introductory combat, and three Aspect combat libraries |
| Blood Aspects | 3 | Wolf, Wraith, and Ronin are the approved launch roster |
| Technique loadout | 4 active + 1 reserve | Launch catalog size remains open |
| Prosthetic tools | 8 | One equipped at a time in the initial run structure |
| Run-scoped Relic capacity | 1 | Launch catalog remains open |
| Strand NPCs | 6 | Keeper, Peddler, Smith, Raven, Undead Samurai, Scribe |
| Area 1 standard enemies | 6 | Hushiro rupture roster |
| Area 2 standard enemies | 4 | Yomori spirit and predator roster |
| Area 3 standard enemies | 5 | Kagutsuchi court roster |
| Miniboss encounters | 6 | Two designed encounters per area; run frequency is later routing work |
| Regional bosses | 3 | Keeper of the Gate, Twin Maws, Eclipse Shogun |
| Heart Binding campaign | 7 original / 6 player clears | One historical breach and six player-destroyed Bindings |
| True-final Heart | 1 encounter / 2 forms | Unbound Heart and Vessel of Continuance |
| Environment sets | 4 + Heart subset | Strand, Areas 1–3, Heart chamber states |
| Cross-area room functions | 6 | Combat, Shrine, rest, shop, treasure/miniboss, boss |
| Currency families | 4 | Mist, Scroll, Boss Emblem, Gold |
| Relic rarity tiers | 4 | Common, Uncommon, Rare, Legendary |

## Player and run build

Akio begins with a complete introductory katana kit: Quick Slash, Cross Cut, Heavy Cleave, Hold Thrust, Counter Cut, and Dash Slash.

Core combat includes parry, player and enemy posture, stagger, deathblow, block, dash, and prosthetic support.

After Returning Blood awakens, launch scope includes:

- one selected Blood Aspect as the immediate Tier 0 run foundation,
- Wolf as a four-hit fast close-range pressure and pursuit kit,
- Wraith as a two-hit extended spectral reach and control kit,
- Ronin as a three-hit slow heavy impact and stability kit,
- one physical katana expressed through Aspect-specific Blood forms,
- universal controls, locomotion, neutral dash, parry timing, enemy rules, and deathblow language,
- fixed Aspect advancement from Tier 0 through Tier IV,
- Shrine decisions between Resist and Embrace, with Stabilize at Tier IV,
- Blood as a run-only combat resource unavailable before Tier II,
- four empty active Technique slots and one empty reserve slot,
- one equipped prosthetic,
- and one run-scoped Relic slot.

The launch roster is approved. The game does not currently require a fourth mobility, evasion, projectile, or crowd-control Aspect; those combat needs remain supported by universal systems, Techniques, prosthetics, and encounter design.

A fourth or fifth Aspect is outside current production scope. Reconsider expansion only after playable testing demonstrates a missing identity that cannot be covered by the approved roster and supporting systems.

Still open at production scope are:

- each Aspect's fixed Tier I-IV benefits and evolving drawback family,
- Blood generation and activation rules,
- the Blood Art package for each Aspect,
- detailed Technique affinity and direct-exception rules,
- exact animation, VFX, audio, UI, trial, and progression packages,
- and the launch Technique, Prosthetic Technique, Relic, and consumable catalogs.

Exact frame data, hitboxes, combat values, resource values, and cancel windows remain implementation and playtesting work.

Techniques remain the horizontal customization layer. Most Techniques are independently useful, use universal action tags, and may receive at most one slotless refinement.

Run-only build state resets after death or successful Heart Binding completion. Destroyed Bindings, permanent unlocks, persistent currencies, discoveries, and story progress survive.

The removed Storm, Frost, Ember, Hex, and Shadow stance system is not part of the game.

## Run-duration target

A normal successful Binding run targets approximately 45–50 minutes of active time from Boat departure through the Binding return.

- Experienced repeat clears may take approximately 35–42 minutes.
- Slower successful clears may approach 60 minutes.
- Standard successful runs should not routinely exceed one hour.
- The seventh story run adds approximately 8–12 minutes for the two-form Heart, producing a typical 55–60-minute final run.

Exact room counts, route topology, branch frequency, miniboss frequency, and authored layout counts remain later prototype and playtest decisions unless testing demonstrates that they change production scope.

## The Strand

The Strand is the persistent preparation, progression, and return hub.

Primary NPCs:

- Keeper
- Peddler
- Smith
- Raven
- Undead Samurai
- Scribe

Primary services:

- Boat and run confirmation
- Forge Bench
- Merchant Stall
- Discovery Board
- Bloodwell
- Blood Cavern
- Blood Mirror

The service ownership boundaries are approved. The exact launch depth of permanent upgrades, onboarding, trials, unlocks, mastery content, and required interface states remains open.

## Area 1 — Hushiro Gate Village / Rupture

Standard enemies:

- Corrupted Swordsman
- Corrupted Archer
- Blighted Hounds
- Hollow
- Cellar Bilemass
- Warden

Minibosses:

- Village Ogre
- The Collector

Boss:

- Keeper of the Gate

Hushiro represents recent corruption, bodily collapse, fragmented community, violence, and desperate faith.

## Area 2 — Yomori Grove / Adaptation

Standard enemies:

- Lingering Wraith
- Lantern Wraith
- Mist Shepherd
- Stalker Hound

Minibosses:

- Embered Pilgrim
- Rotwood Host

Boss:

- Twin Maws: Rootfang and Briarthorn

Both twins begin active. The first defeated transfers part of the shared bond to the survivor, which remains recognizably itself while gaining limited traits from the fallen twin.

Yomori represents long-term predation, spirit persistence, and ecological damage caused by corrupted inhabitants and beasts. Beast Blood does not spread through soil, roots, water, prey, or vegetation.

Exact transition health, posture, timing, and difficulty behavior remain later encounter work.

## Area 3 — Kagutsuchi Court / False Ascendancy

Standard enemies:

- Court Guard
- Court Caster
- Elite Defender
- Hollow Vessel
- Court Sentinel

Minibosses:

- Blood Lotus
- Eternal Swordsman

Regional boss:

- Eclipse Shogun

Kagutsuchi is an immaculate royal court whose elites retain intelligence, hierarchy, and disciplined mutation while remaining unable to reject Beast Blood.

The Elite Defender is the pure shield-and-spear positional defender and does not use the one-time revival mechanic owned by the Court Guard and Court Caster.

The Eclipse Shogun is a regal, composed false master whose controlled inhuman escalation preserves intelligence and recognizable identity. His exact weapon, phase count, attacks, transformation anatomy, animation list, and VFX remain later encounter-design work.

## Heart Binding campaign

The Heart's prison originally contained seven ancient Bindings. The Court destroyed the outermost Binding during the plague, leaving six intact when Akio begins.

After each of the first six successful Shogun victories:

1. Akio enters the Heart chamber.
2. He offers Returning Blood through the Court-built extraction apparatus.
3. The Heart attempts to reclaim its power.
4. Akio's controlled Blood rejects that control.
5. One remaining Binding ruptures.
6. The Heart dissolves Akio's current body.
7. Returning Blood reconstructs him at the Strand.
8. Permanent rewards and Binding progress persist.

This is one reusable ritual. Clear-to-clear production is concentrated in removable Binding states, greater Heart exposure, stronger chamber-local reactions, concise narrative updates, and campaign-progress presentation.

Initial scope does not require new regional environment sets, enemy families, universal modifiers, or a different Shogun encounter after every clear.

## True-final Heart and ending

After the sixth remaining Binding is destroyed, the next successful full run becomes the seventh and final story run.

Akio defeats the Shogun's current body and continues directly into the Heart without ending the active run.

The Heart encounter has two conceptual forms:

1. **The Unbound Heart** — the exposed Heart tears free as a mobile beastlike organ with malformed support limbs.
2. **The Vessel of Continuance** — the Heart forms an enormous nonhuman defensive body around itself while remaining visibly central.

The Heart is not another swordsman encounter and does not require a separate weak-point or body-part targeting subsystem. Exact attacks, timings, posture behavior, arena rules, animation, and effects remain later encounter-design work.

The first Heart victory destroys the source of Beast Blood. The Shogun's reconstruction stops, corrupted inhabitants and beasts lose their unnatural sustain, Yomori's spirits pass on, the Blood Moon ends, and the barrier weakens safely.

Akio survives in his current human body but loses Returning Blood, Blood Aspect powers, supernatural regeneration, and future reconstruction. He becomes mortal.

## Narrative and postgame status

The core story, world rules, major relationships, Binding structure, ending, and postgame continuity are complete at the current scoping depth.

Remaining narrative scope concerns delivery: dialogue and codex volume, first-death and bloodline-reveal presentation, repeated Shogun and Heart-state updates, ending presentation, voice scope, portraits, cinematics, and in-engine ownership.

Completed saves remain playable. Normal runs and the Heart route may be repeated for challenge, but repeat Heart victories do not create new canonical endings or change the completed story.

The exact Heart-route access control, repeat-clear rewards, records, cosmetics, and required postgame UI remain open. Additional difficulty modifiers, enemy variants, room variants, and alternate challenge conditions are not required for initial release.

## Current unresolved production scope

The remaining production-level decisions are maintained only in [Current Design Questions](../_meta/OPEN_QUESTIONS.md):

1. fixed Aspect Tier packages and Blood Arts,
2. launch run-build content catalog,
3. persistent progression, onboarding, and trial package,
4. narrative delivery and authored-content package,
5. postgame release package.

Exact routing, room counts, combat tuning, encounter movesets, catalog effects, final scripts, and numerical values remain deferred to their owning design and implementation stages.
