---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-16
---

# Current Design Questions

This file tracks unresolved decisions that materially affect launch scope, content volume, production planning, interfaces, or authored presentation.

Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here unless they expose a larger production-scope decision.

## Question hierarchy rule

Top-level questions should represent **large gameplay systems or production-wide packages**, not isolated subsystem details.

Examples of details that should remain nested beneath an owning package rather than become headline agenda items include:

- final Technique rarity probabilities or exact offer weights,
- exact Relic mastery thresholds, kill weighting, acquisition-source counts, Forge rank presentation, or transition-swap timing,
- individual Prosthetic upgrade percentages, Scroll costs, Spirit values, or status durations,
- exact Bloodwell node counts, Run Infrastructure values, or Blood Mirror mastery ranks,
- final shop prices, encounter values, or tuned route percentages after prototype validation,
- final animation timings, VFX timing, hitboxes, damage values, and other playtest tuning.

When a major system or package becomes the active design area, finish it at useful paper-design depth before moving to narrow balance work.

## Approved dependencies

- Launch Blood Aspects are **Wolf, Wraith, and Ronin**.
- All three Tier 0-IV Aspect packages are locked at qualitative paper-design depth.
- Five direct Technique slots are locked: **Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow**.
- Supporting, Cross-family, and Legendary Techniques are slotless; there is **no global Technique inventory cap**.
- The launch Technique catalog contains **50 actual Techniques plus 10 refinements** and is complete for current paper-design scope.
- Technique rarity, prerequisites, direct-slot ownership, Supporting / Cross-family / Legendary eligibility, and refinement ownership are approved.
- The launch Relic roster contains **10 Relics**, uses one equipped slot, persistent collection ownership, run-active effects, and **no rarity tiers**.
- Relics gain persistent mastery from eligible enemy kills while equipped; only the currently equipped Relic advances.
- Relic permanent progression and Strand-side management belong to the **Forge Bench** alongside Prosthetics. No separate Relic Reliquary is required in approved hub scope.
- Prosthetic Techniques are removed; Prosthetic progression is persistent and belongs to the Forge.
- The eight-Prosthetic launch roster and each tool's shallow linear Forge upgrade path are locked at qualitative paper-design depth.
- Scrolls remain the primary persistent Forge currency for Prosthetic development.
- The **Bloodwell** owns permanent progression for **Akio** and **Run Infrastructure**.
- Run Infrastructure is one umbrella covering approved permanent improvements to Rest support, Shrine support, rewards, routing/run conditions, regional transitions, and related expedition support rather than separate upgrade trees.
- The **Blood Mirror** owns permanent **Blood Aspect** progression, begins locked, and unlocks later through campaign/onboarding progression. Exact unlock timing and Aspect nodes remain later detailed design.
- Blood Cavern trials, Technique pool unlocks, Discovery Board progress, Merchant services, the Boat, and Heart Binding state are not separate permanent upgrade trees in current scope.
- Backstabs are a universal positional combat classification based on genuinely striking an enemy from behind.
- Mandatory encounters cannot assume a particular Aspect Tier, Blood Art, Technique family, Legendary, Relic, or highly upgraded Prosthetic.
- The standard successful-run target remains approximately **45–50 minutes**.
- The major-system production-scope audit is complete; no additional core gameplay system is currently required before continuing run integration.

## Approved three-region run-structure state

`docs/gameplay/RUN_STRUCTURE.md` owns the regional chamber and branching model. `docs/gameplay/ITEMS_AND_REWARDS.md` owns prototype room/reward weights and cadence.

### Hushiro Gate Village

- **12 counted chambers**.
- Chambers **1–3** opening, **4–8** main, **9–11** pre-boss, **12** Keeper of the Gate.
- Chamber 1 is fixed combat followed by a Technique reward.
- One optional miniboss opportunity appears during Chambers **5–8**, selecting Village Ogre or The Collector for that run.
- Route network contains at least one Shrine, Shop, Rest, miniboss opportunity, and three Technique-reward opportunities total including Chamber 1.
- Chamber 11 guarantees access to meaningful pre-boss preparation.
- Current active-time target: approximately **14–16 minutes**.

### Yomori Grove

