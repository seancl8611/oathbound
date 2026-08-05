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
- Wolf Tier I is **Blood Tempo**, a unified successful-contact continuation system into the Basic sequence.
- Wolf's approved small Tier-growth rule is **Feral Momentum**: later Basic Attacks reached through successful Blood Tempo continuations gain a modest deterministic Health- and enemy-posture payoff that strengthens with each Embrace.
- Wolf Tier II is **Blood Hunt**, an immediate full-meter pursuit Art rather than a temporary transformation.
- Wolf Tier III is **Fanged Guard**, which preserves one selected frontal high-risk ordinary commitment through a normal posture-costing block.
- Wolf Tier IV is **Apex Mauling**, which adds a rapid Blood-claw mauling and brief movement-only slow after qualifying major impacts.

## Current working Aspect packages

Wolf and Ronin have complete qualitative Tier I-IV packages approved through the present audit. Wraith retains a complete working draft, but its Tier 0 foundation and later progression are now under ordered revision.

### Wolf

- **Tier I — Blood Tempo:** successful Wolf contact may continue earlier into the Basic sequence through approved optional routes.
- **Feral Momentum — Tier growth:** later connected Basic-sequence positions gain modest deterministic Health and posture payoff that scales at every Tier.
- **Tier II — Blood Hunt:** activation restores limited Health and disrupts nearby ordinary enemies before one long player-directed pursuit tears through eligible ordinary enemies and ends in Blood Fang.
- **Tier III — Fanged Guard:** one frontal blockable hit may preserve Predator's Passage charge, or one connected Raking Fang or Blood Cleave startup per Basic sequence, using normal player-posture rules.
- **Tier IV — Apex Mauling:** connected Blood Cleave, Predator's Passage, Fang Reversal, and Blood Fang trigger a consolidated Blood-claw mauling with strong posture pressure, compact secondary coverage, and a brief movement-only slow on the primary target.

### Wraith

- **Tier 0:** current two-hit reach-and-control foundation is the next active revision target.
- **Tier I — Pale Barrage:** Pale Lance may continue into rapid stationary spectral jabs.
- **Tier II — Wraith's Reach:** temporary state with greater spectral reach and delayed attack afterimages.
- **Tier III — Veiled Guard:** one manually timed spectral parry may preserve each Pale Lance or Pale Barrage use.
- **Tier IV — Pale Procession:** Pale Barrage gains two non-stacking adjacent shade streams and limited player-directed steering.

### Ronin

- **Tier I — Steadfast Reprisal:** a qualifying block may create an optional Reprisal Cut.
- **Tier II — Falling Mountain:** activation clears meaningful accumulated posture and powers a planted monumental slam, immediate impact burst, and delayed Deep Rupture.
- **Tier III — Unbroken Resolve:** selected commitments may survive one costly eligible hit, while disciplined clean attacks may create Measured Weight and Perfect Weight.
- **Tier IV — Shattering Wake:** qualifying direct heavy impacts transfer reduced Health damage and strong posture force through the primary target into enemies behind it.

Ronin remains the comparison reference for broad later-Tier coverage. Wolf now meets a comparable standard through ordinary sequence flow, a distinct Blood Art, action-specific commitment protection, and a broadly available Tier IV impact effect.

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

Resolve the following questions **one at a time in the listed order**. Each Aspect's Tier 0 foundation must be settled before redesigning its later package around that foundation.

## Resolved Question 1 — Wolf Blood Art form

Wolf's Tier II Blood Art is **Blood Hunt**, replacing the temporary-state Dire Hunt concept.

Approved boundaries:

- Blood Hunt is one immediate authored action rather than a duration transformation.
- Activation restores limited Health and releases a short Blood howl that briefly staggers nearby ordinary enemies and applies modest posture pressure to stronger enemies and bosses.
- The activation value resolves when Blood is spent and does not require the pursuit or endpoint to connect.
- Akio then commits along one player-selected line in a long Blood-wolf pursuit.
- The pursuit damages and may pass through eligible ordinary enemies when valid space exists.
- It stops against elites, bosses, heavy enemies, walls, blocked geometry, invalid destinations, or its maximum distance.
- The action ends in **Blood Fang**, a strong Health- and posture-damaging jaw strike with powerful eligible ordinary-enemy stagger.
- Blood Hunt cannot track, turn, home, retarget, or correct its line.
- Light ordinary hits do not interrupt the launched pursuit, but they still deal full Health, posture, status, and other valid effects.
- Posture-breaking, lethal, perilous, grabbing, launching, or overriding knockdown attacks interrupt normally.
- The brief directional preparation and ending recovery retain ordinary vulnerability.
- A poor line may miss the intended target or leave Akio in severe recovery and dangerous positioning.
- Blood Hunt does not clear player posture, grant damage reduction, or create a temporary generic damage, lifesteal, or moveset-buff state.
- Blood generation resumes after the immediate Art finishes resolving.

Dire Hunt's temporary transformation, general damage bonuses, per-hit lifesteal, moveset-wide interruption resistance, and moveset-wide travel increases are no longer part of Wolf Tier II.

## Resolved Question 2 — Wolf Tier distribution after Blood Hunt

### Tier I — Blood Tempo

Blood Tempo is one unified successful-contact continuation mechanic.

Approved routes:

- Fang Slash → Rending Cross,
- Rending Cross → Raking Fang,
- Raking Fang → Blood Cleave,
- Predator's Passage → Rending Cross,
- Hunting Slash → Rending Cross,
- Fang Reversal → Rending Cross.

Approved boundaries:

- continuations are optional,
- they exist only during the current attack's contact recovery,
- misses receive no accelerated continuation,
- direction remains fully player-selected,
- Blood Cleave does not loop into Fang Slash,
- defensive and utility actions are not accelerated,
- whiff recovery is unchanged,
- and Blood Tempo adds no tracking, corrective turning, additional travel, or rear-hit bonus.

The former Hunting Slash rear-Rending-Cross damage bonus and the former Raking Fang and Hunting Slash travel increases are removed from fixed Wolf progression. They are not automatically moved to another Tier.

### Wolf growth rule — Feral Momentum

Beginning at Tier I, later Basic Attacks reached through successful Blood Tempo continuations receive a deterministic sequence-position bonus:

- Rending Cross receives the smallest additional Health and enemy-posture payoff,
- Raking Fang receives a larger payoff,
- Blood Cleave receives the largest payoff,
- and each Embrace through Tier IV modestly increases those payoffs.

Alternate entries from Predator's Passage, Hunting Slash, and Fang Reversal begin at Rending Cross and receive the normal second-position bonus. The escalation requires the preceding approved action to connect successfully; continuing after a miss does not receive it.

Feral Momentum uses no random critical-hit roll, separate meter, stack counter, or persistent combo timer. It does not improve non-Basic actions, Blood Hunt, travel, or whiff recovery, and it does not make Blood Cleave mandatory.

### Tier III — Fanged Guard

Fanged Guard preserves selected high-risk ordinary Wolf commitments through one frontal blockable hit using normal player-posture rules.

Approved uses:

- while charging Predator's Passage, the first frontal blockable hit is blocked, does not cancel the Held Attack, and immediately completes its charge,
- when Raking Fang or Blood Cleave is reached through successful Blood Tempo continuation, one eligible early committed startup window may block the first frontal blockable hit without cancelling that attack,
- and only one Fanged Guard block may occur during one connected Basic sequence.

If Raking Fang spends the sequence allowance, Blood Cleave receives no second block. If Raking Fang does not spend it and Blood Cleave is reached through continued successful contact, Blood Cleave may use the allowance. Predator's Passage has its own one-block allowance per Held use.

Boundaries:

- normal player-posture damage applies,
- posture break cancels the attack normally,
- Fang Slash, Rending Cross, nonconnected Raking Fang or Blood Cleave, Blood Hunt, Blood Fang, and recovery receive no protection,
- side, rear, perilous, unblockable, grab, launch, knockdown, and second-hit threats are not protected,
- and Fanged Guard grants no damage reduction beyond the normal block, posture immunity, tracking, direction correction, damage increase, or guaranteed safe positioning.

Tier III also advances Feral Momentum by one normal Tier step.

### Tier IV — Apex Mauling

Qualifying direct hits or guards from connected Blood Cleave, Predator's Passage, Fang Reversal, or Blood Fang trigger one rapid Blood-claw mauling at the original contact point.

Approved boundaries:

- the primary target receives meaningful additional Health damage, strong total enemy-posture pressure, powerful guard recoil, and eligible ordinary-enemy stagger,
- compact outer claw arcs may strike nearby enemies once for reduced Health damage and meaningful posture pressure,
- the visible claw series is resolved as one consolidated Tier IV package rather than several independent full-power hits,
- large enemies and bosses do not receive extra damage because several marks overlap them,
- the final claw briefly slows only the primary target's movement,
- attack startup, animation speed, recovery, defensive timing, projectile speed, and perilous timing remain unchanged,
- elite and boss slow strength or duration is reduced and protected authored movement remains unaffected,
- Apex Mauling does not track, retarget, rotate, search for enemies, generate Blood, recursively trigger itself, or cancel Wolf's recovery,
- Blood Hunt travel hits do not trigger it; only Blood Fang may do so,
- and Feral Momentum may strengthen Apex Mauling's posture, recoil, and stagger when connected Blood Cleave creates it, without substantially multiplying its Health damage.

Tier IV also applies Feral Momentum's final normal Tier increase. The former deathblow-only Apex Feast package, its healing, eruption, and primed Predator's Passage are removed.

Wolf's Tier I-IV package is complete for the present audit. Exact damage, posture, claw cadence, slow strength and duration, collision, proc weighting, and presentation remain implementation and playtesting work.

## Question 3 — Wraith Tier 0 revision

Reassess Wraith's complete starting weapon kit before redesigning its Blood Art or later Tiers.

Resolve:

- Does the current two-hit Basic sequence provide enough ordinary decision variety and satisfaction compared with Wolf's four-hit pressure sequence and Ronin's three-hit heavy sequence?
- Should Veil Cut → Passing Arc remain a two-attack sequence, gain a third authored option, or change its attack roles while preserving Wraith's shorter sequence identity?
- Are Veil Cut, Passing Arc, Pale Lance, Ghostline Slash, and Veil Reversal sufficiently distinct in timing, geometry, commitment, and purpose?
- Does Wraith currently rely too heavily on generic longer reach rather than producing a distinct frontal-control playstyle through attack selection?
- How should Tier 0 handle close-range pressure, groups, mobile targets, ranged enemies, elites, and bosses without solving every weakness?
- Does Pale Lance already carry too much of Wraith's identity before later Tiers further concentrate on it?
- What should Wraith's ordinary damage, posture, stagger, movement, and recovery profile be relative to Wolf and Ronin?
- Which Tier 0 animations, VFX, hit geometries, and teaching requirements are necessary for a complete and production-realistic foundation?

**This is the current active question.**

## Question 4 — Wraith Blood Art form

After Wraith Tier 0 is settled, compare the current temporary-state **Wraith's Reach** against immediate-action or concise non-duration alternatives.

Resolve:

- Should Wraith's Blood Art remain a temporary reach-and-afterimage state?
- Could a short spectral formation, authored corridor, large frontal sequence, or another immediate control action fit better?
- What guaranteed activation value does the Art provide if the player cannot land an ideal follow-up?
- How does the Art reinforce reach and frontal control without permanently solving point-blank pressure?
- How does it remain distinct from Ronin's delayed ground rupture, Wolf's pursuit and Blood-claw impacts, projectiles, tracking attacks, and autonomous companions?
- Which current ideas—extended geometry, delayed afterimages, Pale Procession, or another effect—belong in the Art versus later Tiers?
- What production and readability burden does each candidate create?

