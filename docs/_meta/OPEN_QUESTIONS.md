---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-06
---

# Current Design Questions

This file contains unresolved decisions that materially affect initial-release scope, content volume, production planning, interfaces, or authored presentation. Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here.

## Approved dependencies

The following decisions are settled and should not be reopened as top-level questions:

- The launch Blood Aspect roster is **Wolf, Wraith, and Ronin**.
- Wolf owns fast close-range pressure and pursuit.
- Wraith owns extended spectral reach and frontal control.
- Ronin owns slow heavy impact and defensive stability.
- A fourth or fifth Aspect is outside current launch scope.
- Each Aspect begins as a complete and viable Tier 0 katana weapon kit.
- Wolf, Wraith, and Ronin share the same controller layout, neutral movement and dash, Defense input, ordinary parry timing and success rules, posture-break language, deathblows, Techniques, Prosthetics, and interface language.
- Aspect identity comes primarily from authored attacks: cadence, reach, geometry, movement, damage, posture pressure, stagger, commitment, and recovery.
- Aspects do not use corrective tracking, hidden homing, or post-input target correction.
- Aspect progression is one fixed optional Tier path rather than a branching package selection.
- Every run begins at Tier 0. Embrace advances the selected Aspect up to Tier IV; Resist provides recovery and stabilization instead of an equal alternate power tree.
- Tier 0-I with a strong Technique build must remain capable of completing a run.
- Tier II with a solid Technique build is a common hybrid outcome; Tier III is deeper Aspect investment; Tier IV is occasional rather than expected.
- Mandatory encounters must not assume a particular Aspect Tier or Blood Art.
- Blood is run-only, unavailable before Tier II, stored between rooms until spent, and reset after the run.
- Blood Arts normally require a full meter, activate manually, consume the stored Blood, and must provide practical value without requiring perfect follow-up play.
- Every Tier must be clearly net-positive while preserving the Aspect's inherent limitations through the upgraded action itself.
- A Tier may contain one headline benefit and at most one minor supporting rule.
- A supporting rule must reinforce the Aspect's own play pattern rather than become generic stat inflation or erase Technique space.
- Techniques remain universal temporary run rewards with four active slots, one reserve slot, and at most one refinement per Technique.

## Current working Aspect packages

Wolf and Wraith have complete qualitative Tier 0-IV packages approved through the present audit.

Ronin's current Tier I-IV package remains approved, but its Tier 0 weapon foundation is the next ordered review before its growth rule and final roster comparison.

### Wolf

- **Tier I — Blood Tempo:** successful Wolf contact may continue earlier into the Basic sequence through approved optional routes.
- **Feral Momentum — Tier growth:** later connected Basic-sequence positions gain modest deterministic Health and posture payoff that scales at every Tier.
- **Tier II — Blood Hunt:** activation restores limited Health and disrupts nearby ordinary enemies before one long player-directed pursuit ends in Blood Fang.
- **Tier III — Fanged Guard:** one selected frontal blockable hit may preserve approved high-risk ordinary commitments through normal posture rules.
- **Tier IV — Apex Mauling:** qualifying major impacts create a consolidated Blood-claw follow-up with strong posture pressure and limited secondary coverage.

### Wraith

- **Tier 0:** Veil Cut is a precise low-commitment line; Passing Arc is a broader, slower, more committed frontal-control follow-up. Pale Lance is the longest focused punish, Ghostline Slash is controlled dash re-entry, and Veil Reversal is Wraith's strongest ordinary parry-to-posture conversion.
- **Tier I — Pale Barrage:** Pale Lance may continue into rapid stationary spectral jabs and may be released early to end the commitment.
- **Spectral Edge — Tier growth:** qualifying spectral-only primary contact gains modest enemy-posture and guard pressure and scales slightly at every Embrace. Veil Cut, Passing Arc, and Veil Reversal qualify from Tier I; Pale Lance's initial thrust and Ghostline Slash unlock qualification at Tier IV.
- **Tier II — Wraith's Reach:** a full meter commits a compact broad frontal sweep, one very long fixed corridor strike, and one delayed spectral repetition along the same corridor.
- **Tier III — Spectral Passage:** qualifying ordinary spectral attacks continue through ordinary-enemy bodies across their remaining authored geometry, dealing reduced Health damage and meaningful posture and guard pressure to additional ordinary targets.
- **Tier IV — Beyond the Veil:** Pale Lance and Ghostline Slash gain increased spectral reach, unlock their Spectral Edge eligibility, and valid deathblows may begin from greater clear-path frontal distance. A deathblow kill grants brief movement-only Veilstride.

### Ronin

