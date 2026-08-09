---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-09
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
- Mandatory encounters cannot assume a particular Aspect Tier, Blood Art, Technique family, or Legendary.
- Exact damage, timing, hitboxes, growth percentages, collision, VFX timing, and other balance values remain prototype and implementation work.

## Technique architecture now approved

- Techniques are the main horizontal run-build layer around the selected Aspect.
- There is **no global cap on total Technique upgrades**.
- Five core combat slots may each hold one direct Technique: **Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow**.
- Direct Techniques do not stack within the same combat slot.
- A filled slot normally remains committed; rare replacement offers may overwrite that slot.
- Slotless supporting Techniques may deepen an existing family, create cross-family synergy, or improve broader Technique behavior.
- A slotted Technique may receive at most one refinement.
- Technique rarity uses **Common / Uncommon / Rare / Legendary**.
- Some Legendary Techniques may use family-investment prerequisites; exact thresholds remain open.
- Internal effect families must be broad enough to affect several core combat slots and support comparable build depth.
- Family names and player-facing presentation are not locked; the player may ultimately recognize them mainly through symbols, color, VFX, or effect language.
- Generic elemental schools are not the target. Familiar functions such as slow, AoE, extra reach, delayed damage, chaining, restraint, or recovery should be expressed through Oathbound-specific samurai / Returning Blood themes.

## Priority order

1. Launch Technique roster and family design
2. Remaining run-build catalog: Prosthetic Techniques, Relics, consumables
3. Persistent progression, onboarding, and trial package
4. Narrative delivery and authored-content package
5. Postgame release package

# 1. Launch Technique roster and family design

**This is the current active design area.**

Define the first small set of broad internal effect families, then map them against the five core combat slots.

The next roster pass should answer:

- what each family fundamentally does,
- how each family can affect Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow without feeling forced,
- which direct Techniques are strongest enough to define one of those slots,
- what slotless supporting Techniques deepen focused and hybrid builds,
- which effects deserve refinements,
- which rare offers may replace an occupied combat slot,
- what Legendary / capstone concepts exist and what prerequisite depth is reasonable,
- and how the full roster performs across Wolf, Wraith, Ronin, bosses, groups, and realistic trigger frequency.

Do **not** lock the old ~30-Technique total or the old Blade / Deflection / Execution / Movement / General quotas. The final launch count should emerge from the new roster architecture.

The working roster belongs in `gameplay/TECHNIQUE_CATALOG.md`.

# 2. Remaining run-build catalog

After the core Technique roster is coherent, define:

- how Prosthetic-specific temporary upgrades fit the new slot structure,
- initial Relic count and final rarity structure,
- whether consumables ship,
- reward-room frequency and offer construction,
- and entries requiring unique icons, VFX, animation, or audio.

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

Do not assume a duplicate Blood Art upgrade tree beneath every Aspect.

# 4. Narrative delivery and authored-content package

Define:

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

Keep exact values in their owning files, including:

- damage, posture, guard pressure, stagger, reach, movement, recovery, and interruption timing,
- hitboxes, collision, targeting, deathblow pathing, and blocker classifications,
- Blood capacity, gain values, proc weighting, and anti-farming rules,
- Aspect growth percentages,
- room counts, route and reward probabilities, prices, rarity weights, replacement rates, and rerolls,
- permanent-upgrade percentages,
- and final animation frames, VFX density, audio timing, or HUD layout.
