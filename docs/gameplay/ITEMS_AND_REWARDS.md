---
id: GAMEPLAY-ITEMS-REWARDS
title: Items, Currencies, and Rewards
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-20
topics:
  - currencies
  - pickups
  - techniques
  - relics
  - breakables
  - room-rewards
  - reward-cadence
  - heart-binding-completion
related:
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RUN-STRUCTURE
  - CONTENT-ROOM-TYPES
  - ART-ITEM-REWARD-ART
  - UI-TECHNIQUE-REWARDS
  - UI-HUD
---

# Items, Currencies, and Rewards

This file owns the functional categories for currencies, pickups, Techniques, Relics, breakables, reward containers, room payout ownership, and the current reward-cadence framework. Exact drop rates, prices, catalog sizes, rarity weights, and final room counts remain balance content.

## Reward-design goals

The reward framework should:

- make route choice readable before commitment,
- build Technique power gradually rather than after every room,
- keep survival, economy, and persistent progression valuable,
- allow four active Technique slots to fill across Areas 1 and 2,
- shift Area 3 toward refinement, replacement, reserve use, and final build optimization,
- provide meaningful rewards even when the player declines a Technique,
- avoid exact-combination dependence and excessive random punishment.

Every major room reward should primarily serve one of four needs:

1. **Build growth:** Techniques, refinements, Prosthetic Techniques, and Relics.
2. **Survival:** Health, Spirit, recovery, and temporary capacity.
3. **Economy:** Gold, rerolls, and shop access.
4. **Persistent progress:** Mist, Scrolls, Boss Emblems, unlocks, discoveries, and destroyed Heart Binding campaign progress.

## Currency families

| Currency | Scope | Primary role |
|---|---|---|
| Mist | Persistent | Base meta-progression currency |
| Scroll | Persistent | Forge-focused upgrade currency |
| Boss Emblem | Persistent | Rare boss-derived progression currency |
| Gold | Run-scoped | Mid-run shop economy |

Corruption is not a currency or pickup. It is a run-only Blood Aspect pressure meter.

Destroyed Heart Binding progress is not a currency and cannot be purchased, spent, or lost.

Earlier references to `Mist Shards` are treated as draft/deprecated wording unless a separate shard denomination is intentionally reintroduced later.

## Health and Spirit pickups

- **Health pickup:** restores HP.
- **Spirit pickup:** restores Spirit emblems used by prosthetic tools.
- Drops may come from enemies, breakables, scripted rewards, Shrine support, rest rooms, or boss transitions.
- Pickup confirmation should be fast and should not interrupt combat flow.

## Route and reward previews

When the player chooses between upcoming routes, the primary reward category should be previewed through a consistent symbol or environmental marker.

Preview categories may include:

- Technique,
- Gold,
- Mist,
- Scroll,
- Health,
- Spirit,
- temporary Health capacity,
- temporary Spirit capacity,
- Shrine,
- rest,
- shop,
- treasure,
- miniboss,
- boss.

Room function and primary reward are separate. A standard combat room may pay out Gold, Mist, Scrolls, recovery, temporary capacity, or a Technique opportunity.

Color cannot be the only differentiator between route rewards.

## Standard combat-room rewards

A standard combat room uses the current area's enemy roster and awards one previewed primary reward after completion.

Eligible primary rewards include:

- Gold,
- Mist,
- Scrolls,
- Health recovery,
- Spirit recovery,
- temporary maximum-Health increase,
- temporary maximum-Spirit increase,
- Technique opportunity,
- an approved reroll resource when implemented.

Not every combat room awards a Technique. Small enemy and breakable drops may supplement the primary reward with minor Gold, Health, Spirit, or rare small materials.

## Technique opportunities

Technique-marked combat rooms and other approved Technique sources present three options through the Technique reward interface.

Before all four active slots are filled, offers favor:

- immediately useful new Techniques,
- selected-Aspect compatibility,
- eligible Prosthetic Techniques,
- occasional higher-rarity options.

After all four active slots are filled, offers should usually mix:

- a compatible new Technique that may replace an active Technique or enter reserve,
- a refinement for an active Technique,
- a Prosthetic Technique, rare option, or wildcard.

The player may reject all Technique choices and take the displayed smaller fallback reward. The fallback is predetermined for that offer rather than selected from every reward category.

Possible fallbacks include:

- moderate Gold,
- small Health and Spirit recovery,
- a small amount of Mist,
- a reroll resource when approved.

The fallback must remain lower value than accepting a suitable Technique.

Detailed active-slot, reserve, replacement, overwrite, refinement, and swapping rules belong in [Technique System](TECHNIQUES.md). Screen behavior belongs in [Technique Rewards and Build Management](../ui_ux/TECHNIQUE_REWARDS.md).

## Shrine rooms

Shrines exclusively own Blood Aspect stabilization and escalation.

When Corruption is full, the Shrine presents:

- Resist,
- Embrace.

When Corruption is not full, the Shrine provides normal support such as Health, Spirit, or another approved stabilizing result.

Shrines do not normally present ordinary Technique selections. This keeps the Corruption meter and Aspect Tier decision clear and prevents one room from owning two major build systems.

## Rest rooms

Rest rooms provide:

- Health recovery,
- Spirit restoration,
- active/reserve Technique swapping,
- read-only build review and comparison,
- short narrative breathing room where appropriate.

Rest rooms do not generate new Techniques or restore Techniques that were permanently discarded during the run.

## Shop rooms

Run shops use Gold and offer limited random stock. Eligible stock may include:

- Health recovery,
- Spirit restoration,
- temporary maximum-Health or maximum-Spirit increases,
- consumables,
- Technique rerolls,
- a purchasable Technique,
- an active-Technique refinement,
- eligible prosthetic support or Prosthetic Techniques,
- an occasional run-scoped Relic.

