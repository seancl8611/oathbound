---
id: GAMEPLAY-WOLF-ASPECT
title: Wolf Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-26
topics:
  - blood-aspects
  - wolf
  - tier-0
  - combat-foundation
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Wolf Blood Aspect

This document owns Wolf's approved qualitative Tier 0 combat foundation under the expanded Aspect contract.

It supersedes the assumption that Wolf merely changes the properties of one universal `Quick Slash`, `Cross Cut`, `Heavy Cleave`, `Hold Thrust`, `Counter Cut`, and `Dash Slash` kit.

It does not approve exact numerical values, frame data, hitboxes, unique meters or marks, Tier progression, drawbacks, Blood Art, Corruption interactions, production counts, or Wolf's final inclusion after the three-Aspect roster audit.

## Tier 0 identity

**Wolf is the close-range aggressive Aspect.**

Wolf reshapes Akio's shared controls around:

- fast and continuous offensive timing,
- strong forward pursuit,
- staying connected to nearby enemies,
- transferring pressure between threats,
- repeated health and posture pressure,
- rapid return to offense after movement or defense,
- and greater commitment once an attack sequence begins.

Wolf does not require a unique meter, target mark, stacking buff, additional input, or automatic attack behavior at Tier 0. Its identity comes from its complete Aspect-specific moveset and transition rules.

## Universal movement retained

Wolf uses the same functional neutral movement and dash as every launch Aspect.

Wolf does not receive:

- shorter backward or lateral dash distance,
- reduced dash speed,
- reduced neutral dash invulnerability,
- slower neutral dash recovery,
- or reduced general locomotion speed.

Wolf's aggressive movement identity comes from attacks and offensive transitions rather than a nerf to Akio's dependable evasion or traversal.

## Shared Wolf attack rules

Wolf's attacks generally have:

- short effective weapon reach,
- strong forward movement,
- strong correction toward nearby aimed enemies,
- fast transitions after successful contact,
- practical redirection between nearby targets,
- moderate per-hit damage,
- repeated posture pressure,
- and greater recovery risk after missing.

Wolf should feel responsive while its attacks connect and reckless when the player attacks into empty space or continues an unearned sequence.

Wolf does not teleport to targets, automatically continue attacking, ignore enemy pressure, gain broad invulnerability while attacking, or magnetize across unreasonable distances.

## Wolf basic attack sequence

Repeated basic attack presses produce Wolf's three-hit escalating pressure chain:

1. **Fang Slash**
2. **Rending Cross**
3. **Blood Cleave**

The sequence belongs specifically to Wolf. Other Aspects may use different chain lengths, names, structures, or purposes.

### Fang Slash

Fang Slash is Wolf's fast advancing opener.

It should have:

- fast or near-fastest opening timing among the launch Aspects,
- a narrow diagonal or forward arc,
- short weapon reach,
- a small but noticeable forward step,
- moderate nearby target correction,
- and moderate health and posture pressure.

Primary uses:

- begin pressure,
- catch a nearby retreating enemy,
- test a close opening,
- and establish Wolf's forward momentum.

Its narrow coverage does not protect Wolf from enemies approaching from the sides.

### Rending Cross

Rending Cross is Wolf's broader returning cut and pressure connector.

It should have:

- a broader arc than Fang Slash,
- continued forward movement,
- enough side coverage to catch nearby interference,
- stronger redirection toward a second nearby threat,
- and balanced health and posture pressure.

Primary uses:

- continue pressure on the current target,
- remain connected to an enemy attempting to shift away,
- catch a nearby enemy entering from the side,
- redirect pressure between close threats,
- and establish the opening for Blood Cleave.

Rending Cross is not a full-circle crowd-clear attack. Enemies behind Akio or beyond its arc remain dangerous.

### Blood Cleave

Blood Cleave is Wolf's committed finishing cut.

It should have:

- a broad frontal or diagonal arc,
- stronger posture pressure than the preceding hits,
- meaningful but not automatically roster-leading health damage,
- coverage against the main target and nearby enemies in front of Akio,
- strong forward commitment,
- and severe recovery after missing.

Primary uses:

- finish an earned close-range sequence,
- threaten several enemies positioned in front of Akio,
- punish a large opening,
- and drive an elite or boss toward posture break.

Blood Cleave is Wolf's clearest basic-chain overcommitment point. Earlier hits connecting does not automatically make the finisher safe.

## Chain continuation rule

After a successful Blood Cleave, Wolf may restart at Fang Slash with a shortened but readable transition.

This creates the intended rhythm:

> Fang Slash → Rending Cross → Blood Cleave → recommit or disengage.

The shortened restart is available because Wolf completed the sequence successfully. It does not create an automatic infinite combo.

On a miss—especially a missed Blood Cleave—Wolf receives the full recovery and becomes punishable. The player must still choose whether another sequence is safe.

## Held attack — Predator's Passage

