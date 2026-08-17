---
id: META-DECISION-LOG
title: Decision Log
category: meta
status: approved
authority: summary
last_reviewed: 2026-08-16
---

# Decision Log

This is a concise index of major approved directions that materially changed Oathbound's scope or identity. Complete rules live in authoritative files; superseded wording is recoverable through Git history.

## 2026-08-16 — Area 1 and Area 2 prototype run structure locked

Oathbound's regional run routing now uses a Hades-like model of broadly fixed regional length, fixed boss destinations, previewed route choices, chamber-index eligibility bands, weighted procedural contents, and hard opportunity safeguards.

**Hushiro Gate Village** uses 12 counted chambers: opening Chambers 1–3, main Chambers 4–8, pre-boss Chambers 9–11, and Keeper of the Gate at Chamber 12. Chamber 1 is fixed combat followed by a Technique reward. One optional miniboss opportunity appears during Chambers 5–8 and selects Village Ogre or The Collector for that run. The generated route network contains at least one Shrine, Shop, Rest, miniboss opportunity, and three Technique-reward opportunities total including Chamber 1. Current active-time target: approximately 14–16 minutes.

**Yomori Grove** uses 10 counted chambers: opening Chambers 1–2, main Chambers 3–7, pre-boss Chambers 8–9, and Twin Maws at Chamber 10. Branching begins immediately without a forced Chamber 1 Technique reward. One optional miniboss opportunity appears during Chambers 4–7 and selects The Embered Pilgrim or Rotwood Host for that run. The route network contains at least one Shrine, Shop, Rest, miniboss opportunity, and two Technique-reward opportunities. Current active-time target: approximately 12–14 minutes.

Guaranteed opportunities exist in the generated route network but are not mandatory visits. Keeper and Twin Maws each lead to a brief safe regional transition space that is not counted as an additional chamber. Exact room/reward percentage weights, branch frequency, encounter compositions, transition values, and Area 3's chamber budget remain later integration/playtest work.

The major-system production-scope audit is treated as complete. The next regional run-design task is Kagutsuchi at the same structural depth, followed by validation of the complete three-region 45–50-minute route.

**Authority:** `docs/gameplay/RUN_STRUCTURE.md`, `docs/content/ROOM_TYPES.md`, `docs/gameplay/ITEMS_AND_REWARDS.md`

## 2026-08-16 — Permanent progression station architecture locked

Oathbound uses three permanent upgrade stations at current launch scope:

- **Bloodwell:** permanent progression for **Akio** and one combined **Run Infrastructure** system.
- **Forge Bench:** permanent progression and Strand-side management for **Prosthetics and Relics**.
- **Blood Mirror:** permanent progression for **Blood Aspects**; the Mirror begins locked and becomes available later through campaign/onboarding progression.

Run Infrastructure is one umbrella for approved permanent improvements to Rest support, Shrine support, rewards, routing/run conditions, regional-transition support, and related expedition support. These are not separate permanent upgrade trees.

Relics retain kill-earned individual mastery while equipped even though their Strand progression/management now belongs to the Forge. Sharing the Forge does not require Relics to use the same currency or linear progression as Prosthetics.

The separate Relic Reliquary direction, the older generic weapon-development/weapon-socket Forge model, and the fixed Bloodwell `Way of Steel / Way of Secrets / Way of Vows` structure are no longer current scope. Exact upgrade nodes, values, rank counts, costs, mastery thresholds, and precise Blood Mirror unlock timing remain deferred.

The next top-level design task at this decision point was a **major-system production-scope audit**, not detailed permanent-upgrade design. That audit has since been completed and run integration is now active.

**Authority:** `docs/gameplay/PROGRESSION.md`, `docs/content/strand/INTERACTIBLES.md`, `docs/content/strand/interactibles/BLOODWELL.md`, `docs/content/strand/interactibles/FORGE_BENCH.md`, `docs/content/strand/interactibles/BLOOD_CAVERN.md`

## 2026-08-15 — Relic mastery and Prosthetic Forge progression locked

