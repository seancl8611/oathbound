---
id: GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
title: Blood Aspect Identity Guidelines
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-06
topics:
  - blood-aspects
  - aspect-roster
  - weapon-kits
  - wolf
  - wraith
  - ronin
  - encounter-design
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-TECHNIQUE-CATALOG
  - META-OPEN-QUESTIONS
---

# Blood Aspect Identity Guidelines

## Evaluation principle

Blood Aspects are complete katana weapon kits that share one control and combat language.

> **Define concrete moves first. Let timing, range, geometry, player-directed movement, damage, posture, stagger, commitment, and recovery create the playstyle naturally.**

Do not substitute an abstract behavior rule or player-facing drawback category for a weapon kit. Avoid identities based on maintaining pressure forever, repositioning after every sequence, preserving a combo through defense, reaching one required finisher, or selecting attacks through movement-direction input.

## Approved launch roster

| Aspect | Identity | Inherent tradeoffs |
|---|---|---|
| Wolf | Fast close-range pressure and pursuit | Short reach, unsafe misses, and dangerous positioning after poorly aimed pursuit |
| Wraith | Extended spectral reach, frontal control, formation penetration, and distant engagement | Slower cadence than Wolf, fewer ordinary attack options, restrained movement, fixed direction, close and lateral pressure, and vulnerability after a poor line commitment |
| Ronin | Slow heavy impact and defensive stability | Slow startup, severe recovery, minimal attack movement, and slow posture recovery |

The launch roster is final at the current scoping stage. Mobility, evasion, ranged utility, and broader crowd control remain shared-system, Technique, and Prosthetic territory rather than requiring a fourth Aspect.

## Encounter assumption

Oathbound combines disciplined posture, parry, block, dodge, counter, and deathblow combat with roguelite encounters containing:

- multiple waves,
- mixed melee and ranged enemies,
- simultaneous threats,
- target-priority decisions,
- crowd pressure,
- elites and minibosses,
- and sustained bosses.

Every launch kit must remain viable across these situations. No Aspect is designed only for one-on-one sword duels or only for large groups.

## Universal layer

Wolf, Wraith, and Ronin share:

- controller layout,
- neutral locomotion and dash properties,
- defense input,
- parry timing and success rules,
- posture-break and deathblow language,
- enemy responses,
- Technique rules,
- Prosthetic controls,
- and combat interface language.

No Aspect receives a weaker or stronger neutral dash. Beyond the Veil increases Ghostline Slash's attack reach but does not modify Wraith's neutral dash.

## Player-directed attack guidance

No Aspect uses corrective tracking, hidden homing, or post-input target correction.

Attacks use the direction selected by the player together with their authored arc, line, forward travel, and collision. Once an ordinary attack is committed, it does not curve or rotate toward a moving enemy.

A sustained authored attack may permit limited direct player steering when explicitly approved. That steering must:

- respond only to player input,
- remain inside an authored angular range,
- avoid snapping toward or automatically following enemies,
- preserve the attack's commitment and movement limits,
- and remain readable against enemy telegraphs.

No current fixed Wraith Tier requires steering. The retired Pale Procession candidate used limited steering as an exploration boundary, but it is not production scope.

Distinct target handling should otherwise come from:

- attack width and reach,
- forward travel,
- collision behavior,
- sequence timing,
- and player aim.

A signature attack may pass through an eligible ordinary enemy only when the behavior is explicitly authored. It must still follow the original attack geometry and preserve clear stopping rules.

Wraith's approved Spectral Passage is the ordinary-attack example:

- qualifying spectral geometry continues through ordinary-enemy bodies,
- additional ordinary targets receive reduced Health damage and meaningful posture and guard pressure,
- elites, bosses, heavy stopping enemies, and solid geometry end further passage,
- each enemy may be struck at most once by the action,
- and the Tier adds no tracking, extra reach, movement, bounce, or same-enemy multiplication.

A signature execution may begin from greater distance only when the target already satisfies the shared deathblow rules and the authored path is valid. Wraith's Beyond the Veil is the approved example:

- the target must already be deathblow-ready,
- the target must lie within the approved frontal angle and distance,
- the path must be clear of geometry, hazards, intervening enemies, and authored blockers,
- Akio uses one straight authored spectral approach,
- and the movement does not curve, retarget, become a neutral dash, or create general traversal.

## Defensive-profile guidance

Every Aspect retains block, parry, dodge, player posture, and deathblows.

Modest differences may use:

- player-posture capacity,
- block posture efficiency,
- posture recovery direction,
- access to defense after attacks,
- and Parry Counter payoff.

These differences support a complete weapon kit; they cannot be the kit's entire identity.

Do not change universal parry timing, parry success conditions, defense input, posture-break consequences, or enemy response rules. Do not grant automatic counters, posture-break immunity, free guarding, or posture recovery while actively blocking.

A fixed Tier benefit may protect one specific authored action while still using shared defensive rules. Wolf's Fanged Guard automatically blocks one frontal blockable attack through normal posture rules during selected commitments. Ronin's Unbroken Resolve preserves selected late commitments through one costly eligible hit. Wraith's former Veiled Guard candidate was rejected rather than adding a third commitment-preservation Tier III.

## Shared offensive slots

Every Aspect defines:

1. **Basic Attack** — primary sequence and normal swordplay.
2. **Held Attack** — major secondary or committed sword action.
3. **Dash Attack** — offensive follow-up after the universal neutral dash.
4. **Parry Counter** — direct attack after the universal parry.
5. **Blood Art** — Tier II Blood-powered package finalized through fixed Aspect progression.

The Held Attack is a genuine secondary action rather than one universal thrust with different numbers.

## Sequence guidance

A sequence is a weapon property, not an objective.

The player may stop after one attack, continue, defend, dash, redirect, use a Prosthetic, or abandon the sequence. The player should not feel that an Aspect failed because a sequence was not completed.

| Aspect | Sequence | Cadence purpose |
|---|---:|---|
| Wolf | Four attacks | Sustained close pressure and pursuit |
| Wraith | Two attacks | Precise extended line followed by an optional broader committed frontal sweep |
| Ronin | Three attacks | Slow escalating impact and heavy direct damage |

Each attack must remain useful when the sequence ends early. Wraith remains shorter and more selective than Wolf: Veil Cut handles short precise openings, while Passing Arc adds broader posture and guard pressure when the player accepts more commitment.

## Movement guidance

Attack movement may reinforce a kit but must not replace it.

Avoid mandatory lateral movement, every counter relocating Akio, every dash attack ending at a special offset, or directional movement input selecting unrelated sword attacks.

A specific signature move may cross an enemy along its original line when that behavior is central to the move and safely constrained. This must not become automatic target selection or general behind-the-enemy repositioning.

A spacing identity should emerge from reach, geometry, player-directed movement, commitment, and recovery.

A short supporting movement reward may follow a completed authored event when it reinforces the kit without rewriting neutral controls. Wraith's Veilstride is the approved example: a deathblow kill grants brief movement speed to leave the execution position or rebuild spacing, but it does not increase attack speed, dash distance, invulnerability, recovery, or attack-bound movement.

## Tier progression guidance

Aspect Tier progression is a fixed optional investment route.

- Tier 0 is a complete and viable weapon kit.
- Every Tier is clearly net-positive.
- Higher Tiers deepen signature actions without requiring separate named drawbacks or added penalty attributes.
- Existing weaknesses may remain visible through the upgraded action's movement, commitment, direction, speed, recovery, collision, or defensive access.
- Technique-focused Tier 0-I builds must remain capable of completing a run.
- Tier II is a common hybrid target, Tier III is deeper specialization, and Tier IV is occasional rather than expected.

The purpose of preserving tradeoffs is to keep the weapon identity and player outplay intact, not to discourage Embrace or make later Tiers undesirable.

A Tier III should provide a clear built-in specialization rather than requiring unnecessary operational complexity. Spectral Passage deepens Wraith's existing lines and arcs through authored collision behavior without adding a new command or generic stat bonus.

A Tier IV should create a recognizable final capability rather than merely adjust hidden timing or repeat the previous Tier's encounter role. Beyond the Veil follows that standard:

- it expands Pale Lance's and Ghostline Slash's authored spectral opportunity,
- it unlocks their Spectral Edge eligibility only at Tier IV,
- it turns Wraith's posture pressure into a unique extended-range deathblow opportunity,
- and it supplies a small post-kill repositioning reward without becoming generic combat mobility.

Pale Procession was rejected because it repeated Spectral Passage's ordinary-group problem category through width after Tier III had already solved it through depth.

## Blood Art differentiation

Blood Arts should produce distinct encounter-scale decisions rather than three versions of the same damage state.

The approved launch distinction is:

> Wolf moves through the battlefield → Wraith controls a chosen corridor → Ronin dominates a chosen point

