---
id: GAMEPLAY-RUN-STRUCTURE
title: Run Structure
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-18
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
  - branching-frequency
  - authored-encounters
  - enemy-lineage
related:
  - GAMEPLAY-FIRST-ATTEMPT
  - LORE-RETURNING-BLOOD
  - LORE-STORY-OVERVIEW
  - LORE-BARRIER-BLOOD-MOON
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-ITEMS-REWARDS
  - NARRATIVE-DELIVERY
  - OVERVIEW-ENDGAME-POSTGAME-RELEASE
  - CONTENT-ROOM-TYPES
  - CONTENT-AREA1-OVERVIEW
  - CONTENT-AREA2-OVERVIEW
  - CONTENT-AREA3-OVERVIEW
  - CONTENT-STRAND-BLOODWELL
  - CONTENT-STRAND-BOAT
  - UI-RUN-RESULTS
---

# Run Structure

A standard post-awakening run begins after preparation and final confirmation at the Boat in the Strand. The Keeper stabilizes the controlled passage through the barrier, and the Boat carries Akio to the island.

A run ends through death, successful destruction of one Heart Binding after the Shogun, completion of the first true-final Heart route, a postgame Shogun-ending expedition, or a postgame Heart-suppression clear.

The campaign takes place beneath the Blood Moon. The game does not define how much ordinary time passes between repeated runs.

## Introductory first attempt

The first attempt is **not a scripted prologue route**. `FIRST_ATTEMPT.md` owns its pre-awakening exceptions.

The player begins directly in the normal Hushiro route as an ordinary Order swordsman carrying dormant inherited Beast Blood but no active Returning Blood powers.

During this attempt:

- the player uses the base katana kit,
- **Beast-Bane Whistle** is the default equipped Prosthetic,
- normal Technique rewards are available and modify the base-katana action tags,
- normal Combat, Rest, Shop, Treasure, miniboss, Gold, Mist/Scroll, reward, and route-choice flow remains available where meaningful,
- Shrines remain valid route rooms and use their no-Aspect/below-full support behavior,
- Blood Aspects are unavailable,
- Corruption, Resist/Embrace Tier progression, Blood, and Blood Arts are unavailable,
- Relic loadout and permanent upgrade systems are not yet active.

The game does **not** force Akio's first death at a predetermined room, enemy, miniboss, or boss. A new player is expected to die relatively early because they lack knowledge, permanent progression, Blood Aspects, Relics, and a developed toolkit, but the route itself remains honest.

A highly skilled player may progress through all three regions, defeat Keeper, Twin Maws, and the Eclipse Shogun, and reach the Heart before dying. In that exceptional case, no Binding can yet be broken because the rejection ritual requires awakened Returning Blood. Heart contact destroys Akio's current body, triggers his first Returning Blood reconstruction, and begins the normal six-Binding campaign without advancing Binding progress.

Whenever the first death occurs, dormant inherited Beast Blood awakens and reconstructs Akio at the Strand as Returning Blood. The return is brief and striking rather than a long explanatory cutscene. Akio remains silent; the player understands that he died and returned, but not yet his ancestry or the full Blood system.

The normal repeated-run preparation/progression loop begins after this return. Persistent rewards already earned on the first attempt remain saved under their normal rules.

## Regional flow

The intended full route is:

1. Hushiro Gate Village
2. Yomori Grove
3. Kagutsuchi Court
4. Eclipse Shogun
5. temporary access to the Heart chamber
6. one Binding completion during the first six successful post-awakening clears, the canonical true-final Heart encounter after all six Bindings are destroyed, or an approved postgame endpoint after Story Complete

The introductory first attempt uses this **same complete regional flow**. It is not restricted to a short Hushiro-only path.

All three regions have approved **prototype chamber structures**. Their chamber counts, structural bands, and the prototype branching-frequency model below are planning targets for implementation and playtesting rather than immutable final balance values. Exact standard-combat encounter scripts, encounter-pool counts, authored room-variant counts, and final tuned percentages remain later content/playable-validation work.

## Chamber and route model

A **counted chamber** is a room that represents an actual run node. Standard combat rooms, Shrine, Rest, Shop, Treasure, Miniboss, and regional Boss rooms can count as chambers. Small entrance corridors, boss exits, loading connectors, regional transition spaces, Heart approach spaces, and Binding-completion spaces do not count toward the regional chamber total.

