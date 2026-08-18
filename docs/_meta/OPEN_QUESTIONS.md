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

# Completed implementation pass

## Pass 1 — Core combat implementation baseline — COMPLETE

The shared first-playtest combat contract is now approved in:

- `docs/gameplay/COMBAT.md` — shared combat rules/vocabulary,
- `docs/gameplay/COMBAT_IMPLEMENTATION_BASELINE.md` — first-playtest numeric/common-behavior values.

The baseline now defines:

- Akio Health/Posture/Spirit,
- neutral movement and dash values,
- parry/block/posture-break behavior,
- normalized standard-enemy Health/posture profiles,
- enemy posture recovery/deathblow readiness,
- Deathblow execution safety,
- shared attack data fields and modifier convention,
- proc normalization,
- universal backstab geometry/payoff,
- perilous-response classes,
- shared status-refresh conventions.

Do not reopen these values as planning questions unless implementation/playtesting exposes a concrete problem.

# Current priority — Pass 2: Player-build implementation sheets

**Question:** What first-playtest values and exact implementation behavior complete the already-approved player content?

This pass should make every launch player-build item instantiable in Godot without inventing missing combat behavior inside code.

## 2A. Blood Aspect implementation sheets — NEXT

Define first-playtest data for **Wolf, Wraith, and Ronin**.

For every Tier 0 sword action and relevant Tier mechanic, define the implementation fields actually needed by Godot, including:

- Health damage,
- posture damage,
- block-posture damage,
- startup / active / recovery timing,
- reach / geometry,
- movement or fixed-position behavior,
- tracking/facing rule,
- stagger level,
- proc coefficient,
- cancel/commitment behavior,
- Blood/Tier values where applicable,
- Aspect-specific posture/guard adjustments already allowed by the shared combat rules.

Prefer one consistent data-sheet format across all three Aspects.

**Exit condition:** Wolf, Wraith, and Ronin can each be implemented from their documentation without a coder deciding what an attack mechanically does.

## 2B. Technique implementation sheet

After the Aspect attacks are numeric enough to serve as hosts, fill the implementation fields for:

- 25 Direct Techniques,
- 15 Supporting Techniques,
- 5 Cross-family Techniques,
- 5 Legendaries,
- 10 refinements.

Define exact first-playtest values for damage/posture bonuses, proc thresholds, status duration, internal cooldowns, normalization/proc coefficients, replacement behavior, and other missing implementation fields.

Do not redesign the approved roster merely because numbers are being assigned.

## 2C. Prosthetic implementation sheet

Define for all 8 Prosthetics and 19 upgrades:

- Spirit cost,
- cooldown/charge behavior,
- startup / active / recovery,
- geometry/range,
- valid targets/immunity,
- Health/posture effects,
- status values/durations,
- exact first-playtest upgrade improvements.

## 2D. Relic implementation sheet

Define for all 10 Relics:

- Base effect value,
- Mastery I value,
- Mastery II value,
- qualifying trigger rules,
- any once-per-room/run/reset behavior,
- first-playtest mastery thresholds if needed for implementation.

## 2E. Corruption / Shrine / Blood numeric sheet

Fill any remaining first-playtest values required to instantiate:

- Corruption gain/loss,
- Resist/Embrace/Stabilize behavior,
- Tier thresholds,
- Blood generation/storage,
- Blood Art costs/effects,
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
