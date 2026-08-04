---
id: GAMEPLAY-RONIN-ASPECT
title: Ronin Blood Aspect
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-04
topics:
  - blood-aspects
  - ronin
  - tier-0
  - tier-progression
  - blood-arts
  - weapon-kits
  - combat-foundation
  - roguelite-combat
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Ronin Blood Aspect

## Status

Ronin is an approved member of the three-Aspect launch roster. This document owns Ronin's qualitative Tier 0 weapon kit, its boundaries, and its approved working Tier I-II progression package and Blood Art.

It replaces earlier directions based on maintaining a combo through defense, reaching a special finisher as the central goal, or selecting Basic Attacks through movement-direction input.

Exact numerical values, frame data, hitboxes, animation, Blood presentation, Tier III-IV package, justified exceptions to the shared Blood defaults, Technique exceptions, and production counts remain later design or implementation work.

## Weapon identity

**Ronin is the slow, precise, heavy-impact and stability kit.**

Ronin is defined by:

- a three-hit heavy Basic Attack sequence,
- conventional medium sword reach,
- the slowest cadence in the launch roster,
- the highest per-hit health damage,
- the highest or near-highest per-hit enemy-posture pressure,
- the strongest ordinary-enemy stagger,
- minimal player-directed attack movement,
- fixed attack lines after commitment,
- severe recovery after missed heavy attacks,
- and the strongest guard profile, balanced by slow posture recovery.

Ronin's limitations are inherent in its startup, movement, commitment, and recovery rather than expressed through a separate player-facing drawback category.

Ronin does not use corrective tracking, hidden homing, or post-input target rotation. The player judges both the attack direction and how much of an opening can be used safely. Ronin's attacks are individually valuable; the player never needs to complete the full sequence.

## Shared systems

Ronin retains universal locomotion, neutral dash, defense input, parry timing, posture-break rules, deathblows, Technique inventory, and prosthetic controls.

Its stability does not create parry immunity, automatic counters, free posture recovery while guarding, instant attack cancels, innate interruption resistance, super armor, damage reduction, or a unique defensive input.

A Tier 0 heavy attack must be protected by correct timing, spacing, enemy stagger, or a sufficiently large opening. A later fixed Tier benefit or Blood Art may protect one specific authored action only if that exception is explicitly approved.

## Tier 0 kit

### Basic Attack sequence

1. **Severing Cut** — the most reliable Basic Attack for short openings, using a comparatively compact line while still delivering meaningful single-hit damage and posture pressure.
2. **Crushing Cross** — the broadest frontal Basic Attack, with greater commitment, stronger impact, and the clearest role against closely grouped enemies in front of Akio.
3. **Bloodfall** — the most committed and directionally demanding Basic Attack, delivering the sequence's largest damage, posture, and stagger payoff with severe recovery.

The sequence cadence is:

> deliberate punish → broader heavy commitment → maximum committed impact

Severing Cut must provide strong value during short openings. Crushing Cross provides Ronin's primary ordinary frontal group coverage through authored sword geometry rather than a shockwave, tracking, or permanent extended reach. Bloodfall is an available heavy option, not a required finisher or combo reward.

Each attack remains useful when the sequence ends early.

### Held Attack — Stillness Draw

A defining high-damage draw attack that concentrates power around the katana and sheath.

Stillness Draw uses one fixed preparation threshold rather than multiple damage charge levels. Once prepared, the player may hold the readied stance and manually release the strike. Continuing to hold does not increase its power.

While the readied stance is held, Akio remains committed and does not regain ordinary defense access. Its risk comes from choosing when and where to prepare and release the attack, not from managing several charge tiers.

Stillness Draw provides:

- Ronin's clearest precise single-target punish,
- major single-hit health damage,
- major enemy-posture pressure,
- strong ordinary-enemy stagger,
- conventional or modestly extended melee reach rather than Wraith-like reach,
- a fixed attack line after commitment,
- and severe miss recovery.

Its advantage is power, not safe distance. It must remain distinct from Bloodfall: Bloodfall is the sequence's largest impact and stagger commitment, while Stillness Draw is Ronin's strongest prepared single-target punishment tool.

### Dash Attack — Breaching Slash

A quicker attack after the universal neutral dash.