The run uses a Hades-like chamber-routing model:

- each region has a broadly fixed chamber destination and fixed final boss,
- chamber-index bands determine which room functions and special opportunities are eligible,
- eligible room functions and rewards are selected procedurally through weighted generation,
- when a standard Combat chamber is selected, its combat content comes from the region's authored encounter pool rather than from an automatically assembled threat budget,
- hard generation safeguards prevent important opportunity types from disappearing from the full route network,
- route exits preview the upcoming room function and/or primary reward before commitment,
- one or two exits are the normal route presentation,
- branches may reconverge later,
- and there is no routine backtracking after choosing an exit.

A guaranteed **opportunity** means the generated route network contains at least one accessible offer of that type. It does not mean the player is forced to enter that room. Choosing a competing route can intentionally give up the guaranteed opportunity.

## Standard combat encounter model

A normal **encounter** is one authored Combat-room sequence from combat start until the room is cleared. The encounter definition owns the intended enemy composition, theme, counts, waves/spawn sequencing where applicable, and any encounter-specific restrictions.

Launch encounter construction follows these rules:

- each region has a finite pool of deliberately authored and playtested standard encounters,
- the route generator selects an eligible authored encounter when it creates a standard Combat chamber,
- encounters should usually center on a coherent enemy combination or tactical idea rather than being arbitrary mixes,
- there is **no required opening/main/pre-boss encounter-pool split** merely because the route itself has chamber bands,
- by default, an encounter in a regional pool may appear throughout that region,
- an individual authored encounter may later receive a minimum-chamber or other narrow eligibility requirement when its mechanics, teaching role, or difficulty clearly require one,
- regional difficulty progression comes primarily from the enemies and encounter compositions designed for that region; later regions naturally contain more demanding enemy mechanics rather than relying on automatic threat-budget inflation,
- encounter-pool size and every individual encounter script are intentionally deferred until the dedicated encounter-authoring pass.

Standard enemies are **region-native by default**. An enemy does not automatically carry forward unchanged into later regions simply because the run has progressed. When an earlier enemy concept continues, it should do so through a separately authored evolved regional variant whose behavior expresses the later area's identity rather than through simple stat inflation.

For launch, the only approved standard-enemy lineage across regions is **Blighted Hounds → Stalker Hound** in Yomori Grove. Stalker Hound is a separate Area 2 enemy built on the earlier hound family with new stalking, mist-repositioning, and pounce behavior. No other Hushiro standard enemy has an approved Yomori continuation, and no earlier-region standard enemy or evolved continuation is currently approved for Kagutsuchi. Regional `ENEMIES.md` files own the detailed roster boundary.

## Prototype branching frequency

Branch count is rolled from the current chamber band before room/reward contents are generated:

| Chamber band | 1 exit | 2 exits | 3 exits |
|---|---:|---:|---:|
| Opening | 50% | 50% | 0% |
| Main stretch | 25% | 70% | 5% |
| Pre-boss / final stretch | 45% | 55% | 0% |

Additional route-generation safeguards:

- three-exit choices may occur only during a region's main stretch and are capped at **one per region**,
- a normal two-exit choice should present different primary reward categories rather than duplicate the same choice,
- no region main stretch should generate more than two consecutive ordinary forced one-exit chambers,
- ordinary routing should not place two safe service rooms such as Rest and Shop back-to-back,
- a miniboss route must compete against at least one non-miniboss route,
- if a guaranteed regional opportunity has not appeared by the end of its valid window, generation forces it into an upcoming eligible branch,
- and pre-boss preparation safeguards override ordinary weights when needed.

Across the 33-chamber regional route, the current prototype target is roughly **17–19 multi-exit routing decisions** on a normal successful run. This is a pacing target rather than a hard per-run quota.

`ITEMS_AND_REWARDS.md` owns prototype room-type weights, standard-combat reward weights, Gold/Shop values, recovery/capacity values, and expected reward cadence. Final values remain subject to playtesting.

## Area 1 — Hushiro Gate Village prototype structure

Hushiro uses **12 counted chambers**, including Keeper of the Gate at Chamber 12. The current active-time target is approximately **14–16 minutes**.

### Chambers 1–3 — Opening stretch