- **Blood Hunt** commits Wolf to one long player-directed pursuit and endpoint.
- **Wraith's Reach** supplies one compact frontal sweep, one very long fixed corridor strike, and one delayed repetition along the same geometry.
- **Falling Mountain** plants Ronin at one chosen point for a monumental slam and delayed rupture.

Wraith's Reach is not a duration buff. Its corridor and delayed echo are one immediate authored package. It does not track, pursue, grant generic defense, generate Blood, or independently trigger Spectral Edge.

## Kit evaluation template

### Concrete actions

- What happens on one and repeated Basic Attack presses?
- What distinct purpose does Held Attack serve?
- What attack follows the universal dash?
- What direct response follows a universal parry?
- What practical payoff does the Blood Art guarantee on activation?

### Weapon properties

- range and geometry,
- cadence and sequence length,
- player-directed attack movement,
- per-hit and sustained Health damage,
- enemy-posture pressure and stagger,
- commitment and miss recovery,
- target handling through arcs and collision,
- modest defensive properties,
- and fixed Tier evolution.

### Game-wide fit

- natural strengths and weaknesses,
- groups, ranged pressure, elites, and boss viability,
- reinforce, broaden, compensate, and hybridize Technique space,
- viability across Technique-focused, hybrid, and Aspect-focused runs,
- Prosthetic relevance,
- and animation, VFX, audio, UI, and teaching scope.

## Approval standard

A kit is ready when:

- its moves can be explained without abstract behavioral instructions,
- Basic and Held attacks form a coherent weapon style,
- strengths and weaknesses emerge from attack properties,
- Dash Attack and Parry Counter reinforce the kit without rewriting universal controls,
- ordinary defense, deathblows, Techniques, and Prosthetics remain relevant,
- the kit works against groups and single targets,
- its Blood Art is practically useful even without perfect follow-up play,
- Tier 0-I Technique-focused builds remain viable,
- and it is distinguishable from the other two during the first combat room.

Wolf and Wraith meet the current qualitative Tier 0-IV working-package standards. Ronin's current Tier I-IV package remains approved, and its Tier 0 foundation is the next ordered review before final cross-roster approval.

## Cross-roster comparison

| Property | Wolf | Wraith | Ronin |
|---|---|---|---|
| Style | Fast close pressure | Extended spectral frontal control | Slow heavy direct impact |
| Sequence | Four hits | Two hits | Three hits |
| Range | Close | Longest average | Medium |
| Cadence | Fastest | Slower and deliberate | Slowest |
| Per-hit damage | Moderate | Moderate | Highest |
| Sustained output | Highest while connected | Moderate and opening-dependent | Opening-dependent |
| Attack movement | Strongly forward | Restrained | Minimal |
| Held purpose | Pursuit | Focused reach and stationary multi-hit commitment | Power |
| Blood Art | Long pursuit through the battlefield | Immediate sweep, fixed corridor, and delayed echo | Planted slam and delayed rupture |
| Tier III | Preserve connected aggression through one frontal block | Penetrate layered ordinary formations through existing spectral geometry | Preserve heavy commitments or earn clean posture payoff |
| Tier IV | Maul major contacts and briefly slow caught prey | Engage and execute from greater spectral distance, then reclaim spacing after a killing deathblow | Drive posture force through a directly struck target |
| Primary risk | Overextension | Poor positioning, collapsed spacing, lateral pressure, and commitment to the wrong line | Missed heavy commitment and slow posture recovery |

## Technique compatibility

Ordinary Techniques target universal action categories rather than separate move-specific versions for each Aspect.

Each Aspect must support reinforce, broaden, compensate, and hybridize builds. No Aspect owns all attack, range, movement, damage, posture, parry, block, healing, or deathblow Techniques.

Fixed Tier benefits and Blood Arts should avoid broad generic effects that would erase Technique space. Their rules should be tailored to the Aspect's signature actions and progression fantasy.

## Future roster capacity

A fourth or fifth Aspect remains possible only after the initial three are implemented and playable evidence demonstrates a missing combat identity that cannot be solved through the current roster, Techniques, Prosthetics, or encounter design.

Neither additional Aspect belongs to current launch paper-design or production scope.

## Next design dependency

Review Ronin's Tier 0 weapon foundation before selecting its repeated Tier-growth rule or conducting the final cross-roster lock. Confirm that Severing Cut, Crushing Cross, Bloodfall, Stillness Draw, Breaching Slash, Answering Steel, and the strongest-guard/slow-posture-recovery profile create a complete and readable Tier 0 kit.
