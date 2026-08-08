---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-07
---

# Current Design Questions

This file contains unresolved decisions that materially affect launch scope, content volume, production planning, interfaces, or authored presentation. Resolved rules belong in their authoritative files. Exact numerical tuning and playtest variables do not belong here.

## Approved dependencies

- Launch Blood Aspects are **Wolf, Wraith, and Ronin**; no fourth or fifth Aspect is in launch scope.
- Each Aspect begins as a complete Tier 0 katana kit and follows one optional fixed Tier path through Tier IV.
- Wolf owns fast close-range pressure and pursuit.
- Wraith owns extended spectral reach and frontal control.
- Ronin owns slow heavy impact and defensive stability.
- Shared controls, neutral locomotion and dash, parry rules, posture-break language, deathblows, Techniques, Prosthetics, and core interface language remain universal.
- Aspect identity comes primarily from authored attacks: cadence, reach, geometry, movement, damage, posture, stagger, commitment, and recovery.
- No Aspect uses corrective tracking, hidden homing, or post-input target correction.
- Blood is run-only, unavailable before Tier II, stored between rooms until spent, and reset after the run.
- Blood Arts normally require a full meter, activate manually, consume stored Blood, and provide practical activation value.
- Every Tier is net-positive. A Tier may contain one headline benefit and at most one minor supporting rule.
- Tier 0-I Technique-focused builds, Tier II hybrids, and deeper Tier III-IV Aspect builds must all remain viable.
- Mandatory encounters cannot assume a particular Aspect Tier or Blood Art.

## Locked Aspect packages

### Wolf

- **Tier 0:** Fang Slash → Rending Cross → Raking Fang → Blood Cleave; Predator's Passage; Hunting Slash; Fang Reversal.
- **Tier I — Blood Tempo:** successful contact may continue earlier into approved Basic-sequence positions.
- **Feral Momentum:** later connected Basic positions gain modest deterministic Health and posture payoff that increases at each Embrace.
- **Tier II — Blood Hunt:** limited activation healing and close disruption followed by one fixed pursuit line ending in Blood Fang.
- **Tier III — Fanged Guard:** one normal posture-costing frontal block may preserve selected committed attacks.
- **Tier IV — Apex Mauling:** qualifying major impacts create a consolidated Blood-claw follow-up with strong posture pressure and compact secondary coverage.

### Wraith

- **Tier 0:** Veil Cut → Passing Arc; Pale Lance; Ghostline Slash; Veil Reversal.
- **Tier I — Pale Barrage:** Pale Lance may continue into rapid stationary spectral jabs.
- **Spectral Edge:** eligible spectral-only contact gains modest posture and guard pressure that increases at each Embrace.
- **Tier II — Wraith's Reach:** compact frontal sweep, very long fixed corridor strike, and one delayed same-geometry repetition.
- **Tier III — Spectral Passage:** qualifying spectral attacks continue through ordinary-enemy bodies across their remaining authored geometry.
- **Tier IV — Beyond the Veil:** longer Pale Lance and Ghostline Slash spectral reach, expanded Spectral Edge eligibility, greater-distance clear-path deathblows, and brief movement-only Veilstride after a killing deathblow.

### Ronin

- **Tier 0:** Severing Cut → Crushing Cross → Bloodfall; Stillness Draw; Breaching Slash; Answering Steel; strongest guard with slowest posture recovery.
- **Tier-growth rule:** every Embrace from Tier I through Tier IV modestly increases maximum player-posture capacity without increasing posture recovery or block efficiency.
- **Tier I — Steadfast Reprisal:** a qualifying block creates an optional Reprisal Cut.
- **Tier II — Falling Mountain:** partial posture relief on activation, planted monumental slam, compact impact burst, and delayed Deep Rupture.
- **Tier III — Unbroken Resolve:** selected late commitments may survive one costly eligible frontal hit; clean deliberate strikes may create Measured Weight and one Perfect Weight follow-up.
- **Tier IV — Shattering Wake:** qualifying direct heavy impacts transfer reduced Health damage and strong posture force through the primary target into enemies behind it.

Authorities:

- `gameplay/WOLF_ASPECT.md`
- `gameplay/WRAITH_ASPECT.md`
- `gameplay/RONIN_ASPECT.md`
- `gameplay/BLOOD_ASPECTS.md`
- `gameplay/ASPECT_WEAPON_KIT_MODEL.md`
- `gameplay/ASPECT_IDENTITY_GUIDELINES.md`

## Resolved Aspect audit

The ordered Wolf, Wraith, and Ronin package revisions are complete at qualitative paper-design depth.

