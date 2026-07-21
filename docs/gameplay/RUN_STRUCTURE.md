---
id: GAMEPLAY-RUN-STRUCTURE
title: Run Structure
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-21
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

Before the normal roguelite loop begins, the player completes Akio's first attempt.

Akio enters as an ordinary Order swordsman with dormant inherited Beast Blood but no knowledge of it and no active Blood powers.

During this attempt:

- the player uses the base katana kit and available Order equipment,
- Blood Aspects are unavailable,
- Shrine Resist and Embrace progression is unavailable,
- Blood-derived Techniques are unavailable,
- and the player is introduced to the island and core combat without a full run build.

The first attempt ends in Akio's first death. The exact enemy, location, run length, and whether the endpoint is fully scripted or reached through a designed unwinnable encounter remain opening-production decisions.

Death awakens the dormant Beast Blood inherited through Akio's escaped royal bloodline. It reconstructs him at the Strand as Returning Blood.

The first return should use a brief, striking presentation with subtle physical and environmental signs rather than a long explanatory cutscene. Akio and the player should understand that he died and returned, but not yet understand his ancestry or the full Blood system.

The normal repeated-run structure begins after this return.

## Regional flow

The current intended progression is:

1. Hushiro Gate Village
2. Yomori Grove
3. Kagutsuchi Court
4. Eclipse Shogun
5. Temporary access to the Heart chamber
6. One Binding completion during the first six successful clears, or the unlocked true-final Heart encounter after all six Bindings are destroyed

Exact branching, room counts, rerouting, and area-order flexibility remain implementation and playtest questions.

The introductory attempt may use only a short portion of Hushiro rather than the complete regional flow.

## Standard run start

Before departure, the player:

- completes available Strand preparation,
- confirms an unlocked Blood Aspect at the Boat after the system is unlocked,
- confirms the current prosthetic loadout when available,
- begins at Blood Aspect Tier 0,
- begins with four empty active Technique slots and one empty reserve slot,
- starts without the previous run's Corruption, Techniques, refinements, Gold, room progress, or temporary Relic effects,
- and commits to the Keeper-guided barrier crossing by selecting `Start Run`.

The Keeper's contribution should remain part of the departure presentation rather than a separate repeated menu or resource cost.

Blood Aspect selection does not appear during the first attempt and need not become available immediately after the first return. Akio and the player unlock and learn advanced Blood systems through later progression.

## Room functions

The game uses recognizable room categories:

- Combat
- Shrine
- Rest
- Shop
- Treasure/reward
- Miniboss
- Boss approach and boss arena
- Heart approach and Binding-completion chamber after the Shogun

Each function should read before interaction through environment composition, focal props, lighting, and UI treatment.

Combat routes may also display a previewed primary reward category before entry. Room function and reward category are related but separate: a standard combat encounter may pay out Gold, Mist, Scrolls, recovery, temporary run growth, or a Technique opportunity.

Detailed reward ownership and cadence belong in [Items, Currencies, and Rewards](ITEMS_AND_REWARDS.md).

## Run power curve

The intended build progression after the relevant systems are unlocked is:

- **Area 1:** acquire the first meaningful Techniques and begin defining the build.
- **Area 2:** fill the four active Technique slots, gain Aspect Tiers, and establish coherent synergy.
- **Area 3:** refine, replace, use reserve strategically, and finalize the build for the Shogun and any enabled Heart continuation.

A successful run should create several meaningful Technique decisions without awarding a Technique after every combat room.

## Failed run

After Returning Blood has awakened, Akio's death reconstructs him at the Strand. Death is a real supernatural event, not a non-canon reset.

The failed run burns away its temporary blood-state and run-only progress. Permanent unlocks, upgrades, discoveries, Blood Mirror progress, and major currencies survive according to the progression matrix.

Akio may prepare and board the Boat again without the narrative defining an exact elapsed time between attempts.

## Successful Binding run

On a successful Binding run, Akio:

1. defeats the Eclipse Shogun's current manifestation,
2. gains temporary access to the Heart chamber and the Shogun-built extraction apparatus,
3. cuts himself and offers Returning Blood through that apparatus,
4. causes the Heart to attempt to reclaim the Blood,
5. breaks one ancient Heart Binding when Akio's resistant Blood rejects that control,
6. is dissolved into blood by the Heart's retaliation,
7. reforms at the Strand through Returning Blood,
8. saves permanent rewards and the destroyed-Binding campaign progress,
9. clears temporary run-state,
10. receives a results summary,
11. triggers relevant NPC, codex, Blood Mirror, Heart-state, or hub updates.

The ritual should remain visually direct: blood offering, Heart reaction, one Binding rupture, Akio's dissolution, and Strand reconstruction. It is one reusable completion sequence with escalating Heart exposure rather than a separate mechanism or puzzle for every Binding.

The destroyed Binding remains gone because it is an external ancient restraint that the Heart did not create and cannot regenerate. Akio can destroy only one per run because the retaliation kills his current body immediately after the Binding breaks.

Successful completion and failed death both return Akio to the Strand, but they must remain visually and narratively distinct. See [Run Results and Strand Return](../ui_ux/RUN_RESULTS.md) for presentation requirements.

## Campaign clear structure

The Heart's ancient prison originally contained seven Heart Bindings. The Shogun's researchers destroyed the outermost Binding before the game, leaving six intact Bindings when Akio begins the campaign.

The main campaign requires six successful Binding runs. Each successful Binding run destroys one of those six remaining restraints. Failed runs do not advance the Binding count.

