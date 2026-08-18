---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - open-questions
  - design-priority
  - encounter-authoring
  - playtest-validation
---

# Current Design Questions

This file contains only unresolved decisions that materially affect production, authored content, implementation, or playable validation.

Resolved rules and prototype values belong in their authoritative files and should **not** be copied here. Small cleanup decisions should not be promoted ahead of content-production work.

# Top-level launch scope status

**Oathbound's top-level launch architecture is closed at paper-design depth.**

The approved package now includes:

- three launch Blood Aspects: Wolf, Wraith, Ronin,
- 50 Techniques + 10 refinements,
- 10 Relics with two mastery ranks each,
- 8 Prosthetics with 19 permanent upgrades,
- 10 Akio Bloodwell + 8 Run Infrastructure + 9 Blood Mirror nodes,
- no general launch consumable inventory,
- 33-chamber three-region route,
- authored standard-combat encounter model,
- regional-native enemy rule with Blighted Hounds → Stalker Hound as the only approved launch cross-region lineage,
- route/reward/Technique/economy/survival/persistent-resource prototypes,
- six Binding clears followed by the seventh story Heart route,
- silent Akio and approved narrative-delivery volume,
- canonical Heart ending where the Heart permanently loses the ability to create/spread **new Beast Blood** while existing Beast Blood remains active,
- canonical postgame based on continued Heart suppression and existing-bearer containment,
- postgame Standard Expedition and Heart Suppression run goals,
- 100% completion framework and approximately 30 launch achievements,
- no required launch Heat/Pact, New Game+, endless, daily-challenge, extra-Aspect, or extra-progression package,
- front-end/save/settings/accessibility/localization/credits release scope.

Current authorities include:

- `docs/overview/ENDGAME_POSTGAME_RELEASE.md`
- `docs/gameplay/RUN_STRUCTURE.md`
- `docs/gameplay/PROGRESSION.md`
- `docs/lore/STORY_OVERVIEW.md`
- `docs/lore/BEAST_BLOOD.md`
- `docs/lore/RETURNING_BLOOD.md`
- `docs/lore/ECLIPSE_SHOGUN.md`
- `docs/narrative/NARRATIVE_DELIVERY.md`
- `docs/content/area_3/TRUE_FINAL_HEART.md`
- `docs/ui_ux/RUN_RESULTS.md`

# Current production-design sequence

The next work is **content realization**, not another top-level system pass.

## 1. Author regional standard-encounter pools

For Hushiro, Yomori, and Kagutsuchi:

- determine the practical number of launch encounters needed for replay variety,
- author each encounter's tactical theme and enemy composition,
- define enemy counts, waves, and spawn sequencing,
- add minimum-chamber/narrow eligibility only where a specific encounter needs it,
- preserve the approved regional-native enemy boundaries,
- test each encounter against multiple Aspects/build states.

The route generator selects among these authored encounters; it does not build compositions from a procedural threat budget.

## 2. Regional miniboss and boss encounter design

Move from role/concept into playable encounter packages for:

- six regional minibosses,
- Keeper of the Gate,
- Twin Maws,
- Eclipse Shogun.

Define actual phase/move structures, arena requirements, posture/Health expectations, readability, and build-neutral compatibility.

## 3. True-final Heart encounter design

Author the playable two-form encounter:

1. Unbound Heart,
2. Vessel of Continuance.

Keep the approved no-humanoid/no-weak-point-system boundary and postgame regeneration role.

## 4. Exact content realization

After encounter architecture is usable:

- exact NPC/boss scripts,
- exact Discovery Board entries,
- achievement trigger list/names,
- trial content realization,
- exact Relic acquisition sequencing,
- exact individual Blood Mirror effects within approved roles.

## 5. Playtest and numerical tuning

Validate:

- standard-room clear times,
- miniboss/boss durations,
- full 45–50 minute Binding-run target,
- 55–60 minute Heart/Suppression target,
- damage/posture values,
- Technique offer rates,
- route/reward weights,
- Shop prices,
- recovery/capacity percentages,
- Mist/Scroll payouts and costs,
- boss-material quantities,
- Relic mastery thresholds,
- Bloodwell/Blood Mirror values,
- Prosthetic values,
- frame data/VFX timing/hitboxes.

These are implementation/playtest variables and should not be reopened as new top-level architecture questions unless testing exposes a production-scope problem.