- faster and more convenient than Ronin's normal heavy attacks,
- conventional sword reach,
- useful for short openings or re-entry,
- the most responsive recovery profile within Ronin's Tier 0 attacks,
- and lower damage, posture pressure, and stagger than the main sequence.

Breaching Slash must not replace Ronin's ordinary heavy strikes. Its role is access and re-entry, not pursuit dominance or maximum punishment.

### Parry Counter — Answering Steel

A forceful retaliatory strike after the universal parry.

- universal parry requirements,
- Ronin's strongest immediate conversion from a successful parry,
- high damage and enemy-posture payoff,
- strong ordinary-enemy recoil or stagger where enemy rules allow,
- restrained player-directed movement,
- and meaningful commitment after activation.

It does not change parry timing, turn toward a target after release, or make the counter automatically safe in crowds.

## Contact, commitment, and recovery

Ronin should feel deliberate and heavy rather than generally unresponsive.

- meaningful startup and active commitment cannot be cancelled into block or dash,
- a full miss receives severe authored recovery,
- successful or guarded contact receives strong hit-stop, audiovisual weight, and its authored contact recovery,
- and ordinary defensive access returns after that authored recovery rather than through a special hit-confirm cancellation rule.

Tier 0 does not include a formal mechanic that reduces recovery whenever an attack connects. The distinction between a successful impact and a complete miss should initially come from authored animation, hit-stop, feedback, and recovery tuning.

## Defensive profile

Ronin has the strongest ordinary guard profile in the launch roster through:

- meaningfully higher player-posture capacity as its primary defensive advantage,
- modestly better block posture efficiency as a secondary advantage,
- and greater stability during direct exchanges.

These strengths are balanced by:

- the slowest player-posture recovery in the launch roster,
- committed attacks that delay access to defense,
- no instant block or dash cancel during meaningful attack startup or active frames,
- and no free posture recovery while actively guarding.

Ronin can withstand a direct exchange longer, but accumulated posture remains a serious concern during the next exchange. Its guard supports deliberate exchanges; it does not erase the consequences of bad commitments or permit indefinite blocking.

## Combat profile

| Property | Approved direction |
|---|---|
| Preferred range | Medium |
| Basic sequence | Three attacks |
| Cadence | Slowest and most deliberate |
| Per-hit damage | Highest |
| Sustained output | Opening-dependent and lower than Wolf |
| Enemy posture | Largest chunks per clean strike |
| Ordinary-enemy stagger | Strongest |
| Attack movement | Minimal, grounded, and player-directed |
| Held identity | Prepared single-target power |
| Main failure state | Missed heavy commitment and accumulated posture that recovers slowly |

## Strengths

- highest per-hit health damage,
- highest or near-highest per-hit posture pressure,
- strong ordinary-enemy stagger,
- excellent punishment of short and large openings,
- powerful elite and boss damage,
- strong Parry Counter payoff,
- clear frontal group coverage through Crushing Cross,
- and stable blocking during direct exchanges.

## Firm tradeoffs

- slow attack startup,
- severe whiff recovery,
- fixed attack lines after commitment,
- minimal attack-bound movement,
- no innate interruption resistance or damage reduction during attacks,
- low sustained output when openings are scarce,
- mobile or ranged enemies,
- pressure from several directions,
- and slow recovery of accumulated player posture.

Ronin must not become the generally optimal kit by combining the strongest guard with unrestricted damage, posture, and stagger. Its commitments and recovery remain fundamental costs.

## Encounter role

- **Mixed groups:** remove or stagger priority enemies while using Crushing Cross, frontal arcs, and defense to stabilize direct pressure.
- **Crowds:** threaten grouped frontal targets but struggle when fast enemies attack from several directions.
- **Ranged pressure:** rely on universal dash, Breaching Slash, projectile defense where supported, prosthetics, and target priority rather than pursuit or extended reach.
- **Elites and bosses:** convert correctly read openings into the largest individual health and posture gains, with Stillness Draw serving as the clearest prepared single-target punish.

# Fixed Tier progression

Each Ronin Tier must provide a concrete net-positive combat benefit while preserving slow startup, heavy commitment, minimal attack movement, fixed direction, severe miss recovery, and slow player-posture recovery.

