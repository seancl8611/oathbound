---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-07
---

# Current Design Questions

This file contains only unresolved decisions that materially affect launch scope, content volume, production planning, interfaces, or authored presentation. Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here.

## Approved dependencies

- The launch Blood Aspect roster is **Wolf, Wraith, and Ronin**.
- All three Tier 0-IV Aspect packages are locked at current qualitative paper-design depth.
- No further Aspect or Tier comparison question is active unless prototyping exposes a concrete problem.
- A fourth or fifth Aspect is outside launch scope.
- Every run begins at Tier 0; Embrace advances the selected Aspect through its fixed path to Tier IV.
- Blood is run-only and unavailable before Tier II.
- Tier 0-I Technique-focused builds, Tier II hybrids, and deeper Tier III-IV Aspect builds must all remain viable.
- Mandatory encounters cannot assume a particular Aspect Tier or Blood Art.
- Exact damage, timing, hitboxes, growth percentages, collision, VFX timing, and other balance values remain prototype and implementation work.

Aspect authority remains in:

- `gameplay/WOLF_ASPECT.md`
- `gameplay/WRAITH_ASPECT.md`
- `gameplay/RONIN_ASPECT.md`
- `gameplay/BLOOD_ASPECTS.md`
- `gameplay/ASPECT_WEAPON_KIT_MODEL.md`
- `gameplay/ASPECT_IDENTITY_GUIDELINES.md`

## Priority order

1. Launch run-build content catalog
2. Persistent progression, onboarding, and trial package
3. Narrative delivery and authored-content package
4. Postgame release package

# 1. Launch run-build content catalog

**This is the current active question.**

Define the minimum complete and replayable launch catalog:

- approximate base Technique count and role distribution,
- universal action-tag coverage,
- Technique rarity roles,
- affinity and offer weighting,
- number and quality of refinements,
- post-fill offer construction and anti-dead-offer rules,
- allowed direct Aspect-, Tier-, or Blood-referencing entries,
- temporary Prosthetic Technique count per tool,
- initial Relic count and rarity distribution,
- whether consumables ship,
- and entries requiring unique icons, VFX, animation, or audio.

The coverage matrix belongs in `gameplay/TECHNIQUE_CATALOG.md`.

# 2. Persistent progression, onboarding, and trial package

Define the minimum launch package across the Bloodwell, Forge, Blood Mirror, and Blood Cavern:

- permanent node, rank, or branch counts,
- basic-combat onboarding trials,
- Aspect teaching and mastery trials,
- Technique demonstrations or mastery trials,
- unlock ownership,
- capped reliability upgrades,
- rewards and mastery marks,
- and required interface states.

Do not assume a duplicate Blood Art upgrade tree beneath every Aspect.

# 3. Narrative delivery and authored-content package

Define:

- first-death and Returning Blood awakening presentation,
- bloodline confirmation timing and evidence,
- Shogun dialogue progression and reconstruction presentation,
- NPC, codex, results, and Heart-chamber updates,
- ending and credits requirements,
- voice scope,
- and cinematic, portrait, in-engine, or environmental delivery ownership.

# 4. Postgame release package

Define:

- repeat access to the Heart route,
- repeat-clear rewards,
- launch completion goals such as records, marks, or cosmetics,
- and required Boat, results, save-state, and postgame UI states.

Additional difficulty settings, challenge modifiers, enemy variants, and room variants remain outside initial release unless explicitly promoted later.

## Deferred implementation and balance work

Keep exact values in their owning files, including:

- damage, posture, guard pressure, stagger, reach, movement, recovery, and interruption timing,
- hitboxes, collision, targeting, deathblow pathing, and blocker classifications,
- Blood capacity, gain values, proc weighting, and anti-farming rules,
- Feral Momentum, Spectral Edge, and Ronin posture-capacity scaling,
- Tier IV reach, extended deathblow range and angle, and Veilstride duration,
- room counts, route and reward probabilities, prices, rarity weights, and rerolls,
- permanent-upgrade percentages,
- and final animation frames, VFX density, audio timing, or HUD layout.