---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-14
---

# Current Design Questions

This file contains unresolved decisions that materially affect launch scope, content volume, production planning, interfaces, or authored presentation. Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here.

## Approved dependencies

- Launch Blood Aspects are **Wolf, Wraith, and Ronin**.
- All three Tier 0-IV Aspect packages are locked at qualitative paper-design depth.
- Five direct Technique slots are locked: **Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow**.
- The complete **25-Technique direct matrix is approved** at qualitative paper-design depth.
- The current working launch Technique catalog contains **50 actual Techniques plus 10 refinements**.
- The 50 Techniques consist of 25 direct, 15 same-family Supporting, 5 Cross-family, and 5 Legendary Techniques.
- Current rarity distribution is **10 Common / 18 Uncommon / 17 Rare / 5 Legendary**.
- Refinements have no rarity and are not separate Techniques.
- Direct Techniques have no family prerequisite and are normally eligible while their combat slot is empty.
- Supporting Techniques require an already-owned effect that can actually interact with the support.
- Cross-family Techniques require investment in both listed families plus any entry-specific mechanic requirement.
- Legendaries require **3 native Techniques from that family**, including at least **1 slotted Technique**. Same-family Supporting Techniques count; Cross-family Techniques and refinements do not.
- A slotted Technique may receive at most one refinement, and the parent Technique must already be owned.
- There is no global cap on slotless Supporting Techniques.
- Filled direct slots normally remain committed; rare replacement offers may overwrite that same slot.
- All Technique rewards use the same underlying reward screen regardless of source.
- Prosthetic Techniques are removed; Prosthetic progression is persistent and belongs to the Forge.
- Backstabs are a universal positional combat classification based on genuinely striking an enemy from behind.
- Mandatory encounters cannot assume a particular Aspect Tier, Blood Art, Technique family, or Legendary.

## Approved Technique roster state

The current Technique roster is complete for paper-design scope. `docs/gameplay/TECHNIQUE_CATALOG.md` owns the full 50-Technique roster, individual rarities, Supporting / Cross-family / Legendary prerequisites, and the 10 refinements.

The roster should not be expanded merely to hit a larger count. New or replacement Techniques should be added only when the later audit or prototype exposes a concrete gap, overlap, balance issue, readability problem, or compatibility problem.

## Priority order

1. Finish Technique reward-offer structure and roster audit
2. Finish Relic / consumable run-build scope
3. Scope permanent Prosthetic progression and the wider Forge package
4. Persistent progression, onboarding, and trial package
5. Narrative delivery and authored-content package
6. Postgame release package

# 1. Technique reward structure and roster audit

**This is the current active Technique area.**

Technique content creation, rarity assignment, and prerequisite / eligibility design are no longer open questions.

Next establish:

1. **Reward frequency** — how many Technique opportunities a normal successful run should produce.
2. **Offer-generation order** — whether the game builds the eligible pool first and then weights rarity, or rolls rarity first and resolves eligible entries afterward.
3. **Rarity probabilities / source weighting** — how Common, Uncommon, Rare, and Legendary offers are distributed across combat rooms, shops, treasure, minibosses, bosses, and other approved sources.
4. **Rare replacement behavior** — how often an occupied direct slot can receive an explicit overwrite offer and what confirmation / comparison presentation it requires.
5. **Roster audit** — test all 50 Techniques across Wolf, Wraith, Ronin, bosses, groups, multi-hit normalization, backstab access, mixed-family builds, AoE / control limits, and visual readability.

The audit should also verify that prerequisite rules never create dead reward offers and that the three-native-Technique Legendary gate produces realistic but rare capstone access within the run-duration target.

# 2. Remaining run-build catalog

After the Technique reward structure is coherent, define:

- initial Relic count and final rarity structure,
- whether consumables ship,
- competition between Technique rewards and other route rewards,
- and entries requiring unique icons, VFX, animation, or audio.

# 3. Permanent Prosthetic / Forge scope

Define individual permanent upgrade paths for the eight Prosthetics through the Forge.

Scrolls are currently the persistent Forge currency. Exact branch counts, ranks, costs, and tool-specific upgrade depth remain open.

# 4. Persistent progression, onboarding, and trial package

Define the minimum launch package across the Bloodwell, Forge, Blood Mirror, and Blood Cavern.

# 5. Narrative delivery and authored-content package

Define first-death presentation, bloodline confirmation, Shogun dialogue progression, codex / NPC updates, ending / credits requirements, voice scope, and delivery ownership.

# 6. Postgame release package

Define repeat Heart-route access, repeat-clear rewards, launch completion goals, and required postgame UI states.

## Deferred implementation and balance work

Keep exact values in their owning files, including damage, posture, Rupture buildup/decay, Seal slow/duration/expiry, protected-enemy control resistance, Rift fuse/intensity/damage, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc damage/width, Predator's Wake radius, Legendary durations, room probabilities, prices, rarity probabilities, offer weights, replacement rates, permanent-upgrade percentages, and final VFX/animation timing.
