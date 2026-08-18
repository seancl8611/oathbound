---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - open-questions
  - implementation-readiness
  - content-authoring
  - playtest-handoff
---

# Current Design Questions

This file is the implementation-facing design queue for Oathbound.

Oathbound's launch architecture is already scoped. An item belongs here only if answering it will materially reduce implementation ambiguity, prevent predictable rework, define authored launch content, or create a useful first-playtest baseline.

The goal is **not** to solve final balance on paper. The goal is to make the documented game concrete enough that implementation becomes filling in known pieces, then let Godot playtesting drive revisions.

# Planning-to-implementation rule

Approved documents are the current source of truth, but prototype values are expected to move when playtesting provides better evidence.

Use three decision classes:

1. **Define before implementation** — rules/content/data that code, UI, art, or authored encounters need in order to exist.
2. **Set a first-playtest baseline** — values needed to make the game playable; choose a reasonable prototype rather than debating final balance indefinitely.
3. **Defer to playtesting** — final damage, timing, frequency, pacing, economy, and difficulty tuning that the playable game can answer better.

A question leaves this file once it has enough of an answer to implement.

# Completed implementation passes

## Pass 1 — Core combat implementation baseline — COMPLETE

Approved in `docs/gameplay/COMBAT_IMPLEMENTATION_BASELINE.md`.

The common combat layer now has first-playtest Health/Posture/Spirit normalization, movement/dash/parry/block rules, enemy posture/deathblow rules, backstab geometry/payoff, perilous response classes, proc conventions, and shared status behavior.

## Pass 2A — Blood Aspect implementation baselines — COMPLETE

Approved in `docs/gameplay/ASPECT_IMPLEMENTATION_BASELINES.md`, implementing the qualitative Aspect authorities.

The first-playtest package now gives Wolf, Wraith, and Ronin concrete Tier 0 attack values, startup/recovery targets, reach/movement targets, defensive differences, Tier I-IV first-playtest values, Blood Art targets, repeated-growth values, and cross-roster balance targets.

Do not reopen the three Aspect identities or these prototype values as planning questions unless implementation/playtesting exposes a concrete problem.

## Pass 2B.1 — Technique-family implementation constants — COMPLETE

Approved in `docs/gameplay/TECHNIQUE_IMPLEMENTATION_BASELINES.md`.

The five existing Technique families now have shared first-playtest implementation rules for:

- proc coefficients and multi-hit normalization,
- Echo delay / replication / propagation,
- Rupture meter / buildup / trigger payoff,
- Seal duration / movement restriction / Bind,
- Rift fuse / intensity / burst progression,
- Crimson Vulnerable / genuine-backstab payoff / direct-Health conventions,
- the five approved Cross-family interactions.

The Technique roster itself remains unchanged: 25 Direct, 15 Supporting, 5 Cross-family, 5 Legendary, and 10 refinements.

# Current priority — Pass 2B.2: Individual Direct Technique implementation values — NEXT

**Question:** What exact first-playtest values and remaining per-entry rules should the existing **25 Direct Techniques** use on top of the approved family constants and Wolf/Wraith/Ronin host attacks?

Do not redesign the roster. Work through the five Direct slots in the existing catalog for each family and fill only fields still needed for implementation, including where relevant:

- exact application count or family contribution,
- direct bonus Health/posture value,
- secondary geometry/radius/width,
- internal cooldown only where needed,
- host-action proc normalization,
- boss/elite treatment only when shared rules are insufficient,
- interaction with the five host action slots,
- any required once-per-action/sequence cap.

Use `TECHNIQUE_IMPLEMENTATION_BASELINES.md` whenever a shared family value already answers the question; do not duplicate new one-off constants unnecessarily.

**Exit condition:** all 25 Direct Techniques can be represented as data/rules on top of Wolf, Wraith, and Ronin without a coder inventing Technique behavior.

## Pass 2B.3 — Supporting / Legendary / refinement implementation values

After the Direct Techniques are concrete, finish the remaining already-approved catalog:

- 15 Supporting Techniques,
- 5 Legendary Techniques,
- 10 refinements.

The 5 Cross-family Techniques already have their shared first-playtest numeric constants and need only any remaining per-entry implementation fields exposed by the Direct/support pass.

**Pass 2B exit condition:** all 50 Techniques + 10 refinements are directly instantiable in Godot while preserving the approved roster, rarity, prerequisites, family identity, and slot ownership.

# Remaining Pass 2 player-build work

## Pass 2C — Prosthetic implementation sheet

