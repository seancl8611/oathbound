---
id: GAMEPLAY-TECHNIQUE-CATALOG
title: Technique Catalog
category: gameplay
status: draft
authority: primary
last_reviewed: 2026-08-08
topics:
  - techniques
  - technique-catalog
  - refinements
  - combat-verbs
  - aspect-affinity
  - run-builds
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

This file owns the working Technique roster, coverage matrix, individual Technique concepts, refinements, and production treatment.

`TECHNIQUES.md` owns system rules such as slots, reserve behavior, categories, affinity, rarity, and refinement structure. The Aspect files own Wolf, Wraith, and Ronin and must not be reopened merely to make a Technique fit.

## Current status

No individual launch Technique is locked yet. The next design step is to sketch the roster and then judge the catalog rules against the roster as a whole.

### Provisional launch targets

These targets are intentionally flexible:

| Planning item | Working sketch |
|---|---|
| Base Techniques | ~30 |
| Blade | ~8 |
| Deflection | ~6 |
| Execution | ~5 |
| Movement | ~5 |
| General | ~6 |
| Technique rarity | Common / Uncommon / Rare / Legendary |
| Techniques with a refinement | ~60–70% |
| Aspect affinity | Mostly soft weighting |
| Direct Aspect/Tier/Blood Techniques | Rare exceptions |

The category totals, rarity distribution, refinement count, and affinity mix may change substantially once actual Techniques exist. They are planning guides, not quotas.

Legendary Techniques are currently intended as very rare, powerful, exciting run-shaping finds rather than simple numerical upgrades. Their exact number, appearance rules, and power ceiling should be decided after candidate Techniques are drafted.

Relics are currently being explored with a simpler three-rarity structure rather than mirroring all four Technique rarities. Relic details remain provisional and belong to the broader run-build catalog.

## Locked surrounding systems

The catalog must respect the already-approved Aspect packages:

- **Wolf:** fast close-range pressure and pursuit.
- **Wraith:** extended spectral reach and frontal control.
- **Ronin:** slow heavy impact and defensive stability.

Techniques use four active slots plus one inactive reserve. Ordinary Techniques should remain usable across all three Aspects. Affinity may make an entry naturally stronger with one Aspect, but should not normally determine eligibility.

A Technique may reinforce, broaden, compensate for, or hybridize an Aspect. It should modify an existing combat verb rather than recreate a complete fixed Tier mechanic or Blood Art.

## Roster-design approach

Do not fully specify rarity distribution, refinement distribution, offer weighting, or exception rules before the roster exists.

Instead:

1. sketch a broad set of individual Technique concepts,
2. check action/category and encounter coverage,
3. identify natural affinities and build directions,
4. identify which concepts deserve refinements,
5. identify which concepts feel Rare or Legendary,
6. remove overlap and weak filler,
7. then revise the provisional counts and system rules.

The goal is a coherent fun roster, not perfect adherence to the first numerical sketch.

## Coverage matrix

Use this as a checklist while concepts are drafted. A Technique may cover several rows.

| Coverage family | Design question | Status |
|---|---|---|
| Basic attacks | Are there meaningful ways to deepen normal swordplay across all Aspects? | Open |
| Held attacks | Are committed Held actions supported without making them universally safe? | Open |
| Dash attacks / re-entry | Are movement-to-offense and spacing options represented? | Open |
| Parry counters | Are successful defensive reads able to develop offensively? | Open |
| Block / player posture | Are defensive builds possible without erasing Aspect weaknesses? | Open |
| Enemy posture | Are posture-pressure builds represented without becoming mandatory? | Open |
| Deathblows / execution | Are posture breaks and executions supported beyond raw damage? | Open |
| Movement / spacing | Are repositioning and spacing builds available without tracking/homing? | Open |
| Health / Spirit / recovery | Is limited survival/resource support represented without generic filler? | Open |
| Prosthetics | Can each equipped tool receive meaningful temporary specialization? | Open |
| Reinforce | Does every Aspect have several natural strength-deepening choices? | Open |
| Broaden | Can every Aspect gain adjacent options without losing identity? | Open |
| Compensate | Can a slot soften a weakness without deleting it? | Open |
| Hybridize | Are unusual cross-category builds possible? | Open |
| Boss value | Does the pool avoid too many group-only or kill-only dead choices? | Open |
| Mixed encounters | Are groups, ranged pressure, and target priority supported? | Open |
| Early-run value | Can entries stand alone before a build forms? | Open |
| Late-run value | Can refinement, replacement, rarity, and specialization remain exciting? | Open |

## Technique entry template

### Identity

- **Stable ID:** `TECH-###`
- **Name:**
- **Status:** concept / candidate / approved / deferred / cut / implemented
- **Primary category:**
- **Working rarity:**
- **Combat-verb tags:**
- **Aspect affinity:** neutral or soft affinity
- **Build direction:** reinforce / broaden / compensate / hybridize
- **Prosthetic requirement:** none unless applicable

### Gameplay

- **Trigger or condition:**
- **Base effect:** qualitative behavior before exact tuning
- **Player decision:** why this is chosen over another valid option
- **Skill expression:** what good play improves
- **Failure / reset behavior:**
- **Boss / elite behavior:**
- **Crowd behavior:**
- **Cross-Aspect usefulness:**
- **Overlap check:** why it does not reproduce a fixed Aspect mechanic

### Refinement

- **Refinement:** candidate or `None at launch`
- **Effect:**
- **Why it deepens the same Technique:**

### Production

- **UI:**
- **VFX:** reused / extended / bespoke
- **Animation:** existing / new scope
- **Audio:**
- **Unlock ownership:**

## Quality direction

A strong Technique should:

- provide standalone value,
- reward active play or a clear tactical decision,
- remain useful outside its strongest affinity,
- avoid exact prerequisite chains,
- avoid replacing sword execution with automatic damage,
- remain understandable before selection,
- preserve boss and mixed-encounter usefulness where appropriate,
- and justify any bespoke production cost.

Not every Technique needs equal complexity. Common entries can be clean and dependable; higher-rarity entries can be stranger or more transformative. Final rarity rules should follow the actual roster rather than precede it.

## Deferred until roster review

Do not lock yet:

- exact category totals,
- exact rarity totals or probabilities,
- exact Legendary count or appearance rules,
- which specific 60–70% of Techniques receive refinements,
- exact affinity weighting,
- offer-generation weights,
- exact direct Aspect/Tier/Blood exception count,
- Prosthetic Technique count per tool,
- final Relic count and rarity distribution,
- consumable inclusion,
- or numerical combat values.

These should be revisited after a meaningful first-pass Technique roster exists.
