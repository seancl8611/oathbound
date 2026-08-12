---
id: GAMEPLAY-RUN-STRUCTURE
title: Run Structure
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-12
topics:
  - runs
  - first-attempt
  - death
  - returning-blood
  - successful-return
  - heart-bindings
  - campaign-clears
  - true-final-heart
  - postgame
  - strand
  - techniques
  - room-rewards
  - blood-moon
related:
  - LORE-RETURNING-BLOOD
  - LORE-STORY-OVERVIEW
  - LORE-BARRIER-BLOOD-MOON
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-ITEMS-REWARDS
  - CONTENT-STRAND-BLOODWELL
  - CONTENT-STRAND-BOAT
  - UI-RUN-RESULTS
---

# Run Structure

A standard run begins after preparation and final confirmation at the Boat in the Strand. The Keeper stabilizes the controlled passage through the barrier, and the Boat carries Akio to the island.

A run ends through death, successful destruction of one Heart Binding after the Shogun, completion of an unlocked true-final Heart route, or another explicitly designed return condition.

The campaign takes place beneath the Blood Moon. The game does not define how much ordinary time passes between repeated runs.

## Introductory first attempt

Before the normal roguelite loop begins, Akio enters as an ordinary Order swordsman with dormant inherited Beast Blood but no knowledge of it and no active Blood powers.

During this attempt:

- the player uses the base katana kit and available Order equipment,
- Blood Aspects are unavailable,
- Shrine Resist and Embrace progression is unavailable,
- Blood-derived Techniques are unavailable,
- and the player is introduced to the island and core combat without a full run build.

The attempt ends in Akio's first death. Its exact enemy, location, length, and scripted-versus-played endpoint belong to the narrative-delivery and opening-production package rather than the standard run model.

Death awakens the inherited Beast Blood and reconstructs Akio at the Strand as Returning Blood. The return should be brief and striking rather than a long explanatory cutscene. Akio and the player understand that he died and returned, but not yet his ancestry or the full Blood system.

The normal repeated-run structure begins after this return.

## Regional flow

The intended full route is:

1. Hushiro Gate Village
2. Yomori Grove
3. Kagutsuchi Court
4. Eclipse Shogun
5. temporary access to the Heart chamber
6. one Binding completion during the first six successful clears, or the unlocked true-final Heart encounter after all six Bindings are destroyed

The introductory attempt may use only a short portion of Hushiro rather than the complete regional flow.

Exact room counts, route topology, branch frequency, miniboss frequency, rerouting, and authored room-variant counts are deferred to environment prototyping, encounter pacing, and playtesting. They are not current full-game scope blockers.

## Approved duration target

A normal successful Binding run should target approximately **45–50 minutes of active run time** from Boat departure through completion of the Heart Binding return.

Supporting targets:

- experienced repeat clear: approximately 35–42 minutes,
- typical successful Binding run: approximately 45–50 minutes,
- cautious or first successful clear: approximately 50–60 minutes,
- standard successful-run ceiling: runs should not routinely exceed 60 minutes,
- seventh story run with the Heart: approximately 55–60 minutes, with slower successful attempts able to approach 65 minutes.

The two-form Heart continuation should add approximately 8–12 minutes to the established Shogun route rather than functioning as another full region.

Active run time includes combat, reward choices, shops, rests, transitions, bosses, and the Binding or Heart completion sequence. It excludes Strand preparation, trials, codex reading, and time spent paused.

These are production and pacing targets, not guarantees. Exact room and encounter budgets must be validated in playable builds.

## Standard run start

Before departure, the player:

- completes available Strand preparation,
- confirms one unlocked Blood Aspect at the Boat after the system is unlocked,
- confirms the current Prosthetic loadout when available,
- begins at Blood Aspect Tier 0,
- begins with five empty direct Technique slots: Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow,
- starts without the previous run's Corruption, slotted or supporting Techniques, refinements, replacement state, Gold, room progress, or temporary Relic effects,
- and commits to the Keeper-guided barrier crossing by selecting `Start Run`.

