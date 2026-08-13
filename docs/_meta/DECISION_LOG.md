---
id: META-DECISION-LOG
title: Decision Log
category: meta
status: approved
authority: summary
last_reviewed: 2026-08-12
---

# Decision Log

This is a concise index of major approved directions that materially changed Oathbound's scope or identity. Complete rules live in authoritative files; superseded wording is recoverable through Git history.

## 2026-07-10 — Seven production milestones and paid Style Test

Oathbound uses seven dependency/playtest-based production milestones. Milestone 1 begins only after a separately paid Style Test locks practical sprite scale, palette, perspective, detail, outline, shadow, and Godot import targets.

**Authority:** `docs/overview/PRODUCTION_ROADMAP.md`

## 2026-07-11 — Blood Aspects replace the stance system

Wolf, Wraith, and Ronin are the central run weapon identities. The former Storm, Frost, Ember, Hex, and Shadow stance system is removed.

**Authority:** `docs/gameplay/BLOOD_ASPECTS.md`

## 2026-07-11 — Original four-slot Technique system — superseded

The original Technique model used four unrestricted active slots plus one reserve. This structure was superseded on 2026-08-09 by five action-specific combat slots plus slotless supporting Technique upgrades.

**Authority:** `docs/gameplay/TECHNIQUES.md`

## 2026-07-11 — Previewed reward and currency framework

Room function and payout are separate. Routes may preview reward categories; Shrines own Resist/Embrace; shops use Gold. Mist, Scrolls, and Boss Emblems persist; Gold is run-only.

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

A normal successful Binding run targets roughly 45-50 minutes. Exact room counts, topology, branch frequency, and encounter budgets remain prototype/playtest work.

**Authority:** `docs/gameplay/RUN_STRUCTURE.md`

## 2026-07-26 — Blood Aspects use complete weapon kits

Aspect identity comes from concrete timing, reach, geometry, movement, damage, posture, stagger, commitment, recovery, and modest defensive differences rather than passive bonuses or mandatory behavioral loops. Sequences are available attacks, not objectives.

All launch Aspects retain universal neutral movement, dash, defense input, ordinary parry timing, posture-break rules, and deathblow language.

**Authority:** `docs/gameplay/ASPECT_WEAPON_KIT_MODEL.md`

## 2026-08-05 — Wolf package revised around Blood Hunt

Wolf's fixed path is Blood Tempo with Feral Momentum growth, Blood Hunt/Blood Fang, Fanged Guard, and Apex Mauling.

**Authority:** `docs/gameplay/WOLF_ASPECT.md`

## 2026-08-05 to 2026-08-06 — Wraith Tier package completed

Wraith retains Veil Cut → Passing Arc with Pale Lance, Ghostline Slash, and Veil Reversal. Pale Barrage, Spectral Edge, Wraith's Reach, Spectral Passage, and Beyond the Veil complete its Tier I-IV path.

**Authority:** `docs/gameplay/WRAITH_ASPECT.md`

## 2026-08-07 — Ronin Tier 0-IV package locked

Ronin keeps Severing Cut → Crushing Cross → Bloodfall, Stillness Draw, Breaching Slash, Answering Steel, strongest baseline guard, and slowest player-posture recovery. Its fixed progression remains Steadfast Reprisal, Falling Mountain / Deep Rupture, Unbroken Resolve / Measured Weight / Perfect Weight, and Shattering Wake, with modest maximum-posture growth at each Embrace.

**Authority:** `docs/gameplay/RONIN_ASPECT.md`

## 2026-08-07 — Launch Aspect design locked for current scope

Wolf, Wraith, and Ronin each have complete qualitative Tier 0-IV paper-design packages. No Aspect or Tier question remains active unless prototyping reveals a concrete problem.

**Authority:** `docs/_meta/OPEN_QUESTIONS.md`, `docs/gameplay/BLOOD_ASPECTS.md`

## 2026-08-09 — Technique architecture rebuilt around core combat actions

Techniques remain the main horizontal run-build layer, but the four-active-plus-reserve model is removed.

Akio has five direct Technique slots tied to Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow. One direct Technique may occupy each slot; ordinary Techniques do not stack within the same action. Filled slots normally remain committed, with rare replacement offers allowed.

Slotless supporting Techniques can deepen a recurring effect family, create synergy, or improve broader build behavior without a global inventory cap. Slotted Techniques may receive one refinement.

Effect families are internal authoring/build structures rather than necessarily player-facing named schools. Generic elemental schools are not the target.

**Authority:** `docs/gameplay/TECHNIQUES.md`, `docs/gameplay/TECHNIQUE_CATALOG.md`

## 2026-08-09 — Technique families refocused on scalable mechanics

The earlier broad Technique concept pool is no longer treated as the current launch roster. Core family mechanics must be stabilized before supporting, cross-family, Legendary, and refinement content is rebuilt.

Families do not need formal player-facing names; the intended recognition model is symbol, color treatment, effect behavior, VFX, and audio.

The pale-silver family is centered on **echoes**, meaning delayed additional sword slashes rather than Akio literally repeating full actions.

The gold family is centered on **Rupture**. Eligible effects fill an enemy Rupture meter. Partial buildup has no separate effect. Filling the meter triggers a large posture-damage proc, a strong hit reaction where allowed, and a smaller nearby posture shockwave, then resets the meter. The separate `Fracture` term is retired.

