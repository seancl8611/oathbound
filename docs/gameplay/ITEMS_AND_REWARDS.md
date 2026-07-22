---
id: GAMEPLAY-ITEMS-REWARDS
title: Items, Currencies, and Rewards
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-22
topics:
  - currencies
  - pickups
  - techniques
  - relics
  - room-rewards
  - reward-cadence
  - heart-binding-completion
related:
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RUN-STRUCTURE
  - CONTENT-ROOM-TYPES
  - META-OPEN-QUESTIONS
---

# Items, Currencies, and Rewards

This file owns reward categories, currency ownership, room payouts, and the current reward-cadence framework. Exact rates, prices, route probabilities, room counts, and numerical values remain balance and implementation work unless explicitly approved elsewhere.

## Reward goals

The reward framework should:

- make route choices readable before commitment,
- build run power gradually,
- keep survival, economy, and persistent progression valuable,
- fill the Technique loadout mainly through Areas 1 and 2,
- shift Area 3 toward refinement and final build decisions,
- provide useful fallback rewards,
- and avoid exact-combination dependence or severe random failure.

Major rewards support:

1. **Build growth** — Techniques, refinements, Prosthetic Techniques, Relics.
2. **Survival** — Health, Spirit, recovery, temporary capacity.
3. **Economy** — Gold, shops, rerolls.
4. **Persistent progress** — Mist, Scrolls, Boss Emblems, unlocks, discoveries, Heart Bindings.

## Currency families

| Currency | Persistence | Primary role |
|---|---|---|
| Mist | Persistent | Broad meta progression |
| Scroll | Persistent | Forge upgrades |
| Boss Emblem | Persistent | Rare major progression gates |
| Gold | Run-only | Shops and run economy |

Corruption and destroyed Heart Bindings are not currencies.

`Mist Shards` is deprecated unless intentionally restored as a separate denomination.

## Pickups and minor drops

- Health restores HP.
- Spirit restores the shared prosthetic resource.
- Minor enemy and breakable drops may include small Gold, Health, Spirit, Mist, or Scroll value where approved.
- Minor drops support flow but do not replace the room's previewed primary reward.

## Route previews

When the player chooses between routes, the primary reward category should be shown through a consistent symbol or environmental marker.

Supported preview categories may include:

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

Room function and payout are related but separate. A standard combat room may award any approved combat-room payout. Color cannot be the only differentiator.

Exact route topology, branch frequency, and room distribution are later run-design and playtest decisions.

## Standard combat rewards

A standard combat room awards one previewed primary reward after completion.

Eligible rewards include:

- Gold,
- Mist,
- Scrolls,
- Health or Spirit recovery,
- temporary capacity,
- Technique opportunity,
- an approved reroll resource.

Not every combat room awards a Technique.

## Technique opportunities

Technique offers normally present three cards.

Before all four active slots are filled, offers favor immediately useful Techniques, selected-Aspect compatibility, eligible Prosthetic Techniques, and occasional higher-rarity options.

After all active slots are filled, offers usually mix a compatible replacement, an active-Technique refinement, and a Prosthetic Technique, rare option, or wildcard.

The player may decline all choices for a displayed lower-value fallback such as Gold, recovery, Mist, or an approved reroll resource.

Detailed slot, reserve, overwrite, and refinement rules belong in `TECHNIQUES.md`.

## Shrine rooms

Shrines own Blood Aspect stabilization and escalation.

- At full Corruption: present Resist or Embrace.
- Below full Corruption: provide approved support such as Health or Spirit recovery.
- Shrines do not normally present ordinary Technique selections.

## Rest rooms

Rest rooms provide:

- Health and Spirit recovery,
- active and reserve Technique swapping,
- read-only build review,
- short narrative breathing room where appropriate.

They do not generate new Techniques or restore discarded Techniques.

## Shops

Run shops use Gold and may offer:

- recovery,
- temporary capacity,
- consumables if included at launch,
- rerolls,
- Techniques,
- refinements,
- prosthetic support,
- occasional Relics.

Technique and refinement purchases should be expensive enough that Gold routing is a meaningful build strategy rather than an automatic purchase path.

Final stock count, prices, refresh rules, and reroll economics remain balance work.

## Treasure and miniboss rewards

Treasure rooms provide higher-value or less predictable rewards than standard combat rooms. Eligible rewards may include a Relic choice, rare Technique, guaranteed refinement, large currency bundle, major temporary capacity, or rare consumable if consumables ship at launch.

A miniboss guarantees meaningful build development and should never award only ordinary Gold or healing. Possible rewards include:

- higher-rarity Technique,
- active-Technique refinement,
- Relic,
- special encounter reward,
- modest additional Mist or Scrolls.

Miniboss frequency and route placement remain later gameplay decisions. The reward system must support the approved encounters without assuming all six appear in every run.

## Regional boss rewards

The Area 1 and Area 2 bosses provide both persistent and current-run value.

Persistent rewards may include Boss Emblems, Mist, Scrolls, unlocks, and narrative or codex progress.

Current-run rewards may include a refinement, rare Technique choice, Prosthetic Technique, Relic, or major temporary Health or Spirit improvement.

Regional transitions should restore enough Health or Spirit for the next area to begin from a viable state.

## Eclipse Shogun and Heart Binding completion

The Eclipse Shogun does not grant additional current-run power during the first six successful clears because the run ends after the Binding ritual.

After defeating him, Akio:

1. enters the Heart chamber,
2. offers Returning Blood through the extraction apparatus,
3. breaks one remaining Heart Binding,
4. is dissolved by the Heart,
5. reconstructs at the Strand.

Permanent completion rewards may include destroyed-Binding progress, Mist, Scrolls, Boss Emblems, unlocks, narrative discoveries, codex progress, and results confirmation.

After all six Bindings are destroyed, the seventh successful story run continues from the Shogun into the Heart instead of performing another Binding ritual.

## Relics

Relics are rare run-scoped passive rules using a separate slot.

The initial structure uses one equipped Relic. Current rarity tiers are:

- Common,
- Uncommon,
- Rare,
- Legendary.

Relics may alter broader combat, economy, survival, or risk rules, but should not replace the selected Blood Aspect as the run's central identity.

The final Relic catalog belongs to the launch run-build content decision.

## Pacing framework

Within the approved 45–50-minute successful-run target, the current pacing direction is approximately:

- six to eight Technique-related decisions,
- two regional boss power rewards before Kagutsuchi is complete,
- one to two miniboss rewards depending on later routing decisions,
- one to two Relic opportunities,
- several economy, recovery, capacity, Mist, and Scroll routes,
- multiple Shrine decisions governed by Corruption pacing.

Regional direction:

- **Area 1:** first meaningful Techniques and one major boss reward.
- **Area 2:** complete the active loadout and deepen synergy.
- **Area 3:** refine, replace, use reserve, and finalize the build.

These are pacing targets, not locked room counts or probabilities.

## Guardrails

- Do not require an exact Technique combination for a viable run.
- Do not generate three invalid choices.
- Refinements target active Techniques.
- Prosthetic Techniques appear only for the equipped tool.
- Selected Aspect weights but does not fully restrict offers.
- Rare rewards must not invalidate sword combat or boss mechanics.
- Persistent currency must not overwhelm current-run strength.
- Heart Binding progress cannot be replaced by ordinary currency.

## Current production dependency

The remaining reward-level production question is the launch run-build content catalog: approximate Technique, refinement, Prosthetic Technique, Relic, and consumable counts, plus their reusable-versus-unique production treatment.

Exact effects, prices, rates, probabilities, route generation, temporary values, and reroll formulas remain later design and playtest work.