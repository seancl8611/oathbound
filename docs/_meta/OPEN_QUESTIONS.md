---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-05
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
- Blood Arts are not required to share one form. Immediate actions, temporary states, and other concise authored expressions are all valid when they fit the Aspect.
- Every Tier must be clearly net-positive while preserving the Aspect's inherent limitations through the upgraded action itself.
- A Tier may contain one headline benefit and at most one minor supporting rule.
- A supporting rule must reinforce the Aspect's own play pattern rather than become generic stat inflation or erase Technique space.
- Techniques remain universal temporary run rewards with four active slots, one reserve slot, and at most one refinement per Technique.

## Current working Aspect packages

Wolf and Ronin have complete qualitative Tier I-IV packages approved through the present audit.

Wraith's Tier 0 foundation and Tier I package are now approved. Wraith's Tier II Blood Art and later Tier distribution remain under ordered revision.

### Wolf

- **Tier I — Blood Tempo:** successful Wolf contact may continue earlier into the Basic sequence through approved optional routes.
- **Feral Momentum — Tier growth:** later connected Basic-sequence positions gain modest deterministic Health and posture payoff that scales at every Tier.
- **Tier II — Blood Hunt:** activation restores limited Health and disrupts nearby ordinary enemies before one long player-directed pursuit ends in Blood Fang.
- **Tier III — Fanged Guard:** one selected frontal blockable hit may preserve approved high-risk ordinary commitments through normal posture rules.
- **Tier IV — Apex Mauling:** qualifying major impacts create a consolidated Blood-claw follow-up with strong posture pressure and limited secondary coverage.

### Wraith

- **Tier 0:** Veil Cut remains a precise low-commitment line; Passing Arc remains a broader, slower, more committed frontal-control follow-up. Pale Lance is the longest focused punish, Ghostline Slash is controlled dash re-entry, and Veil Reversal is Wraith's strongest ordinary parry-to-posture conversion.
- **Tier I — Pale Barrage:** Pale Lance may continue into rapid stationary spectral jabs and may be released early to end the commitment.
- **Spectral Edge — Tier growth:** qualifying primary attacks that connect through spectral-only reach gain modest enemy-posture and guard pressure; the reward scales slightly at every Embrace.
- **Tier II candidate — Wraith's Reach:** temporary state with greater spectral reach and delayed attack afterimages.
- **Tier III candidate — Veiled Guard:** one manually timed spectral parry may preserve each Pale Lance or Pale Barrage use.
- **Tier IV candidate — Pale Procession:** Pale Barrage gains two non-stacking adjacent shade streams and limited player-directed steering.

### Ronin

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

The kit does not use an artificial close-range damage dead zone. Point-blank pressure remains a weakness because Wraith has deliberate frontal commitments, restrained attack movement, and fewer ordinary options.

Approved Tier I package:

- **Pale Barrage** remains the headline benefit.
- Continuing to hold after Pale Lance produces rapid lower-impact spectral jabs along the committed line.
- Akio remains stationary, the barrage may be released early, and the jabs do not track or retarget.
- **Spectral Edge** is the supporting Tier-growth rule.
- Qualifying primary attacks that connect through spectral-only geometry gain modest enemy-posture and guard pressure.
- The reward scales slightly with every Embrace from Tier I through Tier IV.
- It adds no Health damage, tracking, movement, reach, interruption resistance, or separate meter.
- Pale Barrage jabs and later secondary hits do not each receive unrestricted full-value Spectral Edge bonuses.

**Authority:** `gameplay/WRAITH_ASPECT.md`

## Question 4 — Wraith Blood Art form

Compare the current temporary-state **Wraith's Reach** against immediate-action or concise non-duration alternatives.

Resolve:

- Should Wraith's Blood Art remain a temporary reach-and-afterimage state?
- Does the Art need a guaranteed activation effect before any follow-up attack connects?
- Could a spectral formation, authored corridor, broad frontal sequence, delayed line field, or another immediate control action fit better?
- Should extended geometry and delayed afterimages remain together, be separated, or be removed?
- Which Tier 0 actions should the Art affect?
- How should Pale Barrage and Spectral Edge interact with the Art without multiplying repeated hits or posture pressure excessively?
- How does the Art reinforce reach and frontal control without solving point-blank, lateral, and simultaneous pressure?
- How does it remain distinct from Wolf's pursuit, Ronin's monumental slam and rupture, projectiles, tracking attacks, and autonomous companions?
- What practical value does activation provide if the player cannot land the ideal follow-up?
- What animation, VFX, audio, HUD, readability, and engineering burden does each candidate create?

**This is the current active question.**

## Question 5 — Wraith Tier distribution after the Blood Art

After Wraith's Blood Art is selected, reassess Tiers III and IV around it.

Resolve:

- Does too much of Wraith's progression still develop Pale Lance and Pale Barrage?
- Should Tier III or IV provide additional value to Veil Cut, Passing Arc, Ghostline Slash, or Veil Reversal?
- Is Veiled Guard sufficient as a complete Tier III?
- Is Pale Procession sufficiently broad and useful for Tier IV?
- What Tier IV value remains useful in short exchanges, against mobile bosses, and when a full stationary barrage is unsafe?
- Which later Tier interactions with Spectral Edge are meaningful without becoming repeated-hit multiplication?
- Does any Tier need one minor supporting benefit beyond Spectral Edge, or would that exceed the one-headline-plus-one-supporting-rule limit?

## Question 6 — Per-Tier growth rules

Current state:

- **Wolf is resolved:** Feral Momentum scales later connected Basic-sequence positions.
- **Wraith is resolved:** Spectral Edge scales posture and guard pressure from spectral-only primary contact.
- **Ronin remains unresolved:** modest maximum-Health growth is one candidate.

Resolve for Ronin:

- Should Ronin use one repeated growth track, selected Tier-specific supporting rules, or no persistent growth rule?
- Is maximum Health perceptible and enjoyable without making Ronin's guard and interruption-resistance tools generally optimal?
- Would posture stability, heavy-hit consistency, or another authored combat verb fit better?
- Should generic Health, damage, posture, or Blood-generation increases remain rare because Techniques and permanent progression also need meaningful space?

## Question 7 — Minor supporting benefits by Tier

Audit every Tier that contains only one narrow or highly conditional mechanic.

For each Tier, determine:

- whether the headline is understandable and useful to a beginner,
- whether it affects ordinary encounters and bosses,
- whether it needs one minor supporting rule,
- whether that rule improves the full kit or merely repeats the headline,
- whether the reward is visible through play rather than only through hidden percentages,
- and whether it overlaps an ordinary Technique.

Do not add filler benefits only to equalize feature counts.

## Question 8 — Ronin follow-up audit

Ronin does not currently require a new Blood Art concept, but it must be checked against the standards approved for Wolf and Wraith.

Resolve:

- Does Ronin receive a small Tier-growth structure?
- Is Tier III's Measured Weight and Perfect Weight state readable without excessive timer management?
- Is Shattering Wake appropriately comparable to revised Wolf and Wraith Tier IV benefits?
- Does Falling Mountain remain powerful without trivializing elite and boss posture systems?
- Does any Ronin Tier need simplification after the full roster is compared?

## Question 9 — Final cross-roster lock

After Questions 1-8 are resolved, compare the completed packages for:

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

- frame data, hitboxes, cancel windows, attack travel, damage, posture, stagger, and recovery,
- neutral movement and dash values,
- Corruption thresholds, Shrine frequency, route distribution, and support values,
- Blood capacity, gain weighting, activation cost, duration, and anti-farming rules,
- exact Wolf package values and collision rules,
- exact Wraith Tier 0 timings, geometry, Spectral Edge qualification and scaling, Pale Barrage behavior, and later-Tier interactions,
- exact Ronin package values and any later growth rule,
- enemy immunity and response tables,
- Spirit costs and Prosthetic cooldowns,
- room and encounter counts,
- reward probabilities, prices, rarity weights, and rerolls,
- exact permanent-upgrade percentages,
- and final animation frames, VFX density, audio timing, or HUD layout.