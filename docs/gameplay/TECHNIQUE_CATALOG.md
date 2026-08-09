---
id: GAMEPLAY-TECHNIQUE-CATALOG
title: Technique Catalog
category: gameplay
status: draft
authority: primary
last_reviewed: 2026-08-09
topics:
  - techniques
  - technique-catalog
  - combat-slots
  - effect-families
  - supporting-techniques
  - refinements
  - rarity
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-COMBAT
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-PROGRESSION
  - UI-TECHNIQUE-REWARDS
  - ART-TECHNIQUE-VFX
  - META-OPEN-QUESTIONS
---

# Technique Catalog

## Purpose

This file owns the working Technique roster, family coverage, individual Technique concepts, supporting upgrades, refinements, rarity candidates, and production treatment.

`TECHNIQUES.md` owns the system rules. The Aspect files own Wolf, Wraith, and Ronin and must not be reopened merely to make a Technique fit.

## Current status

The Technique architecture is now locked at a higher level, but the actual effect families and individual roster are not yet approved.

The old planning model of roughly 30 base Techniques divided into Blade, Deflection, Execution, Movement, and General quotas is retired. Those buckets were too unequal to serve as the backbone of build design.

The roster should now be built from two independent dimensions:

1. **Combat slot** — which core action is directly modified.
2. **Effect family** — which recurring supernatural / martial rule the Technique belongs to.

Exact player-facing family names are not required. Family identity may ultimately be communicated through color, symbol, VFX, effect wording, or another UI language.

## Five slotted action roles

Every broad effect family should be tested for meaningful representation across these action roles:

| Combat slot | Core action | Trigger frequency | Expected per-trigger power |
|---|---|---|---|
| Basic Attack | Basic sequence / primary sword action | Very high | Lower per trigger |
| Held Attack | committed Held action | Medium | Strong |
| Dash | Dash Attack / approved evade or re-entry interaction | High | Medium |
| Parry / Counter | successful parry / Parry Counter | Medium and skill-gated | Strong |
| Deathblow | posture break / execution | Low | Very strong |

A family does not need perfectly symmetrical effects in all five slots, but it must have enough breadth that it does not become an unequal mechanic bucket such as "only healing" or "only delayed attacks."

## Effect-family requirements

A launch family should:

- fit Akio's disciplined supernatural-samurai fantasy,
- derive naturally from Returning Blood, Order technique, seals, wounds, execution, controlled mutation, or another established world concept,
- support several combat slots rather than one narrow mechanic,
- have a repeatable visual / gameplay identity,
- support both focused and hybrid builds,
- offer room for slotless supporting upgrades,
- and remain distinct from the locked Wolf, Wraith, and Ronin identities.

Avoid using generic elemental categories such as fire, frost, or lightning as the main family structure. Familiar functions such as slow, area damage, chaining, extra reach, delayed damage, crowd control, or recovery remain valid when expressed through Oathbound-specific rules.

## Supporting-upgrade layer

After or alongside slotted Techniques, the roster needs slotless supporting Techniques that can deepen a family without occupying another core action slot.

Supporting concepts may:

- strengthen a family's shared effect,
- improve buildup, spread, duration, or payoff,
- connect two combat slots that already use the same family,
- create cross-family interactions,
- modify a family interaction with posture, Health, Spirit, bosses, crowds, or positioning,
- or unlock a more advanced family behavior.

There is no fixed inventory cap on these upgrades. Their practical limit comes from reward opportunities and build prerequisites.

## Rarity direction

Technique rarity remains:

- Common
- Uncommon
- Rare
- Legendary

Legendary Techniques should be exceptional and run-shaping. Some may be independent rare finds; others may act as family capstones that require prior investment before becoming eligible.

Exact prerequisite counts are not yet locked. Prerequisites must never consume so much of a run that the player is forced into one family merely to reach a capstone.

## Replacement direction

A slotted Technique normally commits that combat slot for the rest of the run.