Holding and releasing the attack input produces **Predator's Passage**, a long piercing pursuit lunge.

The purpose of Predator's Passage is not safe long-range damage. Wolf uses range to force itself back into close combat.

### Against ordinary enemies

On a clean hit against a valid ordinary enemy, Wolf may drive through the target and emerge immediately behind or slightly beside it.

After passage:

- Wolf turns toward the struck enemy,
- remains at close combat distance,
- and may quickly resume offense.

The move should feel like Wolf crossing through its prey and immediately turning back onto it.

### Against elites, bosses, and heavy enemies

Wolf does not pass through enemies whose size, stability, state, or encounter role makes passage visually or mechanically unreasonable.

Instead:

- Wolf stops at impact,
- drives the thrust into the target,
- remains directly engaged,
- and may transition into a close follow-up after successful contact.

### Collision and safety rules

Predator's Passage:

- travels along a committed line,
- provides no additional invulnerability beyond any already-active universal movement rule,
- has limited directional correction after release,
- and leaves Wolf exposed if it misses.

Wolf must stop at impact rather than passing into an invalid destination such as:

- a wall,
- a pit,
- a persistent hazard,
- blocked geometry,
- or an occupied space that cannot safely contain Akio.

The exact passage eligibility rules remain implementation and testing work.

## Dash attack — Hunting Slash

Attacking during the approved late-dash window or shortly after the universal neutral dash produces **Hunting Slash**.

Hunting Slash is an aggressive re-entry cut with:

- quick startup after the shared dash window,
- strong movement toward the aimed nearby enemy,
- a relatively narrow initial hit,
- moderate target correction,
- and a close finishing position.

On successful use, Hunting Slash enters Wolf's basic sequence at **Rending Cross**, functioning as an alternate opener:

> Universal dash → Hunting Slash → Rending Cross → Blood Cleave.

This supports Wolf's pressure identity without changing the distance, speed, invulnerability, or recovery of the neutral dash itself.

Hunting Slash remains an optional offensive commitment. Using it after every dash can place Wolf back into the attack it avoided or into pressure from another enemy.

## Parry counterattack — Fang Reversal

After a successful universal parry, pressing attack produces **Fang Reversal**.

Fang Reversal is a fast advancing retaliatory cut with:

- the same parry requirement and timing rules used by every Aspect,
- quick attack startup,
- short range with a forward step,
- strong posture pressure,
- limited nearby coverage,
- and immediate close-range orientation toward the parried enemy.

On successful use, Fang Reversal enters Wolf's basic sequence at **Rending Cross**:

> Universal parry → Fang Reversal → Rending Cross → Blood Cleave.

The parry itself does not become easier, safer, or stronger. Wolf changes the offensive continuation after success.

Fang Reversal does not guarantee safety in a crowd. Another enemy may punish an immediate counterattack.

## Wolf defensive and player-posture profile

Wolf retains:

- sustained block,
- universal parry timing,
- the universal neutral dash,
- player posture,
- posture break,
- and deathblows.

Wolf's qualitative defensive profile is:

- moderate-to-high player posture capacity,
- normal functional blocking rather than exceptional guard dominance,
- average or somewhat slow posture recovery after disengaging,
- and strong offensive continuation after successful parries.

This gives Wolf enough stability to remain close without allowing careless sustained blocking to erase its commitment risk.

Wolf's preferred defensive answer is:

> Read the attack, parry it, use Fang Reversal, and reclaim pressure.

Wolf does not automatically recover posture by attacking at Tier 0. That remains a possible later mechanic or Technique direction rather than part of the approved foundation.

Exact posture capacity, block cost, recovery delay, and recovery rate remain playtest work.

## Offensive transitions

### From neutral

- Fang Slash begins the standard three-hit chain.
- Predator's Passage closes a larger gap through committed pursuit.

### After parry

- Fang Reversal restores close-range pressure.
- It enters the basic sequence at Rending Cross.
- Parry timing and defensive safety remain universal.

### After block

- Releasing block into Fang Slash should feel responsive.
- Blocking does not preserve a hidden sequence bonus.
- Sustained blocking remains a compromise rather than Wolf's preferred state.

### After dash

- The neutral dash retains universal behavior.
- Hunting Slash provides optional aggressive re-entry.
- Hunting Slash enters the basic sequence at Rending Cross.
- The player may still choose to disengage instead.

### After deathblow

- Wolf finishes positioned and oriented clearly enough to identify the next threat.
- Wolf may transition quickly into movement, Fang Slash, Predator's Passage, or a universal dash.
- The deathblow does not automatically damage, attack, or mark another enemy.

## Target switching and crowd behavior

Wolf supports target transfer through normal movement, aim, and attack direction.

During the basic sequence, the player may redirect the next attack toward another nearby enemy. Helpful target correction should not force Wolf to remain attached to the original target.

Wolf's crowd viability comes from:

- fast redirection,
- Rending Cross's nearby coverage,
- Blood Cleave's frontal crowd threat,
- forward movement between enemies,
- Hunting Slash re-entry,
- Predator's Passage access to priority threats,
- and quick continuation after deathblows.

Wolf does not receive:

- automatic chained attacks between enemies,
- full-circle coverage on every attack,
- constant crowd stagger,
- automatic passage through every target,
- or immunity while attacking.

Crowds remain a major source of risk.

## Damage and posture profile

Wolf applies both health and posture pressure through repeated successful contact.

Its qualitative profile is:

- moderate damage per attack,
- strong sustained output while connected,
- consistent posture pressure across the basic sequence,
- stronger posture payoff from Blood Cleave, Predator's Passage, and Fang Reversal,
- and reduced effectiveness when attacks miss or the player must disengage.

Wolf does not own the highest individual-hit damage. Its advantage comes from continuity, pursuit, and reduced downtime after successful actions.

## Range and Blood-katana direction

Wolf has the shortest or near-shortest normal weapon reach.

Its Returning Blood expression should make the katana feel:

- dense,
- forceful,
- predatory,
- and built for close engagement.

The Blood form may strengthen the blade's visual weight, edge, impact, or trails, but it should not create a permanently long extension that contradicts Wolf's normal range weakness.

Predator's Passage may create a temporary elongated piercing form because its purpose is committed pursuit rather than safe spacing.

Exact shape, color, VFX, and animation treatment remain open.

## Encounter behavior

### Mixed groups

Wolf pressures an important enemy while using Rending Cross, Blood Cleave, target redirection, defense, and movement to account for nearby threats.

It should feel strong while moving through a group, but unsafe when surrounded without a clear route or defensive response.

### Ranged enemies

Wolf uses the universal dash, Hunting Slash, Predator's Passage, prosthetics, and target prioritization to reach ranged threats.

It has viable approach tools without gaining a safe ranged attack solely to erase its short-range weakness.

### Elites

Wolf maintains steady health and posture pressure, but elite retaliation punishes careless chain completion, failed passage attempts, and repeated unearned Blood Cleaves.

### Bosses

Wolf performs well during sustained attack windows and applies consistent posture pressure.

During short or dangerous openings, the player must stop the chain early, parry, block, or disengage. Heavy bosses stop Predator's Passage at impact rather than allowing visually implausible pass-through behavior.

### Hazards and constrained arenas

Wolf's forward commitment can carry it toward walls, hazards, pits, or surrounding enemies.

Universal neutral movement remains reliable, but Wolf's chosen offensive attacks may end in dangerous positions. The player must consider where the attack will finish, not only whether it will connect.

## Technique build space

Universal Techniques retain the same rules under every Aspect.

Under Wolf they may naturally:

- **reinforce:** pursuit, repeated contact, sustained offense, sequence continuation, and posture continuity,
- **broaden:** crowd coverage, ranged-enemy handling, alternate chain routes, and mixed-wave control,
- **compensate:** recovery, defense, spacing, reach, and disengagement,
- **hybridize:** Blood Cleave, Fang Reversal, deathblow, posture, movement, held-attack, or prosthetic-focused builds.

No Technique is required for Wolf to handle groups, bosses, hazards, or ranged enemies at a basic viable level.

## Tier 0 summary

Wolf uses the shared controls and universal neutral movement through an Aspect-specific combat grammar:

- **Basic sequence:** Fang Slash → Rending Cross → Blood Cleave.
- **Sequence behavior:** successful completion may restart smoothly; missed commitment receives full recovery.
- **Held attack:** Predator's Passage, a committed piercing pursuit that may cross through ordinary enemies and stops at heavy targets.
- **Dash attack:** Hunting Slash, an aggressive re-entry that follows the universal dash and enters at Rending Cross.
- **Parry counter:** Fang Reversal, a fast return to pressure that enters at Rending Cross.
- **Defense:** functional block, universal parry timing, moderate-to-high posture capacity, and no automatic attack-based posture recovery.
- **Neutral movement:** identical functional dash distance, speed, invulnerability, and recovery to other launch Aspects.
- **Main strengths:** close pressure, sustained output, target pursuit, posture continuity, and transfer through mixed encounters.
- **Main weaknesses:** short reach, forward commitment, missed attacks, overextension, target fixation, and surrounding pressure.

## Remaining Wolf decisions

After the full three-Aspect identity roster and overlap audit are approved, decide:

- exact relative attack, damage, posture, range, tracking, and recovery values,
- exact chain timing, restart timing, passage eligibility, and transition windows,
- exact player-posture capacity, blocking cost, and recovery values,
- exact animation and Blood-katana treatment,
- whether Wolf needs any later unique mechanic beyond this attack foundation,
- shared Tier progression and Wolf's Tier package,
- drawback and Corruption behavior,
- Blood generation and Blood Art if retained,
- production scope,
- and trial or persistent-progression requirements.