---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-31
---

# Current Design Questions

This file contains only unresolved decisions that materially affect initial-release scope, content volume, production planning, interfaces, or authored presentation. Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here.

## Approved dependencies

The following decisions are settled and should not be reopened as top-level questions:

- The launch Blood Aspect roster is **Wolf, Wraith, and Ronin**.
- Current launch identity space is complete: Wolf owns pressure and pursuit, Wraith owns reach and control, and Ronin owns impact and stability.
- Mobility, evasion, ranged utility, and broader crowd-control options remain shared-system, Technique, and prosthetic territory rather than requiring a fourth Aspect.
- A fourth or fifth Aspect is outside current launch scope and requires later playable evidence of a genuinely missing identity.
- Each Aspect is a complete Tier 0 katana weapon kit using the shared combat language.
- Aspect Tier progression is fixed rather than a branching upgrade-package choice.
- Every run begins at Tier 0. At a full Corruption threshold, the player chooses **Resist** or **Embrace**; Embrace advances the selected Aspect by one fixed Tier, up to Tier IV.
- Tier IV is the maximum. A full threshold at Tier IV uses **Stabilize** rather than creating Tier V.
- Blood is run-only, unavailable before Tier II, stored between rooms until spent, and reset after the run.
- The working launch default uses one shared Blood meter, capacity, readiness, activation input, and HUD language. Blood is generally built through meaningful katana Health damage, enemy-posture pressure, successful Parry Counters, posture breaks, and deathblows rather than a flat equal reward per hit.
- Blood Arts normally require a full meter, activate manually, consume their cost, and do not generate Blood while a duration-based Art is active. These are defaults rather than absolute restrictions; a specific Aspect may depart from them only when its approved design clearly requires the exception.
- A Blood Art is not required to use one common form. It may be an immediate signature action, a temporary state, or another clearly defined combat expression.
- Techniques remain universal temporary run rewards with four active slots, one reserve slot, and at most one refinement per Technique.
- Aspects do not use corrective tracking, hidden homing, or post-input target correction.
- Wolf's Tier I-IV progression, Predatory Commitment drawback family, Blood direction, and Dire Hunt Blood Art are approved as a working draft for current scoping.
- Wraith's Tier I **Pale Barrage** is approved as a working draft: continuing to hold Pale Lance after its initial thrust performs rapid lower-impact spectral jabs, with greater combined payoff and commitment the longer the player continues.
- Wraith's Tier II Blood Art form and combat behavior are approved as a working draft: a full meter activates a fixed, steerable sequence of identical spinning spectral hits with no finishing slash; ordinary enemies are repeatedly interrupted without knockback, elites resist the forced interrupt, and Akio receives direct Health damage but cannot be interrupted by enemy attacks during the sequence.

Wolf's working progression is:

- **Tier I — Blood Tempo**, including alternate entries into Rending Cross and the Hunting Slash rear follow-up
- **Tier II — Dire Hunt**, including Blood Fang
- **Tier III — Fanged Guard**
- **Tier IV — Apex Feast**

Wraith's working progression is:

- **Tier I — Pale Barrage**
- **Tier II — spinning Blood Art**, final name unresolved

Wolf may be revised after Wraith and Ronin are developed or after playable testing, but it is no longer an unanswered blank package. Wraith Tier I-II may likewise be revised after the rest of the roster is drafted or after playable testing.

Authoritative references:

- `gameplay/BLOOD_ASPECTS.md`
- `gameplay/CORRUPTION_AND_SHRINES.md`
- `gameplay/PROGRESSION.md`
- `gameplay/TECHNIQUES.md`
- `gameplay/WOLF_ASPECT.md`
- `gameplay/WRAITH_ASPECT.md`
- `gameplay/RONIN_ASPECT.md`

## Priority order

1. Remaining Blood Aspect Tier packages and cross-roster comparison
2. Launch run-build content catalog
3. Persistent progression, onboarding, and trial package
4. Narrative delivery and authored-content package
5. Postgame release package

## 1. Remaining Blood Aspect Tier packages and cross-roster comparison

Define Wraith's fixed Tier III-IV package and Ronin's fixed Tier I-IV package within the approved Shrine structure.

Resolve:

- Wraith's headline benefit at Tiers III and IV,
- Ronin's headline benefit at Tiers I, II, III, and IV,
- whether each remaining Tier needs one minor supporting rule in addition to its headline benefit,
- one evolving drawback family for Wraith that incorporates Pale Barrage's focused commitment and the Tier II Art's direct Health exposure, and one evolving drawback family for Ronin,
- Wraith's final Blood Art name and any later Tier interactions with Pale Barrage or the Art,
- Ronin's Tier II Blood Art form, practical payoff, duration or resolution behavior, and any justified exception to the shared Blood defaults,
- how each remaining package deepens its Tier 0 weapon kit without replacing Techniques,
- whether limited direct Aspect-, Tier-, or Blood-referencing Techniques ship,
- and the required HUD, input, animation, VFX, audio, Shrine, trial, and progression states.

After both packages are drafted, compare Wolf, Wraith, and Ronin for:

- practical payoff and accessibility,
- power across ordinary encounters, elites, and bosses,
- drawback severity,
- production cost,
- visual distinction,
- overlap with universal Techniques,
- and whether each Tier is desirable to Embrace.

Do not reopen whether advancement is linear or choice-based. The player choice is Resist versus Embrace; the Aspect's Tier path itself is fixed.

## 2. Launch run-build content catalog

Define the minimum complete and replayable launch catalog:

- approximate base Technique count and role distribution,
- universal action-tag coverage,
- affinity and offer-weighting rules,
- the number of Techniques that support one refinement,
- the allowed number of direct Aspect-, Tier-, or Blood-referencing entries,
- temporary Prosthetic Technique count per tool,
- initial Relic count and rarity distribution,
- whether consumables ship,
- and entries requiring unique icons, VFX, animation, or audio.

The coverage matrix belongs in `gameplay/TECHNIQUE_CATALOG.md`.

## 3. Persistent progression, onboarding, and trial package

Define the minimum launch package across the Bloodwell, Forge, Blood Mirror, and Blood Cavern:

- permanent node, rank, or branch counts,
- basic-combat onboarding trials,
- Aspect teaching and mastery trials,
- Technique demonstrations or mastery trials,
- unlock ownership,
- capped reliability upgrades,
- rewards and mastery marks,
- and required interface states.

The service ownership boundaries and persistent currencies are already approved.

Do not assume a separate duplicate Blood Art upgrade tree beneath each Aspect. Any future Blood Art meta progression must be justified as part of a broader game-wide system.

## 4. Narrative delivery and authored-content package

Define the authored presentation required for launch:

- first-death and Returning Blood awakening presentation,
- bloodline confirmation timing and evidence,
- Shogun dialogue progression and reconstruction presentation,
- NPC, codex, results, and Heart-chamber updates,
- ending and credits requirements,
- voice scope,
- and cinematic, portrait, in-engine, or environmental delivery ownership.

The story spine, Binding campaign, true-final Heart, ending consequences, and postgame continuity are already approved.

## 5. Postgame release package

Define:

- repeat access to the Heart route,
- repeat-clear rewards,
- launch completion goals such as records, marks, or cosmetics,
- and required Boat, results, save-state, and postgame UI states.

Additional difficulty settings, challenge modifiers, enemy variants, and room variants remain outside initial release unless explicitly promoted later.

## Deferred implementation and balance work

Keep the following in their owning gameplay, encounter, economy, UI, or production files rather than this tracker:

- exact frame data, hitboxes, cancel windows, attack travel, damage, posture, stagger, and recovery values,
- exact neutral movement and dash values within the approved universal contract,
- exact Corruption gain, thresholds, Shrine frequency, and support values,
- exact Blood capacity, source weighting, gain values, activation cost, duration, cooldown, and anti-farming values within the approved shared defaults,
- Wraith Blood Art rotation count, exact duration, exact spin speed, exact movement speed, exact radius, collision behavior, enemy-response cadence, and numerical damage or posture values within the approved Tier II behavior,
- Spirit costs and prosthetic cooldowns,
- immunity tables and status values,
- room counts, route topology, branch frequency, and miniboss placement,
- enemy and boss movesets,
- reward probabilities, prices, rerolls, and anti-streak formulas,
- exact permanent-upgrade percentages,
- and final animation frames or VFX timing.