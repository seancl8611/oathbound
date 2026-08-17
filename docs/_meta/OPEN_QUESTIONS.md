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

Top-level questions should represent **large gameplay systems or production-wide packages**, not isolated subsystem tuning.

Examples of details that should remain nested beneath an owning package rather than become headline agenda items include:

- final Technique rarity probabilities or final offer weights after prototype validation,
- final Shop prices, Gold values, recovery percentages, or capacity percentages,
- exact Relic mastery thresholds, kill weighting, acquisition-source counts, Forge rank presentation, or transition-swap timing,
- individual Prosthetic upgrade percentages, Scroll costs, Spirit values, or status durations,
- exact Bloodwell node counts, Run Infrastructure values, or Blood Mirror mastery ranks,
- final encounter values, route-generation percentages, and room-clear timing,
- final animation timings, VFX timing, hitboxes, damage values, and other playtest tuning.

When a major system or package becomes the active design area, finish it at useful paper-design depth before moving to narrow balance work.

# Approved dependencies

## Core run build and progression

- Launch Blood Aspects are **Wolf, Wraith, and Ronin**.
- All three Tier 0-IV Aspect packages are locked at qualitative paper-design depth.
- Five direct Technique slots are locked: **Basic Attack, Held Attack, Dash, Parry / Counter, Deathblow**.
- Supporting, Cross-family, and Legendary Techniques are slotless; there is **no global Technique inventory cap**.
- The launch Technique catalog contains **50 actual Techniques plus 10 refinements** and is complete for current paper-design scope.
- Technique rarity, prerequisites, direct-slot ownership, Supporting / Cross-family / Legendary eligibility, refinement ownership, and first-pass reward-screen generation are approved.
- The launch Relic roster contains **10 Relics**, uses one equipped slot, persistent collection ownership, run-active effects, and no rarity tiers.
- Relics gain persistent mastery from eligible enemy kills while equipped; only the currently equipped Relic advances.
- Relic permanent progression and Strand-side management belong to the **Forge Bench** alongside Prosthetics. No separate Relic Reliquary is required.
- Merchant's Seal currently prototypes a **20% discount on the first purchase in each region**.
- Prosthetic Techniques are removed; Prosthetic progression is persistent and belongs to the Forge.
- The eight-Prosthetic launch roster and each tool's shallow linear Forge upgrade path are locked at qualitative paper-design depth.
- Scrolls remain the primary persistent Forge currency for Prosthetic development.
- The **Bloodwell** owns permanent progression for **Akio** and **Run Infrastructure**.
- Run Infrastructure is one umbrella covering approved permanent improvements to Rest support, Shrine support, rewards, routing/run conditions, regional transitions, and related expedition support rather than separate upgrade trees.
- The **Blood Mirror** owns permanent Blood Aspect progression, begins locked, and unlocks later through campaign/onboarding progression.
- Blood Cavern trials, Technique-pool unlocks, Discovery Board progress, Merchant services, the Boat, and Heart Binding state are not separate permanent upgrade trees.
- Backstabs are a universal positional combat classification based on genuinely striking an enemy from behind.
- Mandatory encounters cannot assume a particular Aspect Tier, Blood Art, Technique family, Legendary, Relic, highly upgraded Prosthetic, ideal economy, or ideal survival build.
- The standard successful-run target remains approximately **45–50 minutes**.

# Approved three-region run structure

`docs/gameplay/RUN_STRUCTURE.md` owns the regional chamber and branching model. `docs/gameplay/ITEMS_AND_REWARDS.md` owns prototype room/reward weights, economy, recovery, and capacity values.

## Hushiro Gate Village

- **12 counted chambers**.
- Chambers **1–3** opening, **4–8** main, **9–11** pre-boss, **12** Keeper of the Gate.
- Chamber 1 is fixed combat followed by a Technique reward.
- One optional miniboss opportunity appears during Chambers **5–8**, selecting Village Ogre or The Collector for that run.
- Route network contains at least one Shrine, Shop, Rest, miniboss opportunity, and three Technique-reward opportunities total including Chamber 1.
- Chamber 11 guarantees access to meaningful pre-boss preparation.
- Current active-time target: approximately **14–16 minutes**.