After the sixth Binding is destroyed, the Heart's deeper body is exposed and the next successful full run becomes the final story run. No Binding remains during that run, so Akio does not repeat the extraction ritual and is not automatically dissolved after defeating the Shogun's current body. He continues directly into the true-final Heart encounter with the same run still active.

The Shogun is not permanently killed through a separate anti-regeneration method before the Heart. His body may begin reconstructing as it did after earlier defeats. Destroying the Heart ends the curse, makes Beast Blood inert, stops that reconstruction, frees the Shogun from the Blood's influence, and allows his body to die permanently with the rest of the corrupted island.

The six-clear requirement is a roguelite mastery target rather than six unique story missions. Continued play is supported primarily by alternate Blood Aspects, Techniques, prosthetics, Relics, routes, rewards, persistent upgrades, and increasing player consistency.

Mandatory clear-to-clear production remains restrained. Progress is communicated through:

- six removable or broken Binding states around the same Heart chamber,
- progressively greater Heart exposure and stronger room-local pulse, movement, sound, and reaction,
- a clear destroyed-versus-remaining Binding tracker in results or campaign presentation,
- and concise Shogun, NPC, or codex progression where appropriate.

The base game does not require island-wide visual transformations, universal enemy modifiers, new regional environment sets, or new enemy families after every Binding clear. Those ideas remain optional future expansion material.

## True-final Heart route

The true-final Heart encounter unlocks only after all six remaining Bindings have been destroyed.

The first unlocked Heart route is the final story run. The player must defeat the Eclipse Shogun and then defeat the Heart without ending or losing the run between those encounters. The Heart is an additional true-final boss after the established three-region route and Shogun climax, not a replacement for the Shogun.

The Heart encounter has two conceptual phases:

1. **The Unbound Heart** — the fully exposed Heart tears free of the ancient prison and Shogun-built apparatus, grows malformed limbs, and becomes a mobile beastlike organ.
2. **The Vessel of Continuance** — the Heart forms an enormous nonhuman defensive vessel around itself, creating a larger and more complete beast body while remaining visibly central to that form.

The Heart is not a humanoid swordsman, does not create another samurai duel, and does not require a weak-point subsystem that does not exist elsewhere in Oathbound. Exact attacks, timings, numerical tuning, arena-control rules, posture behavior, transitions, and final animation lists remain encounter-design and playtest work.

The final resolution may use Returning Blood's established rejection of the Heart as the narrative basis for Akio surviving direct contact and creating the opportunity to destroy the exposed source. This does not add a separate player mechanic or weak-point system by itself.

## First Heart victory and ending

The first true-final Heart victory canonically completes the story.

Destroying the Heart makes active Beast Blood inert across the island. Its death:

- stops the Shogun's reconstruction and allows him to die permanently,
- frees corrupted inhabitants from the curse before their unnaturally sustained bodies fail,
- collapses corrupted beasts and failed bodies,
- allows Yomori's lingering spirits to pass on,
- ends the supernatural Blood Moon cycle,
- and allows the containment barrier to weaken safely.

Akio survives in his current complete human body, but Returning Blood, Blood Aspects, supernatural regeneration, and future reconstruction end with the source. He becomes mortal.

The ending and credits follow the first Heart victory.

## Postgame runs

After the story is completed, the save remains playable. Akio may continue starting normal roguelite runs and may repeat the true-final Heart route.

Repeat Heart victories are gameplay challenges only. They do not advance the story, produce additional canonical endings, destroy another Heart, or reverse the completed ending. The first victory remains the canonical conclusion.

The postgame should allow the player to choose or meet a clear condition for whether a completed run ends after the Shogun or continues into the harder Heart encounter. The exact Boat option, modifier, menu label, reward structure, and unlock presentation remain future design work.

Future postgame development may explore additional difficulty settings, run modifiers, enemy or room variants, challenge restrictions, and special rewards tied to challenging the Heart. These are explicitly deferred and are not part of the initial game scope.

The Binding identity, repeated ritual, persistent damage rule, forced-return cause, seven-original/six-remaining count, six successful Binding clears, seventh final-story run, two-phase Heart concept, first-clear ending, and repeatable non-progressing postgame Heart route are locked. Exact clear rewards, dialogue allocation, Shogun reconstruction presentation, Heart moveset, balance tuning, postgame route control, and optional future challenge systems remain open.

## Run growth

A run may change through:

- Blood Aspect Tier choices,
- four active Techniques and one reserve Technique,
- Technique refinements and replacements,
- prosthetic tools, resources, and eligible Prosthetic Techniques,
- run-scoped Relics,
- consumables,
- temporary currencies and materials,
- survival and resource-cap rewards,
- boss, miniboss, treasure, shop, or discovery rewards.

## Reset boundary

The following reset after death or successful Heart Binding return:

- current Corruption,
- Blood Aspect Tier,
- active Techniques,
- reserve Technique,
- Technique refinements,
- Gold,
- room progress,
- temporary Relic effects,
- other explicitly run-only states.

The following persist:

- unlocked Blood Aspects,
- chosen Aspect as an available loadout selection,
- unlocked Techniques in future reward pools,
- permanent upgrades,
- Blood Mirror trial and mastery progress,
- narrative discoveries,
- codex progression,
- major permanent currencies and rewards,
- destroyed Heart Bindings and equivalent campaign progress,
- story-completion state and unlocked postgame Heart access.

See [Progression](PROGRESSION.md) for system ownership and the current persistence matrix.