The Keeper's contribution remains part of the departure presentation rather than a separate repeated menu or resource cost.

Blood Aspect selection does not appear during the first attempt and need not become available immediately after the first return. Advanced Blood systems unlock through later progression.

## Room functions

The game uses recognizable room categories:

- Combat
- Shrine
- Rest
- Shop
- Treasure or reward
- Miniboss
- Boss approach and boss arena
- Heart approach and Binding-completion chamber after the Shogun

Each function should read before interaction through environment composition, focal props, lighting, and UI treatment.

Combat routes may display a previewed primary reward category before entry. Room function and reward category are related but separate: a standard combat encounter may pay Gold, Mist, Scrolls, recovery, temporary run growth, or a Technique opportunity.

Detailed reward ownership and cadence belong in [Items, Currencies, and Rewards](ITEMS_AND_REWARDS.md).

## Run power curve

After the relevant systems are unlocked:

- **Area 1:** acquire early direct Techniques and establish the first family/build direction.
- **Area 2:** fill more of the five core slots, gain Aspect Tiers, and begin deepening family synergy through later Technique rewards.
- **Area 3:** finish or refine the build through remaining direct slots, slotless supporting Techniques, refinements, rare same-slot replacements, and eligible high-rarity or Legendary opportunities.

A successful run should create several meaningful Technique decisions without awarding a Technique after every combat room. Exact reward frequency remains a later tuning and catalog decision.

## Failed run

After Returning Blood has awakened, Akio's death reconstructs him at the Strand. Death is a real supernatural event, not a non-canon reset.

A failed run burns away temporary Blood state and run-only progress. Permanent unlocks, upgrades, discoveries, Blood Mirror progress, and persistent currencies survive according to the progression matrix.

Akio may prepare and board the Boat again without the narrative defining an exact elapsed time between attempts.

## Successful Binding run

On a successful Binding run, Akio:

1. defeats the Eclipse Shogun's current manifestation,
2. enters the Heart chamber and reaches the Shogun-built extraction apparatus,
3. offers Returning Blood through that apparatus,
4. causes the Heart to attempt to reclaim the Blood,
5. breaks one ancient Heart Binding when Akio's Blood rejects that control,
6. is dissolved by the Heart's retaliation,
7. reforms at the Strand through Returning Blood,
8. saves permanent rewards and destroyed-Binding progress,
9. clears temporary run state,
10. receives a results summary,
11. triggers relevant NPC, codex, Blood Mirror, Heart-state, or hub updates.

The ritual is one reusable completion sequence: blood offering, Heart reaction, one Binding rupture, Akio's dissolution, and Strand reconstruction. Clear-to-clear escalation uses greater Heart exposure, stronger room-local reaction, damaged Binding states, and concise narrative updates rather than a different mechanism or puzzle every time.

The destroyed Binding remains gone because it is an external ancient restraint that the Heart did not create and cannot regenerate. Akio destroys only one per run because the retaliation immediately kills his current body.

Successful completion and failed death both return Akio to the Strand, but they must remain visually and narratively distinct. See [Run Results and Strand Return](../ui_ux/RUN_RESULTS.md).

## Campaign clear structure

The Heart's prison originally contained seven Heart Bindings. The Court destroyed the outermost Binding before the game, leaving six intact when Akio begins the campaign.

The main campaign requires six successful Binding runs. Each destroys one remaining restraint. Failed runs do not advance the count.

After the sixth Binding is destroyed, the next successful full run becomes the seventh and final story run. No Binding remains, so Akio does not repeat the extraction ritual or automatically dissolve after the Shogun. He continues directly into the Heart encounter with the same active build.

