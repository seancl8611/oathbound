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

This supporting file preserves the retired Tier II duration-state direction and the current provisional Tier III-IV candidates.

It is not approved production scope. `WRAITH_ASPECT.md` owns the approved Tier 0-II package. Git history preserves the complete earlier draft if exact superseded wording is needed.

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

The delayed repetition concept survived in the approved immediate Wraith's Reach, but it is now concentrated into one authored corridor instead of repeating ordinary attacks throughout a duration state.

# Approved replacement reference — immediate Wraith's Reach

The approved Tier II package is summarized here only to clarify later-Tier dependencies:

- a compact broad frontal opening sweep provides guaranteed activation value,
- one very long narrow-to-medium corridor strike follows along a fixed player-selected direction,
- one delayed spectral Wraith repeats the exact same corridor geometry,
- the Art does not track, pursue, grant generic defense, generate Blood, or independently trigger Spectral Edge,
- and ordinary vulnerability, interruption, commitment, and recovery remain active.

The full approved rules belong in `WRAITH_ASPECT.md`.

# Tier III candidate — Veiled Guard

While charging Pale Lance or channeling Pale Barrage, Akio may press the normal parry input to have a spectral Wraith parry one eligible incoming attack from any direction.

Candidate rules:

- the player must time the input within the ordinary parry window,
- the incoming attack must be eligible for an ordinary parry,
- the spectral Wraith may face and intercept the attack without turning Akio,
- a successful parry uses ordinary enemy-posture pressure, deflection response, and posture-break rules,
- success does not cancel Pale Lance, interrupt Pale Barrage, remove charge, change the selected direction, or automatically release the attack,
- success does not automatically trigger Veil Reversal or another offensive action,
- each Pale Lance use permits one Veiled Guard parry, including when that use continues into Pale Barrage,
- entering Pale Barrage does not refresh Veiled Guard after it has been spent,
- a mistimed parry provides no fallback block, damage reduction, interruption resistance, or other protection,
- and an attack that connects after a mistime or after the use is spent affects Akio and the committed action through ordinary combat rules.

Veiled Guard adds no healing, Blood generation, Blood refund, bonus damage, automatic counter, easier parry timing, turning, or passive protection.

The candidate Tier III rhythm is:

> begin a committed Pale Lance action → continue reading the encounter while holding the selected line → manually parry one eligible attack without abandoning the charge or barrage → decide whether the remaining commitment is still safe after the guard is spent

## Questions for Tier III review

- Is preserving Pale Lance or Pale Barrage sufficient as a complete Tier III?
- Does this still concentrate too much Wraith progression on the Held Attack?
- Should Veiled Guard affect another authored commitment instead?
- Is multidirectional parry coverage too generous for Wraith's weakness to pressure outside its focused front?
- Does the concurrent Held/parry input and presentation burden justify the benefit?
- Should Tier III instead broaden Veil Cut, Passing Arc, Ghostline Slash, Veil Reversal, or Wraith's Reach?

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
- Should Tier IV instead upgrade several Wraith actions or build from the approved corridor Blood Art?
- Can a broad Tier IV preserve point-blank and lateral weaknesses without becoming a full-screen control tool?
- What benefit remains valuable when stationary barrage commitment is unsafe?

# Candidate production burden

If Veiled Guard and Pale Procession are retained, they require:

- Veiled Guard availability, spent-state, success, and failed-timing feedback,
- concurrent Held/parry input handling during Pale Lance and Pale Barrage,
- multidirectional spectral defense without rotating Akio or redirecting the attack,
- ordinary parry, posture-break, and interruption behavior during the preserved commitment,
- Pale Procession shade spawning, stable offsets, adjacent line geometry, reduced impact, and dismissal,
- slow direct steering within a limited frontal arc,
- deterministic one-stream-per-enemy resolution with central-stream priority,
- prevention of shade Blood generation, Wraith's Reach echo creation, Spectral Edge multiplication, and full-value proc multiplication,
- and readable Shrine, HUD, teaching, and mastery-trial states.

# Current active decision

Reassess Tier III and Tier IV around the approved immediate Wraith's Reach.

The final package should avoid developing only Pale Lance and Pale Barrage, remain useful against ordinary encounters and mobile bosses, preserve Wraith's frontal and spacing weaknesses, and justify its production burden relative to Wolf and Ronin.