Technique and refinement purchases should be expensive enough that Gold-focused routes represent a meaningful alternate build strategy rather than automatic purchases.

Final stock count, prices, refresh rules, and reroll behavior remain balance work.

## Treasure rooms and reward containers

Treasure rooms provide higher-value or less predictable rewards than ordinary combat rooms.

Eligible rewards include:

- run-scoped Relic choice,
- rare Technique,
- guaranteed active-Technique refinement,
- large Gold, Mist, or Scroll bundle,
- major temporary maximum-Health or maximum-Spirit increase,
- rare consumable,
- exceptional reserve or lost-Technique interaction when explicitly designed.

Major reward containers appear after minibosses, in treasure rooms, and at scripted discoveries. They require unmistakable unopened and opened states.

A standard treasure room should not guarantee the same payout type every run unless its route preview explicitly identifies that reward.

## Miniboss rewards

A miniboss guarantees a meaningful build-development reward after victory. It should never award only ordinary Gold or healing.

The reward presentation should offer a high-value choice such as:

- a higher-rarity Technique,
- a refinement for an active Technique,
- a run-scoped Relic,
- a special regional or encounter reward.

A miniboss may also provide a modest persistent payout such as Mist or Scrolls alongside the run reward.

Exact choice composition may vary by encounter, but the reward must match the greater risk and time commitment.

## Regional boss rewards

Bosses that lead into another region provide both persistent and current-run value.

### Persistent reward

May include:

- Boss Emblem where appropriate,
- Mist or Scrolls,
- unlock or narrative progression,
- discovery or codex progress.

### Current-run reward

May include:

- refine any active Technique,
- choose from rare Techniques,
- gain an eligible Prosthetic Technique or refinement,
- choose a run-scoped Relic,
- receive a major temporary Health or Spirit improvement.

Regional transition support should also restore an approved amount of Health and/or Spirit so the next area begins from a viable state.

The Eclipse Shogun is different. Defeating him opens the Heart Binding completion space rather than granting additional current-run power. Permanent rewards and campaign progress are finalized only after Akio breaks one Binding and completes the successful-return sequence.

## Heart Binding completion

After the Shogun, Akio uses the Court's extraction apparatus and Returning Blood to break one ancient Heart Binding. The Heart's retaliation dissolves his current body, so the run ends immediately after the Binding ruptures.

This completion may grant:

- one persistent destroyed-Binding campaign step,
- major currencies or Boss Emblems where appropriate,
- narrative and codex discoveries,
- unlocks tied to the next campaign stage,
- results-screen confirmation.

It does not grant current-run power because Akio's current body is destroyed immediately afterward.

The Binding identity, persistence rule, and one-per-run completion are locked. The total Binding count, clear-specific reward changes, and final completion sequence remain open.

## Relics

Relics provide rare passive rules and use a separate Relic slot rather than Technique slots.

The initial framework assumes one equipped run-scoped Relic. Any additional Relic capacity is a later progression or balance decision and should not be implied by art before approval.

Current rarity tiers:

- Common
- Uncommon
- Rare
- Legendary

Rarity changes frame treatment and presentation hierarchy; it should not recolor the same icon into an unreadable palette swap.

Relics should create broader rules, risks, or economy changes without replacing the selected Blood Aspect as the run's central identity.

## Breakable props and enemy drops

Breakables are area-appropriate destructible objects that may drop:

- minor Gold,
- Health,
- Spirit,
- rare small consumables,
- occasional small Mist or Scroll value when approved.

Required gameplay states:

- intact,
- damaged where useful,
- broken/spent.

Breakables must be distinguishable from decorative props without appearing like modern glowing containers.

Minor drops should support run flow without replacing previewed room rewards.

## Provisional reward cadence

Until exact room counts are playtested, target a successful full run at approximately:

- six to eight Technique-related decisions,
- two regional boss power rewards before the final region is complete,
- one to two miniboss rewards depending on route,
- one to two Relic opportunities,
- several Gold, recovery, capacity, Mist, and Scroll routes,
- multiple Shrine decisions governed by Corruption pacing.

Provisional regional shape:

- **Area 1:** roughly two ordinary Technique opportunities, then a major Area 1 boss reward.
- **Area 2:** roughly two ordinary Technique opportunities, then a major Area 2 boss reward.
- **Area 3:** roughly two or three Technique, refinement, treasure, or shop opportunities focused on finalizing the build.
- **Optional routes:** shops, treasure rooms, and minibosses may add further choices without guaranteeing a perfect combination.

These are pacing targets, not locked room counts or mandatory probabilities.

## Reward-generation guardrails

- Do not require an exact Technique combination for a viable run.
- Do not generate three options that are all invalid for the current loadout.
- Refinements only target active Techniques.
- Prosthetic Techniques only appear for the equipped prosthetic.
- Selected Aspect weights offers but does not fully lock the player to one pool.
- Rare rewards should be exciting without invalidating sword combat or boss mechanics.
- Technique rewards should be less frequent and more consequential than minor currency or recovery rewards.
- Persistent-currency rewards must not overwhelm the reason to pursue current-run strength.
- Heart Binding progress cannot be replaced by an ordinary currency payout.

## Implementation boundaries

Still unresolved:

- final room counts and route branching,
- exact reward probabilities and anti-streak rules,
- final costs and drop tables,
- Technique and Relic catalog sizes,
- final rarity probabilities,
- shop stock and reroll economics,
- exact temporary capacity values,
- individual consumable ownership,
- whether any additional persistent currency families are needed,
- Heart Binding count and clear-specific completion rewards.