The Shogun is not permanently killed through a separate anti-regeneration method before the Heart. Destroying the Heart makes Beast Blood inert, stops his reconstruction, frees him from the Blood's influence, and allows his body to die permanently.

The six-clear requirement is a roguelite mastery target rather than six unique story missions. Continued play is supported through alternate Blood Aspects, Techniques, Prosthetics, Relics, routes, rewards, persistent upgrades, and increasing player consistency.

The base game does not require island-wide visual transformations, universal enemy modifiers, new regional environment sets, or new enemy families after every Binding clear.

## True-final Heart route

The true-final Heart encounter unlocks only after all six remaining Bindings are destroyed.

The first unlocked Heart route is the final story run. The player must complete the established island route, defeat the Eclipse Shogun, and defeat the Heart without ending or losing the run between those encounters.

The Heart encounter has exactly two conceptual forms:

1. **The Unbound Heart** — the exposed Heart tears free, creates malformed support limbs, and becomes a mobile beastlike organ.
2. **The Vessel of Continuance** — the Heart forms an enormous nonhuman defensive vessel around itself while remaining visibly central.

The Heart is not a humanoid swordsman and does not add a separate weak-point subsystem. Exact attacks, timings, posture behavior, transitions, arena rules, animation lists, and tuning remain later encounter-design and playtest work.

Returning Blood's rejection of the Heart may support the final narrative and visual resolution without creating a new one-off player mechanic.

## First Heart victory and ending

The first true-final Heart victory canonically completes the story.

Destroying the Heart makes active Beast Blood inert across the island. Its death:

- stops the Shogun's reconstruction and allows him to die permanently,
- releases corrupted inhabitants before their unnaturally sustained bodies fail,
- collapses corrupted beasts and failed bodies,
- allows Yomori's lingering spirits to pass on,
- ends the supernatural Blood Moon cycle,
- and allows the containment barrier to weaken safely.

Akio survives in his current complete human body, but Returning Blood, Blood Aspects, supernatural regeneration, and future reconstruction end with the source. He becomes mortal.

The ending and credits follow the first Heart victory.

## Postgame runs

After the story is completed, the save remains playable. Akio may continue normal roguelite runs and may repeat the Heart route.

Repeat Heart victories are gameplay challenges only. They do not advance the story, create another canonical ending, imply another Heart, or reverse the completed ending.

The postgame must provide a clear choice or condition determining whether a completed run ends after the Shogun or continues into the Heart. The exact access control, repeat rewards, records, and required UI belong to the postgame release-package decision.

Additional difficulty settings, run modifiers, enemy variants, room variants, challenge restrictions, and special challenge systems are deferred beyond the initial release unless deliberately promoted later.

## Run growth

A run may change through:

- Blood Aspect Tier choices,
- five direct slotted Techniques,
- slotless supporting Techniques,
- Technique refinements and rare same-slot replacements,
- the equipped Prosthetic,
- run-scoped Relics,
- approved consumables,
- temporary currencies and materials,
- survival and resource-cap rewards,
- boss, miniboss, treasure, shop, or discovery rewards.

Prosthetic progression itself is persistent and belongs to the Forge rather than a temporary Technique layer.

## Reset boundary

The following reset after death or successful Heart Binding return:

- Corruption,
- Blood Aspect Tier,
- slotted Techniques,
- supporting Techniques,
- Technique refinements and replacement state,
- Gold,
- room progress,
- temporary Relic effects,
- and other explicitly run-only states.

The following persist:

- unlocked Blood Aspects,
- selected Aspect as an available loadout choice,
- Techniques unlocked into future reward pools,
- permanent upgrades,
- permanent Prosthetic progression,
- Blood Mirror trial and mastery progress,
- narrative discoveries and codex progress,
- persistent currencies and rewards,
- destroyed Heart Bindings and campaign progress,
- story-completion state and unlocked postgame Heart access.

See [Progression](PROGRESSION.md) for system ownership and the persistence matrix.