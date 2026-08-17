---
id: GAMEPLAY-RUN-STRUCTURE
title: Run Structure
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-16
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
  - regional-routing
  - chamber-structure
related:
  - LORE-RETURNING-BLOOD
  - LORE-STORY-OVERVIEW
  - LORE-BARRIER-BLOOD-MOON
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-ITEMS-REWARDS
  - CONTENT-ROOM-TYPES
  - CONTENT-AREA1-OVERVIEW
  - CONTENT-AREA2-OVERVIEW
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

Hushiro and Yomori now have approved **prototype chamber structures** defined below. Their chamber counts and structural bands are planning targets for implementation and playtesting, not immutable final balance values. Kagutsuchi's exact chamber count and the final route-generation weights remain open until the full three-region pacing pass is completed.

## Chamber and route model

A **counted chamber** is a room that represents an actual run node. Standard combat rooms, Shrine, Rest, Shop, Treasure, Miniboss, and regional Boss rooms can count as chambers. Small entrance corridors, boss exits, loading connectors, and regional transition spaces do not count toward the regional chamber total.

The run uses a Hades-like chamber-routing model:

- each region has a broadly fixed chamber destination and fixed final boss,
- chamber-index bands determine what room and encounter types are eligible,
- eligible contents are selected procedurally through weighted generation,
- hard generation safeguards prevent important opportunity types from disappearing from the full route network,
- route exits preview the upcoming room function and/or primary reward before commitment,
- one or two exits are the normal route presentation, with occasional wider choices allowed where useful,
- branches may reconverge later,
- and there is no routine backtracking after choosing an exit.

A guaranteed **opportunity** means the generated route network contains at least one accessible offer of that type. It does not mean the player is forced to enter that room. Choosing a competing route can intentionally give up the guaranteed opportunity.

Exact percentage weights, branch frequency, reward weights, encounter compositions, and authored room-variant counts remain prototype and playtest tuning.

## Area 1 — Hushiro Gate Village prototype structure

Hushiro uses **12 counted chambers**, including Keeper of the Gate at Chamber 12. The current active-time target is approximately **14–16 minutes**.

### Chambers 1–3 — Opening stretch

- **Chamber 1 is fixed:** a standard combat encounter followed by a guaranteed Technique reward.
- Chambers 2–3 introduce the normal previewed route-choice structure.
- Early encounter generation favors simpler Hushiro combinations so the player can establish the run before the region uses its full mixed-enemy pressure.
- Hushiro's build purpose is to establish the first direct-action modifications and the first recognizable family/build direction, not to finish the build.

### Chambers 4–8 — Main stretch

The complete normal Hushiro room/reward pool is eligible here. Combat remains the majority experience, while route choices may lead toward Technique, Gold, Mist, Scrolls, Shrine, Rest, Shop, Treasure, or Miniboss opportunities.

Hushiro's single miniboss opportunity is eligible during **Chambers 5–8**. Each run selects one candidate from:

- Village Ogre
- The Collector

The miniboss path is optional. A normal Hushiro run therefore contains **0–1 fought minibosses**, even though one miniboss opportunity is generated into the route network.

### Chambers 9–11 — Pre-boss stretch

- Minibosses leave the eligible pool.
- Encounter generation may use the strongest normal Hushiro compositions and should visually move toward the old gate.
- No new major system is introduced here; the purpose is to consolidate the current build and prepare for Keeper.
- **Chamber 11 guarantees a meaningful pre-boss support opportunity in the available route**, such as Rest, Shop, or another approved high-value preparation choice. This does not require a free full heal.

### Chamber 12 — Keeper of the Gate

Keeper is fixed at Chamber 12 and ends Hushiro. All routes converge on the old gate boss encounter.

### Hushiro route-network safeguards

Before Keeper, the generated route network must contain at least:

- **1 Shrine opportunity**,
- **1 Shop opportunity**,
- **1 Rest opportunity**,
- **1 optional miniboss opportunity**,
- **3 Technique-reward opportunities total**, including the fixed Chamber 1 Technique reward.

These are network opportunities rather than mandatory visits. Exact reward odds outside the safeguards remain later tuning.

## Area 2 — Yomori Grove prototype structure

Yomori uses **10 counted chambers**, including Twin Maws at Chamber 10. The current active-time target is approximately **12–14 minutes**.

Yomori is intentionally shorter than Hushiro because its normal encounters, minibosses, and paired regional boss are expected to be denser and mechanically more complex.

### Chambers 1–2 — Opening stretch

- Branching begins immediately.
- There is no fixed guaranteed Technique reward on Yomori Chamber 1; the player already enters with an established run build.
- Early Yomori encounters introduce its spirit manifestation, mist, stalking, predator, and positional-control language before the main stretch combines those pressures more aggressively.

### Chambers 3–7 — Main stretch

The main Yomori room/reward pool is active here. Area 2's build purpose is to expand direct-action coverage where still open and deepen the existing build through Supporting Techniques, refinements, Cross-family eligibility, continued Aspect progression, and other reward choices.

Yomori's single miniboss opportunity is eligible during **Chambers 4–7**. Each run selects one candidate from:

- The Embered Pilgrim
- Rotwood Host

The miniboss path is optional. A normal Yomori run therefore contains **0–1 fought minibosses**, even though one miniboss opportunity is generated into the route network.

### Chambers 8–9 — Pre-boss stretch