- **10 counted chambers**.
- Chambers **1–2** opening, **3–7** main, **8–9** pre-boss, **10** Twin Maws.
- Branching begins immediately; Chamber 1 does not force a Technique reward.
- One optional miniboss opportunity appears during Chambers **4–7**, selecting The Embered Pilgrim or Rotwood Host for that run.
- Route network contains at least one Shrine, Shop, Rest, miniboss opportunity, and two Technique-reward opportunities.
- Chambers 8–9 ensure at least one meaningful pre-boss preparation route.
- Current active-time target: approximately **12–14 minutes**.

### Kagutsuchi Court

- **11 counted chambers**.
- Chambers **1–2** Court entrance, **3–7** main Court, **8–10** final Court / Shogun approach, **11** Eclipse Shogun.
- Branching begins immediately; no fixed opening Technique reward.
- One optional miniboss opportunity appears during Chambers **4–7**, selecting Blood Lotus or Eternal Swordsman for that run.
- Route network contains at least one Shrine, Shop, Rest, miniboss opportunity, two Technique-reward opportunities, and one meaningful final-preparation opportunity across Chambers 9–10.
- Heart approach, Binding completion, and the true-final Heart are outside Kagutsuchi's counted chamber total.
- Current active-time target: approximately **15–17 minutes**.

### Shared route-generation prototype

- Current regional baseline is **33 counted chambers total: 12 + 10 + 11**.
- Branch count prototype:
  - opening: **50% one exit / 50% two exits**,
  - main: **25% one exit / 70% two exits / 5% three exits**,
  - pre-boss/final: **45% one exit / 55% two exits**.
- Three-exit choices are main-stretch only and capped at one per region.
- Current target is roughly **17–19 multi-exit decisions** across a normal successful run.
- Room-type prototype weights by band:
  - opening: **82% Combat / 6% Shrine / 4% Rest / 2% Shop / 6% Treasure**,
  - main: **70% Combat / 8% Shrine / 7% Rest / 7% Shop / 8% Treasure**,
  - pre-boss/final: **58% Combat / 5% Shrine / 13% Rest / 13% Shop / 11% Treasure**.
- Minibosses and bosses are injected/fixed rather than rolled from the room table.
- Standard-combat Technique weight declines from **36% Hushiro → 32% Yomori → 28% Kagutsuchi** as survival/optimization value rises.
- Normal successful-route targets include roughly **20–22 standard combat chambers**, **7–9 Technique pickups for a Technique-invested run**, **4–5 Shrine opportunities**, and approximately **1–2 visits each to Shops, Rests, Treasures, and minibosses**.
- Consumables have **0% primary room-reward weight** in this first prototype.
- Previewed choices, hard opportunity safeguards, no routine backtracking, no duplicate primary rewards on normal two-door choices, no back-to-back ordinary safe-service rooms, and dead-late-Gold suppression remain part of controlled generation.
- These percentages are approved prototype values and may be tuned through playtesting without reopening the underlying architecture.

## Approved Technique roster state

The Technique content roster is complete for current paper-design scope. `docs/gameplay/TECHNIQUE_CATALOG.md` owns the full 50-Technique roster, individual rarities, Supporting / Cross-family / Legendary prerequisites, and the 10 refinements.

The roster should not be expanded merely to hit a larger count. New or replacement Techniques should be added only when prototype or integration testing exposes a concrete gap, overlap, balance issue, readability problem, or compatibility problem.

The active Technique-system question is now **offer generation and rarity/source weighting**: how eligible Techniques are selected into the reward screen, how rarity changes by source and region, and how replacement/refinement/Legendary opportunities are prevented from crowding out basic build formation.

## Approved Relic state

`docs/gameplay/RELICS.md` owns the approved **10-Relic launch roster**, system boundaries, and mastery direction.

Relic progression is based on combat use: only the equipped Relic receives persistent mastery from eligible enemy kills earned while it is equipped. Switching during approved run transitions redirects future kill progress to the newly equipped Relic. The **Forge Bench** owns Relic progression / management at the Strand, while exact rank realization, costs if any, mastery thresholds, acquisition sources, and transition-swap timing remain later detailed decisions.

## Approved Prosthetic / Forge state

`docs/gameplay/PROSTHETICS.md` owns the approved eight-tool roster and permanent Prosthetic Forge paths.

The roster remains:

- Beast-Bane Whistle
- Thunder Rod
- Smoke Gourd
- Fang Harpoon
- Mirror Umbrella
- Flame Vent
- Mist Raven
- Bloodletting Gourd

The Prosthetic progression structure is locked as **shallow and linear**. Two upgrades are the default; a third is used only when a base tool already contains multiple distinct properties worth improving. Current paths contain no mutually exclusive branches.