## Yomori Grove

- **10 counted chambers**.
- Chambers **1–2** opening, **3–7** main, **8–9** pre-boss, **10** Twin Maws.
- Branching begins immediately; Chamber 1 does not force a Technique reward.
- One optional miniboss opportunity appears during Chambers **4–7**, selecting The Embered Pilgrim or Rotwood Host for that run.
- Route network contains at least one Shrine, Shop, Rest, miniboss opportunity, and two Technique-reward opportunities.
- Chambers 8–9 ensure at least one meaningful pre-boss preparation route.
- Current active-time target: approximately **12–14 minutes**.

## Kagutsuchi Court

- **11 counted chambers**.
- Chambers **1–2** Court entrance, **3–7** main Court, **8–10** final Court / Shogun approach, **11** Eclipse Shogun.
- Branching begins immediately; no fixed opening Technique reward.
- One optional miniboss opportunity appears during Chambers **4–7**, selecting Blood Lotus or Eternal Swordsman for that run.
- Route network contains at least one Shrine, Shop, Rest, miniboss opportunity, two Technique-reward opportunities, and one meaningful final-preparation opportunity across Chambers 9–10.
- Heart approach, Binding completion, and the true-final Heart are outside Kagutsuchi's counted chamber total.
- Current active-time target: approximately **15–17 minutes**.

## Shared route-generation prototype

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
- Standard-Combat Technique weight declines from **36% Hushiro → 32% Yomori → 28% Kagutsuchi** as survival/optimization value rises.
- Normal successful-route targets include roughly **20–22 standard Combat chambers**, **7–9 Technique pickups for a Technique-invested run**, **4–5 Shrine opportunities**, and approximately **1–2 visits each to Shops, Rests, Treasures, and minibosses**.
- Consumables have **0% primary room-reward weight** in this first prototype.
- Previewed choices, hard opportunity safeguards, no routine backtracking, no duplicate primary rewards on normal two-door choices, no back-to-back ordinary safe-service rooms, and dead-late-Gold suppression remain part of controlled generation.
- These percentages are approved prototype values and may be tuned through playtesting without reopening the underlying architecture.

# Approved Technique offer-generation state

`docs/gameplay/TECHNIQUES.md` owns the first Technique offer-generation prototype.

- A normal Technique reward presents **3 choices**.
- Generation order is **eligibility → required Direct/flex composition → rarity/source weighting → specific selection → final screen validation**.
- With 3–5 direct slots empty, at least 2 offers are Direct; with 1–2 empty, at least 1 is Direct; with none empty, all 3 may be flex offers.
- Hushiro Chamber 1 presents 3 Direct options from different slots and families where possible.
- Standard-Combat Common/Uncommon/Rare weighting is **55/35/10 Hushiro**, **35/45/20 Yomori**, and **20/45/35 Kagutsuchi**.
- Shops shift 10 percentage points from Common into Rare. Treasure uses **10/40/50**, minibosses **0/35/65**, and regional bosses **0/25/75**.
- Eligible Legendaries use a separate source-specific appearance check; no Legendary pity exists in the first prototype.
- Cross-family Techniques receive 1.5× selection weight inside the Rare pool when eligible.
- Refinements, replacements, Cross-family cards, and Legendaries each have one-card-per-screen limits.
- Hushiro replacements are disabled. Yomori/Kagutsuchi replacements use low regional chances, with a modest premium-source bonus.
- Rerolls regenerate the full screen while preserving source quality and build-stage composition rather than automatically upgrading rarity.
- Final offer percentages remain playtest-tunable.

# Approved Gold / Shop and survival state

`docs/gameplay/ITEMS_AND_REWARDS.md` owns the current economy and survival prototypes.

## Gold / Shops

- Normal runs begin at 0 Gold unless an approved effect changes starting Gold.
- Standard Gold rewards are **60 Hushiro / 70 Yomori / 80 Kagutsuchi**.
- Minor Gold drops are **5–10**.
- A Shop presents **3 purchasable items** across Survival / Build / Flex roles.
- All affordable displayed items may be purchased; there is no one-purchase limit.
- Prototype prices are stable across regions: moderate recovery 30–35, large recovery 50–55, reroll 45, temporary capacity 60–65, Technique 100, eligible Relic opportunity 140 Gold.
- Shop inventory itself does not reroll in the first prototype.
- An eligible flex slot has roughly a 10% chance to become a Relic opportunity.
- Gold cannot appear as a primary reward after the final realistic Shop opportunity.