- **Chamber 1 is fixed:** a standard combat encounter followed by a guaranteed Technique reward.
- Chambers 2–3 introduce the normal previewed route-choice structure.
- Chamber 1's authored encounter should function as an accessible opening combat test; further encounter-specific early gating is assigned only during encounter authoring when needed.
- Hushiro's build purpose is to establish the first direct-action modifications and the first recognizable family/build direction, not to finish the build.
- On the first attempt, this same guaranteed Technique reward modifies the base katana rather than a Blood Aspect weapon kit.

### Chambers 4–8 — Main stretch

The complete normal Hushiro room/reward pool is eligible here. Combat remains the majority experience, while route choices may lead toward Technique, Gold, Mist, Scrolls, Shrine, Rest, Shop, Treasure, or Miniboss opportunities.

Hushiro's single miniboss opportunity is eligible during **Chambers 5–8**. Each run selects one candidate from:

- Village Ogre
- The Collector

The miniboss path is optional. A normal Hushiro run therefore contains **0–1 fought minibosses**, even though one miniboss opportunity is generated into the route network.

### Chambers 9–11 — Pre-boss stretch

- Minibosses leave the eligible pool.
- Standard Combat still draws from the authored Hushiro encounter pool; any encounter reserved for later Hushiro chambers must be explicitly tagged that way during encounter authoring rather than belonging to a mandatory separate pre-boss pool.
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

These are network opportunities rather than mandatory visits.

## Area 2 — Yomori Grove prototype structure

Yomori uses **10 counted chambers**, including Twin Maws at Chamber 10. The current active-time target is approximately **12–14 minutes**.

Yomori is intentionally shorter than Hushiro because its normal enemies, minibosses, and paired regional boss are mechanically more complex.

### Chambers 1–2 — Opening stretch

- Branching begins immediately.
- There is no fixed guaranteed Technique reward on Yomori Chamber 1; the player already enters with an established run build.
- Standard Combat draws from the authored Yomori encounter pool. Any encounter that must be delayed until later chambers receives an explicit encounter-level eligibility requirement during authoring rather than relying on a universal opening encounter tier.

### Chambers 3–7 — Main stretch

The main Yomori room/reward pool is active here. Area 2's build purpose is to expand direct-action coverage where still open and deepen the existing build through Supporting Techniques, refinements, Cross-family eligibility, continued Aspect progression after awakening, and other reward choices.

Yomori's single miniboss opportunity is eligible during **Chambers 4–7**. Each run selects one candidate from:

- The Embered Pilgrim
- Rotwood Host

The miniboss path is optional. A normal Yomori run therefore contains **0–1 fought minibosses**, even though one miniboss opportunity is generated into the route network.

### Chambers 8–9 — Pre-boss stretch

- Minibosses leave the eligible pool.
- Standard Combat continues using eligible authored Yomori encounters rather than switching to a separate mandatory late-region encounter pool.
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

## Area 3 — Kagutsuchi Court prototype structure

Kagutsuchi uses **11 counted chambers**, including the Eclipse Shogun at Chamber 11. The current active-time target is approximately **15–17 minutes**.

Kagutsuchi is the mature-build region. Its standard enemies are inherently more demanding because Court enemies combine revival, ranged ritual pressure, directional defense, spawning, frenzy, and more disciplined coordinated behavior.

### Chambers 1–2 — Court entrance

- Branching begins immediately.
- There is no fixed opening Technique reward; the player enters with an established build from Hushiro and Yomori.
- Standard Combat draws from the authored Kagutsuchi encounter pool. Encounter-specific minimum-chamber restrictions may be added later when a particular composition needs them.
- Kagutsuchi should become dangerous immediately through enemy behavior and composition rather than simple Health inflation.

### Chambers 3–7 — Main Court

The complete normal Kagutsuchi room/reward pool is eligible here. The region's build purpose is to **finish or sharpen the mature run build** through remaining direct-action Techniques, Supporting Techniques, refinements, Cross-family Techniques, rare replacements, eligible Legendaries, continued Shrine decisions after awakening, and competing economy/survival rewards.

Kagutsuchi's single miniboss opportunity is eligible during **Chambers 4–7**. Each run selects one candidate from:

- Blood Lotus
- Eternal Swordsman

The miniboss path is optional. A normal Kagutsuchi run therefore contains **0–1 fought minibosses**, even though one miniboss opportunity is generated into the route network.

### Chambers 8–10 — Final Court / Shogun approach

