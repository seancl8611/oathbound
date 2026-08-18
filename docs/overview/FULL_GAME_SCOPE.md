---
id: OVERVIEW-FULL-SCOPE
title: Full Game Scope
category: overview
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - full-scope
  - techniques
  - relics
  - prosthetics
  - progression
  - narrative-delivery
  - first-attempt
  - areas
  - the-heart
  - postgame
  - release-scope
  - authored-encounters
related:
  - OVERVIEW-PRODUCTION-ROADMAP
  - OVERVIEW-ENDGAME-POSTGAME-RELEASE
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-PROGRESSION
  - NARRATIVE-DELIVERY
  - META-OPEN-QUESTIONS
---

# Full Game Scope

This document summarizes Oathbound's approved launch shape. Detailed mechanics remain in their owning authorities; prototype values remain playtest-tunable without reopening architecture.

# Master scope

| Asset / system group | Planned count / boundary |
|---|---|
| Player | Akio; fully silent protagonist |
| Blood Aspects | 3 — Wolf, Wraith, Ronin |
| Direct Technique slots | 5 |
| Techniques | 50 + 10 refinements |
| Prosthetics | 8 tools / 19 permanent upgrades |
| Relics | 10 / Base + 2 mastery ranks each |
| Bloodwell | 10 Akio + 8 Run Infrastructure nodes |
| Blood Mirror | 9 nodes total / 3 per Aspect |
| Boss-material-gated nodes | 6 total |
| Permanent upgrade stations | 3 — Bloodwell, Forge Bench, Blood Mirror |
| General consumables | 0 launch inventory layer |
| Strand NPCs | 6 |
| Standard enemies | 6 Hushiro / 4 Yomori / 5 Kagutsuchi |
| Regional minibosses | 6 authored / 2 per region |
| Regional bosses | 3 |
| Regional chambers | 33 — 12 / 10 / 11 |
| Heart Bindings | 7 original / 6 player-destroyed |
| True-final Heart | 1 encounter / 2 forms |
| Persistent resources | Mist, Scrolls, 3 boss-material families |
| Run-only currency | Gold |
| Major narrative sequences | ~5 |
| Awakened Shogun states | 7 + 1 rare pre-awakening fallback |
| Binding presentation states | 6 states of one reusable ritual |
| Major Strand conversations | ~30–36 |
| Lore / Records entries | ~20–25 substantive entries |
| Narrative writing target | ~15k–20k words |
| Launch achievements | ~30 |
| Save slots | 3 |

# First attempt

The first attempt is the normal full route, not a scripted tutorial.

Akio starts with:

- base katana,
- Beast-Bane Whistle,
- ordinary Technique rewards and room/reward flow,
- no active Blood Aspect, Corruption/Tier progression, Blood Art, Relic loadout, or permanent upgrades.

The first death may happen anywhere. An exceptional player may reach the Shogun/Heart before dying; Heart contact triggers the first awakening without destroying a Binding.

# Run and combat structure

Launch regional route:

- Hushiro — 12 chambers / Keeper / ~14–16 min,
- Yomori — 10 / Twin Maws / ~12–14 min,
- Kagutsuchi — 11 / Eclipse Shogun / ~15–17 min.

Normal successful Binding runs target ~45–50 active minutes. Heart/Suppression routes target ~55–60.

Standard Combat uses deliberately authored regional encounter scripts selected by the route generator; it does not procedurally assemble enemy threat budgets.

Standard enemies are region-native by default. The only approved launch cross-region lineage is **Blighted Hounds → Stalker Hound** in Yomori.

# Build and progression scope

Run build:

- one Blood Aspect at Tier 0 after awakening,
- optional Shrine progression through Tier IV,
- five direct Technique slots,
- slotless Supporting / Cross-family / Legendary Techniques,
- refinements/replacements,
- one Prosthetic,
- one Relic,
- Gold/Shop and survival/capacity decisions.

There is no global Technique inventory cap beyond the five direct slots and no general launch consumable inventory.

Permanent progression:

- Bloodwell — 10 Akio + 8 Infrastructure,
- Forge — 19 Prosthetic upgrades + 20 Relic mastery milestones,
- Blood Mirror — 9 nodes,
- exactly six boss-material-gated Bloodwell nodes.

All foundational permanent systems are structurally available after the first Binding clear. Later campaign/postgame play emphasizes completion and mastery rather than new meta trees.

# Campaign and narrative

After Returning Blood awakens, Akio destroys the six remaining Heart Bindings across six successful Shogun clears. The seventh story run continues directly from Shogun into the two-form Heart encounter.

Akio remains silent throughout the game.

Narrative production target:

- ~5 controlled in-engine sequences,
- 7 awakened Shogun states + rare pre-awakening fallback,
- 6 Binding states,
- ~30–36 major Strand conversations,
- ~4–6 reactive line sets per NPC,
- ~20–25 substantive Lore / Records entries,
- ~15k–20k narrative words,
- no full spoken-dialogue VO requirement.

# Canonical Heart ending

The first Heart victory completes the main story but does **not** erase existing Beast Blood.

Akio destroys the Heart's manifested body and permanently cripples the source so that:

- it can never produce or release new Beast Blood,
- no new bearer can ever be created,
- the curse cannot spread beyond the existing population,
- the Shogun's mainland expansion plan is permanently defeated.

The Heart survives as a faint regenerating remnant. Existing Beast Blood remains active in Akio, the Shogun, corrupted inhabitants, altered beasts, and other existing bearers. Their established regeneration/reconstruction remains intact.

# Canonical postgame

After Story Complete, Akio continues containment work on the island.

Boat run goals:

- **Standard Expedition** — normal route ending after Shogun,
- **Heart Suppression** — continues from Shogun into regenerated Heart manifestation.

Postgame adds no new currency or progression tree. It supports existing mastery, collection, records, and completion.

100% Completion broadly requires:

- Story Complete,
- all Bloodwell/Blood Mirror/Prosthetic progression,
- all Relics collected and mastered,
- all Techniques/refinements discovered,
- required trials and Discovery Board completion,
- Heart victory with Wolf, Wraith, and Ronin.

Launch target is approximately 30 achievements.

# Release boundary

Launch includes:

- 3 save slots,
- Continue / New Game / Settings / Credits / platform-appropriate Quit,
- safe autosave and quit/resume support,
- control rebinding,
- vibration options,
- screen-shake/reduced-flash/reduced-VFX options,
- UI/text scaling and color-independent gameplay communication,
- text-speed/instant/manual-advance options,
- separate Master/Music/SFX/Ambience controls,
- English as required launch language with localization-ready text systems,
- required contributor/licensing credits and notices.

Launch does **not** require:

- Heat/Pact-style modifiers,
- New Game+,
- endless mode,
- daily challenges,
- postgame enemy/room variant packages,
- a fourth Aspect,
- another campaign,
- another permanent progression tree or persistent currency.

# Scope status

**Top-level launch architecture is closed at paper-design depth.**

Next work is content realization and playable validation:

1. author regional standard-encounter pools,
2. design/tune miniboss and boss encounters,
3. design/tune the two-form Heart encounter,
4. realize exact scripts/achievements/trials/content,
5. tune numerical balance and validate run-time targets.

`OPEN_QUESTIONS.md` owns the active content-production sequence.