## Survival / recovery / capacity

- Standard recovery: **25% max Health** or **35% max Spirit**.
- Rest: **35% max Health + 50% max Spirit**.
- Below-full-Corruption Shrine support: **20% max Health** or **25% max Spirit**.
- Normal temporary capacity: **+15% starting max Health** or **+20% starting max Spirit**, also adding the same amount to current resource.
- Capacity stacks additively from starting maximum.
- Treasure major recovery: **50% Health / 65% Spirit**; enhanced capacity **+20% Health / +25% Spirit**.
- Minibosses may grant enhanced capacity but do not use pure healing as a primary reward.
- Keeper/Twin Maws transitions restore **20% Health / 35% Spirit** and enforce **35% Health / 50% Spirit** next-region floors.
- The seventh-story-run Shogun→Heart handoff restores **30% Health / 50% Spirit** and enforces **40% Health / 60% Spirit** Heart-entry floors.
- A normal successful run is expected to take roughly 1–2 capacity improvements; a survival-focused route may take roughly 3–4.
- No special automatic pre-boss heal is added; preparation remains an existing Rest/Shop/Technique/Treasure route choice.

# Approved Relic / Prosthetic / station state

The approved launch Relic roster remains 10 items with one equipped slot and persistent individual mastery. Exact Relic acquisition allocation, mastery thresholds, Forge rank realization, most values, and transition-swap timing remain later design.

The approved eight Prosthetics remain functionally complete when unlocked with shallow linear Forge paths that improve existing properties only. Exact percentages, costs, Spirit values, damage, status values, timing, and unlock thresholds remain implementation/playtest tuning.

Current launch permanent-upgrade stations remain:

1. **Bloodwell — Akio + Run Infrastructure**
2. **Forge Bench — Prosthetics + Relics**
3. **Blood Mirror — Blood Aspects**, with the Mirror locked at the beginning and introduced later

The old Forge weapon-development model, fixed Bloodwell `Way of Steel / Way of Secrets / Way of Vows` tree, separate Relic Reliquary direction, and four-active-plus-reserve Technique loadout are not current design.

# Priority order

1. **Complete full-run integration, rewards, encounters, and pacing**
2. **Define narrative delivery and campaign presentation**
3. **Define endgame, postgame, and release scope**

# 1. Full-run integration, rewards, encounters, and pacing

The regional chamber structure, route generation, Technique offer generation, Gold/Shop economy, and survival/recovery/capacity model are now approved at prototype paper-design depth.

The next reward-value layer is **persistent-resource payout design**:

- Mist quantity for ordinary primary rewards,
- Scroll quantity for ordinary primary rewards,
- Treasure/miniboss/boss persistent-resource bonuses,
- Boss Emblem cadence and which progression gates actually consume them,
- expected persistent-resource earnings on failed versus successful runs,
- and how attractive persistent-resource routes should be relative to immediate Technique, Shrine, economy, and survival power.

After persistent-resource payouts, continue full-run integration with:

- regional-boss current-run reward mix,
- final Relic acquisition allocation and transition-swap placement,
- consumables include/cut confirmation if still needed,
- encounter composition and expected room-clear-time tuning,
- full-run simulation against the 45–50-minute target,
- and playable validation of all prototype route/economy/recovery values.

The numerical values in this package remain **prototype targets**, not immutable final balance law.

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

Keep final values in their owning files, including damage, posture, Rupture buildup/decay, Seal slow/duration/expiry, protected-enemy control resistance, Rift fuse/intensity/damage, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc damage/width, Predator's Wake radius, Legendary durations, final route/reward percentages after prototype validation, final Technique offer rates, final Shop prices and recovery/capacity values, Relic mastery thresholds/kill weighting/acquisition allocation, Prosthetic upgrade percentages/costs, Bloodwell/Run Infrastructure node values, Blood Mirror Aspect-upgrade values, and final VFX/animation timing.
