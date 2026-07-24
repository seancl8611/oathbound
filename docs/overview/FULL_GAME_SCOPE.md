---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: draft
authority: primary
last_reviewed: 2026-07-23
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
  - META-OPEN-QUESTIONS
---

# Full Game Scope

This document defines the current production-level shape of Oathbound. It does not lock exact balance values, room counts, route algorithms, attack lists, frame counts, or other implementation details that require later design and playtesting.

## Master scope

| Asset group | Planned count | Current boundary |
|---|---:|---|
| Player character | 1 | Akio concept, final sprite, complete base combat library |
| Blood Aspects | 3 | Three launch positions; Wolf, Wraith, and Ronin are working candidates rather than approved identities |
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

Akio begins with a complete katana kit: Quick Slash, Cross Cut, Heavy Cleave, Hold Thrust, Counter Cut, and Dash Slash.

Core combat includes parry, posture, stagger, deathblow, block, dash, and prosthetic support.

The current launch-scoping direction includes:

- one selected Blood Aspect as an immediate Tier 0 run foundation,
- three Blood Aspect positions at launch,
- one physical katana expressed through Aspect-specific Blood combat forms,
- a shared defensive and execution framework across all Aspects,
- Corruption and Shrine decisions as a working structure,
- four empty active Technique slots,
- one empty reserve slot,
- one equipped prosthetic,
- and one initial run-scoped Relic slot.

The Aspect system's role and current launch count are approved at this scoping depth. The final identities, exact weapon forms, Tier structure, Blood model, and individual mechanics remain open. Wolf, Wraith, and Ronin are the current working candidates for the three roster positions.

A fourth or later Aspect is not included in current production scope. Reconsider expansion only after playable testing demonstrates a missing combat identity that cannot be covered by the three approved identities, Techniques, or prosthetics.

Techniques remain the working horizontal customization layer. Most Techniques should be independently useful, and each may receive at most one slotless refinement.

Run-only build state resets after death or successful Heart Binding completion. Destroyed Bindings, permanent unlocks, persistent currencies, discoveries, and story progress survive.

The removed Storm, Frost, Ember, Hex, and Shadow stance system is not part of the game.

## Run-duration target

A normal successful Binding run targets approximately 45–50 minutes of active run time from Boat departure through the Binding return.

- Experienced repeat clears may take approximately 35–42 minutes.
- Slower successful clears may approach 60 minutes.
- Standard successful runs should not routinely exceed one hour.
- The seventh story run adds approximately 8–12 minutes for the two-form Heart, producing a typical 55–60-minute final run.

Exact room counts, route topology, branch frequency, miniboss frequency, and authored layout counts remain later gameplay, environment-prototype, and playtest decisions. They are not current production-scope questions unless testing demonstrates that additional asset packages are required.

## The Strand

The Strand is the persistent preparation and progression hub.

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

The exact launch depth of permanent upgrades, onboarding, trials, unlocks, and mastery content remains a current production-scope decision. Aspect-specific services and trial counts depend on the approved three identities and shared system.

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

Exact transition health, posture, timing, and difficulty behavior remain later encounter implementation work.

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

Kagutsuchi remains an immaculate royal court whose elites retain intelligence, hierarchy, and disciplined mutation while remaining unable to reject Beast Blood.

The Elite Defender is the pure shield-and-spear positional defender and does not use the one-time revival mechanic owned by the Court Guard and Court Caster.

The Eclipse Shogun is a regal, composed, disciplined false master whose controlled inhuman escalation preserves intelligence and recognizable identity. His exact weapon, phase count, attacks, transformation anatomy, animation list, and VFX remain later encounter-design work.

## Heart Binding campaign

The Heart's prison originally contained seven ancient Heart Bindings. The Court destroyed the outermost Binding during the plague, leaving six intact when Akio begins the campaign.

After each of the first six successful Shogun victories:

1. Akio enters the Heart chamber.
2. He offers Returning Blood through the Court-built extraction apparatus.
3. The Heart attempts to reclaim its power.
4. Akio's controlled Blood rejects that control.
5. One remaining Heart Binding ruptures.
6. The Heart dissolves Akio's current body.
7. Returning Blood reconstructs him at the Strand.
8. Permanent rewards and Binding progress persist.

The sequence is one reusable ritual. Clear-to-clear production is concentrated in removable Binding states, greater Heart exposure, stronger room-local reactions, concise narrative updates, and campaign-progress presentation.

The base game does not require new regional environment sets, new enemy families, universal modifiers, or a different Shogun encounter after every successful clear.

## True-final Heart and ending

After the sixth remaining Binding is destroyed, the next successful full run becomes the seventh and final story run.

Akio defeats the Shogun's current body and continues directly into the Heart without ending the active run.

The Heart encounter has exactly two conceptual forms:

1. **The Unbound Heart** — the exposed Heart tears free and becomes a mobile beastlike organ with malformed support limbs.
2. **The Vessel of Continuance** — the Heart forms an enormous nonhuman defensive beast body around itself while remaining visibly central.

The Heart is not another swordsman encounter and does not require a separate weak-point or body-part targeting system. Exact attacks, timings, posture behavior, arena rules, animations, and effects remain later encounter-design work.

The first Heart victory destroys the source of Beast Blood. The Shogun's reconstruction stops, corrupted inhabitants and beasts lose their unnatural sustain, Yomori's spirits pass on, the Blood Moon ends, and the barrier weakens safely.

Akio survives in his current human body but loses Returning Blood, any Blood Aspect powers, supernatural regeneration, and future reconstruction. He becomes mortal.

## Narrative status

The core story, world rules, major character relationships, Heart Binding structure, ending, and postgame continuity are complete at the current scoping depth.

The remaining narrative decision concerns the authored delivery package: dialogue and codex volume, first-death and bloodline-reveal presentation, repeated Shogun and Heart-state updates, ending presentation, voice scope, portraits, cinematics, and in-engine delivery.

## Postgame

The completed save remains playable. Normal runs and the Heart route may be repeated for gameplay challenge, but repeat Heart victories do not create new canonical endings or change the completed story.

The exact Heart-route access control, repeat-clear rewards, records, and required postgame UI remain a current release-scope decision.

Additional difficulty modifiers, enemy variants, room variants, and alternate challenge conditions are not required for the initial release.

## Current unresolved production scope

The remaining production-level decisions are maintained only in [Current Design Questions](../_meta/OPEN_QUESTIONS.md), in dependency order:

1. three-Aspect identity roster,
2. shared Aspect structure and selected Aspect packages,
3. launch run-build content catalog,
4. persistent progression, onboarding, and trial package,
5. narrative delivery and authored-content package,
6. postgame release package.

Exact routing, room counts, miniboss frequency, combat tuning, encounter movesets, catalog effects, final scripts, and numerical values are deferred to their appropriate design and implementation stages rather than treated as missing full-game scope.