- **Tier 0:** Severing Cut → Crushing Cross → Bloodfall, Stillness Draw, Breaching Slash, Answering Steel, strongest guard profile, and slow player-posture recovery.
- **Tier I — Steadfast Reprisal:** a qualifying block may create an optional Reprisal Cut.
- **Tier II — Falling Mountain:** activation clears meaningful accumulated posture and powers a planted monumental slam, immediate impact burst, and delayed Deep Rupture.
- **Tier III — Unbroken Resolve:** selected commitments may survive one costly eligible hit, while disciplined clean attacks may create Measured Weight and Perfect Weight.
- **Tier IV — Shattering Wake:** qualifying direct heavy impacts transfer reduced Health damage and strong posture force through the primary target into enemies behind it.

Authoritative references:

- `gameplay/BLOOD_ASPECTS.md`
- `gameplay/ASPECT_IDENTITY_GUIDELINES.md`
- `gameplay/ASPECT_WEAPON_KIT_MODEL.md`
- `gameplay/COMBAT.md`
- `gameplay/WOLF_ASPECT.md`
- `gameplay/WRAITH_ASPECT.md`
- `gameplay/RONIN_ASPECT.md`
- `gameplay/TECHNIQUES.md`

## Priority order

1. Cross-roster Aspect package revision
2. Launch run-build content catalog
3. Persistent progression, onboarding, and trial package
4. Narrative delivery and authored-content package
5. Postgame release package

# 1. Cross-roster Aspect package revision

Resolve the following questions **one at a time in the listed order**.

## Resolved Question 1 — Wolf Blood Art form

Wolf Tier II is **Blood Hunt**, an immediate authored pursuit Art rather than the former Dire Hunt temporary transformation.

The approved package includes limited guaranteed activation value, one player-selected pursuit line, Blood Fang as the endpoint, strict stopping and interruption rules, and severe consequences for a poor route.

**Authority:** `gameplay/WOLF_ASPECT.md`

## Resolved Question 2 — Wolf Tier distribution

Wolf's approved progression is Blood Tempo with Feral Momentum, Blood Hunt, Fanged Guard, and Apex Mauling.

The removed rear-hit, generic travel, temporary-transformation, and deathblow-only Apex Feast concepts are not part of fixed Wolf progression.

**Authority:** `gameplay/WOLF_ASPECT.md`

## Resolved Question 3 — Wraith Tier 0 and Tier I

Wraith retains a two-hit Basic Attack sequence.

Approved Tier 0 roles:

- **Veil Cut:** precise, low-commitment line attack for short openings.
- **Passing Arc:** broader, slower, more committed frontal-control follow-up with stronger posture and guard pressure.
- **Pale Lance:** longest narrow focused punish with meaningful preparation and severe miss recovery.
- **Ghostline Slash:** controlled dash re-entry with quick defensive return.
- **Veil Reversal:** extended parry counter with Wraith's strongest ordinary parry-to-posture conversion.

Approved Tier I package:

- **Pale Barrage** remains the headline benefit.
- Continuing to hold after Pale Lance produces rapid lower-impact spectral jabs along the committed line.
- Akio remains stationary, the barrage may be released early, and the jabs do not track or retarget.
- **Spectral Edge** is the supporting Tier-growth rule.
- Veil Cut, Passing Arc, and Veil Reversal qualify from Tier I when contact occurs through spectral-only geometry.
- Pale Lance and Ghostline Slash do not qualify until Tier IV.
- The reward scales slightly with every Embrace from Tier I through Tier IV.
- It adds no Health damage, tracking, movement, reach, interruption resistance, or separate meter.
- Pale Barrage jabs and later secondary hits do not each receive unrestricted full-value Spectral Edge bonuses.

**Authority:** `gameplay/WRAITH_ASPECT.md`

## Resolved Question 4 — Wraith Blood Art form

Wraith Tier II is **Wraith's Reach**, replacing the former temporary reach-and-afterimage state with one immediate authored frontal action.

Approved package:

- a full Blood meter activates manually and is consumed when the Art commits,
- the player selects one direction during a short readable preparation,
- a compact broad frontal opening sweep supplies guaranteed activation value,
- Akio then performs one very long narrow-to-medium corridor strike along the fixed selected direction,
- a delayed spectral Wraith repeats the exact same corridor geometry,
- enemies may leave before the echo or enter the corridor before it resolves,
- the Art's stages generate no Blood and do not independently trigger Spectral Edge,
- the echo cannot recursively create another echo and receives restricted Technique, healing, and proc weighting,
- ordinary vulnerability, interruption, commitment, and recovery remain active,
- and a poor selected line may miss the priority target or leave Akio exposed outside the chosen front.

The former duration-wide reach increase and repeated afterimages on ordinary attacks are retired from fixed Wraith progression.

**Authority:** `gameplay/WRAITH_ASPECT.md`

