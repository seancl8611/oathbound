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

1. Three-Aspect weapon-kit roster and Technique compatibility
2. Shared Aspect progression structure and selected packages
3. Launch run-build content catalog
4. Persistent progression, onboarding, and trial package
5. Narrative delivery and authored-content package
6. Postgame release package

## Resolved Blood Aspect foundation

The following direction is approved:

- the player selects one Blood Aspect before a run,
- the selected Aspect creates an immediate Tier 0 sword-combat identity,
- the current launch baseline contains three Aspects,
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
- commitment,
- recovery,
- target handling,
- and Blood-katana presentation.

The held attack is treated as a genuine secondary sword action. It does not need to be one universal thrust or merely a charged Basic Attack.

## Resolved universal launch layer

During the initial three-Aspect identity pass, every candidate shares the same functional:

- controller layout,
- ordinary locomotion,
- neutral dash distance, speed, startup, invulnerability, recovery, steering, collision, and repeat availability,
- block rules and baseline efficiency,
- player-posture capacity and recovery,
- parry timing and success rules,
- enemy telegraphs and response logic,
- posture-break and stagger rules,
- deathblow eligibility, execution, and standard positioning,
- Technique system,
- prosthetic system,
- and combat interface language.

These systems are not current Aspect identity levers.

The identity pass should not create:

- weaker or stronger neutral dashes,
- different base player-posture bars,
- different base block efficiency,
- removal of sustained block,
- unique deathblow movement or effects,
- or new Aspect-specific resources or inputs.

Later exceptions require playable evidence and explicit review of balance, enemies, bosses, onboarding, accessibility, UI, and production cost.

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

Ordinary Technique action tags should include:

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

## Current launch roster status

Wolf, Wraith, and Ronin remain the three working launch positions.

Three is the current production baseline, not a permanent ceiling. The weapon-kit model may eventually support a fourth and possibly fifth Aspect, but neither belongs to current launch paper-design, animation, VFX, UI, trial, content-count, or milestone scope.

Complete and test the initial three first. Expansion requires playable evidence of a missing identity that cannot be covered by revising the roster, Techniques, or prosthetics.

### Wolf — approved for comparison

Wolf remains the fast close-range pressure kit.

Approved qualitative package:

- **Basic Attack:** Fang Slash → Rending Cross → Blood Cleave,
- **Held Attack:** Predator's Passage,
- **Dash Attack:** Hunting Slash,
- **Parry Counter:** Fang Reversal,
- short reach,
- fast cadence,
- strong forward attack movement,
- strong nearby tracking,
- moderate per-hit damage,
- strong sustained health and enemy-posture output,
- and significant whiff and overcommitment risk.

Important correction:

- Wolf's sequence is an available pressure pattern, not a required combo objective.
- Wolf uses universal block, player posture, deathblows, locomotion, and neutral dash.

Still unresolved:

- exact values and frame data,
- exact hitboxes and chain windows,
- Predator's Passage eligibility and collision behavior,
- exact animations and Blood presentation,
- later unique mechanics if any,
- progression, drawback, Corruption, Blood, and Blood Art,
- Technique interactions,
- production counts,
- and final roster inclusion after the audit.

### Wraith — reopened and next active task

Wraith's previous complete Tier 0 approval is partially superseded.

Retained promising territory:

- extended spectral Blood-katana form,
- medium-to-long melee reach,
- strong line and arc coverage,
- deliberate timing,
- Pale Lance as a possible long narrow Held Attack,
- and weakness when enemies enter inside preferred range.

No longer approved:

- mandatory lateral movement in Passing Arc,
- required reposition-and-reassess sequence behavior,
- Ghostline Slash always ending at an offset,
- Veil Reversal always shifting off-axis,
- weaker base block,
- lower base player posture,
- special deathblow behavior,
- and any unique neutral dash behavior.

The next discussion must define two or three concrete Wraith weapon-kit options and choose one based on the moves themselves.

Decide:

- complete Basic Attack sequence,
- sequence length,
- cadence,
- reach,
- hit geometry,
- damage and enemy-posture profile,
- tracking,
- commitment and recovery,
- Held Attack,
- Dash Attack,
- Parry Counter,
- natural strengths and weaknesses,
- encounter coverage,
- and Technique build directions.

### Ronin — unresolved after Wraith

Rejected Ronin directions:

- preserving a combo through defense,
- playing around reaching Judgment Stroke,
- and movement-direction input selecting different Basic Attacks.

Ronin requires a new complete weapon-kit direction.

A deliberate high-impact katana is one possible exploration path, not an approved answer. Ronin must not become:

- the plain default sword kit,
- only the parry Aspect,
- the intentionally safest option,
- a weaker or stronger Wolf,
- or a kit defined by one input gimmick.

## Roster design sequence

1. Redesign Wraith under the weapon-kit model.
2. Define Ronin under the same model.
3. Compare Wolf, Wraith, and Ronin together.
4. Identify mechanical overlap and missing combat territory.
5. Confirm mixed-wave, crowd, ranged, hazard, elite, and boss viability.
6. Confirm several four-Technique build directions for each kit.
7. Confirm Techniques and prosthetics retain meaningful space.
8. Estimate required animation, VFX, audio, UI, and trial scope.
9. Revise, rename, combine, or replace candidates as needed.
10. Approve the final three-row launch roster.

Only after that should exact Tiers, Blood generation, Blood Arts, drawbacks, affinities, or candidate production packages be treated as final.

## Roster approval test

The launch roster is not ready unless:

- each candidate can be explained as a concrete sword weapon kit,
- its playstyle emerges from the moves rather than behavioral instructions,
- no candidate depends on a mandatory combo or movement loop,
- no candidate is merely a stronger or weaker version of another,
- universal movement, defense, player posture, and deathblows remain readable,
- every candidate works against all major encounter types,
- each supports reinforce, broaden, compensate, and hybridize Technique builds,
- Techniques and prosthetics retain meaningful territory,
- and production requirements remain achievable.

## 2. Shared Aspect progression structure and selected packages

After the weapon-kit roster is approved, decide:

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

Exact damage, posture, attack speed, range, gain-rate, threshold, and duration values remain playtest work.

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

1. the three-Aspect roster,
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
- exact attack, damage, posture, tracking, and recovery values,
- exact neutral movement and dash values while preserving the universal contract,
- any future difference in base block, player posture, or deathblow behavior,
- individual Technique concepts and final counts before roster approval,
- exact affinity weights and reward probabilities,
- exact room counts and route topology,
- miniboss placement,
- exact enemy and boss movesets,
- exact Corruption gain, Shrine frequency, and Tier thresholds,
- exact Blood gain, capacity, activation, duration, retention, and anti-farming values,
- partial Blood Art activation,
- Spirit costs and prosthetic cooldowns,
- immunity tables and status values,
- reward probabilities, prices, rerolls, and anti-streak formulas,
- exact permanent-upgrade percentages,
- and final animation frames and VFX timing.
