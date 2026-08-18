---
id: GAMEPLAY-CORRUPTION-SHRINES
title: Corruption and Shrines
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - corruption
  - shrine
  - resist
  - embrace
  - stabilize
  - blood-aspects
  - first-attempt
  - implementation
  - first-playtest
related:
  - LORE-RETURNING-BLOOD
  - GAMEPLAY-FIRST-ATTEMPT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-ITEMS-REWARDS
  - UI-SHRINE
  - UI-HUD
---

# Corruption and Shrines

Corruption is the run-only pressure of **awakened Returning Blood**. It controls Shrine-ready states and optional Aspect Tier advancement; it is not morality, currency, Blood Art charge, or a Technique resource.

Corruption does not exist on Akio's first pre-awakening attempt.

The values below are approved first-playtest implementation targets. Final pacing may move through Godot testing without reopening the Corruption/Shrine architecture.

# Corruption meter

- maximum / full threshold: **100 Corruption**,
- awakened runs begin at **0 / 100**,
- Corruption persists between chambers,
- Corruption does not passively decay,
- gain above 100 is discarded,
- while full, further gain is discarded until a Shrine resolves the state,
- death or successful run completion resets Corruption to 0.

# Corruption gain

First-playtest event values:

| Event | Corruption |
|---|---:|
| Ordinary enemy defeated | **+1** |
| Elite enemy defeated | **+3 instead of +1** |
| Successful parry | **+1** |
| First posture break on an enemy | **+2** |
| Successful Deathblow | **+3** |
| Standard combat clear | **+4** |
| Miniboss clear | **+10** |
| Authored regional-boss progress checkpoint | **+5** |
| Regional boss defeat | **+10** |

Encounter caps:

- standard Combat chamber: **16 Corruption maximum**,
- miniboss encounter: **24 maximum**,
- regional boss encounter: **30 maximum**,
- successful parries contribute at most **4 Corruption per chamber**.

## Anti-farming / credit rules

Combatants use a progression-credit eligibility flag.

No Corruption is awarded from endlessly generated targets, respawned farming targets, decorative units, or summons explicitly marked no-credit.

An ordinary enemy may award the posture-break Corruption bonus only once per life and the Deathblow bonus only once. An authored boss phase may explicitly refresh break-credit eligibility when that phase represents a genuine new combat state.

Taking Health damage is not a universal Corruption source.

# Shrine-ready state

At **100 Corruption**, the player receives a clear non-disruptive indication that a Shrine progression decision is available.

Choosing a Shrine route is the main opportunity cost of Aspect advancement. A Shrine route competes with Technique, refinement, Relic, economy, survival, and other previewed rewards.

# Shrine support below full Corruption

A Shrine encountered below 100 Corruption provides fixed support and does not change Corruption:

- restore **20% max Health**, and
- restore **25% max Spirit**.

Each resource resolves independently. If Health or Spirit is already full, that part simply has no effect; the other resource still restores normally. There is no Health-versus-Spirit selection rule.

Shrines do not normally present ordinary Technique selections.

# Resist

At full Corruption, Resist stabilizes Returning Blood without advancing the Aspect:

- keep the current Tier,
- set Corruption to **75 / 100**,
- restore **25% max Health**,
- restore **35% max Spirit**,
- remain eligible to Embrace later.

Health and Spirit restoration resolve independently and simply do nothing for a resource already at maximum.

Resist is a recovery option and pacing valve. It does not stack Aspect power or improve the Blood Art.

# Embrace

Embrace advances the selected Aspect by one fixed Tier, up to Tier IV:

- advance exactly **one Tier**,
- set Corruption to **0 / 100**,
- apply the new approved Tier package immediately.

Every Tier remains clearly net-positive. The Aspect authorities own the actual Tier behavior and values.

Reaching **Tier II** makes the selected Aspect's Blood meter available under `BLOOD_ASPECTS.md`.

# Optional Aspect investment

- Tier 0 is a complete and viable weapon kit.
- Technique-focused Tier 0-I builds must remain capable of completing a run.
- Tier II is a common hybrid target that unlocks Blood and the Blood Art.
- Tier III represents deeper deliberate Aspect investment.
- Tier IV is powerful and occasional rather than the expected endpoint of every successful run.
- Mandatory encounters must not assume a specific Tier or Blood Art is present.

# Maximum Tier: Stabilize

There is no Tier V. Corruption may continue filling at Tier IV so the Shrine loop remains relevant.

At Tier IV and 100 Corruption:

- Embrace is unavailable,
- the Shrine presents **Stabilize**,
- set Corruption to **50 / 100**,
- restore **30% max Health**,
- restore **40% max Spirit**,
- grant no additional Tier, Aspect power, Blood Art improvement, or permanent scaling.

Health and Spirit restoration again resolve independently and skip any resource already full.

# First-attempt pre-awakening Shrine state

Shrines remain valid route rooms on the unscripted first attempt even though Returning Blood has not awakened.

Because no Corruption or Blood Aspect exists yet:

- no Corruption meter is shown,
- Resist is unavailable,
- Embrace is unavailable,
- no Aspect Tier can be gained,
- the Shrine restores **20% max Health + 25% max Spirit** using the same independent-resource rule as an ordinary below-full Shrine.

`FIRST_ATTEMPT.md` owns the complete pre-awakening run exception.

# Run-state transitions

After the first awakening:

1. select an unlocked Aspect at the Boat,
2. begin the run at Tier 0 and 0 Corruption,
3. gain Corruption through approved combat/progression events,
4. at 100, enter the full / Shrine-ready state,
5. a Shrine resolves that state through Resist or Embrace; at Tier IV use Stabilize,
6. death or successful completion resets Corruption and temporary Tier state.

The HUD must support hidden/pre-awakening, empty, filling, near-full, full/Shrine-ready, post-Resist, post-Embrace, and Tier-IV maximum states.

# Presentation requirements

- Resist, Embrace, and Stabilize must be distinguishable before text is read.
- Show current Aspect, current Tier, and the next headline benefit when an Aspect is active.
- Resist should feel controlled and stabilizing.
- Embrace should feel forceful and desirable without appearing generically evil.
- The Shrine interface must remain distinct from Technique card selection.
- The first-attempt no-Aspect support state must be readable without showing nonexistent Corruption/Tier data.

# First-playtest pacing target

The current gain values should make Tier I reliably accessible, Tier II a common mid-run investment target, Tier III a deeper investment, and Tier IV achievable but not routine.

Final gain rates, encounter caps, and successful-run Tier distributions are playtest-tuning variables. They do not require another planning pass unless implementation exposes a structural problem.