Relics gain persistent individual mastery from eligible enemy kills while equipped; only the currently equipped Relic advances. Mastery strengthens the existing Relic benefit rather than adding unrelated mechanics.

The eight launch Prosthetics receive shallow linear permanent Forge paths. A Prosthetic is functionally complete when unlocked; two upgrades are the default and a third is used only where the base tool already has another meaningful existing property to improve. The locked launch roster contains 19 permanent Prosthetic upgrades across the eight tools. Scrolls remain the primary persistent currency for Prosthetic development.

Prosthetic Techniques remain removed from the run-build system.

**Authority:** `docs/gameplay/RELICS.md`, `docs/gameplay/PROSTHETICS.md`, `docs/gameplay/PROGRESSION.md`

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

A normal successful Binding run targets roughly 45-50 minutes. Exact room counts, topology, branch frequency, and encounter budgets were originally left to prototype/playtest work; Hushiro and Yomori prototype chamber budgets were later approved on 2026-08-16.

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

The direct Crimson row is approved at qualitative depth: Open Wound, Deep Cut, Blood Arc, Exposed Guard, and Predator's Wake.

**Authority:** `docs/gameplay/COMBAT.md`, `docs/gameplay/TECHNIQUE_CATALOG.md`, `docs/gameplay/TECHNIQUES.md`, `docs/art_production/TECHNIQUE_VFX.md`

## 2026-08-12 — Five-family matrix dependency — superseded 2026-08-13

At this point Echo, Rupture, Seal, Rift, and Crimson were defined at qualitative core-rule depth, but the full direct matrix remained incomplete. That dependency was closed on 2026-08-13.

**Current authority:** `docs/gameplay/TECHNIQUE_CATALOG.md`

## 2026-08-13 — Direct five-by-five Technique matrix locked

All 25 direct slotted Techniques are approved at qualitative paper-design depth: one Technique for each of the five combat slots in each of the five families. The direct matrix is no longer an active content-design dependency.

**Authority:** `docs/gameplay/TECHNIQUE_CATALOG.md`, `docs/gameplay/TECHNIQUES.md`

## 2026-08-14 — 50-Technique working roster, rarity, and eligibility locked

The current working launch Technique roster is **50 actual Techniques plus 10 refinements**: 25 direct, 15 same-family Supporting, 5 Cross-family, and 5 Legendary Techniques.

The rarity distribution is **10 Common / 18 Uncommon / 17 Rare / 5 Legendary**. Refinements have no rarity.

Direct Techniques require only an empty relevant combat slot and can be the player's first pickup from a family regardless of rarity. Supporting Techniques require an already-owned effect that can actually use them. Cross-family Techniques require investment in both listed families plus any entry-specific mechanic requirement.

A Legendary requires **3 native Techniques from its family, including at least 1 slotted Technique**. Same-family Supporting Techniques count toward the three; Cross-family Techniques and refinements do not. Individual Legendaries may impose a mechanic-specific requirement so the capstone cannot appear in a build unable to use it.

The current Technique content roster should remain stable unless audit or prototyping identifies a concrete problem. The next Technique-system decisions are reward frequency, offer-generation order, rarity probabilities/source weighting, rare replacement behavior, and full-roster validation.

**Authority:** `docs/gameplay/TECHNIQUE_CATALOG.md`, `docs/gameplay/TECHNIQUES.md`, `docs/_meta/OPEN_QUESTIONS.md`

## 2026-08-09 — Technique reward and Prosthetic boundaries clarified

All Technique reward sources use the same underlying Technique reward screen. Combat rooms are the main source, while shops, treasure, minibosses, and regional bosses may also grant a Technique reward. The source does not inherently force a refinement or other Technique subtype.

Refinements are small improvements to an existing slotted Technique and are not separate Techniques.

Prosthetic Techniques are removed. Prosthetic progression is persistent and belongs to the Forge, with Scrolls as the current Forge currency.

**Authority:** `docs/gameplay/TECHNIQUES.md`, `docs/gameplay/ITEMS_AND_REWARDS.md`, `docs/gameplay/PROSTHETICS.md`
