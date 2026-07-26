---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-07-26
---

# Current Design Questions

This file contains unresolved decisions that materially change release scope, production workload, interfaces, or authored presentation. Exact numerical tuning remains implementation and playtesting work.

## Priority order

1. Three-Aspect weapon-kit roster audit and final approval
2. Shared Aspect progression structure and selected packages
3. Launch run-build content catalog
4. Persistent progression, onboarding, and trial package
5. Narrative delivery and authored-content package
6. Postgame release package

## Resolved Blood Aspect foundation

The following direction is approved:

- the player selects one Blood Aspect before a run,
- the selected Aspect creates an immediate Tier 0 sword-combat identity,
- the current launch baseline contains Wolf, Wraith, and Ronin,
- all Aspects use one physical katana expressed through different Returning Blood forms,
- shared controls do not require one identical moveset,
- each Aspect owns a complete sword kit assigned to shared offensive action slots,
- ordinary Techniques use one universal ruleset,
- and the initial roster is completed before exact progression, Blood Arts, or production counts are locked.

The authoritative design rule is:

> **The moves create the playstyle. An Aspect should not depend on a mandatory combo goal, forced movement loop, or separate behavioral minigame.**

See `gameplay/ASPECT_WEAPON_KIT_MODEL.md`.

## Resolved weapon-kit action model

Every candidate defines:

- **Basic Attack:** primary attack sequence and normal swordplay,
- **Held Attack:** major secondary or committed sword action,
- **Dash Attack:** offensive follow-up after the universal neutral dash,
- **Parry Counter:** direct attack after the universal parry,
- and potentially **Blood Art** later if retained by the final progression system.

Aspect identity should emerge from connected differences in:

- attack cadence,
- sequence length,
- reach,
- hit geometry,
- attack-bound movement,
- tracking,
- health damage,
- enemy-posture pressure,
- stagger,
- commitment,
- recovery,
- target handling,
- modest defensive profile where approved,
- and Blood-katana presentation.

The Held Attack is a genuine secondary sword action. It does not need to be one universal thrust or merely a charged Basic Attack.

## Resolved universal layer

Every launch candidate shares the same functional:

- controller layout,
- ordinary locomotion,
- neutral dash distance, speed, startup, invulnerability, recovery, steering, collision, and repeat availability,
- defense input,
- parry timing and success rules,
- enemy telegraphs and response logic,
- posture-break and stagger language,
- deathblow eligibility and execution behavior,
- Technique system,
- prosthetic system,
- and combat interface language.

Aspect selection must not create a weaker or stronger neutral dash.

## Resolved defensive-profile boundary

Every launch kit retains block, parry, dodge, player posture, and deathblows.

Modest differences may be used in:

- player-posture capacity,
- block posture efficiency,
- posture recovery direction,
- defensive access after attacks,
- and Parry Counter payoff.

The following remain universal:

- defense input,
- parry timing,
- parry success conditions,
- posture-break consequences,
- and enemy attack-response rules.

No launch Aspect removes block or parry, gains automatic counters, becomes immune to posture break, or recovers posture freely while actively guarding.

## Resolved combo and movement boundaries

### Combos

A combo or attack sequence is a set of available sword attacks, not a required objective.

The player may stop, defend, dash, redirect, use a Prosthetic, or abandon a sequence without failing the Aspect's intended gameplay.

Do not define a kit around:

- preserving a combo state,
- reaching one finisher as the main goal,
- maintaining a combo through unrelated actions,
- or looping a sequence as a mandatory success condition.

### Movement

Attack-bound movement is valid when it naturally belongs to the attack.

Do not manufacture identity through:

- mandatory lateral movement after ordinary attacks,
- every counter changing position,
- every dash attack ending at a special offset,
- automatic movement behind enemies,
- or movement-direction input selecting unrelated Basic Attacks.

A spacing playstyle should usually emerge from reach, geometry, timing, tracking, and recovery.

## Resolved Aspect-Technique responsibility contract

- **Aspect:** pre-run, always-present sword foundation active from Tier 0.
- **Techniques:** four active temporary modifications plus one inactive reserve.
- An Aspect must function before any Technique is acquired.
- Ordinary Techniques must function with every Aspect.
- Ordinary Techniques are not hard-locked to an Aspect or minimum Tier.
- Affinity may later amplify or weight offers; it does not determine eligibility.
- A Technique modifies a specific action, condition, payoff, transition, resource interaction, or tactical option.
- A Technique cannot repair an incomplete Aspect kit.
- Aspect progression cannot make Techniques secondary.

Ordinary Technique action tags include:

- Basic Attack,
- Held Attack,
- Dash Attack,
- Parry Counter,
- Block,
- Parry,
- Deathblow,
- Prosthetic,
- Health,
- Enemy Posture,
- Player Posture,
- and Movement.

