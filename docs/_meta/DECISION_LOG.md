---
id: META-DECISION-LOG
title: Decision Log
category: meta
status: approved
authority: summary
last_reviewed: 2026-08-07
---

# Decision Log

This is a concise index of major approved directions that materially changed Oathbound's scope or identity. Complete rules live in authoritative files; superseded wording is recoverable through Git history.

## 2026-07-10 — Seven production milestones and paid Style Test

Oathbound uses seven dependency/playtest-based production milestones. Milestone 1 begins only after a separately paid Style Test locks practical sprite scale, palette, perspective, detail, outline, shadow, and Godot import targets.

**Authority:** `docs/overview/PRODUCTION_ROADMAP.md`

## 2026-07-11 — Blood Aspects replace the stance system

Wolf, Wraith, and Ronin are the central run weapon identities. The former Storm, Frost, Ember, Hex, and Shadow stance system is removed.

**Authority:** `docs/gameplay/BLOOD_ASPECTS.md`

## 2026-07-11 — Four active Techniques and one reserve

Runs use four active Technique slots, one inactive reserve, independently useful Techniques, and at most one refinement per Technique.

**Authority:** `docs/gameplay/TECHNIQUES.md`

## 2026-07-11 — Previewed reward and currency framework

Room function and payout are separate. Routes may preview reward categories; Shrines own Resist/Embrace; rest rooms own recovery/reserve swapping; shops use Gold. Mist, Scrolls, and Boss Emblems persist; Gold is run-only.

**Authority:** `docs/gameplay/ITEMS_AND_REWARDS.md`

## 2026-07-14 — Heart, Bindings, Beast Blood, and Returning Blood

The Heart is an ancient supernatural core imprisoned by seven Bindings. The Court breached the outermost Binding during the plague and built an extraction apparatus. Beast Blood must be deliberately introduced and does not spread environmentally. Akio descends from the Shogun's escaped child; his first death during the Blood Moon awakens Returning Blood and reconstructs his human form at the Strand.

**Authority:** `docs/lore/BEAST_BLOOD.md`, `docs/lore/RETURNING_BLOOD.md`, `docs/lore/STORY_OVERVIEW.md`

## 2026-07-15 — Shogun and regional curse identities

The Eclipse Shogun remains intelligent and responsible for his actions. Hushiro represents rupture, Yomori adaptation, and Kagutsuchi false ascendancy.

**Authority:** `docs/lore/ECLIPSE_SHOGUN.md` and regional overview files

## 2026-07-20 — Heart Binding campaign

The Court destroyed one of seven Bindings before the game. Akio destroys the remaining six across six successful runs using one reusable Returning Blood ritual.

**Authority:** `docs/gameplay/RUN_STRUCTURE.md`

## 2026-07-21 — Final story run, ending, and postgame

The seventh successful story run continues from the Shogun into the two-form Heart. Destroying the Heart ends Beast Blood and makes Akio mortal. Completed saves retain repeatable normal runs and optional Heart-route gameplay without creating new canonical endings.

**Authority:** `docs/lore/STORY_OVERVIEW.md`, `docs/gameplay/RUN_STRUCTURE.md`

## 2026-07-22 — Successful-run duration

A normal successful Binding run targets roughly 45–50 minutes. Exact room counts, topology, branch frequency, and encounter budgets remain prototype/playtest work.

**Authority:** `docs/gameplay/RUN_STRUCTURE.md`

## 2026-07-26 — Blood Aspects use complete weapon kits

Aspect identity comes from concrete timing, reach, geometry, movement, damage, posture, stagger, commitment, recovery, and modest defensive differences rather than passive bonuses or mandatory behavioral loops. Sequences are available attacks, not objectives.

All launch Aspects retain universal neutral movement, dash, defense input, ordinary parry timing, posture-break rules, and deathblow language.

**Authority:** `docs/gameplay/ASPECT_WEAPON_KIT_MODEL.md`

## 2026-08-05 — Wolf package revised around Blood Hunt

Wolf's fixed path is Blood Tempo with Feral Momentum growth, Blood Hunt/Blood Fang, Fanged Guard, and Apex Mauling. Dire Hunt transformation and Apex Feast are superseded.

**Authority:** `docs/gameplay/WOLF_ASPECT.md`

## 2026-08-05 — Wraith Tier 0-II direction

Wraith retains Veil Cut → Passing Arc, with Pale Lance, Ghostline Slash, and Veil Reversal. Pale Barrage is Tier I; Spectral Edge rewards eligible spectral-only posture/guard pressure; Wraith's Reach is an immediate frontal sweep–corridor–echo Blood Art rather than a duration state.

**Authority:** `docs/gameplay/WRAITH_ASPECT.md`

## 2026-08-06 — Wraith Tier III Spectral Passage

Qualifying Wraith spectral attacks continue through ordinary-enemy bodies across their remaining authored geometry, with reduced secondary Health damage and meaningful posture/guard pressure. Protected targets and geometry stop further passage. Veiled Guard is retired.

**Authority:** `docs/gameplay/WRAITH_ASPECT.md`

## 2026-08-06 — Wraith Tier IV Beyond the Veil

Pale Lance and Ghostline Slash gain greater Tier IV spectral reach and Spectral Edge eligibility. Valid deathblows may begin from greater clear-path frontal distance through one straight visible spectral approach. Killing deathblows grant brief movement-only Veilstride. Pale Procession is retired.

**Authority:** `docs/gameplay/WRAITH_ASPECT.md`

## 2026-08-07 — Ronin Tier 0-IV package locked

Ronin keeps its current Tier 0 weapon foundation:

- Severing Cut → Crushing Cross → Bloodfall,
- Stillness Draw,
- Breaching Slash,
- Answering Steel,
- strongest baseline guard with slowest player-posture recovery.

Its fixed progression remains:

- Tier I — Steadfast Reprisal,
- Tier II — Falling Mountain with Deep Rupture,
- Tier III — Unbroken Resolve with Measured Weight and Perfect Weight,
- Tier IV — Shattering Wake.

Beginning at Tier I, every Embrace modestly increases Ronin's maximum player-posture capacity. This growth does not increase posture recovery speed or block efficiency. Generic maximum-Health growth and Stillness Draw-only damage growth are not part of the fixed package.

**Authority:** `docs/gameplay/RONIN_ASPECT.md`

## 2026-08-07 — Three launch Aspect packages individually complete

Wolf, Wraith, and Ronin now each have complete qualitative Tier 0-IV paper-design packages. The next active Aspect decision is the final cross-roster comparison for overlap, accessibility, encounter coverage, Technique space, preserved weaknesses, and production cost.

**Authority:** `docs/_meta/OPEN_QUESTIONS.md`, `docs/gameplay/BLOOD_ASPECTS.md`