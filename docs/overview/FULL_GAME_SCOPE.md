---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: draft
authority: primary
last_reviewed: 2026-08-06
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
| Technique loadout | 4 active + 1 reserve | Launch catalog size remains open; later development uses replacement, rarity, and one refinement per Technique |
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

Core combat includes parry, player and enemy posture, stagger, deathblow, block, dash, and Prosthetic support.

After Returning Blood awakens, launch scope includes:

- one selected Blood Aspect as the immediate Tier 0 run foundation,
- Wolf as a four-hit fast close-range pressure and pursuit kit,
- Wraith as a two-hit extended spectral reach and frontal-control kit approved through Tier III,
- Ronin as a three-hit slow heavy impact and stability kit,
- one physical katana expressed through Aspect-specific Blood forms,
- universal controls, locomotion, neutral dash, parry timing, enemy rules, and deathblow language,
- player-directed attacks without corrective tracking, hidden homing, or post-input target correction,
- optional fixed Aspect advancement from Tier 0 through Tier IV,
- Shrine decisions between Resist and Embrace, with Stabilize at Tier IV,
- route-level opportunity cost between Shrine, Technique, refinement, Relic, economy, survival, and other rewards,
- Blood as a run-only combat resource unavailable before Tier II,
- four empty active Technique slots and one empty reserve slot,
- continued Technique development after the slots are filled through replacement, rarity, one refinement per Technique, and reserve decisions,
- one equipped Prosthetic,
- and one run-scoped Relic slot.

The launch roster is approved. The game does not currently require a fourth mobility, evasion, projectile, or crowd-control Aspect; those combat needs remain supported by universal systems, Techniques, Prosthetics, and encounter design.

A fourth or fifth Aspect is outside current production scope. Reconsider expansion only after playable testing demonstrates a missing identity that cannot be covered by the approved roster and supporting systems.

## Optional investment outcomes

The selected Aspect always defines Akio's weapon identity, but a successful run does not need to maximize the Aspect Tier path.

Launch balance and content must support:

- Tier 0-I with an excellent coherent and refined Technique build,
- Tier II with a solid Technique build as a common hybrid outcome,
- Tier III with fewer or less-developed Technique upgrades as a deliberate Aspect-focused outcome,
- and occasional Tier IV high-roll runs.

Mandatory encounters must not assume a particular Aspect Tier or Blood Art. Choosing a Shrine route should have a meaningful opportunity cost because the player forgoes another previewed reward. Resist remains recovery and stabilization rather than an equal alternate long-term power route.

## Wolf package at current scope

Wolf's fixed Tier package is approved through the present cross-roster audit:

- **Tier I — Blood Tempo:** approved successful-contact routes may continue earlier into the Basic sequence.
- **Feral Momentum — Tier growth:** later Basic attacks reached through successful Blood Tempo continuations gain modest deterministic Health and enemy-posture payoff that increases with every Embrace.
- **Tier II — Blood Hunt:** a full Blood meter restores limited Health, releases a short disruptive Blood howl, launches Akio along one player-selected pursuit line through eligible ordinary enemies, and ends in Blood Fang against the stopping target or endpoint.
- **Tier III — Fanged Guard:** one selected frontal blockable hit may preserve Predator's Passage charge or one connected Raking Fang or Blood Cleave startup through normal player-posture rules.
- **Tier IV — Apex Mauling:** qualifying major impacts trigger one consolidated Blood-claw mauling with strong posture pressure, compact reduced-power secondary coverage, and a brief movement-only slow on the primary target.

Wolf remains player-directed and punishable. Blood Hunt cannot track, turn, retarget, or correct its line. Its preparation and ending recovery remain vulnerable, full incoming damage and posture still apply during pursuit, and overriding attacks interrupt normally. Fanged Guard is action-specific rather than general armor. Apex Mauling does not cancel recovery, recursively trigger, generate Blood, or alter enemy attack timing.

This package defines high-level gameplay, VFX, animation, HUD, Shrine, and trial dependencies without locking final values or counts. Final production counts still require implementation briefs and playtesting.

## Wraith package at current scope

Wraith's Tier 0-III package is approved, while Tier IV remains under ordered revision:

- **Tier 0:** Veil Cut is the precise low-commitment line, Passing Arc is the broader committed frontal sweep, Pale Lance is the longest focused punish, Ghostline Slash is controlled dash re-entry, and Veil Reversal is Wraith's strongest ordinary parry-to-posture conversion.
- **Tier I — Pale Barrage:** continuing Pale Lance produces rapid lower-impact spectral jabs while Akio remains stationary and committed to the selected direction.
- **Spectral Edge — Tier growth:** qualifying ordinary primary attacks that connect through spectral-only geometry gain modest enemy-posture and guard pressure that scales at each Embrace.
- **Tier II — Wraith's Reach:** a full Blood meter commits one compact broad frontal sweep, one very long narrow-to-medium fixed corridor strike, and one delayed spectral repetition along the exact same corridor.
- **Tier III — Spectral Passage:** Veil Cut, Passing Arc, Pale Lance's initial thrust, Ghostline Slash, and Veil Reversal continue through ordinary-enemy bodies across their remaining authored geometry. Additional ordinary targets receive reduced Health damage and meaningful posture and guard pressure.
- **Tier IV candidate — Pale Procession:** Pale Barrage may gain two reduced-power adjacent shade streams and limited player-directed steering within a frontal arc, with one stream per enemy per beat.