Forge upgrades improve properties already present in the unlocked tool. They do not add alternate attacks, new combat roles, unrelated statuses, new active abilities, or another Technique-style build layer.

Exact costs, percentages, Spirit values, damage, status values, timing, and unlock thresholds remain implementation/playtest tuning rather than top-level design blockers.

## Approved permanent-upgrade station scope

Current launch scope uses three permanent upgrade stations:

1. **Bloodwell — Akio + Run Infrastructure**
2. **Forge Bench — Prosthetics + Relics**
3. **Blood Mirror — Blood Aspects**, with the Mirror locked at the beginning and introduced later

Exact node rosters, values, rank counts, currencies beyond already approved ownership, interface layouts, mastery thresholds, and precise unlock timing are intentionally deferred.

The old Forge weapon-development model, fixed Bloodwell `Way of Steel / Way of Secrets / Way of Vows` tree, separate Relic Reliquary direction, and four-active-plus-reserve Technique loadout are not current design.

# Priority order

1. **Complete full-run integration, rewards, encounters, and pacing**
2. **Define narrative delivery and campaign presentation**
3. **Define endgame, postgame, and release scope**

# 1. Full-run integration, rewards, encounters, and pacing

The 33-chamber structure and first controlled-procedural branch/room/reward weighting model are approved at prototype level.

Continue one layer deeper by defining **Technique offer generation and rarity/source weighting**:

- number of Technique choices shown per reward,
- rarity probabilities by region and reward source,
- offer-generation order after eligibility filtering,
- how empty direct slots compete with Supporting/refinement/Cross-family opportunities,
- rare same-slot replacement frequency,
- Legendary appearance behavior after prerequisites are met,
- duplicate/repeat-family handling,
- source quality bonuses for Treasure, minibosses, Shops, and regional bosses,
- reroll behavior,
- and safeguards against reward screens that are technically valid but strategically dead.

After that, continue into:

- Gold income and Shop pricing,
- exact Shop inventory structure,
- regional boss current-run reward weighting,
- Relic acquisition allocation and transition-swap placement,
- remaining recovery/capacity values,
- encounter composition and expected clear-time tuning,
- and playable validation of the 45–50-minute successful-run target.

The numerical values in this package remain **prototype targets**, not immutable final balance law. Final combat damage/stats, economy tuning, and generation percentages require playable validation.

# 2. Narrative delivery and campaign presentation

The story spine, Heart Binding structure, major lore, Shogun motivation, Returning Blood foundation, and ending are already approved at high level.

Define how much authored content is actually required to deliver that story across repeated runs:

- introductory attempt and first-death presentation,
- bloodline / Returning Blood reveal timing,
- Shogun dialogue progression across repeated encounters,
- NPC dialogue and Strand updates,
- codex / Discovery Board ownership,
- Binding-clear presentation and campaign-state communication,
- portrait / cinematic / voice-acting scope,
- ending and credits presentation,
- and the final writing / localization inventory required for launch.

Detailed line counts and final scripts should follow only after this delivery package is scoped.

# 3. Endgame, postgame, and release scope

Define what the player can do after the first canonical Heart victory and what presentation is required for a complete initial release.

At broad scope, establish:

- how repeat Heart-route access works after story completion,
- whether repeat Heart clears provide unique rewards or primarily mastery / record value,
- launch completion goals, achievements, records, or optional mastery objectives,
- required postgame UI states and save-state communication,
- front-end / settings / credits / completion presentation still needed for release,
- and whether any additional challenge-mode, modifier, variant, or New-Game-style system is truly required for launch or should remain post-launch scope.

Do not expand the base game with difficulty modifiers, large variant systems, or additional Aspects merely to create postgame volume unless playable testing demonstrates a clear need.

## Deferred implementation and balance work

Keep final values in their owning files, including damage, posture, Rupture buildup/decay, Seal slow/duration/expiry, protected-enemy control resistance, Rift fuse/intensity/damage, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc damage/width, Predator's Wake radius, Legendary durations, tuned room/reward probability weights after prototype validation, prices, final rarity probabilities, final offer weights, replacement rates, Relic mastery thresholds/kill weighting/acquisition allocation, Prosthetic upgrade percentages/costs, Bloodwell/Run Infrastructure node values, Blood Mirror Aspect-upgrade values, and final VFX/animation timing.