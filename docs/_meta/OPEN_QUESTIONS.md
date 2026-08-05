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
- Blood Arts are not required to share one form. An immediate action, temporary state, or another clearly authored expression may be used when it best fits the Aspect.
- Every Tier must be clearly net-positive while preserving the Aspect's inherent limitations through the upgraded action itself.
- A Tier may contain one headline benefit and at most one minor supporting rule. A small supporting reward may improve accessibility and immediate feel, but it must not turn Tier progression into generic stat inflation or erase Technique space.
- Techniques remain universal temporary run rewards with four active slots, one reserve slot, and at most one refinement per Technique.

## Current working Aspect packages

All three Aspects now have complete qualitative Tier I-IV working packages. These packages are strong foundations but are explicitly open to revision during the current cross-roster audit.

### Wolf

- **Tier I — Blood Tempo:** successful contact improves offensive flow, alternate entries, and selected pursuit follow-ups.
- **Tier II — Dire Hunt:** temporary Blood transformation with activation recovery, increased offense, sustain, interruption resistance, and Blood Fang.
- **Tier III — Fanged Guard:** one frontal blockable attack may be blocked while charging Predator's Passage or Blood Fang.
- **Tier IV — Apex Feast:** deathblows create an eruption, restore Health, and fully charge the next Held Attack.

### Wraith

- **Tier I — Pale Barrage:** Pale Lance may continue into rapid stationary spectral jabs.
- **Tier II — Wraith's Reach:** temporary state with greater spectral reach and delayed attack afterimages.
- **Tier III — Veiled Guard:** one manually timed spectral parry may preserve each Pale Lance or Pale Barrage use.
- **Tier IV — Pale Procession:** Pale Barrage gains two non-stacking adjacent shade streams and limited player-directed steering.

### Ronin

- **Tier I — Steadfast Reprisal:** a qualifying block may create an optional Reprisal Cut.
- **Tier II — Falling Mountain:** activation clears meaningful accumulated posture and powers a planted monumental slam, immediate impact burst, and delayed Deep Rupture.
- **Tier III — Unbroken Resolve:** selected commitments may survive one costly eligible hit, while disciplined clean attacks may create Measured Weight and Perfect Weight.
- **Tier IV — Shattering Wake:** qualifying direct heavy impacts transfer reduced Health damage and strong posture force through the primary target into enemies behind it.

Ronin is currently closest to the desired progression standard because its later Tiers affect several parts of the ordinary kit, remain useful during bosses, and provide both expert and accessible value. This is a comparison reference, not a decision that Ronin can no longer be adjusted.

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

Resolve the following questions **one at a time in the listed order**. Do not redesign later Tiers around a Blood Art until that Aspect's Blood Art form is selected.

## Question 1 — Wolf Blood Art form

Compare the current temporary-state **Dire Hunt** against serious immediate-action or other non-duration alternatives.

Resolve:

- Should Wolf's Blood Art remain a temporary transformation, become one explosive pursuit action, or use another concise form?
- What immediate practical value occurs at activation even if the primary follow-up misses or cannot be used?
- Should **Blood Fang** remain, and if so, should it be the Art's main action rather than one feature inside a larger state?
- How does the Art express pressure and pursuit without tracking, line correction, or guaranteed safe positioning?
- How does it remain useful against ordinary encounters, elites, and bosses?
- Which parts of current Dire Hunt are essential, excessive, generic, or better assigned to later Tiers or Techniques?
- What animation, VFX, audio, HUD, collision, and teaching scope does each candidate require?

**This is the current active question.**

## Question 2 — Wolf Tier distribution after the Blood Art

After Wolf's Blood Art is selected, reassess Tiers I, III, and IV around it.

Resolve:

- Is Blood Tempo overloaded with accelerated chains, alternate entries, rear payoff, and travel increases?
- Which Blood Tempo behavior is the essential Tier I headline?
- Does Fanged Guard remain appropriate for the selected Blood Art and Held Attack structure?
- What becomes Wolf's Tier IV headline benefit?
- How can Tier IV provide meaningful value during a boss fight and ordinary combat without depending solely on a deathblow?
- Can deathblows remain a secondary refresh, amplification, or special payoff rather than the only trigger?
- Which Wolf Tiers need one small beginner-visible supporting reward?

## Question 3 — Wraith Blood Art form

Compare the current temporary-state **Wraith's Reach** against immediate-action or concise non-duration alternatives.

Resolve:

- Should Wraith's Blood Art remain a temporary reach-and-afterimage state?
- Could a short spectral formation, authored corridor, large frontal sequence, or another immediate control action fit better?
- What guaranteed activation value does the Art provide if the player cannot land an ideal follow-up?
- How does the Art reinforce reach and frontal control without permanently solving point-blank pressure?
- How does it remain distinct from Ronin's delayed ground rupture, Wolf's pursuit, projectiles, tracking attacks, and autonomous companions?
- Which current ideas—extended geometry, delayed afterimages, Pale Procession, or another effect—belong in the Art versus later Tiers?
- What production and readability burden does each candidate create?

## Question 4 — Wraith Tier distribution after the Blood Art

After Wraith's Blood Art is selected, reassess Tiers I, III, and IV around it.

Resolve:

- Does too much of Wraith's progression currently develop only Pale Lance and Pale Barrage?
- Should later Tiers provide additional value to Veil Cut, Passing Arc, Ghostline Slash, or Veil Reversal?
- Is Veiled Guard sufficient as a complete Tier III, or does it need one small supporting benefit outside the Held Attack?
- Is Pale Procession sufficiently broad and valuable for Tier IV?
- What Tier IV benefit remains useful in short exchanges, against mobile bosses, and when a full stationary barrage is unsafe?
- Which Wraith Tiers need a beginner-visible supporting reward?

## Question 5 — Per-Tier small growth rewards

Decide whether every Embrace should include a small, always-readable growth reward in addition to its headline mechanic.

Candidate identity directions include:

- Wolf: modest authored attack-cadence improvements,
- Wraith: modest spectral attack-reach improvements,
- Ronin: modest maximum-Health improvements.

Resolve:

- Should growth occur at every Tier, only selected Tiers, or through action-specific supporting rules instead of one repeated stat track?
- Which game attributes are real scalable implementation metrics rather than vague labels?
- Which changes are perceptible and enjoyable for beginners without becoming mandatory raw power?
- How should attack speed be authored without compressing parry readability or erasing severe miss recovery?
- How much additional reach can Wraith gain without becoming excessively safe?
- How much Health can Ronin gain without making its strongest guard and interruption-resistance tools generally optimal?
- Should generic Health, damage, posture, or Blood-generation increases remain rare because Techniques and permanent progression also need meaningful space?

## Question 6 — Minor supporting benefits by Tier

Audit every Tier that currently contains only one narrow or highly conditional mechanic.

For each Tier, determine:

- whether the headline is understandable and useful to a beginner,
- whether it affects ordinary encounters and bosses,
- whether it needs one minor supporting rule,
- whether that rule improves the full kit or only repeats the headline,
- whether the reward is visible through play rather than only through hidden percentages,
- and whether it overlaps an ordinary Technique.

Possible supporting rewards include small action-specific changes to preparation, contact recovery, geometry, guard recoil, response-window duration, Blood gain from skilled actions, or another existing combat verb. Do not add filler benefits only to equalize feature counts.

## Question 7 — Ronin follow-up audit

Ronin does not currently require a new Blood Art concept, but it must be checked against whatever standards are approved for Wolf and Wraith.

Resolve:

- Does Ronin receive the approved small Tier-growth structure, and is maximum Health the correct direction?
- Is Tier III's Measured Weight and Perfect Weight state readable without excessive timer management?
- Is Shattering Wake's availability and posture payoff appropriately comparable to revised Wolf and Wraith Tier IV benefits?
- Does Falling Mountain remain powerful without trivializing elite and boss posture systems?
- Does any Ronin Tier need simplification after the full roster is compared?

## Question 8 — Final cross-roster lock

After Questions 1-7 are resolved, compare the completed packages for:

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
- and whether every Tier is a clearly worthwhile but nonmandatory Embrace.

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

Do not assume a separate duplicate Blood Art upgrade tree beneath every Aspect. Any Blood Art meta progression must be justified as part of a broader game-wide system.

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

Keep exact values and frame-level decisions in their owning gameplay, encounter, economy, UI, or production files, including:

- frame data, hitboxes, cancel windows, attack travel, damage, posture, stagger, and recovery,
- neutral movement and dash values,
- Corruption thresholds, Shrine frequency, route distribution, and support values,
- Blood capacity, gain weighting, activation cost, duration, and anti-farming rules,
- exact per-Tier stat or action-growth values after the growth structure is approved,
- enemy immunity and response tables,
- Spirit costs and Prosthetic cooldowns,
- room and encounter counts,
- reward probabilities, prices, rarity weights, and rerolls,
- exact permanent-upgrade percentages,
- and final animation frames, VFX density, audio timing, or HUD layout.
