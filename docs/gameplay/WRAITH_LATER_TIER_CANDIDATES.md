---
id: GAMEPLAY-WRAITH-LATER-TIER-CANDIDATES
title: Wraith Later-Tier Candidates
category: gameplay
status: draft
authority: supporting
last_reviewed: 2026-08-05
topics:
  - blood-aspects
  - wraith
  - tier-progression
  - blood-arts
  - working-draft
related:
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-BLOOD-ASPECTS
  - META-OPEN-QUESTIONS
---

# Wraith Later-Tier Candidates

## Purpose

This file preserves the complete detailed Tier II-IV Wraith package that existed before the ordered Wraith revision began.

It is not approved production scope. `WRAITH_ASPECT.md` owns the approved Tier 0 and Tier I package. The current active question is whether Tier II should remain Wraith's Reach or use a different Blood Art form. The candidate material below remains available for comparison, redistribution, or rejection without being mistaken for a final lock.

# Tier II candidate — Wraith's Reach

Tier II unlocks Wraith's Blood meter and Blood Art.

Wraith's Reach follows the shared Blood defaults: it requires a full meter, activates manually, consumes the stored Blood, and does not generate Blood while its duration state is active. Exact Blood capacity, source weighting, activation timing, and duration remain tuning work.

Activation begins the empowered state after a short readable Blood manifestation. No separate damaging activation attack, forced movement, control lockout, or replacement moveset is currently required by this candidate.

For the duration of Wraith's Reach:

- Veil Cut gains additional spectral reach.
- Passing Arc gains additional spectral reach and wider frontal coverage.
- Pale Lance gains additional spectral reach.
- Each qualifying Veil Cut, Passing Arc, or Pale Lance produces one delayed spectral afterimage strike a short beat after the physical hit timing.
- The afterimage repeats the original action's player-selected direction and authored line or arc.
- The afterimage does not track, home, rotate toward, or independently select an enemy.
- The afterimage may hit an enemy that remains in or enters its geometry, and it misses if the enemy leaves that geometry.
- Akio retains ordinary locomotion, neutral dash, block, parry, Basic Attacks, Held Attack, Dash Attack, Parry Counter, deathblows, and Prosthetic access.
- Wraith's ordinary startup, recovery, restrained attack movement, commitment, and defensive-access rules remain unchanged.

## Pale Barrage interaction

The initial Pale Lance creates one delayed Pale Lance afterimage whether the player releases immediately or continues into Pale Barrage.

Pale Barrage's additional jabs receive Wraith's Reach's increased reach, but the individual jabs do not each create their own full afterimage strike. This prevents excessive damage, posture pressure, visual noise, Blood generation, or Technique-trigger multiplication.

## Echo impact and system interactions

The delayed afterimage is a secondary Wraith hit rather than a second full copy of every property on the original attack.

Candidate boundaries are:

- lower Health damage than the corresponding physical strike,
- meaningful enemy-posture pressure,
- normal hit or guard response unless an enemy's own rules specify otherwise,
- no forced repeated stagger against elites or bosses,
- no Blood generation from the afterimage,
- no independent Spectral Edge bonus from the afterimage,
- and weighted or restricted per-hit Technique and healing interactions so the echo does not automatically duplicate every proc at full value.

Exact Health damage, enemy-posture pressure, ordinary-enemy interruption, guard response, Technique weighting, and hit-stop remain implementation and playtesting work if this candidate is retained.

## Defense and parry relationship

Wraith's Reach grants no direct Health restoration, Blood refund, damage reduction, posture clearing, interruption resistance, automatic counter, or special parry success condition.

A successful parry remains valuable through the universal defense system and may naturally allow a previously placed afterimage to resolve while Akio defends. Veil Reversal remains available after a successful parry, but this candidate adds no separate parry reward.

The candidate Tier II rhythm is:

> fill Blood through ordinary combat → activate Wraith's Reach before a valuable exchange → place longer player-directed attacks and delayed echoes through deliberate line and arc selection → continue reading, blocking, parrying, dashing, and repositioning normally → gain greater frontal control without escaping Wraith's existing commitment and spacing limits

# Tier III candidate — Veiled Guard

While charging Pale Lance or channeling Pale Barrage, Akio may press the normal parry input to have a spectral Wraith parry one eligible incoming attack from any direction.

Veiled Guard follows these candidate rules:

- The player must time the input within the ordinary parry window.
- The incoming attack must be eligible for an ordinary parry.
- The spectral Wraith may face and intercept the attack from any direction without turning Akio.
- A successful parry uses ordinary enemy-posture pressure, deflection response, and posture-break rules.
- A successful parry does not cancel Pale Lance, interrupt Pale Barrage, remove accumulated charge, change the attack's selected direction, or automatically release the attack.
- A successful parry does not automatically trigger Veil Reversal or another offensive action.
- Each Pale Lance use permits one Veiled Guard parry, including when the same use continues into Pale Barrage.
- Entering Pale Barrage does not refresh Veiled Guard after it has been spent.
- A mistimed parry provides no fallback block, damage reduction, interruption resistance, or other protection.
- If an enemy attack connects after a missed timing or after Veiled Guard is spent, it affects Akio and the committed action through ordinary combat rules.
- Veiled Guard adds no healing, Blood generation, Blood refund, bonus damage, automatic counter, easier parry timing, turning, or passive protection.

Veiled Guard does not change ordinary parries outside Pale Lance or Pale Barrage. Its multidirectional property exists because the spectral manifestation performs the defense while Akio preserves the original attack animation and direction.

## Wraith's Reach interaction

If Wraith's Reach is retained:

- Veiled Guard remains available during Pale Lance and Pale Barrage while the state is active.
- Wraith's Reach still extends Pale Lance and Pale Barrage according to the Tier II candidate.
- The initial Pale Lance still creates only one delayed afterimage.
- Veiled Guard does not create another afterimage, extend Wraith's Reach, refund Blood, or add a separate parry reward.
- One Veiled Guard use remains available per Pale Lance use; Wraith's Reach does not increase or refresh that count.

The candidate Tier III rhythm is:

> choose and begin a committed Pale Lance action → continue reading the entire encounter while holding the selected line → manually parry one eligible attack through the spectral guard without abandoning the charge or barrage → decide whether the remaining commitment is still safe after the guard is spent

# Tier IV candidate — Pale Procession

While channeling Pale Barrage, two spectral shades manifest beside Akio and perform reduced-power barrages along adjacent lines, creating a broad three-lane frontal formation.

## Formation and steering

- Akio remains the central and strongest barrage stream.
- One shade forms to his left and one to his right.
- Each shade performs Pale Barrage along a fixed adjacent line relative to the central stream.
- The player may slowly rotate the entire formation through direct directional input within a limited frontal arc.
- The shades maintain their authored spacing and angles while the formation rotates.
- The formation does not snap toward, track, home onto, or automatically follow enemies.
- Akio remains stationary and cannot move the formation's origin while channeling.
- Releasing Pale Barrage or being interrupted immediately ends all three streams and dismisses the shades.

## Non-stacking rule

An enemy may receive damage and enemy-posture pressure from only one Pale Procession stream during each authored barrage beat.

- If an enemy overlaps multiple streams, only one stream applies for that beat.
- Akio's central stream takes priority when it connects.
- The shade streams cannot converge to multiply damage or posture pressure against one enemy.
- Large enemies and bosses do not receive extra hits merely because their collision overlaps several lanes.

This rule makes Pale Procession a frontal coverage and reliability upgrade rather than a single-target damage multiplier.

## Shade impact and system interactions

- Shade jabs deal reduced Health damage and reduced enemy-posture pressure compared with Akio's central barrage.
- Shade jabs generate no Blood.
- Shade jabs receive no independent Spectral Edge bonus.
- Shade jabs use weighted or restricted Technique, healing, and other per-hit interactions.
- Shade jabs do not create delayed Wraith's Reach afterimages.
- Shade jabs do not independently force repeated stagger against elites or bosses.
- The shades do not select targets, retarget after a death, or persist independently of Akio.

## Boss and single-target role

Pale Procession does not increase Wraith's maximum single-target Pale Barrage damage. Its boss value comes from limited manual steering:

- the player may keep Akio's central stream aligned with modest boss movement during a valid opening,
- the rotation is deliberately slower and narrower than ordinary locomotion or free aiming,
- a boss can still leave the formation's frontal arc or interrupt Akio after Veiled Guard is spent,
- and Basic Attacks remain preferable for short, mobile, or uncertain exchanges.

## Veiled Guard interaction

If Veiled Guard is retained:

- one Veiled Guard parry remains available per Pale Lance use,
- the shades do not gain separate defensive uses,
- a successful Veiled Guard preserves Akio's channel and both shade streams,
- entering Pale Barrage still does not refresh Veiled Guard,
- and after Veiled Guard is spent or mistimed, Pale Procession provides no fallback defense.

## Wraith's Reach interaction

If Wraith's Reach is retained:

- the central and shade barrage streams receive the approved extended Pale Barrage reach,
- the formation's non-stacking rule remains absolute,
- the initial Pale Lance still creates only one delayed afterimage,
- the shades and individual barrage jabs do not create additional afterimages,
- and Wraith's Reach does not increase the number of shades or Veiled Guard uses.

The candidate Tier IV rhythm is:

> identify a sufficiently long frontal opening → commit through Pale Lance into Pale Barrage → manifest three non-stacking spectral lanes → slowly steer the formation to maintain coverage or keep the central stream aligned → use Veiled Guard once when a correctly read attack justifies preserving the commitment → release before stationary exposure becomes unsafe

Pale Procession adds no lingering attacks, detonations, automatic target selection, single-target stacking, healing, Blood refund, extra parry, damage reduction, or unrelated passive.

# Candidate presentation and production burden

If these candidates are retained, they require:

- Wraith's Reach activation, active-state, and ending presentation,
- extended Veil Cut, Passing Arc, Pale Lance, and Pale Barrage geometry and VFX,
- delayed afterimage creation, timing, direction, line and arc reuse, and dissolution,
- deterministic prevention of echo Blood generation and full-value proc duplication,
- Veiled Guard availability, spent-state, success, and failed-timing feedback,
- concurrent Held/parry input handling during Pale Lance and Pale Barrage,
- multidirectional spectral defense without rotating Akio or redirecting the attack,
- Pale Procession shade spawning, stable offsets, adjacent line geometry, reduced impact, and dismissal,
- slow direct steering within a limited frontal arc,
- deterministic one-stream-per-enemy resolution with central-stream priority,
- prevention of shade Blood generation, echo creation, Spectral Edge multiplication, and full-value proc multiplication,
- and readable HUD, Shrine, teaching, and mastery-trial states.

# Questions carried into the active review

- Is a duration state the correct Tier II form?
- What guaranteed activation value exists before a follow-up connects?
- Is increased reach plus delayed repetition too redundant with Tier 0 and Spectral Edge?
- Are delayed echoes strategically meaningful or primarily visual and numerical duplication?
- Should Ghostline Slash or Veil Reversal participate in the Blood Art?
- Does Veiled Guard overconcentrate progression on Pale Lance and Pale Barrage?
- Does Pale Procession provide enough value during short or mobile boss openings?
- Which pieces should remain, move to another Tier, become Techniques, or be removed?
- Is the animation, VFX, hit-resolution, and readability cost justified by the gameplay value?