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

Top-level questions should represent **large game-wide or production-wide packages**, not isolated subsystem details.

Examples of details that should remain nested beneath an owning package rather than become headline agenda items include:

- exact Technique reward frequency or rarity probabilities,
- exact Relic rank thresholds, acquisition-source counts, or swap timing,
- individual Prosthetic upgrade percentages or node costs,
- exact room counts, route probabilities, shop prices, or reward weights,
- final animation timings, VFX timing, hitboxes, damage values, and other playtest tuning.

When a major package becomes the active design area, narrow into its detailed questions only as needed. Do not allow a small unresolved detail to displace broader unfinished areas of the game from the top of the agenda.

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

Remaining Technique reward-frequency, offer-weighting, replacement, and roster-audit work belongs inside the broader **launch run-build and preparation package** below. It is no longer the game's top-level design question by itself.

# Priority order

1. **Launch run-build and pre-run preparation package**
2. **Strand hub and permanent-progression package**
3. **Full-run integration, encounter, and pacing package**
4. **Narrative delivery and campaign-presentation package**
5. **Endgame, postgame, and release package**

# 1. Launch run-build and pre-run preparation package

Define the remaining launch-facing structure around what Akio brings into a run, what he discovers during the run, and how the major run-build systems compete for attention without becoming redundant.

At broad scope, finish:

- the **Relic system's launch role and catalog scope**, including its simple one-slot identity, persistent collection boundary, run-only equipped benefit, and relationship to Techniques / Aspects / Prosthetics,
- whether **consumables** add enough value to justify launch inclusion,
- the **pre-run selection experience** for Aspect, Prosthetic, and Relic through distinct Strand interactibles while keeping the Boat focused on run-start confirmation,
- the overall relationship between **Techniques, Relics, Shrines, economy, survival rewards, and route choices** so no run-build layer crowds out the others,
- and whether the current reward ecosystem gives the player enough meaningful decisions across a normal successful run.

Only after that broad structure is coherent should this package narrow into details such as:

- Relic roster entries, shallow upgrade / mastery behavior, exact swap opportunities, and acquisition-source allocation,
- Technique reward frequency, eligible-pool generation, rarity/source weighting, and rare replacement behavior,
- exact reward-source competition and fallback behavior,
- and the final cross-Aspect / boss / readability audit of the 50-Technique roster.

These detailed items are important for implementation, but they are subordinate to the larger question of whether Oathbound's complete run-build ecosystem is coherent and appropriately scoped.

# 2. Strand hub and permanent-progression package

Define the Strand as a complete between-run gameplay space rather than solving each service in isolation.

At broad scope, establish:

- the permanent progression available through the **Bloodwell**,
- the permanent **Prosthetic / Forge** development package for all eight tools,
- the long-term progression or mastery role, if any, for **Relics** and Blood Aspects,
- the purpose and launch depth of the **Blood Mirror and Blood Cavern** trial / mastery systems,
- the unlock and onboarding flow across the Strand's services,
- the final physical ownership of run-preparation interactibles such as the Aspect selection station, Prosthetic selection station, Relic Reliquary, Forge Bench, and Boat,
- and whether the four persistent / run currencies have enough meaningful uses without creating unnecessary upgrade economies.

After this package is coherent, narrow into individual Forge paths, rank counts, costs, trial rewards, mastery thresholds, exact unlock timing, and interface states.

# 3. Full-run integration, encounter, and pacing package

Review Oathbound as one complete playable run from the Strand through Hushiro, Yomori, Kagutsuchi, the Eclipse Shogun, and eventual Heart progression.

At broad scope, verify:

- the three-region sequence provides enough change in combat demands and pacing,
- standard combat rooms, Shrines, Rest rooms, Shops, treasure / miniboss rooms, regional bosses, and transition spaces each have a clear purpose,
- regional-boss transitions provide the correct recovery / preparation opportunities without becoming overloaded menus,
- enemy, miniboss, boss, Aspect, Technique, Prosthetic, Relic, Shrine, and economy systems can coexist without any one layer invalidating the others,
- the current 45–50 minute successful-run target still appears plausible once the full system set is playable,
- and no major encounter, room, reward, or run-flow system is missing from launch scope.

Exact room counts, route algorithms, branch frequency, reward probabilities, encounter compositions, enemy values, and pacing numbers remain prototype / playtest work unless testing reveals a production-scope change.

# 4. Narrative delivery and campaign-presentation package

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

# 5. Endgame, postgame, and release package

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