Define for all 8 Prosthetics and 19 upgrades:

- Spirit cost,
- cooldown/charge behavior,
- startup / active / recovery,
- geometry/range,
- valid targets/immunity,
- Health/posture effects,
- status values/durations,
- exact first-playtest upgrade improvements.

## Pass 2D — Relic implementation sheet

Define for all 10 Relics:

- Base effect value,
- Mastery I value,
- Mastery II value,
- qualifying trigger rules,
- any once-per-room/run/reset behavior,
- first-playtest mastery thresholds if needed for implementation.

## Pass 2E — Corruption / Shrine / Blood numeric sheet

Fill any remaining first-playtest values required to instantiate:

- Corruption gain/loss,
- Resist/Embrace/Stabilize behavior,
- Tier thresholds,
- Blood generation/storage,
- Blood Art costs/effects not already owned by the Aspect baseline,
- interaction with the three approved Aspects.

**Pass 2 exit condition:** every launch player-build item has enough data to instantiate in Godot, even though values remain playtest-tunable.

# Pass 3 — Hushiro implementation-ready content package

This is the first complete regional production target.

## 3A. Standard encounter pool

Define the authored Hushiro launch encounters:

- practical pool count,
- tactical purpose,
- exact enemy composition,
- waves/spawn sequence if any,
- layout/space requirement,
- minimum-chamber restriction only where needed,
- anti-repeat/eligibility rule only if needed.

## 3B. Room-layout inventory

Define the reusable Hushiro gameplay spaces actually required for:

- standard Combat,
- Shrine,
- Rest,
- Shop,
- Treasure,
- minibosses,
- Keeper,
- transitions.

This is a reusable layout inventory, not unique art per chamber.

## 3C. Village Ogre, Collector, and Keeper implementation packages

For each, finish:

- complete move/state list,
- targeting/selection conditions,
- parryable/dodge/perilous classifications,
- phase/escalation transitions,
- arena interactions,
- add/hazard rules,
- posture/deathblow/death behavior.

**Pass 3 exit condition:** Hushiro can be built as a complete repeatable region and used as the first serious end-to-end balance environment.

# Implementation restart gate

Do **not** wait for all later-region documentation before returning to Godot.

The documentation-first phase has done its job once:

- Pass 1 is complete,
- Pass 2 makes player-build content instantiable,
- Pass 3 makes Hushiro implementation-ready,
- the existing Godot project is audited against current documentation.

At that point implementation and documentation proceed together.

# Later implementation-content passes

## Pass 4 — Strand and permanent progression

Define exact Bloodwell/Blood Mirror effects, first-playtest prices, Relic mastery thresholds, Prosthetic unlock sequencing, Relic 4/2/4 source assignments, Blood Cavern trial roster/rewards, and save/progression flags.

## Pass 5 — Yomori

Define Yomori encounter pool/layout inventory, Embered Pilgrim, Rotwood Host, Twin Maws, and required region-specific hazard rules.

## Pass 6 — Kagutsuchi + Shogun + Heart

Define Kagutsuchi encounter pool/layout inventory, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Binding-space states, Unbound Heart, Vessel of Continuance, and first-clear vs repeat-suppression presentation/state differences.

## Pass 7 — Exact authored presentation/content

Finish NPC/Shogun scripts, Discovery Board/Lore entries, achievement names/triggers, tutorial/help text, records labels, ending/postgame lines, and final credits/legal text when dependencies are known.

This pass should not block combat implementation unless a specific interface requires the content earlier.

# Playtest-only tuning backlog

Do not turn these into planning blockers before the playable build can measure them:

- final damage/posture values,
- final attack/frame timing,
- final parry/dash windows,
- final enemy Health/damage,
- final encounter count/variety adjustments,
- final route/reward weights,
- final Technique rarity/source percentages,
- final Shop prices,
- final recovery/capacity values,
- final Mist/Scroll payouts/prices,
- final mastery thresholds,
- final Bloodwell/Blood Mirror percentages,
- final Prosthetic magnitudes,
- exact 45–50 / 55–60 minute pacing validation,
- VFX density, hitbox polish, camera timing, animation timing.

Use the approved first-playtest values, implement them, measure them, then update the owning authority when evidence supports a change.

# Question-quality filter

Before adding a new item here, ask:

1. Does implementation need this answer now?
2. Would leaving it undefined force a coder/content author to invent design?
3. Would answering it now prevent meaningful rework?
4. Can playtesting answer it more reliably than documentation?

If #4 is yes and the first three are no, do **not** add it as an open design question.