**Authority:** `docs/gameplay/TECHNIQUE_CATALOG.md`, `docs/_meta/OPEN_QUESTIONS.md`

## 2026-08-09 — Violet family locked around Seal stacks

The Violet family uses discrete visible **Seal stacks**, not a buildup meter and not posture pressure.

One Seal mildly slows enemy movement. Two Seals strengthen the movement restriction and suppress qualifying movement abilities where applicable. Three Seals complete the pattern and briefly **Bind** the enemy in place. Bind is not a stun: the enemy can still use attacks valid from its current position. When Bind ends, the stacks clear and must be rebuilt.

Seal presentation should visibly progress from individual marks to connected marks to a completed binding pattern. Exact slow strength, duration, expiry, and protected-enemy resistance remain tuning / integration work.

**Authority:** `docs/gameplay/TECHNIQUE_CATALOG.md`, `docs/gameplay/TECHNIQUES.md`

## 2026-08-11 — Ivory-symbol family locked around Rift

The Ivory / blade-circle family now uses **Rift** as its scalable effect. A qualifying Technique creates one visible ivory fracture-line on the enemy and starts a short fuse. The Rift is guaranteed to open for direct Health damage even with only one application.

Further qualifying Rift applications before opening intensify the same visible fracture rather than adding exposed stacks. The mark spreads and becomes more unstable as its eventual burst grows stronger. Rift is intentionally positioned as a strong-upfront, moderate-scaling family rather than another threshold-dependent buildup path.

**Authority:** `docs/gameplay/TECHNIQUE_CATALOG.md`, `docs/gameplay/TECHNIQUES.md`, `docs/art_production/TECHNIQUE_VFX.md`

## 2026-08-11 — Crimson-symbol close-range Burst — superseded 2026-08-12

The Crimson / split-blood-drop family briefly used **Burst**: immediate heavy direct AoE centered on a Burst-ready enemy, followed by per-target recharge accelerated by close-range sword pressure.

That direction was superseded on 2026-08-12 because it overlapped too closely with other direct-damage family behavior and required unnecessary target recharge state.

**Current authority:** `docs/gameplay/TECHNIQUE_CATALOG.md`, `docs/gameplay/TECHNIQUES.md`

## 2026-08-12 — Universal backstab classification and Crimson Vulnerable family

A **backstab** is now a universal positional hit classification for an eligible sword attack that genuinely strikes an enemy from behind relative to current facing. Backstab availability does not require Crimson, stealth, scripted enemy behavior, forced facing, a widened rear arc, or a temporary eligibility window.

Crimson is rebuilt around **Vulnerable**, direct Health damage, and backstab specialization. Vulnerable is a short enemy status that causes genuine backstabs to deal substantially increased Health damage. It does not slow, stun, root, alter facing, suppress movement abilities, or change awareness.

Not every Crimson Technique must apply Vulnerable. Crimson can also use standalone Health damage, bounded AoE, and direct backstab payoffs. Every Crimson direct Technique must remain useful as the player's only Crimson pickup.

The direct Crimson row is approved at qualitative depth:

- **Open Wound — Basic Attack:** qualifying Basic hits apply Vulnerable.
- **Deep Cut — Held Attack:** a genuine Held backstab deals extremely high direct Health damage and partially bypasses defensive mitigation.
- **Blood Arc — Dash:** Dash Attack produces a wide bounded crimson sword arc for direct Health damage and nearby coverage.
- **Exposed Guard — Parry / Counter:** a successful Counter applies Vulnerable.
- **Predator's Wake — Deathblow:** nearby surviving enemies become Vulnerable after the Deathblow resolves.

Brief invisibility / enemy-awareness suppression is reserved for a future Crimson Legendary through the working **Unseen** concept rather than ordinary core Techniques. Exact Legendary behavior remains deferred.

**Authority:** `docs/gameplay/COMBAT.md`, `docs/gameplay/TECHNIQUE_CATALOG.md`, `docs/gameplay/TECHNIQUES.md`, `docs/art_production/TECHNIQUE_VFX.md`

## 2026-08-12 — Five-family matrix remains active design dependency

Echo, Rupture, Seal, Rift, and the redesigned Crimson Vulnerable / direct-Health family are defined at qualitative core-rule depth. Crimson's direct row is complete; Echo, Rupture, Seal, and Rift still require remaining slot approval before the full matrix audit.

Families are allowed to use different buildup structures and different early / late power curves rather than being forced into one standardized stack model.

**Authority:** `docs/_meta/OPEN_QUESTIONS.md`, `docs/gameplay/TECHNIQUE_CATALOG.md`

## 2026-08-09 — Technique reward and Prosthetic boundaries clarified

All Technique reward sources use the same underlying Technique reward screen. Combat rooms are the main source, while shops, treasure, minibosses, and regional bosses may also grant a Technique reward. The source does not inherently force a refinement or other Technique subtype.

Refinements are small improvements to an existing slotted Technique and are not separate Techniques.

Prosthetic Techniques are removed. Prosthetic progression is persistent and belongs to the Forge, with Scrolls as the current Forge currency.

**Authority:** `docs/gameplay/TECHNIQUES.md`, `docs/gameplay/ITEMS_AND_REWARDS.md`, `docs/gameplay/PROSTHETICS.md`
