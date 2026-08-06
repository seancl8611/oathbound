---
id: GAMEPLAY-WRAITH-LATER-TIER-CANDIDATES
title: Wraith Later-Tier Candidates
category: gameplay
status: draft
authority: supporting
last_reviewed: 2026-08-06
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

This supporting file preserves rejected Wraith Tier II-III directions and the current provisional Tier IV candidate.

It is not approved production scope. `WRAITH_ASPECT.md` owns the approved Tier 0-III package. Git history preserves earlier full drafts if exact superseded wording is needed.

# Retired Tier II direction — duration-state Wraith's Reach

The former candidate used a temporary empowered state rather than one immediate Blood Art.

Retired behavior:

- a full meter activated manually and was consumed,
- Blood did not generate while the duration state remained active,
- Veil Cut, Passing Arc, and Pale Lance gained additional spectral reach,
- qualifying ordinary attacks created one delayed spectral afterimage along the original player-selected line or arc,
- afterimages did not track, home, rotate, or independently select targets,
- Pale Barrage gained additional reach but did not create one echo per jab,
- Akio retained ordinary movement, dash, block, parry, attacks, deathblows, and Prosthetics,
- and ordinary startup, recovery, commitment, and restrained attack movement remained unchanged.

Retired echo boundaries:

- lower Health damage than the corresponding primary strike,
- meaningful enemy-posture pressure,
- no Blood generation,
- no independent Spectral Edge bonus,
- restricted Technique, healing, and proc weighting,
- and no repeated stagger guarantee against elites or bosses.

This direction was rejected because:

- its moveset-wide reach increase overlapped Spectral Edge's spacing identity,
- it provided no guaranteed value when Blood was spent,
- it largely amplified existing attacks rather than creating a new decision,
- and it excluded Ghostline Slash and Veil Reversal while continuing to concentrate progression on the Basic sequence and Pale Lance.

The delayed repetition concept survived in the approved immediate Wraith's Reach, concentrated into one authored corridor instead of repeated ordinary attacks throughout a duration state.

# Approved Tier II reference — immediate Wraith's Reach

The approved Tier II package is summarized here only to clarify later-Tier dependencies:

- a compact broad frontal opening sweep provides guaranteed activation value,
- one very long narrow-to-medium corridor strike follows along a fixed player-selected direction,
- one delayed spectral Wraith repeats the exact same corridor geometry,
- the Art does not track, pursue, grant generic defense, generate Blood, or independently trigger Spectral Edge,
- and ordinary vulnerability, interruption, commitment, and recovery remain active.

The full approved rules belong in `WRAITH_ASPECT.md`.

# Retired Tier III direction — Veiled Guard

Veiled Guard allowed the player to press the normal parry input while charging Pale Lance or channeling Pale Barrage, causing a spectral Wraith to parry one eligible incoming attack from any direction without rotating Akio.

Retired rules:

- the player had to time the input within the ordinary parry window,
- the incoming attack had to be eligible for an ordinary parry,
- a successful parry preserved Pale Lance charge or Pale Barrage channel and selected direction,
- each Pale Lance use permitted one Veiled Guard parry across the complete use,
- entering Pale Barrage did not refresh it,
- a mistime provided no fallback block, damage reduction, or other protection,
- success did not trigger Veil Reversal or another automatic attack,
- and the effect added no healing, Blood generation, Blood refund, bonus damage, easier timing, turning, or passive defense.

The former rhythm was:

> begin a committed Pale Lance action → manually parry one eligible attack without abandoning the charge or barrage → decide whether the remaining commitment is still safe

Veiled Guard was rejected because:

- Tier I already developed Pale Lance through Pale Barrage,
- it returned Tier III to the same Held Attack family after Tier II broadened Wraith through Wraith's Reach,
- it affected none of Veil Cut, Passing Arc, Ghostline Slash, or Veil Reversal,
- its commitment-preservation role overlapped the defensive Tier III territory already occupied by Wolf and Ronin,
- and its concurrent Held/parry input, multidirectional manifestation, spent-state communication, and interruption handling created significant production burden for a narrow reward.

# Approved Tier III reference — Spectral Passage

Spectral Passage replaced Veiled Guard.

Approved summary:

- Veil Cut, Passing Arc, Pale Lance's initial thrust, Ghostline Slash, and Veil Reversal continue through ordinary-enemy bodies across their remaining authored geometry,
- the first or primary target receives the normal result,
- additional ordinary targets receive reduced Health damage and meaningful posture and guard pressure,
- each action may strike each enemy at most once,
- elites, bosses, protected heavy enemies, solid geometry, and authored blockers stop further passage,
- Pale Barrage's repeated jabs do not receive unrestricted full passage behavior,
- Wraith's Reach remains self-contained,
- secondary passage contacts generate no Blood and use restricted Spectral Edge, Technique, healing, status, and proc weighting,
- and the Tier adds no input, mode, reach, width, tracking, movement, defense, or same-enemy multiplication.

The full approved rules belong in `WRAITH_ASPECT.md`.

# Tier IV candidate — Pale Procession

While channeling Pale Barrage, two spectral shades manifest beside Akio and perform reduced-power barrages along adjacent lines, creating a broad three-lane frontal formation.

## Formation and steering

- Akio remains the central and strongest barrage stream.
- One shade forms to his left and one to his right.
- Each shade performs Pale Barrage along a fixed adjacent line relative to the central stream.
- The player may slowly rotate the entire formation through direct directional input within a limited frontal arc.
- The shades maintain authored spacing and angles while the formation rotates.
- The formation does not snap toward, track, home onto, or automatically follow enemies.
- Akio remains stationary and cannot move the formation's origin while channeling.
- Releasing Pale Barrage or being interrupted immediately ends all three streams and dismisses the shades.

## Non-stacking rule

An enemy may receive damage and enemy-posture pressure from only one Pale Procession stream during each authored barrage beat.

- If an enemy overlaps multiple streams, only one stream applies for that beat.
- Akio's central stream takes priority when it connects.
- Shade streams cannot converge to multiply damage or posture pressure against one enemy.
- Large enemies and bosses do not receive extra hits merely because their collision overlaps several lanes.

Pale Procession is therefore a frontal-coverage and reliability upgrade rather than a single-target damage multiplier.

## Shade impact and system interactions

- Shade jabs deal reduced Health damage and reduced enemy-posture pressure compared with Akio's central barrage.
- Shade jabs generate no Blood.
- Shade jabs receive no independent Spectral Edge bonus.
- Shade jabs use restricted Technique, healing, and other per-hit interactions.
- Shade jabs do not create Wraith's Reach echoes.
- Shade jabs do not create Spectral Passage chains or bypass the one-stream-per-enemy rule.
- Shade jabs do not independently force repeated stagger against elites or bosses.
- The shades do not select targets, retarget after a death, or persist independently of Akio.

## Boss and single-target role

Pale Procession does not increase Wraith's maximum single-target Pale Barrage damage. Its current boss value comes from limited manual steering:

- the player may keep Akio's central stream aligned with modest movement during a valid opening,
- the rotation is slower and narrower than ordinary locomotion or free aiming,
- a boss can still leave the formation's frontal arc or interrupt Akio,
- and Basic Attacks remain preferable for short, mobile, or uncertain exchanges.

## Questions for Tier IV review

- Is a second major Pale Barrage upgrade too narrow after Tier I already adds Pale Barrage?
- Does Pale Procession provide enough value during short exchanges and mobile boss encounters?
- Is three-lane hit resolution and steering worth its animation, VFX, collision, and readability cost?
- Does Spectral Passage already provide sufficient ordinary group value, making another formation upgrade redundant?
- Should Tier IV instead upgrade several Wraith actions or build from Wraith's Reach?
- Can a broad Tier IV preserve point-blank and lateral weaknesses without becoming a full-screen control tool?
- What benefit remains valuable when stationary barrage commitment is unsafe?

# Candidate production burden

If Pale Procession is retained, it requires:

- shade spawning, stable offsets, adjacent line geometry, reduced impact, and dismissal,
- slow direct steering within a limited frontal arc,
- deterministic one-stream-per-enemy resolution with central-stream priority,
- prevention of shade Blood generation, Wraith's Reach echo creation, Spectral Edge multiplication, Spectral Passage chains, and full-value proc multiplication,
- and readable Shrine, HUD, teaching, and mastery-trial states.

# Current active decision

Reassess Tier IV around the approved Tier 0-III package.

The final capstone should remain useful against ordinary encounters and mobile bosses, preserve Wraith's frontal and spacing weaknesses, avoid overconcentrating progression on Pale Lance and Pale Barrage, and justify its production burden relative to Wolf and Ronin.
