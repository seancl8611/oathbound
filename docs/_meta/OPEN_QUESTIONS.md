---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-02
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
- Aspect Tier investment is optional even though the selected Aspect remains Akio's central weapon foundation.
- Every run begins at Tier 0. At a full Corruption threshold, the player chooses **Resist** or **Embrace**; Embrace advances the selected Aspect by one fixed Tier, up to Tier IV.
- Tier IV is the maximum. A full threshold at Tier IV uses **Stabilize** rather than creating Tier V.
- Choosing a Shrine route provides the main opportunity cost of Aspect advancement because it competes with Technique, refinement, Relic, economy, survival, and other previewed rewards.
- Resist is recovery and stabilization rather than an equal alternate long-term power path.
- Tier 0-I with a strong refined Technique build must remain capable of completing a run.
- Tier II with a solid Technique build is a common hybrid outcome; Tier III is deeper Aspect specialization; Tier IV is occasional rather than expected.
- Mandatory encounters must not assume a particular Tier or Blood Art.
- Aspect weaknesses and limits come from the weapon kit's normal cadence, reach, movement, commitment, direction, defense access, and recovery.
- Formal named drawback families and added Tier penalty attributes are not required.
- Every Tier must be clearly net-positive while preserving the Aspect's inherent tradeoffs through the upgraded action itself.
- Blood is run-only, unavailable before Tier II, stored between rooms until spent, and reset after the run.
- The working launch default uses one shared Blood meter, capacity, readiness, activation input, and HUD language. Blood is generally built through meaningful katana Health damage, enemy-posture pressure, successful Parry Counters, posture breaks, and deathblows rather than a flat equal reward per hit.
- Blood Arts normally require a full meter, activate manually, consume their cost, and do not generate Blood while a duration-based Art is active. These are defaults rather than absolute restrictions; a specific Aspect may depart from them only when its approved design clearly requires the exception.
- A Blood Art is not required to use one common form. It may be an immediate signature action, a temporary state, or another clearly defined combat expression.
- Duration-based Blood Arts should normally deepen the existing weapon kit and shared combat decisions rather than replace the entire kit with an autonomous or locked sequence.
- Techniques remain universal temporary run rewards with four active slots, one reserve slot, and at most one refinement per Technique.
- Filling four Technique slots does not complete the Technique route. Later rewards remain valuable through refinement, compatible replacement, rarity, reserve management, Prosthetic specialization, build correction, and pivoting.
- Technique rarity represents unusualness, transformation, specialization, complexity, and reward restriction rather than only larger numbers. The final rarity tiers remain catalog work.
- A refinement should be a meaningful improvement that deepens the original Technique rather than adding an unrelated second ability.
- After the active loadout is full, Technique offers should usually include a refinement, a compatible or higher-rarity replacement, and a wildcard category; the exact generator formula remains tuning and catalog work.
- Occasional early ideal Technique builds are allowed and may free the player to invest more heavily in the Aspect afterward. Ideal builds should remain difficult to obtain consistently before late game.
- Aspects do not use corrective tracking, hidden homing, or post-input target correction.
- Wolf's Tier I-IV progression, Blood direction, and Dire Hunt Blood Art are approved as a working draft for current scoping.
- Wolf's positional overcommitment is an inherent consequence of its pursuit actions rather than a formal drawback family.
- Wraith is slower and less versatile than Wolf, uses fewer ordinary attacks, has restrained attack movement, and depends more heavily on positioning and deliberate action selection.
- Wraith's Tier I **Pale Barrage** is approved as a working draft: continuing to hold Pale Lance after its initial thrust performs rapid lower-impact spectral jabs while Akio remains stationary and committed to the selected direction.
- Wraith's Tier II **Wraith's Reach** is approved as a working draft: a full meter begins a duration state that extends Veil Cut, Passing Arc, and Pale Lance and gives each qualifying attack one delayed spectral afterimage along its original player-directed geometry.
- During Wraith's Reach, Akio retains ordinary movement, dash, block, parry, attacks, deathblows, and Prosthetic access. The Art adds no healing, Blood refund, damage reduction, posture clearing, interruption resistance, automatic defense, or special parry reward.
- Pale Barrage's initial Pale Lance creates one delayed afterimage while its additional jabs gain the extended reach without each creating another full echo.
- Wraith's Reach afterimages do not track, home, rotate, independently select enemies, or generate Blood. Their damage, posture pressure, guard response, interruption, and Technique or healing interactions are separately weighted from the physical strike.
- Wraith's Tier III **Veiled Guard** is approved as a working draft: each Pale Lance use permits one manually timed spectral parry against an eligible incoming attack from any direction while charging Pale Lance or channeling Pale Barrage.
- Veiled Guard uses the ordinary parry input, timing, eligibility, enemy-posture pressure, deflection response, and posture-break rules. It does not turn Akio, cancel the charge, interrupt Pale Barrage, remove accumulated charge, change the attack direction, automatically release the attack, or trigger Veil Reversal.
- Entering Pale Barrage does not refresh Veiled Guard after it is spent. A mistimed parry provides no fallback block, damage reduction, interruption resistance, healing, Blood, easier timing, or other protection.
- Veiled Guard is the complete Tier III headline benefit. No additional passive is currently required.