## Tier I — Steadfast Reprisal

After successfully blocking a blockable enemy attack without suffering a posture break, Akio briefly gains the option to perform **Reprisal Cut** with the Basic Attack input.

### Reprisal Cut

Reprisal Cut is a slow, planted heavy retaliation performed from Ronin's guarded stance.

- Akio must complete the relevant authored block recovery before the retaliation may begin.
- Blocking does not accelerate Reprisal Cut's startup.
- The attack uses a compact frontal line with little or no player-directed movement.
- The player selects its direction, which becomes fixed once the attack is committed.
- It deals strong Health damage, substantial enemy-posture pressure, and powerful ordinary-enemy stagger.
- Its payoff is greater than an ordinary Severing Cut but remains below Answering Steel after a successful parry.
- It emphasizes enemy-posture pressure and stagger slightly more than raw Health damage.
- It is a standalone retaliation and does not continue directly into Crushing Cross or the rest of Ronin's Basic Attack sequence.
- A miss or poorly timed use receives severe recovery.

The Reprisal Cut option is always manual and temporary. The player may continue guarding, attempt a parry, dash away, use a Prosthetic, or take another legal action instead. Taking another action or allowing the response window to expire removes the option.

Steadfast Reprisal provides no automatic counter, target selection, corrective turning, tracking, movement into range, posture recovery, block-efficiency increase, damage reduction, interruption resistance, super armor, or protection against a continued enemy sequence.

When Reprisal Cut begins, Akio gives up guarding and may be interrupted through ordinary combat rules. The player must judge that the blocked enemy's sequence has actually ended, that no other threat will arrive first, and that the selected attack line will reach the intended target.

A blocked attack may leave the enemy outside Reprisal Cut's range. Steadfast Reprisal does not compensate for poor spacing or allow the retaliation to chase the attacker.

The resulting Tier I rhythm is:

> withstand one direct attack → read whether the pressure has truly ended → confirm position and range → commit to a heavy retaliation

Steadfast Reprisal is not intended to become Ronin's default answer in every encounter. It is a calculated guard-and-punish option whose value depends on enemy knowledge, timing, positioning, and threat awareness.

## Tier II — Falling Mountain

Tier II unlocks Ronin's Blood meter and Blood Art.

Ronin gains Blood through meaningful katana Health damage, large enemy-posture contributions, Answering Steel, successful Reprisal Cuts, posture breaks, and deathblows. Blood gain is weighted around the value of Ronin's fewer heavy impacts rather than requiring the same number of individual hits as Wolf or Wraith.

Falling Mountain follows the shared Blood defaults: it requires a full meter, activates manually, consumes the stored Blood, and generates no Blood from the Art itself. Exact capacity, gain weighting, activation timing, and anti-farming thresholds remain tuning work.

### Blood Art — Falling Mountain

Akio plants his feet, gathers a dense mass of Returning Blood around the katana, and drives the weapon downward in a monumental two-handed slam.

The action has slow, clearly readable startup and must be protected by a correctly created opening. Akio does not pursue, leap toward, or automatically close distance to a target. The player selects the slam direction, which becomes fixed once the commitment begins.

Falling Mountain grants no invulnerability, damage reduction, automatic block, posture clearing, healing, corrective turning, tracking, homing, or innate interruption resistance. If Akio is interrupted before the weapon establishes the impact site, the delayed rupture is not created.

### Primary slam

The initial strike is Ronin's largest single committed impact.

- The katana's direct landing line deals extreme Health damage and extreme enemy-posture damage.
- Eligible ordinary enemies struck directly receive Ronin's strongest authored stagger or knockdown response.
- A compact immediate impact burst damages and pressures nearby enemies around the landing point.
- The direct blade result takes priority over the immediate burst for a target caught by the central strike, preventing the same enemy from receiving two full simultaneous primary-impact instances.
- Nearby enemies receive a reduced but still meaningful portion of the slam through the immediate impact burst.
- Akio remains planted through the strike and receives severe authored recovery.

The Art's central payoff depends on aiming the blade correctly. The impact burst provides secondary encounter utility without allowing a near miss to equal a direct strike.

### Deep Rupture

The primary slam drives Returning Blood and force into the ground. Approximately three seconds after the initial impact, the original landing point erupts a second time in **Deep Rupture**.