- Minibosses leave the eligible pool.
- Encounter generation may use Yomori's strongest normal combinations.
- At least one available route across Chambers 8–9 should provide meaningful pre-boss preparation without making full recovery automatic.
- The stretch should feel like convergence toward the grove's heart rather than the introduction of another system.

### Chamber 10 — Twin Maws

Twin Maws — Rootfang and Briarthorn are fixed at Chamber 10 and end Yomori. All routes converge on the paired boss encounter.

### Yomori route-network safeguards

Before Twin Maws, the generated route network must contain at least:

- **1 Shrine opportunity**,
- **1 Shop opportunity**,
- **1 Rest opportunity**,
- **1 optional miniboss opportunity**,
- **2 Technique-reward opportunities**.

These are network opportunities rather than mandatory visits. Treasure remains an eligible high-value route rather than a guaranteed regional service.

## Regional boss transitions

Defeating Keeper or Twin Maws leads into a brief **safe regional transition space** that does not count as an additional chamber.

The transition should:

- grant the approved regional boss reward,
- restore enough Health and/or Spirit for the next area to begin from a viable state,
- allow concise read-only build review and any separately approved limited preparation interaction,
- visually transition into the next region,
- and preserve run momentum rather than functioning as a second Strand or overloaded menu hub.

The exact recovery values, Relic-swap timing if retained, and transition interface remain later implementation decisions.

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

The approved Hushiro and Yomori chamber budgets are prototype targets within this larger duration goal. Kagutsuchi and the final cross-region pacing budget still require the same integration pass before the full 45–50-minute structure is considered numerically complete.

## Standard run start

Before departure, the player:

- completes available Strand preparation,
- confirms one unlocked Blood Aspect after that system is available,
- confirms the current Prosthetic and Relic loadouts when those systems are available,
- uses the Boat as the final run-start confirmation,
- begins at Blood Aspect Tier 0,
- begins with five empty direct Technique slots: Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow,
- starts without the previous run's Corruption, slotted or Supporting Techniques, refinements, replacement state, Gold, room progress, or previous run-only Relic activation state,
- and commits to the Keeper-guided barrier crossing by selecting `Start Run`.

The Keeper's contribution remains part of the departure presentation rather than a separate repeated menu or resource cost.

Blood Aspect selection does not appear during the first attempt and need not become available immediately after the first return. The **Blood Mirror** itself begins locked and becomes available later through campaign/onboarding progression; its exact unlock event remains deferred.

The Forge owns permanent Prosthetic and Relic progression / management. The Bloodwell owns Akio and Run Infrastructure progression. The Boat does not duplicate those upgrade interfaces.

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

## Run Infrastructure relationship

Permanent Run Infrastructure progression is owned by the Bloodwell and may improve approved support around future runs, including Rest support, Shrine support, reward possibilities, route support, regional-transition support, or other beneficial run conditions.

Run Infrastructure does not itself carry a previous run's temporary build state forward and cannot bypass the fixed Aspect Tier path or replace Technique/routing decisions.

## Run power curve

After the relevant systems are unlocked:

- **Area 1:** establish the first direct-action Technique modifications and recognizable family/build direction while leaving substantial room for later growth.
- **Area 2:** expand direct-action coverage where still open, gain Aspect Tiers, and deepen family or hybrid synergy through slotless Supporting Techniques, refinements, and later eligibility.
- **Area 3:** finish or refine the mature build through remaining direct opportunities, Supporting Techniques, refinements, rare same-slot replacements, Cross-family Techniques, and eligible high-rarity or Legendary opportunities.

A successful run should create several meaningful Technique decisions without awarding a Technique after every combat room. There is no global Technique inventory cap; practical Technique growth is constrained by reward opportunities, route competition, prerequisites, and run length. Exact reward probabilities remain later tuning work.

## Failed run

After Returning Blood has awakened, Akio's death reconstructs him at the Strand. Death is a real supernatural event, not a non-canon reset.

A failed run burns away temporary Blood state and run-only progress. Permanent unlocks, upgrades, Run Infrastructure, Relic collection/mastery/progression, discoveries, Blood Mirror progress after unlock, and persistent currencies survive according to the progression matrix.

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
- slotless Supporting / Cross-family / Legendary Techniques,
- Technique refinements and rare same-slot replacements,
- the equipped Prosthetic,
- the equipped Relic benefit,
- approved consumables,
- run-only currencies and materials,
- survival and resource-cap rewards,
- boss, miniboss, treasure, shop, or discovery rewards.

Prosthetic and Relic permanent progression belongs to the Forge rather than a temporary Technique layer.

## Reset boundary

The following reset after death or successful Heart Binding return:

- Corruption,
- Blood Aspect Tier,
- slotted Techniques,
- Supporting / Cross-family / Legendary Techniques,
- Technique refinements and replacement state,
- Gold,
- room progress,
- the current run's Relic activation state,
- and other explicitly run-only states.

The following persist:

- unlocked Blood Aspects,
- selected Aspect as an available loadout choice,
- Techniques unlocked into future reward pools,
- permanent Akio upgrades,
- permanent Run Infrastructure upgrades,
- permanent Prosthetic progression,
- Relic collection, mastery, and permanent progression,
- Blood Mirror trial and Aspect-progression state after unlock,
- narrative discoveries and codex progress,
- persistent currencies and rewards,
- destroyed Heart Bindings and campaign progress,
- story-completion state and unlocked postgame Heart access.

See [Progression](PROGRESSION.md) for system ownership and the persistence matrix.