Wolf's working progression is:

- **Tier I — Blood Tempo**, including alternate entries into Rending Cross and the Hunting Slash rear follow-up
- **Tier II — Dire Hunt**, including Blood Fang
- **Tier III — Fanged Guard**
- **Tier IV — Apex Feast**

Wraith's working progression is:

- **Tier I — Pale Barrage**
- **Tier II — Wraith's Reach**
- **Tier III — Veiled Guard**

Wolf may be revised after Wraith and Ronin are developed or after playable testing, but it is no longer an unanswered blank package. Wraith Tier I-III may likewise be revised after Tier IV, the rest of the roster, cross-roster comparison, or playable testing.

Authoritative references:

- `gameplay/BLOOD_ASPECTS.md`
- `gameplay/CORRUPTION_AND_SHRINES.md`
- `gameplay/PROGRESSION.md`
- `gameplay/TECHNIQUES.md`
- `gameplay/ITEMS_AND_REWARDS.md`
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

Continue one Tier at a time within the approved optional-investment structure.

Immediate order:

1. Define Wraith's Tier IV headline benefit.
2. Define Ronin Tier I.
3. Define Ronin Tier II and its Blood Art after Tier I is approved.
4. Define Ronin Tiers III and IV one at a time.
5. Compare the three complete working packages.

For each remaining Tier, resolve:

- the headline benefit,
- whether one minor supporting rule is necessary,
- which existing Aspect action or strength it deepens,
- how the benefit preserves the Aspect's inherent movement, speed, range, direction, commitment, recovery, and defensive-access limits,
- whether the Tier remains clearly desirable to Embrace,
- how it avoids duplicating ordinary Technique space,
- and the required HUD, input, animation, VFX, audio, Shrine, trial, and progression states.

For Wraith specifically, Tier IV may grant a strong final benefit because the kit gives up mobility, speed, and ordinary versatility. It should reward intelligent positioning and action selection without adding artificial penalties. Potential interaction space includes Pale Barrage, delayed afterimages, Veil Reversal, Wraith's Reach, and Veiled Guard, but Tier IV does not need to modify every part of the kit or add a separate passive if one focused headline is sufficient.

For Ronin, preserve slow startup, heavy commitment, minimal attack movement, and slow posture recovery while allowing large deliberate payoffs.

After both packages are drafted, compare Wolf, Wraith, and Ronin for:

- practical payoff and accessibility,
- power across ordinary encounters, elites, and bosses,
- inherent tradeoffs and player outplay,
- viability of Tier 0-I Technique-focused builds,
- viability of Tier II hybrid builds,
- value of Tier III-IV Aspect specialization,
- production cost,
- visual distinction,
- overlap with universal Techniques,
- and whether every Tier is a clearly worthwhile Embrace.

Do not reopen whether advancement is linear or choice-based. The player choice is Resist versus Embrace; the Aspect's Tier path itself is fixed.

## 2. Launch run-build content catalog

Define the minimum complete and replayable launch catalog:

- approximate base Technique count and role distribution,
- universal action-tag coverage,
- final Technique rarity tiers and role of each tier,
- affinity and offer-weighting rules,
- the number of Techniques that support one refinement,
- final refinement quality standard,
- post-fill offer construction and anti-dead-offer rules,
- the allowed number of direct Aspect-, Tier-, or Blood-referencing entries,
- temporary Prosthetic Technique count per tool,
- initial Relic count and rarity distribution,
- whether consumables ship,
- and entries requiring unique icons, VFX, animation, or audio.

The catalog must demonstrate that four filled active slots still leave meaningful late-run Technique decisions through refinement, replacement, rarity, reserve management, and specialization.

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
- exact Corruption gain, thresholds, Shrine frequency, route distribution, and support values,
- exact Blood capacity, source weighting, gain values, activation cost, duration, cooldown, and anti-farming values within the approved shared defaults,
- Wraith's Reach duration, activation timing, extended attack ranges, Passing Arc width, echo delay, echo damage, echo posture pressure, ordinary-enemy interruption, guard response, hit-stop, and Technique or healing proc weighting within the approved Tier II behavior,
- Veiled Guard concurrent Held Attack and parry input handling, input buffering, eligible-attack edge cases, spectral manifestation direction and timing, availability and spent-state feedback, and final VFX or audio presentation within the approved Tier III behavior,
- Spirit costs and prosthetic cooldowns,
- immunity tables and status values,
- room counts, route topology, branch frequency, and miniboss placement,
- enemy and boss movesets,
- reward probabilities, prices, rarity weights, refinement frequency, rerolls, and anti-streak formulas,
- exact permanent-upgrade percentages,
- and final animation frames or VFX timing.