Deep Rupture is a powerful second payoff rather than a minor visual aftereffect.

- It remains fixed at the original impact location.
- Its radius is smaller than the primary slam's immediate impact field.
- It deals strong Health damage and very strong enemy-posture damage.
- It causes forceful stagger or knockdown against eligible ordinary enemies.
- Its direct combat payoff remains below the primary blade slam but is substantial enough to influence positioning and enemy decisions.
- An enemy struck by the primary slam may also be struck by Deep Rupture if it remains within the later eruption.
- Once the primary impact successfully establishes the rupture site, Akio may move, defend, or take other actions normally; later damage to Akio does not cancel the scheduled eruption.
- Deep Rupture does not track, move with an enemy, retarget, expand toward a target, or independently select targets.
- It generates no Blood, creates no further rupture, and uses restricted or weighted per-hit Technique and healing interactions.

The authored timing target is approximately three seconds so the rupture can become a readable delayed threat rather than an immediate double hit. The exact final delay, radius, Health damage, posture damage, stagger rules, and encounter-transition behavior remain implementation and playtesting work.

The resulting Tier II rhythm is:

> build Blood through deliberate heavy combat → create a large opening → aim and commit to the monumental slam → use the fixed delayed rupture as a second powerful positional threat

Falling Mountain is one Blood Art with two linked impacts. Deep Rupture represents the original slam continuing through the earth; it is not a spectral copy of Akio repeating the attack and does not become Wraith-like delayed weapon geometry.

## Tier progression direction

Future Ronin Tiers must provide clearly net-positive benefits that deepen heavy impact, posture pressure, stability, or deliberate punishment. The benefits may be strong because Ronin already gives up speed, movement, and recovery through its ordinary kit.

Future Tiers should preserve those inherent limitations through the actions they strengthen rather than adding separate named drawbacks or unrelated penalty attributes. A strong Ronin Technique build at Tier 0-I must remain capable of completing a run without requiring the Blood Art.

## Technique space

Universal Techniques may:

- **reinforce** heavy Basic Attacks, Stillness Draw, direct damage, posture chunks, and stagger,
- **broaden** attack speed, pursuit, crowd handling, ranged access, or sequence flexibility,
- **compensate** for whiff recovery, fixed attack lines, posture recovery, mobile enemies, or surrounding pressure,
- **hybridize** through Breaching Slash, Answering Steel, Steadfast Reprisal, Falling Mountain, deathblows, blocking, posture, or prosthetics.

Ronin does not own every damage, posture, parry, block, Held Attack, guard-counter, slam, delayed-ground-effect, or heavy-attack Technique. Universal Techniques must not simply duplicate Steadfast Reprisal's block-triggered standalone retaliation or Falling Mountain's full-meter slam-and-rupture package.

## Blood-katana presentation

Ronin's Blood-formed katana should feel dense, compressed, disciplined, and heavy at impact.

Presentation may use a dense Blood edge, a spectral sheath during Stillness Draw, restrained trails before contact, strong hit-frame emphasis, and heavy audio. It must not gain Wraith-like permanent reach.

Steadfast Reprisal requires a readable temporary availability cue after a qualifying block and distinct impact feedback for Reprisal Cut without implying automatic protection or guaranteed safety.

Falling Mountain requires a full-meter ready state, readable activation commitment, a dense Blood-loaded slam, a clearly marked impact site, persistent ground-fracture feedback during the approximate three-second delay, and a powerful second rupture cue that remains visually distinct from Wraith's spectral afterimages.

## Remaining Ronin design work

Define one Tier at a time:

- Tier III,
- Tier IV after Tier III is approved,
- how each Tier preserves Ronin's inherent speed, movement, commitment, and recovery limits,
- any justified exception required by the approved Blood Art,
- limited direct Technique interactions if approved,
- final animation, VFX, audio, HUD, Shrine, selection, and trial requirements.

Exact timing, response-window duration, range, geometry, player-directed movement, damage, posture, stagger, block efficiency, player-posture values, armor interactions, Stillness Draw preparation and readied-state durations, Blood capacity and gain values, Falling Mountain startup and recovery, Deep Rupture delay and radius, and presentation values remain implementation and playtesting work.
