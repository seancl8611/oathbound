---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-14
---

# Current Design Questions

This file tracks unresolved decisions that materially affect launch scope, content volume, production planning, interfaces, or authored presentation.

Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here.

## Question hierarchy rule

Top-level questions should represent **large gameplay systems or production-wide packages**, not isolated subsystem details.

Examples of details that should remain nested beneath an owning package rather than become headline agenda items include:

- exact Technique reward frequency or rarity probabilities,
- exact Relic rank thresholds, acquisition-source counts, or swap timing,
- individual Prosthetic upgrade percentages or node costs,
- exact room counts, route probabilities, shop prices, or reward weights,
- final animation timings, VFX timing, hitboxes, damage values, and other playtest tuning.

When a major system or package becomes the active design area, finish it at useful qualitative paper-design depth before moving to the next major area. Narrow into detailed questions only as needed; do not let a small unresolved detail displace the established design trajectory.

## Approved dependencies

- Launch Blood Aspects are **Wolf, Wraith, and Ronin**.
- All three Tier 0-IV Aspect packages are locked at qualitative paper-design depth.
- Five direct Technique slots are locked: **Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow**.
- The current launch Technique catalog contains **50 actual Techniques plus 10 refinements** and is complete for current paper-design scope.
- Technique rarity, prerequisites, direct-slot ownership, Supporting / Cross-family / Legendary eligibility, and refinement ownership are approved.
- Prosthetic Techniques are removed; Prosthetic progression is persistent and belongs to the Forge.
- Backstabs are a universal positional combat classification based on genuinely striking an enemy from behind.
- Mandatory encounters cannot assume a particular Aspect Tier, Blood Art, Technique family, or Legendary.
- The standard successful-run target remains approximately **45–50 minutes**, with exact room and reward cadence deferred to playable validation.

## Approved Technique roster state

The Technique content roster is complete for current paper-design scope. `docs/gameplay/TECHNIQUE_CATALOG.md` owns the full 50-Technique roster, individual rarities, Supporting / Cross-family / Legendary prerequisites, and the 10 refinements.

The roster should not be expanded merely to hit a larger count. New or replacement Techniques should be added only when prototype or integration testing exposes a concrete gap, overlap, balance issue, readability problem, or compatibility problem.

Remaining Technique reward-frequency, offer-weighting, replacement, and roster-audit work is still required, but it is a later integration/tuning layer and should not interrupt the current system-design sequence.

# Priority order

1. **Finish the Relic system and launch roster**
2. **Define permanent Prosthetic / Forge progression**
3. **Complete the wider Strand, permanent-progression, onboarding, and trial package**
4. **Review full-run integration, rewards, encounters, and pacing**
5. **Define narrative delivery and campaign presentation**
6. **Define endgame, postgame, and release scope**

# 1. Finish the Relic system and launch roster

Relics are the current active design area. Finish them at qualitative paper-design depth before moving on.

At broad scope, establish:

- the final role of Relics alongside Aspects, Techniques, and Prosthetics,
- the one-slot equipped structure and persistent-collection / run-only-benefit boundary,
- whether the current no-rarity direction is retained,
- the pre-run Relic selection experience through a dedicated Strand interactible rather than the Boat,
- the broad in-run replacement / swap boundary,
- whether shallow permanent Relic mastery or upgrading adds value without becoming another large progression tree,
- and the **launch Relic roster**: enough simple, distinct effects to make discovery and experimentation worthwhile without overlapping the larger build systems.

The current direction favors simple, readable, often one-line benefits rather than another family/prerequisite/meter system.

After the role and roster are coherent, exact acquisition-source allocation, rank thresholds, encounter counts, swap timing, and balance values can remain implementation or later-content decisions.

Once this Relic package is complete, move directly to Prosthetics / Forge rather than continuing into small Relic tuning questions.

# 2. Permanent Prosthetic / Forge progression

The eight launch Prosthetic tools and their tactical roles already exist. The next major gameplay-system pass after Relics is to define how those tools develop persistently through the Forge.

At broad scope, establish:

- the meaningful upgrade identity for each of the eight Prosthetics,
- whether each tool uses a short linear path, small branching path, or another consistent shallow structure,
- what kinds of upgrades are allowed without turning Prosthetics into a second Technique system,
- how upgrade depth compares across the eight tools,
- and what the Forge must support at launch for those paths to feel complete.

Scrolls remain the current persistent Forge currency.

Do not make exact node counts, percentage values, costs, unlock thresholds, cooldown values, or damage numbers top-level blockers. Those should follow the qualitative path design and later playtesting.

# 3. Strand hub, permanent progression, onboarding, and trials

After Relics and Prosthetic progression are coherent, review the Strand as the complete between-run layer.

At broad scope, establish:

- the permanent progression available through the **Bloodwell**,
- the long-term mastery role, if any, for Blood Aspects and Relics,
- the purpose and launch depth of the **Blood Mirror and Blood Cavern** trial / mastery systems,
- the unlock and onboarding flow across Strand services,
- the physical preparation interactibles for Aspect selection, Prosthetic selection, Relic selection, the Forge Bench, and the Boat,
- and whether Mist, Scrolls, Boss Emblems, and Gold each have sufficiently clear ownership without creating unnecessary upgrade economies.

The current preparation direction favors separate small physical selection interactibles, while the Boat remains focused on a simple run-start confirmation.

After this package is coherent, narrow into exact trial counts, mastery thresholds, unlock timing, permanent-upgrade values, interface states, and currency costs.

# 4. Full-run integration, rewards, encounters, and pacing

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

This is also where the remaining Technique reward cadence, eligible-pool generation, rarity/source weighting, rare replacement behavior, and full 50-Technique compatibility/readability audit should be resolved when enough of the complete run exists to judge them properly.

Exact room counts, route algorithms, branch frequency, reward probabilities, encounter compositions, enemy values, prices, and pacing numbers remain prototype / playtest work unless testing reveals a production-scope change.

# 5. Narrative delivery and campaign presentation

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

# 6. Endgame, postgame, and release scope

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

Keep exact values in their owning files, including damage, posture, Rupture buildup/decay, Seal slow/duration/expiry, protected-enemy control resistance, Rift fuse/intensity/damage, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc damage/width, Predator's Wake radius, Legendary durations, room probabilities, prices, rarity probabilities, offer weights, replacement rates, Relic rank thresholds, permanent-upgrade percentages, route probabilities, and final VFX/animation timing.