- Minibosses leave the eligible pool.
- Standard Combat continues using eligible authored Court encounters rather than a separate mandatory final encounter tier; the environment and chosen encounter compositions should still support the approach to the Shogun.
- No new run-build system is introduced here; the purpose is final build decisions and preparation for the Shogun.
- Across **Chambers 9–10**, the generated route must expose at least one meaningful final-preparation opportunity such as Rest, Shop, Technique, Treasure, or another approved high-value preparation choice.
- This safeguard does not guarantee a full heal or automatic ideal build.

### Chamber 11 — Eclipse Shogun

The Eclipse Shogun is fixed at Chamber 11 and completes the normal three-region combat route. All Kagutsuchi routes converge on his royal arena.

The Shogun must test a mature run build without assuming a specific Aspect Tier, Blood Art, Technique family, Legendary, Relic, Prosthetic upgrade level, or exact reward history.

A rare pre-awakening dialogue state exists if an exceptional first-attempt player reaches him before Akio's first death. It does not replace the seven awakened-campaign confrontation states.

### Kagutsuchi route-network safeguards

Before the Shogun, the generated route network must contain at least:

- **1 Shrine opportunity**,
- **1 Shop opportunity**,
- **1 Rest opportunity**,
- **1 optional miniboss opportunity**,
- **2 Technique-reward opportunities**,
- **1 meaningful final-preparation opportunity across Chambers 9–10**.

These are network opportunities rather than mandatory visits.

## Regional boss transitions

Defeating Keeper or Twin Maws leads into a brief **safe regional transition space** that does not count as an additional chamber.

The transition should:

- grant the approved regional boss reward,
- apply the automatic recovery prototype owned by `ITEMS_AND_REWARDS.md`,
- allow concise build review and an optional **Relic swap** when the Relic system/collection is available,
- visually transition into the next region,
- and preserve run momentum rather than functioning as a second Strand or overloaded menu hub.

The current recovery prototype restores **20% max Health and 35% max Spirit**, then enforces minimum next-region entry floors of **35% max Health and 50% max Spirit**. This is viability support rather than a full reset. Blood is not automatically refilled.

The safe transition after Keeper is the normal in-run Relic swap point before Yomori. The safe transition after Twin Maws is the normal in-run Relic swap point before Kagutsuchi. Newly discovered Relics may also be equipped immediately at discovery; routine swapping is not available in combat, ordinary rooms, Rest rooms, Shops, or the pause menu. If Relics are not yet available on the first attempt, the transition simply omits that management step.

Exact transition-interface presentation and final recovery tuning remain later implementation/playtest decisions.

## Post-Shogun handoff

The Eclipse Shogun does **not** lead to another counted regional transition chamber.

### Exceptional pre-awakening first-attempt clear

If Akio reaches the Heart before his first death:

**Shogun → Heart approach → pre-awakening Heart chamber → no Binding ritual available → Heart destroys Akio → first Returning Blood reconstruction at the Strand.**

No Heart Binding is destroyed in this exceptional sequence.

### First six successful post-awakening clears

**Shogun → Heart approach → Binding chamber / extraction ritual → one Binding breaks → Akio is dissolved → Strand return.**

After all six remaining Bindings are destroyed, the seventh successful story run instead continues:

**Shogun → Heart approach → true-final Heart encounter**, carrying the same active run build forward.

Heart approach spaces, the Binding-completion chamber, and the true-final Heart encounter are specialized endgame content outside Kagutsuchi's 11 counted chambers. The Shogun does not provide ordinary current-run power during the first six Binding clears because those runs end through the Binding ritual.

For the seventh story run and postgame Heart-suppression routes, the Shogun-to-Heart handoff uses the partial final-encounter recovery prototype owned by `ITEMS_AND_REWARDS.md`: restore **30% max Health and 50% max Spirit**, then enforce minimum Heart-entry floors of **40% max Health and 60% max Spirit**. This preserves a strong Shogun clear as an advantage while keeping the Heart viable after a narrow Shogun victory. Blood is not automatically refilled unless later Heart encounter design explicitly requires a different rule.

## Approved duration target

A normal successful Binding run should target approximately **45–50 minutes of active run time** from Boat departure through completion of the Heart Binding return.

Supporting targets:

- experienced repeat clear: approximately 35–42 minutes,
- typical successful Binding run: approximately 45–50 minutes,
- cautious or first successful clear: approximately 50–60 minutes,
- standard successful-run ceiling: runs should not routinely exceed 60 minutes,
- Heart route / Heart-suppression run: approximately 55–60 minutes, with slower successful attempts able to approach 65 minutes.