Rare replacement offers may overwrite the existing Technique in that same combat slot. Replacements should support meaningful pivots or unusually strong finds rather than make early choices disposable.

## Refinement direction

A slotted Technique may have one refinement. Refinements improve that exact Technique; slotless supporting Techniques improve broader family or build behavior.

There is no longer a target that 60-70% of the roster must receive refinements. Coverage should follow the actual concepts.

## Aspect audit for every candidate

Every slotted or supporting Technique must be checked against all three Aspects:

- **Wolf:** fast, close, pursuit-heavy, high hit frequency.
- **Wraith:** longest effective melee reach, line control, deliberate spacing.
- **Ronin:** slow, heavy, high impact, strong defensive stability.

Check whether the Technique:

- remains useful on all three,
- has intentional rather than accidental affinity,
- disproportionately scales from hit frequency, individual hit size, reach, or defensive stability,
- erases an Aspect's failure state,
- duplicates a fixed Tier or Blood Art,
- or makes one Aspect overwhelmingly correct for that family.

## Coverage checklist

The first roster pass should cover enough of the following without forcing one Technique per row:

- Basic Attack pressure and sequence behavior,
- Held Attack commitment and payoff,
- Dash Attack / re-entry,
- parry and Parry Counter payoff,
- posture break and Deathblow payoff,
- area damage / crowd handling,
- controlled range or geometry changes,
- slow / suppression / restraint equivalents,
- delayed or repeated damage,
- marks and later payoff,
- posture pressure and guard breaking,
- Health risk / recovery,
- Spirit and Prosthetic synergy,
- focused-family build deepening,
- hybrid-family interactions,
- boss usefulness,
- mixed-encounter usefulness,
- and rare high-impact Legendary behavior.

## Entry templates

### Slotted Technique

- **Stable ID:** `TECH-###`
- **Name:**
- **Status:** concept / candidate / approved / deferred / cut / implemented
- **Combat slot:** Basic Attack / Held Attack / Dash / Parry-Counter / Deathblow
- **Effect family:** internal family identifier
- **Working rarity:**
- **Core effect:**
- **Skill / decision requirement:**
- **Aspect audit:** Wolf / Wraith / Ronin
- **Boss / crowd behavior:**
- **Overlap check:**
- **Refinement:** candidate or none
- **Production notes:** UI / VFX / animation / audio

### Supporting Technique

- **Stable ID:** `TECH-S###`
- **Name:**
- **Status:**
- **Effect family or cross-family requirement:**
- **Working rarity:**
- **Prerequisite when present:**
- **Support effect:**
- **Why it is worth a reward choice:**
- **Aspect / encounter audit:**
- **Production notes:**

### Legendary / capstone candidate

- **Stable ID:** `TECH-L###`
- **Name:**
- **Family or neutral:**
- **Eligibility requirement:** provisional until roster review
- **Effect:**
- **Why it changes the run:**
- **Why it does not replace the Aspect:**
- **Production cost:**

## Current roster-design sequence

1. Define the first set of broad effect families.
2. Test each family across all five combat slots.
3. Draft the strongest slotted Technique concepts.
4. Add supporting Techniques that deepen focused and hybrid builds.
5. Identify refinements and rare replacements.
6. Identify Legendary / capstone candidates and sensible prerequisites.
7. Audit the whole roster across Wolf, Wraith, Ronin, bosses, groups, and realistic trigger frequency.
8. Only then lock launch count, family representation, reward frequency, rarity distribution, and production scope.

## Deferred until roster review

Do not lock yet:

- exact number of effect families,
- final family names or player-facing presentation,
- total launch Technique count,
- supporting-Technique count,
- exact rarity totals or probabilities,
- Legendary prerequisite thresholds,
- replacement frequency,
- exact refinement coverage,
- family offer weighting,
- Prosthetic Technique structure under the new slot model,
- final Relic count / rarity distribution,
- consumable inclusion,
- or numerical combat values.
