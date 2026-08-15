---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-15
---

# Current Design Questions

This file tracks unresolved decisions that materially affect launch scope, content volume, production planning, interfaces, or authored presentation.

Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here.

## Question hierarchy rule

Top-level questions should represent **large gameplay systems or production-wide packages**, not isolated subsystem details.

Examples of details that should remain nested beneath an owning package rather than become headline agenda items include:

- exact Technique reward frequency or rarity probabilities,
- exact Relic mastery thresholds, kill weighting, acquisition-source counts, or transition-swap timing,
- individual Prosthetic upgrade percentages, Scroll costs, Spirit values, or status durations,
- exact room counts, route probabilities, shop prices, or reward weights,
- final animation timings, VFX timing, hitboxes, damage values, and other playtest tuning.

When a major system or package becomes the active design area, finish it at useful qualitative paper-design depth before moving to the next major area.

## Approved dependencies

- Launch Blood Aspects are **Wolf, Wraith, and Ronin**.
- All three Tier 0-IV Aspect packages are locked at qualitative paper-design depth.
- Five direct Technique slots are locked: **Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow**.
- The launch Technique catalog contains **50 actual Techniques plus 10 refinements** and is complete for current paper-design scope.
- Technique rarity, prerequisites, direct-slot ownership, Supporting / Cross-family / Legendary eligibility, and refinement ownership are approved.
- The launch Relic roster contains **10 Relics**, uses one equipped slot, persistent collection ownership, run-active effects, and **no rarity tiers**.
- Relics gain persistent mastery from eligible enemy kills while equipped; only the currently equipped Relic advances.
- Relics may be switched during approved run-transition opportunities and are **not upgraded at the Forge Bench**.
- Prosthetic Techniques are removed; Prosthetic progression is persistent and belongs to the Forge.
- The eight-Prosthetic launch roster and each tool's shallow linear Forge upgrade path are locked at qualitative paper-design depth.
- Scrolls remain the primary persistent Forge currency for Prosthetic development.
- Backstabs are a universal positional combat classification based on genuinely striking an enemy from behind.
- Mandatory encounters cannot assume a particular Aspect Tier, Blood Art, Technique family, Legendary, Relic, or highly upgraded Prosthetic.
- The standard successful-run target remains approximately **45–50 minutes**, with exact room and reward cadence deferred to playable validation.

## Approved Technique roster state

The Technique content roster is complete for current paper-design scope. `docs/gameplay/TECHNIQUE_CATALOG.md` owns the full 50-Technique roster, individual rarities, Supporting / Cross-family / Legendary prerequisites, and the 10 refinements.

The roster should not be expanded merely to hit a larger count. New or replacement Techniques should be added only when prototype or integration testing exposes a concrete gap, overlap, balance issue, readability problem, or compatibility problem.

Remaining Technique reward-frequency, offer-weighting, replacement, and roster-audit work is later integration/tuning work.

## Approved Relic state

`docs/gameplay/RELICS.md` owns the approved **10-Relic launch roster**, system boundaries, and mastery direction.

Relic progression is based on combat use: only the equipped Relic receives persistent mastery from eligible enemy kills earned while it is equipped. Switching during approved run transitions redirects future kill progress to the newly equipped Relic. Relics do not use Forge currencies and are not upgraded at the Forge.

Exact acquisition sources, mastery rank count, kill weighting, thresholds, transition-swap timing, and numerical values remain nested later decisions.

## Approved Prosthetic / Forge state

`docs/gameplay/PROSTHETICS.md` owns the approved eight-tool roster and permanent Forge paths.

The roster remains:

- Beast-Bane Whistle
- Thunder Rod
- Smoke Gourd
- Fang Harpoon
- Mirror Umbrella
- Flame Vent
- Mist Raven
- Bloodletting Gourd

The progression structure is locked as **shallow and linear**. Two upgrades are the default; a third is used only when a base tool already contains multiple distinct properties worth improving. Current paths contain no mutually exclusive branches.

Forge upgrades improve properties already present in the unlocked tool. They do not add alternate attacks, new combat roles, unrelated statuses, new active abilities, or another Technique-style build layer.

Current qualitative paths are:

- **Beast-Bane Whistle:** stronger interrupt/stagger → larger pulse radius.
- **Thunder Rod:** stronger direct hit → longer Shock.
- **Smoke Gourd:** larger cloud → longer persistence.
- **Fang Harpoon:** greater eligible pull → stronger interruption/posture impact.
- **Mirror Umbrella:** greater pressure storage → improved Spirit efficiency → stronger posture release.
- **Flame Vent:** greater cone reach → stronger direct Health damage → longer Burn.
- **Mist Raven:** improved Spirit efficiency → modestly greater fixed short-range blink distance.
- **Bloodletting Gourd:** stronger immediate heal → longer healing-on-hit window → stronger healing-on-hit return.

Exact costs, percentages, Spirit values, damage, status values, timing, and unlock thresholds remain implementation/playtest tuning rather than top-level design blockers.

# Priority order

1. **Complete the wider Strand, permanent-progression, onboarding, and trial package**
2. **Review full-run integration, rewards, encounters, and pacing**
3. **Define narrative delivery and campaign presentation**
4. **Define endgame, postgame, and release scope**

# 1. Strand hub, permanent progression, onboarding, and trials

With the Relic and Prosthetic progression directions established, review the Strand as the complete between-run layer.

At broad scope, establish:

- the permanent progression available through the **Bloodwell**,
- the long-term mastery role, if any, for Blood Aspects beyond their existing run Tier paths,
- the purpose and launch depth of the **Blood Mirror and Blood Cavern** trial / mastery systems,
- the unlock and onboarding flow across Strand services,
- the physical preparation interactibles for Aspect selection, Prosthetic selection, Relic selection, the Forge Bench, and the Boat,
- how in-run Relic transition swaps are presented without encouraging combat-time micromanagement,
- and whether Mist, Scrolls, Boss Emblems, and Gold each have sufficiently clear ownership without creating unnecessary upgrade economies.

The current preparation direction favors separate small physical selection interactibles, while the Boat remains focused on a simple run-start confirmation.

After this package is coherent, narrow into exact trial counts, mastery thresholds, unlock timing, permanent-upgrade values, interface states, and currency costs.

# 2. Full-run integration, rewards, encounters, and pacing

Review Oathbound as one complete playable run from the Strand through Hushiro, Yomori, Kagutsuchi, the Eclipse Shogun, and eventual Heart progression.

At broad scope, verify:

- the three-region sequence provides enough change in combat demands and pacing,
- standard combat rooms, Shrines, Rest rooms, Shops, treasure / miniboss rooms, regional bosses, and transition spaces each have a clear purpose,
- regional-boss transitions provide appropriate recovery and limited preparation opportunities without becoming overloaded menus,
- enemy, miniboss, boss, Aspect, Technique, Prosthetic, Relic, Shrine, and economy systems can coexist without one layer invalidating the others,
- Techniques, Relics, Shrines, economy, survival rewards, and route choices compete for attention at a healthy level,
- whether consumables add enough value to justify launch inclusion,
- the current 45–50 minute successful-run target still appears plausible once the full system set is playable,
- and no major encounter, room, reward, or run-flow system is missing from launch scope.

This is also where remaining Technique reward cadence, eligible-pool generation, rarity/source weighting, rare replacement behavior, full roster compatibility/readability audit, Relic acquisition allocation, Relic kill/mastery tuning, transition-swap placement, and exact Forge balance should be resolved when enough of the complete run exists to judge them properly.

Exact room counts, route algorithms, branch frequency, reward probabilities, encounter compositions, enemy values, prices, and pacing numbers remain prototype/playtest work unless testing reveals a production-scope change.

# 3. Narrative delivery and campaign presentation

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

# 4. Endgame, postgame, and release scope

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

Keep exact values in their owning files, including damage, posture, Rupture buildup/decay, Seal slow/duration/expiry, protected-enemy control resistance, Rift fuse/intensity/damage, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc damage/width, Predator's Wake radius, Legendary durations, room probabilities, prices, rarity probabilities, offer weights, replacement rates, Relic mastery thresholds/kill weighting/acquisition allocation, Prosthetic upgrade percentages/costs, route probabilities, and final VFX/animation timing.