## Question 5 — Wraith Tier distribution after the Blood Art

After Wraith's Blood Art is selected, reassess Tiers I, III, and IV around it.

Resolve:

- Does too much of Wraith's progression currently develop only Pale Lance and Pale Barrage?
- Should later Tiers provide additional value to Veil Cut, Passing Arc, Ghostline Slash, or Veil Reversal?
- Is Veiled Guard sufficient as a complete Tier III, or does it need one small supporting benefit outside the Held Attack?
- Is Pale Procession sufficiently broad and valuable for Tier IV?
- What Tier IV benefit remains useful in short exchanges, against mobile bosses, and when a full stationary barrage is unsafe?
- Which Wraith Tiers need a beginner-visible supporting reward?

## Question 6 — Per-Tier small growth rewards

Decide whether every Embrace should include a small, always-readable growth reward in addition to its headline mechanic.

Current directions:

- **Wolf is resolved:** Feral Momentum modestly increases the Health and enemy-posture payoff of later successfully connected Basic-sequence positions at every Tier.
- **Wraith remains unresolved:** modest spectral attack-reach growth is one candidate.
- **Ronin remains unresolved:** modest maximum-Health growth is one candidate.

Resolve:

- Should Wraith and Ronin also use one repeated growth track, selected Tier-specific supporting rules, or no universal pattern?
- Which game attributes are real scalable implementation metrics rather than vague labels?
- Which changes are perceptible and enjoyable for beginners without becoming mandatory raw power?
- How much additional reach can Wraith gain without becoming excessively safe?
- How much Health can Ronin gain without making its strongest guard and interruption-resistance tools generally optimal?
- Should generic Health, damage, posture, or Blood-generation increases remain rare because Techniques and permanent progression also need meaningful space?

## Question 7 — Minor supporting benefits by Tier

Audit every Tier that currently contains only one narrow or highly conditional mechanic.

For each Tier, determine:

- whether the headline is understandable and useful to a beginner,
- whether it affects ordinary encounters and bosses,
- whether it needs one minor supporting rule,
- whether that rule improves the full kit or only repeats the headline,
- whether the reward is visible through play rather than only through hidden percentages,
- and whether it overlaps an ordinary Technique.

Possible supporting rewards include small action-specific changes to preparation, contact recovery, geometry, guard recoil, response-window duration, Blood gain from skilled actions, or another existing combat verb. Do not add filler benefits only to equalize feature counts.

## Question 8 — Ronin follow-up audit

Ronin does not currently require a new Blood Art concept, but it must be checked against whatever standards are approved for Wolf and Wraith.

Resolve:

- Does Ronin receive the approved small Tier-growth structure, and is maximum Health the correct direction?
- Is Tier III's Measured Weight and Perfect Weight state readable without excessive timer management?
- Is Shattering Wake's availability and posture payoff appropriately comparable to revised Wolf and Wraith Tier IV benefits?
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
- exact Blood Hunt preparation, travel, collision, stopping priority, interruption categories, damage, posture, Health recovery, howl radius, and ending recovery,
- exact Feral Momentum Health-damage and enemy-posture scaling at Tiers I-IV,
- exact Fanged Guard startup windows, frontal coverage, reset timing, posture interaction, and feedback,
- exact Apex Mauling damage, posture, claw count, cadence, compact secondary geometry, guard recoil, movement-slow strength and duration, boss and elite scaling, and proc weighting,
- exact Wraith or Ronin Tier-growth values after their structures are approved,
- enemy immunity and response tables,
- Spirit costs and Prosthetic cooldowns,
- room and encounter counts,
- reward probabilities, prices, rarity weights, and rerolls,
- exact permanent-upgrade percentages,
- and final animation frames, VFX density, audio timing, or HUD layout.