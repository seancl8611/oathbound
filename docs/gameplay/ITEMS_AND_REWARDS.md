---
id: GAMEPLAY-ITEMS-REWARDS
title: Items, Currencies, and Rewards
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-21
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

This file owns reward categories, currency ownership, room payouts, and the current reward-cadence framework. Exact rates, prices, room counts, catalog sizes, and numerical values remain balance work unless explicitly approved elsewhere.

## Reward goals

The reward framework should:

- make route choices readable before commitment,
- build run power gradually,
- keep survival, economy, and persistent progression valuable,
- fill the Technique loadout mainly through Areas 1 and 2,
- shift Area 3 toward refinement and final build decisions,
- provide useful fallback rewards,
- and avoid exact-combination dependence or severe random failure.

Major rewards primarily support:

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

`Mist Shards` is deprecated unless restored intentionally as a separate denomination.

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

Room function and payout are related but separate. A standard combat room may award any approved combat-room payout.

Color cannot be the only differentiator.

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

Before all four active slots are filled, offers favor:

- immediately useful new Techniques,
- selected-Aspect compatibility,
- eligible Prosthetic Techniques,
- occasional higher-rarity options.

After all active slots are filled, offers usually mix:

- a compatible replacement option,
- a refinement for an active Technique,
- a Prosthetic Technique, rare option, or wildcard.

The player may decline all choices for a displayed lower-value fallback, such as Gold, recovery, Mist, or an approved reroll resource.

Detailed slot, reserve, overwrite, and refinement rules belong in `TECHNIQUES.md`.

## Shrine rooms

Shrines own Blood Aspect stabilization and escalation.

- At full Corruption: present Resist or Embrace.
- Below full Corruption: provide approved support such as recovery.
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
- consumables,
- rerolls,
- Techniques,
- refinements,
- prosthetic support,
- occasional Relics.

Technique and refinement purchases should be expensive enough that Gold routing is a meaningful build strategy rather than an automatic purchase path.

Final stock count, prices, refresh rules, and reroll economics remain balance work.

## Treasure and miniboss rewards

Treasure rooms provide higher-value or less predictable rewards than standard combat rooms.

Eligible treasure rewards include:

- Relic choice,
- rare Technique,
- guaranteed refinement,
- large currency bundle,
- major temporary capacity,
- rare consumable if consumables are included at launch.

A miniboss guarantees a meaningful build-development reward and should never award only ordinary Gold or healing.

Possible miniboss rewards include:

- higher-rarity Technique,
- active-Technique refinement,
- Relic,
- special encounter reward,
- modest additional Mist or Scrolls.

## Regional boss rewards

The Area 1 and Area 2 bosses provide both persistent and current-run value.

Persistent rewards may include:

- Boss Emblem,
- Mist or Scrolls,
- unlocks,
- narrative or codex progress.

Current-run rewards may include:

- refinement,
- rare Technique choice,
- Prosthetic Technique,
- Relic,
- major temporary Health or Spirit improvement.

Regional transitions should also restore enough Health or Spirit for the next area to begin from a viable state.

## Eclipse Shogun and Heart Binding completion

The Eclipse Shogun does not grant additional current-run power during the first six successful clears because the run ends immediately after the Binding ritual.

After defeating him, Akio:

1. enters the Heart chamber,
2. offers Returning Blood through the extraction apparatus,
3. breaks one remaining Heart Binding,
4. is dissolved by the Heart,
5. reconstructs at the Strand.

The campaign begins with six intact Bindings. Each successful Binding run destroys one. Permanent completion rewards may include:

- destroyed-Binding progress,
- Mist, Scrolls, or Boss Emblems,
- unlocks,
- narrative and codex discoveries,
- results-screen confirmation.

After all six Bindings are destroyed, the seventh successful story run continues from the Shogun into the Heart instead of performing another Binding ritual.

## Relics

Relics are rare run-scoped passive rules using a separate slot.

The initial structure uses one equipped Relic. Current rarity tiers are:

- Common,
- Uncommon,
- Rare,
- Legendary.

Relics may alter broader combat, economy, survival, or risk rules, but should not replace the selected Blood Aspect as the run's central identity.

Final Relic count and detailed effects belong to the launch build-content catalog decision.

## Provisional cadence

Until run length and room structure are approved, target a successful full run at approximately:

- six to eight Technique-related decisions,
- two regional boss power rewards before Kagutsuchi is complete,
- one to two miniboss rewards depending on routing,
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

## Current scope dependencies

The following remain in `OPEN_QUESTIONS.md` because they affect production scope:

- run length and route structure,
- launch Technique, Prosthetic Technique, Relic, and consumable catalog sizes,
- postgame Heart-route rewards.

Exact prices, rates, probabilities, temporary values, and reroll formulas remain implementation and playtest work.