## Resolved Question 5 — Wraith Tier III

Wraith Tier III is **Spectral Passage**, replacing the former Veiled Guard candidate.

Approved package:

- the spectral portion of Veil Cut, Passing Arc, Pale Lance's initial thrust, Ghostline Slash, and Veil Reversal is no longer occluded by the first ordinary enemy it contacts,
- the attack continues through the remaining authored line or arc and may strike additional ordinary enemies layered within that geometry,
- the first or primary target receives the normal authored result,
- additional ordinary targets receive reduced Health damage and meaningful enemy-posture and guard pressure,
- each qualifying action may strike each enemy at most once,
- elites, bosses, protected heavy enemies, solid geometry, and other authored stopping bodies end further passage after valid contact,
- Pale Barrage's repeated jabs do not each receive unrestricted full passage behavior,
- Wraith's Reach remains self-contained,
- secondary passage contacts generate no Blood and use restricted Spectral Edge, Technique, healing, status, and proc weighting,
- and the Tier adds no new input, state, meter, reach, width, movement, tracking, correction, defense, or same-enemy damage multiplication.

**Authority:** `gameplay/WRAITH_ASPECT.md`

## Resolved Question 6 — Wraith Tier IV capstone

Wraith Tier IV is **Beyond the Veil**. The former Pale Procession candidate is retired.

Approved package:

- Pale Lance gains increased maximum spectral reach while retaining its narrow fixed line, preparation, interruption behavior, and severe miss recovery,
- Pale Barrage may use the approved Tier IV maximum line, but its repeated jabs do not independently receive full Spectral Edge triggers,
- Ghostline Slash gains increased spectral attack reach without changing the universal neutral dash,
- Pale Lance's initial thrust and Ghostline Slash become Spectral Edge-eligible at Tier IV,
- valid deathblows may be initiated from greater distance when the target is already deathblow-ready and a clear frontal path exists,
- the extended approach is one straight authored spectral movement rather than a teleport, tracking pursuit, or general traversal action,
- blockers, hazards, intervening enemies, and invalid encounter conditions prevent the extended initiation,
- a deathblow kill grants brief non-stacking movement-only **Veilstride**,
- Veilstride does not alter attack speed, dash distance, dash invulnerability, recovery, or attack-bound movement,
- Tier IV advances Spectral Edge by its normal fourth step,
- and the package preserves point-blank pressure, lateral collapse, fixed direction, interruption, and miss punishment.

Pale Procession is retired because Spectral Passage already provides ordinary group value through formation depth, while Pale Procession repeated the same problem category through width and overconcentrated progression on Pale Barrage.

**Authority:** `gameplay/WRAITH_ASPECT.md`

## Question 7 — Ronin Tier 0 weapon foundation

Review Ronin's current Tier 0 before changing its growth rule or later Tiers.

Resolve:

- Does **Severing Cut → Crushing Cross → Bloodfall** create a satisfying three-step progression from accessible heavy contact into major commitment?
- Are the three Basic attacks sufficiently distinct in startup, reach, geometry, movement, Health damage, posture damage, stagger, guard pressure, and recovery?
- Is Severing Cut practical during short openings, or does Ronin become inaccessible before later progression?
- Does Crushing Cross provide a meaningful middle commitment rather than feeling like filler between the opener and Bloodfall?
- Is Bloodfall powerful enough to justify its startup and recovery without becoming the only Basic attack that matters?
- Does **Stillness Draw** have a clear Held Attack role distinct from Bloodfall and Falling Mountain?
- Does **Breaching Slash** provide appropriate dash re-entry while preserving Ronin's low mobility?
- Does **Answering Steel** provide a satisfying parry-counter identity without making ordinary defense the dominant way to play?
- Is Ronin's strongest guard profile with slow player-posture recovery perceptible, fair, and distinct from later Unbroken Resolve?
- How does Tier 0 perform against ordinary groups, mobile elites, bosses, short openings, ranged pressure, and missed commitments?
- Does Tier 0 preserve clear roster separation from Wolf's pursuit and Wraith's extended frontal control?
- Are the required animations, impact responses, VFX, audio, and teaching burden justified and readable?

**This is the current active question.**

## Question 8 — Ronin per-Tier growth rule

Current state:

- **Wolf is resolved:** Feral Momentum scales later connected Basic-sequence positions.
- **Wraith is resolved:** Spectral Edge scales posture and guard pressure from qualifying spectral-only primary contact.
- **Ronin remains unresolved:** modest maximum-Health growth is one candidate.

Resolve after the Tier 0 audit:

- Should Ronin use one repeated growth track, selected Tier-specific supporting rules, or no persistent growth rule?
- Is maximum Health perceptible and enjoyable without making Ronin's guard and interruption-resistance tools generally optimal?
- Would posture stability, heavy-hit consistency, or another authored combat verb fit better?
- Should generic Health, damage, posture, or Blood-generation increases remain rare because Techniques and permanent progression also need meaningful space?

## Question 9 — Minor supporting benefits by Tier

Audit every Tier that contains only one narrow or highly conditional mechanic.

For each Tier, determine:

- whether the headline is understandable and useful to a beginner,
- whether it affects ordinary encounters and bosses,
- whether it needs one minor supporting rule,
- whether that rule improves the full kit or merely repeats the headline,
- whether the reward is visible through play rather than only through hidden percentages,
- and whether it overlaps an ordinary Technique.

Do not add filler benefits only to equalize feature counts.

## Question 10 — Ronin follow-up audit

After the Tier 0 and growth-rule reviews, recheck Ronin against the standards approved for Wolf and Wraith.

Resolve:

- Does Tier III's Measured Weight and Perfect Weight state remain readable without excessive timer management?
- Is Shattering Wake appropriately comparable to Apex Mauling and Beyond the Veil?
- Does Falling Mountain remain powerful without trivializing elite and boss posture systems?
- Does any Ronin Tier need simplification after the full package is compared?
- Does the final Tier distribution address Ronin's own commitment and recovery weaknesses without erasing them?

## Question 11 — Final cross-roster lock

After Questions 1-10 are resolved, compare the completed packages for:

- immediate feel at Tier 0,
- practical payoff and accessibility at every Embrace,
- ordinary encounters, mixed groups, elites, bosses, and bosses without adds,
- beginner-visible value and expert mastery value,
- Tier 0-I Technique-focused viability,
- Tier II hybrid viability,
- Tier III-IV Aspect-focused value,
- inherent weaknesses and player outplay,
- Blood Art activation value and form diversity,
- movement, range, damage, posture, stagger, sustain, defense, and recovery overlap,
- Technique and permanent-progression space,
- animation, VFX, audio, UI, teaching, and engineering cost,
- and whether every Tier is worthwhile but nonmandatory.

Only after this audit should the three Aspect packages be treated as ready for production planning.

# 2. Launch run-build content catalog

Define the minimum complete and replayable launch catalog:

- approximate base Technique count and role distribution,
- universal action-tag coverage,
- final Technique rarity tiers and role of each tier,
- affinity and offer-weighting rules,
- number of Techniques supporting one refinement,
- final refinement quality standard,
- post-fill offer construction and anti-dead-offer rules,
- allowed direct Aspect-, Tier-, or Blood-referencing entries,
- temporary Prosthetic Technique count per tool,
- initial Relic count and rarity distribution,
- whether consumables ship,
- and entries requiring unique icons, VFX, animation, or audio.

The coverage matrix belongs in `gameplay/TECHNIQUE_CATALOG.md`.

# 3. Persistent progression, onboarding, and trial package

Define the minimum launch package across the Bloodwell, Forge, Blood Mirror, and Blood Cavern:

- permanent node, rank, or branch counts,
- basic-combat onboarding trials,
- Aspect teaching and mastery trials,
- Technique demonstrations or mastery trials,
- unlock ownership,
- capped reliability upgrades,
- rewards and mastery marks,
- and required interface states.

Do not assume a separate duplicate Blood Art upgrade tree beneath every Aspect.

# 4. Narrative delivery and authored-content package

Define the authored presentation required for launch:

- first-death and Returning Blood awakening presentation,
- bloodline confirmation timing and evidence,
- Shogun dialogue progression and reconstruction presentation,
- NPC, codex, results, and Heart-chamber updates,
- ending and credits requirements,
- voice scope,
- and cinematic, portrait, in-engine, or environmental delivery ownership.

# 5. Postgame release package

Define:

- repeat access to the Heart route,
- repeat-clear rewards,
- launch completion goals such as records, marks, or cosmetics,
- and required Boat, results, save-state, and postgame UI states.

Additional difficulty settings, challenge modifiers, enemy variants, and room variants remain outside initial release unless explicitly promoted later.

## Deferred implementation and balance work

Keep exact values and frame-level decisions in their owning files, including:

- damage, posture, guard pressure, stagger, reach, movement, recovery, and interruption timing,
- hitboxes, collision, targeting, deathblow pathing, and blocker classifications,
- Blood capacity, gain values, proc weighting, and anti-farming rules,
- Spectral Edge scaling, Tier IV reach increases, extended deathblow range and angle, and Veilstride duration,
- room counts, route probabilities, reward probabilities, prices, rarity weights, and rerolls,
- exact permanent-upgrade percentages,
- and final animation frames, VFX density, audio timing, or HUD layout.