Wraith's Reach follows these production-level boundaries:

- the opening sweep supplies guaranteed activation value through modest Health damage, strong posture and guard pressure, and brief eligible ordinary-enemy stagger,
- the sweep is frontal rather than full-circle and provides no healing, posture clear, damage reduction, automatic defense, or interruption resistance,
- the corridor uses the fixed player-selected direction and cannot track, turn, home, retarget, or correct itself,
- Akio uses little or no forward pursuit,
- the delayed Wraith repeats the exact same corridor with lower Health damage and meaningful posture and guard pressure,
- enemies may leave before the echo or enter its geometry before it resolves,
- all stages generate no Blood and do not independently trigger Spectral Edge,
- the echo cannot recursively create another echo and receives restricted Technique, healing, and proc weighting,
- and ordinary vulnerability, interruption, commitment, and recovery remain active.

Spectral Passage follows these production-level boundaries:

- the spectral portion continues only across the attack's remaining authored line or arc,
- the attack gains no extra reach or width and cannot turn, track, home, retarget, bounce, or seek another enemy,
- the first or primary target receives the normal authored result,
- additional ordinary targets receive reduced Health damage and meaningful posture and guard pressure,
- each qualifying action may strike each enemy at most once,
- elites, bosses, protected heavy enemies, solid geometry, and authored blockers stop further passage,
- Pale Barrage's repeated jabs and Wraith's Reach do not receive unrestricted passage chains,
- and secondary passage contacts generate no Blood and use restricted Spectral Edge, Technique, healing, status, and proc weighting.

The former duration-wide reach increase, repeated afterimages on ordinary attacks, and Veiled Guard candidate are retired from fixed Wraith progression.

Pale Procession remains a provisional production reference rather than a final lock. The next audit must determine whether it provides sufficient breadth, short-exchange and mobile-boss value, and production efficiency without overconcentrating the capstone on Pale Lance and Pale Barrage.

## Ronin package at current scope

Ronin's current Tier package is approved through the present cross-roster audit:

- **Tier I — Steadfast Reprisal:** a qualifying block creates a short optional window for a slow standalone Reprisal Cut.
- **Tier II — Falling Mountain:** a full Blood meter clears meaningful accumulated player posture and powers a planted monumental slam, compact immediate impact burst, and delayed Deep Rupture at the original impact point.
- **Tier III — Unbroken Resolve:** selected late commitments may survive one costly eligible frontal hit, while disciplined clean attacks may create Measured Weight and one later Perfect Weight strike with improved posture, guard-recoil, and stagger payoff.
- **Tier IV — Shattering Wake:** qualifying direct heavy impacts transfer reduced Health damage and strong posture force through the primary target into enemies behind it.

Ronin remains slow, grounded, and directionally committed. Falling Mountain does not gain tracking, line correction, invulnerability, healing, or safe recovery. Unbroken Resolve keeps full incoming Health and posture damage and fails against posture break, lethal hits, perilous attacks, grabs, launches, side or rear pressure, and later hits. Shattering Wake cannot originate on a miss or multiply its damage back onto the primary target.

Wolf and Ronin have complete qualitative Tier I-IV packages approved through the present audit. Wraith is approved through Tier III and remains the active Tier IV revision target. All three still require a final cross-roster production lock after Wraith and the remaining growth-rule and minor-support questions are resolved.

Still open at production scope are:

- Wraith's Tier IV capstone around the approved Tier 0-III package,
- Ronin's small Tier-growth rule,
- minor supporting-benefit audit across narrow or conditional Tiers,
- Ronin follow-up audit against the final standards,
- final cross-roster power, accessibility, inherent-tradeoff, overlap, and production comparison,
- detailed Technique affinity and direct-exception rules,
- exact animation, VFX, audio, UI, trial, and progression packages,
- and the launch Technique, Prosthetic Technique, Relic, and consumable catalogs.

Exact frame data, hitboxes, combat values, resource values, Wraith's Reach preparation, sweep, corridor, echo, interruption and recovery, Spectral Passage stopping classifications and secondary weighting, Pale Procession lane geometry and steering, Blood Hunt movement and collision, Apex Mauling geometry and slow, Ronin timing windows, and cancel windows remain implementation and playtesting work.

Techniques remain the horizontal customization layer and an optional major run-investment route. Most Techniques are independently useful, use universal action tags, may receive at most one slotless refinement, and remain valuable after the loadout is full through refinement, replacement, rarity, reserve management, or specialization.

Run-only build state resets after death or successful Heart Binding completion. Destroyed Bindings, permanent unlocks, persistent currencies, discoveries, and story progress survive.

No separate duplicate Blood Art progression tree beneath each Aspect is currently part of scope.

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

Exact transition Health, posture, timing, and difficulty behavior remain later encounter work.

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

1. cross-roster Aspect package revision, currently Wraith Tier IV,
2. launch run-build content catalog,
3. persistent progression, onboarding, and trial package,
4. narrative delivery and authored-content package,
5. postgame release package.

Exact routing, room counts, combat tuning, encounter movesets, catalog effects, final scripts, and numerical values remain deferred to their owning design and implementation stages.