The two-form Heart continuation should add approximately 8–12 minutes to the established Shogun route rather than functioning as another full region.

Active run time includes combat, reward choices, shops, rests, transitions, bosses, and the Binding or Heart completion sequence. It excludes Strand preparation, trials, codex reading, and time spent paused.

The current three-region prototype budget is **33 counted chambers total**: 12 Hushiro + 10 Yomori + 11 Kagutsuchi. Regional active-time targets are approximately 14–16, 12–14, and 15–17 minutes respectively. The route-generation prototype targets roughly 17–19 multi-exit decisions and, together with the reward model in `ITEMS_AND_REWARDS.md`, roughly 20–22 standard combat chambers on a normal completed route. These values must be validated in playable builds against the 45–50-minute target once the authored encounter roster exists.

## Standard run start

Before a normal **post-awakening** departure, the player:

- completes available Strand preparation,
- confirms one unlocked Blood Aspect,
- confirms the current Prosthetic and Relic loadouts when those systems are available,
- uses the Boat as the final run-start confirmation,
- begins at Blood Aspect Tier 0,
- begins with five empty direct Technique slots: Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow,
- starts without the previous run's Corruption, slotted or Supporting Techniques, refinements, replacement state, Gold, room progress, or previous run-only Relic activation state,
- and commits to the Keeper-guided barrier crossing by selecting `Start Run`.

The Keeper's contribution remains part of the departure presentation rather than a separate repeated menu or resource cost.

The first attempt is the one exception: it starts directly in the normal Hushiro route without a Blood Aspect or normal persistent loadout preparation, using Beast-Bane Whistle as the default Prosthetic.

After Returning Blood awakens, Blood Aspect selection becomes part of subsequent run preparation. The **Blood Mirror** is a separate permanent-Aspect progression station and remains locked until the first Keeper defeat.

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

On the first attempt, the same Technique-growth cadence operates on the base katana while Aspect-specific growth remains absent.

A successful run should create several meaningful Technique decisions without awarding a Technique after every combat room. There is no global Technique inventory cap; practical Technique growth is constrained by reward opportunities, route competition, prerequisites, and run length. Prototype reward cadence is owned by `ITEMS_AND_REWARDS.md`; exact final balance remains playtest work.

## Failed run

After Returning Blood has awakened, Akio's death reconstructs him at the Strand. Death is a real supernatural event, not a non-canon reset.

A failed run burns away temporary Blood state and run-only progress. Permanent unlocks, upgrades, Run Infrastructure, Relic collection/mastery/progression, discoveries, Blood Mirror progress after unlock, and persistent currencies survive according to the progression matrix.

Akio may prepare and board the Boat again without the narrative defining an exact elapsed time between attempts.

Akio's **first** death is handled by `FIRST_ATTEMPT.md`: it awakens Returning Blood and begins this repeated return structure.

## Successful Binding run

On a successful post-awakening Binding run, Akio:

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

The ritual is one reusable completion sequence: blood offering, Heart reaction, one Binding rupture, Akio's dissolution, and Strand reconstruction. Clear-to-clear escalation uses the six approved visual/campaign states in `NARRATIVE_DELIVERY.md` rather than a different mechanism or puzzle every time.

The destroyed Binding remains gone because it is an external ancient restraint that the Heart did not create and cannot regenerate. Akio destroys only one per run because the retaliation immediately kills his current body.

Successful completion and failed death both return Akio to the Strand, but they must remain visually and narratively distinct. See [Run Results and Strand Return](../ui_ux/RUN_RESULTS.md).

## Campaign clear structure

The Heart's prison originally contained seven Heart Bindings. The Court destroyed the outermost Binding before the game, leaving six intact when Akio begins the campaign.

After Returning Blood awakens, the main campaign requires six successful Binding runs. Each destroys one remaining restraint. Failed runs do not advance the count.

After the sixth Binding is destroyed, the next successful full run becomes the seventh and final story run. No Binding remains, so Akio does not repeat the extraction ritual or automatically dissolve after the Shogun. He continues directly into the Heart encounter with the same active build.

The six-clear requirement is a roguelite mastery target rather than six unique story missions. Continued play is supported through alternate Blood Aspects, Techniques, Prosthetics, Relics, routes, rewards, persistent upgrades, and increasing player consistency.