Resolved Ronin findings:

- Tier 0's six offensive actions and guard profile are sufficiently distinct for prototyping.
- Maximum player-posture capacity is the repeated Tier-growth rule; generic Health growth and Stillness Draw-only damage growth were rejected.
- Steadfast Reprisal remains distinct from Answering Steel because blocking creates a slower optional retaliation while parrying earns the stronger immediate counter.
- Falling Mountain remains the Tier II point-dominating Blood Art with partial posture relief, direct-slam priority, a reduced surrounding burst, and delayed Deep Rupture.
- Unbroken Resolve and Measured Weight → Perfect Weight remain linked Tier III outcomes: costly completion after one eligible hit versus superior clean-execution posture payoff.
- Shattering Wake remains the Tier IV formation-breaking capstone and does not multiply damage against the primary target.

Exact combat values, frame data, timings, hitboxes, radii, proc weighting, posture-growth percentages, and final VFX remain prototype and balance work.

## Priority order

1. Final cross-roster Aspect lock
2. Launch run-build content catalog
3. Persistent progression, onboarding, and trial package
4. Narrative delivery and authored-content package
5. Postgame release package

# 1. Final cross-roster Aspect lock

**This is the current active question.**

Compare the completed Wolf, Wraith, and Ronin packages for:

- immediate Tier 0 differentiation,
- practical value at every Embrace,
- ordinary groups, ranged pressure, elites, bosses, and bosses without adds,
- beginner-visible value and expert mastery value,
- Tier 0-I Technique-focused viability,
- Tier II hybrid viability,
- Tier III-IV Aspect-focused value,
- preserved weaknesses and player outplay,
- Blood Art activation value and form diversity,
- movement, range, Health damage, posture, stagger, sustain, defense, and recovery overlap,
- Technique and permanent-progression design space,
- animation, VFX, audio, UI, teaching, and engineering cost,
- and whether every Tier is worthwhile but nonmandatory.

Only after this comparison should the three Aspect packages be treated as production-ready at paper-design depth.

# 2. Launch run-build content catalog

Define the minimum complete and replayable launch catalog:

- approximate base Technique count and role distribution,
- universal action-tag coverage,
- Technique rarity roles,
- affinity and offer weighting,
- number and quality of refinements,
- post-fill offer construction and anti-dead-offer rules,
- allowed direct Aspect-, Tier-, or Blood-referencing entries,
- temporary Prosthetic Technique count per tool,
- initial Relic count and rarity distribution,
- whether consumables ship,
- and entries requiring unique icons, VFX, animation, or audio.

The coverage matrix belongs in `gameplay/TECHNIQUE_CATALOG.md`.

# 3. Persistent progression, onboarding, and trial package

Define the minimum launch package across the Bloodwell, Forge, Blood Mirror, and Blood Cavern:

- permanent node, rank, or branch counts,
- basic-combat onboarding trials,
- Aspect teaching and mastery trials,
- Technique demonstrations or mastery trials,
- unlock ownership,
- capped reliability upgrades,
- rewards and mastery marks,
- and required interface states.

Do not assume a duplicate Blood Art upgrade tree beneath every Aspect.

# 4. Narrative delivery and authored-content package

Define:

- first-death and Returning Blood awakening presentation,
- bloodline confirmation timing and evidence,
- Shogun dialogue progression and reconstruction presentation,
- NPC, codex, results, and Heart-chamber updates,
- ending and credits requirements,
- voice scope,
- and cinematic, portrait, in-engine, or environmental delivery ownership.

# 5. Postgame release package

Define:

- repeat access to the Heart route,
- repeat-clear rewards,
- launch completion goals such as records, marks, or cosmetics,
- and required Boat, results, save-state, and postgame UI states.

Additional difficulty settings, challenge modifiers, enemy variants, and room variants remain outside initial release unless explicitly promoted later.

## Deferred implementation and balance work

Keep exact values in their owning files, including:

- damage, posture, guard pressure, stagger, reach, movement, recovery, and interruption timing,
- hitboxes, collision, targeting, deathblow pathing, and blocker classifications,
- Blood capacity, gain values, proc weighting, and anti-farming rules,
- Feral Momentum, Spectral Edge, and Ronin posture-capacity scaling,
- Pale Lance/Ghostline Tier IV reach, extended deathblow range and angle, and Veilstride duration,
- room counts, route and reward probabilities, prices, rarity weights, and rerolls,
- permanent-upgrade percentages,
- and final animation frames, VFX density, audio timing, or HUD layout.