Technique builds may reinforce, broaden, compensate, or hybridize the selected kit.

## Resolved qualitative launch candidates

Wolf, Wraith, and Ronin are each approved at qualitative Tier 0 weapon-kit depth for comparison.

Three is the current production baseline, not a permanent ceiling. The weapon-kit model may eventually support a fourth and possibly fifth Aspect, but neither belongs to current launch paper-design, animation, VFX, UI, trial, content-count, or milestone scope.

### Wolf — fast close-range pressure kit

Approved qualitative package:

- **Basic Attack:** Fang Slash → Rending Cross → Raking Fang → Blood Cleave,
- **Held Attack:** Predator's Passage,
- **Dash Attack:** Hunting Slash,
- **Parry Counter:** Fang Reversal,
- four-hit fastest sequence,
- short reach,
- strong forward attack movement,
- strong nearby tracking,
- moderate per-hit damage,
- strong sustained health and enemy-posture output,
- and significant whiff and overcommitment risk.

Wolf changed from a three-hit to four-hit sequence because an additional fast pursuit strike better expresses its sustained pressure identity. The player may stop at any point.

Still unresolved:

- exact values and frame data,
- exact hitboxes and chain windows,
- Predator's Passage eligibility and collision behavior,
- exact animations and Blood presentation,
- later mechanics and progression,
- Technique interactions,
- production counts,
- and final roster inclusion after the audit.

See `gameplay/WOLF_ASPECT.md`.

### Wraith — extended spectral poke and reach-control kit

Approved qualitative package:

- **Basic Attack:** Veil Cut → Passing Arc,
- **Held Attack:** Pale Lance,
- **Dash Attack:** Ghostline Slash,
- **Parry Counter:** Veil Reversal,
- two-hit short sequence,
- longest effective melee reach,
- narrow line attacks and broad spectral arcs,
- quick return to movement or defense,
- moderate per-hit damage,
- restrained tracking,
- and weakness when enemies enter inside preferred range.

Wraith's spacing emerges from concrete attack reach and geometry. The following remain rejected:

- mandatory lateral movement on Passing Arc,
- required reposition-and-reassess behavior,
- Ghostline Slash always ending at an offset,
- Veil Reversal always shifting off-axis,
- unique neutral dash properties,
- and teleportation or additional invulnerability.

Still unresolved:

- exact values and frame data,
- exact hitboxes and arc geometry,
- Pale Lance charge behavior,
- exact animations and Blood presentation,
- later mechanics and progression,
- Technique interactions,
- production counts,
- and final roster inclusion after the audit.

See `gameplay/WRAITH_ASPECT.md`.

### Ronin — slow precise heavy-hitting kit

Approved qualitative package:

- **Basic Attack:** Severing Cut → Crushing Cross → Bloodfall,
- **Held Attack:** Stillness Draw,
- **Dash Attack:** Breaching Slash,
- **Parry Counter:** Answering Steel,
- three-hit slow sequence,
- conventional medium sword reach,
- highest per-hit health damage,
- highest or near-highest per-hit enemy-posture pressure,
- strongest ordinary-enemy stagger,
- minimal attack-bound movement,
- low-to-moderate tracking,
- severe whiff recovery,
- and a stronger guard profile balanced by slow posture recovery and committed attacks.

Ronin rejects:

- preserving a combo through defense,
- playing around reaching a named finisher,
- movement-direction input selecting basic attacks,
- and defining the kit only through parry.

Stillness Draw is a defining high-damage Held Attack. Its advantage is power rather than Wraith-like reach.

Breaching Slash provides a quicker convenient attack after the universal dash, but remains weaker than Ronin's normal heavy strikes so it does not replace them.

Still unresolved:

- exact values and frame data,
- exact hitboxes,
- exact block efficiency and player-posture values,
- exact stagger and interruption rules,
- Stillness Draw charge behavior,
- exact animations and Blood presentation,
- later mechanics and progression,
- Technique interactions,
- production counts,
- and final roster inclusion after the audit.

See `gameplay/RONIN_ASPECT.md`.

## 1. Three-Aspect weapon-kit roster audit and final approval

The next active task is to compare the three approved qualitative kits together.

### Overlap and gap audit

Determine:

- whether Wolf, Wraith, and Ronin remain mechanically distinct during ordinary gameplay,
- whether any kit is merely a stronger or weaker version of another,
- whether the 4/2/3 sequence structure produces clear cadence without becoming an objective,
- whether the roster covers close pressure, extended reach, and heavy direct impact without leaving launch-critical territory missing,
- whether Held Attacks remain clearly separated as pursuit, reach, and power,
- whether Dash Attacks and Parry Counters reinforce each kit without replacing universal systems,
- whether Ronin's defensive advantages remain balanced,
- and whether all three remain recognizable as Akio using one katana and one combat language.

### Encounter audit

Confirm each kit remains viable and active against:

- mixed waves,
- crowds,
- ranged pressure,
- mobile enemies,
- elites and minibosses,
- hazards and area denial,
- and bosses.

### Technique and Prosthetic audit

Confirm:

- several reinforce, broaden, compensate, and hybridize builds per kit,
- no Aspect owns an entire Technique category,
- ordinary Techniques remain understandable through universal action tags,
- no Technique is required to repair a base kit,
- and prosthetics retain meaningful tactical space.

### Production audit

Estimate:

- unique Basic Attack animations,
- Held Attack animations,
- Dash Attack animations,
- Parry Counter animations,
- Blood-form VFX and audio,
- icons and selection presentation,
- teaching and mastery trials,
- and any special collision or hit-reaction requirements.

### Final roster decision

After the audit:

1. retain or revise each kit,
2. resolve overlap or missing territory,
3. confirm final candidate names,
4. approve one concise three-row launch roster,
5. and then advance to the progression structure.

## 2. Shared Aspect progression structure and selected packages

After final roster approval, decide:

- whether Tier 0-IV remains appropriate,
- whether every selected Aspect uses the same Tier contract,
- whether Blood remains a Tier II run-only resource,
- whether every Aspect receives one Blood Art,
- whether one evolving drawback family remains correct,
- how Resist, Embrace, and maximum-Tier Shrine behavior work,
- Blood generation and activation if retained,
- the exact package for each approved Aspect,
- how progression deepens rather than replaces the weapon kit,
- detailed affinity and offer-weighting rules,
- whether limited direct Aspect-, Blood-, or Tier-referencing Techniques ship,
- and required HUD, input, animation, VFX, audio, trial, and progression states.

The prior working model used:

- Tier 0 as the immediate foundation,
- Tier I to deepen it and possibly introduce risk,
- Tier II to unlock Blood and a Blood Art,
- Tier III to deepen the specialization,
- Tier IV as an occasional capstone,
- Tier II or III as a common successful-run endpoint,
- and no Tier V.

This remains a proposal and may be revised or simplified.

## 3. Launch run-build content catalog

Decide the minimum launch catalog for a complete and replayable build system:

- approximate base Technique count and role distribution,
- Technique action-tag coverage,
- how many Techniques support one refinement,
- how many entries may directly reference the approved Aspect system,
- temporary Prosthetic Technique count per tool,
- initial Relic count and rarity distribution,
- whether consumables ship,
- and which entries require unique icons, VFX, animation, or audio.

Before approving counts, complete:

1. the final three-Aspect roster,
2. the shared progression structure and individual packages,
3. affinity and direct-exception rules,
4. a cross-system overlap audit,
5. Technique category, tag, and rarity rules,
6. the refinement standard,
7. and the launch coverage matrix in `gameplay/TECHNIQUE_CATALOG.md`.

## 4. Persistent progression, onboarding, and trial package

Decide the minimum persistent package across the Bloodwell, Forge, Blood Mirror, and Blood Cavern:

- available launch services,
- permanent node, rank, or branch counts,
- required basic-combat trials,
- weapon-kit teaching and mastery trials,
- Technique demonstrations or mastery trials,
- unlock ownership,
- and required interface states.

Exact costs and percentages remain balance work. Persistent Aspect content depends on the final roster and progression structure.

## 5. Narrative delivery and authored-content package

Decide:

- first-death and Returning Blood awakening presentation,
- bloodline confirmation timing and evidence,
- Shogun dialogue progression,
- Shogun reconstruction presentation,
- NPC, codex, results, and Heart-chamber updates,
- ending and credits requirements,
- voice scope,
- and cinematic, portrait, in-engine, or environmental delivery ownership.

## 6. Postgame release package

Decide:

- continuation from the Shogun to the Heart,
- repeat-clear rewards,
- launch completion goals such as records, marks, or cosmetics,
- and required Boat, results, save-state, and postgame UI states.

Additional difficulty settings, challenge modifiers, enemy variants, and room variants remain outside initial release unless promoted later.

## Deferred gameplay and implementation decisions

- fourth or fifth Aspect before playable roster evidence,
- exact frame data and hitboxes,
- exact attack damage, posture, stagger, tracking, and recovery values,
- exact neutral movement and dash values while preserving their universal contract,
- exact Ronin block and player-posture values,
- exact room counts and route topology,
- miniboss placement,
- exact enemy and boss movesets,
- exact Corruption gain, Shrine frequency, and Tier thresholds,
- exact Blood gain, capacity, activation, duration, retention, and anti-farming values if Blood remains,
- partial Blood Art activation before approved system direction and playtest evidence,
- Spirit costs and prosthetic cooldowns,
- immunity tables and status values,
- reward probabilities, prices, rerolls, and anti-streak formulas,
- exact permanent-upgrade percentages,
- and final animation frames and VFX timing.