The base game does not require island-wide visual transformations, universal enemy modifiers, new regional environment sets, or new enemy families after every Binding clear.

## True-final Heart route

The true-final Heart **encounter** unlocks only after all six remaining Bindings are destroyed. Merely reaching the Heart chamber during an exceptional pre-awakening first attempt does not unlock or start this encounter.

The first unlocked Heart route is the final story run. The player must complete the established island route, defeat the Eclipse Shogun, and defeat the Heart without ending or losing the run between those encounters.

The Heart encounter has exactly two conceptual forms:

1. **The Unbound Heart** — the exposed Heart tears free, creates malformed support limbs, and becomes a mobile beastlike organ.
2. **The Vessel of Continuance** — the Heart forms an enormous nonhuman defensive vessel around itself while remaining visibly central.

The Heart is not a humanoid swordsman and does not add a separate weak-point subsystem. Exact attacks, timings, posture behavior, transitions, arena rules, animation lists, and tuning remain later encounter-design and playtest work.

Returning Blood's rejection of the Heart supports the final severance of its ability to create and spread new Beast Blood without creating a new one-off player mechanic.

## First Heart victory and ending

The first true-final Heart victory canonically completes the main story.

Akio destroys the Heart's manifested combat body and reduces it to a faint regenerating remnant. The permanent victory is that the Heart can never again produce, release, or spread **new Beast Blood**.

Consequences:

- the Shogun's plan to spread Beast Blood to the mainland is permanently defeated,
- the Court extraction cycle can never create new bearers again,
- Beast Blood can no longer expand beyond the existing population,
- the Heart's future activity is reduced to a local suppression/containment problem,
- existing Beast Blood remains fully active in Akio, the Shogun, and other existing bearers.

Akio retains Returning Blood, Blood Aspects, supernatural regeneration, and reconstruction. The Shogun retains his established reconstruction. Existing corrupted enemies and other bearers are not erased by the ending.

Akio remains silent. The ending and credits follow the first Heart victory.

## Canonical postgame runs

After Story Complete, Akio continues returning to the island to monitor existing Beast Blood threats and suppress the Heart's physical regrowth.

The Boat provides two postgame run goals before departure:

1. **Standard Expedition** — the normal three-region route ends after defeating the Shogun.
2. **Heart Suppression** — the normal route continues from the Shogun into the regenerated Heart manifestation.

These labels are approved working player-facing names and may receive final copy polish without reopening the structure.

A repeat Heart-suppression clear is canonical containment activity. It does not create another ending or restore the Heart's ability to make new Beast Blood.

Postgame does not add a new currency or permanent progression tree. Runs continue to support existing Mist/Scroll/boss-material progression, Relic mastery, Prosthetic completion, Blood Mirror completion, Technique discovery, trials, records, and build experimentation.

The launch game does **not** require Heat/Pact-style modifiers, New Game+, endless mode, daily challenges, enemy/room variant packages, an additional Aspect, or another postgame campaign. Those remain post-launch possibilities only if testing/player demand justifies them.

`ENDGAME_POSTGAME_RELEASE.md` owns postgame records, completion goals, achievements, launch front-end/settings/accessibility/credits scope, and explicit deferred features.

## Run growth

A run may change through:

- Blood Aspect Tier choices after the first awakening,
- five direct slotted Techniques,
- slotless Supporting / Cross-family / Legendary Techniques,
- Technique refinements and rare same-slot replacements,
- the equipped Prosthetic,
- the equipped Relic benefit after that system is available,
- run-only currencies and materials,
- survival and resource-cap rewards,
- boss, miniboss, treasure, shop, or discovery rewards.

Oathbound does not add a general consumable inventory or one-use item layer to run growth at launch.

Prosthetic and Relic permanent progression belongs to the Forge rather than a temporary Technique layer.

## Reset boundary

The following reset after death, successful Heart Binding return, Standard Expedition clear, or Heart Suppression clear:

- Corruption where active,
- Blood Aspect Tier where active,
- slotted Techniques,
- Supporting / Cross-family / Legendary Techniques,
- Technique refinements and replacement state,
- Gold,
- room progress,
- the current run's Relic activation state where applicable,
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
- story-completion state,
- postgame route access,
- postgame records and completion progress.

See [Progression](PROGRESSION.md) for system ownership and the persistence matrix.
