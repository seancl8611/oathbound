---
id: OVERVIEW-GAME
title: Oathbound Game Overview
category: overview
status: approved
authority: primary
last_reviewed: 2026-10-29
topics:
  - project-identity
  - combat
  - isometric-2d
  - directional-sprites
  - returning-blood
  - techniques
  - relics
  - blood-aspects
  - progression
  - narrative-delivery
  - silent-protagonist
  - first-attempt
  - authored-encounters
  - enemy-lineage
  - heart-bindings
  - postgame
related:
  - OVERVIEW-DESIGN-PILLARS
  - OVERVIEW-ISOMETRIC-2D-PRESENTATION
  - OVERVIEW-V2-COMBAT-DIRECTION
  - OVERVIEW-FULL-SCOPE
  - OVERVIEW-ENDGAME-POSTGAME-RELEASE
  - GAMEPLAY-COMBAT
  - GAMEPLAY-FIRST-ATTEMPT
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-ITEMS-REWARDS
  - LORE-RETURNING-BLOOD
  - NARRATIVE-DELIVERY
---

# Oathbound Game Overview

Oathbound is a **fixed high-angle/isometric-style 2D action roguelite** built around aggressive katana combat, fast planar movement, authored attack commitment, target switching, spacing, hidden enemy Poise/interruption, kit-specific defense, previewed branching routes, and run-based build progression.

Gameplay authority remains planar 2D. The production presentation uses Camera2D, small screen-space characters, eight-direction actor sprites, feet-based Y depth, layered illustrated environments, and independent 2D VFX/telegraphs. Offline 3D rigs may be used to render directional 2D frames, but source rigs are not live runtime actors.

The game should feel disciplined, dangerous, elegant, cursed, and readable. Player execution and combat clarity take priority over spectacle or automatic build power.

# Premise

Akio is a silent Order swordsman sent to a cursed island beyond a containment barrier. He begins fully human with **no Beast Blood**.

An Order physician fits him with an experimental anti-corruption binding before departure. During an early Hushiro encounter, a serious direct blood-bearing wound infects him despite partial protection. The device begins changing alongside the curse. After his first genuine death, Beast Blood unexpectedly reconstructs Akio while the altered binding helps preserve his human identity. This is **Returning Blood**.

Beast Blood powers the supernatural effects; the device regulates imperfectly; Akio's own identity and discipline shape his emerging control. Exact mechanics remain mysterious.

# Core player fantasy

Akio remains a swordsman first. Blood Aspects reshape the weapon kit, Techniques customize current sword actions and supporting synergies, Prosthetics provide one equipped tactical tool, and Relics provide a smaller run-wide support effect.

The build should strengthen decisions the player already makes—timing, spacing, movement, attack commitment, target selection, selective kit-specific defense, rear positioning, and resource use—rather than replace combat fundamentals.

Akio never speaks, supplies dialogue choices, or uses internal monologue. NPCs, intelligent enemies, and bosses carry spoken/written dialogue; Akio is characterized through action, stillness, physical reaction, and refusal.

# First attempt

The player begins with a concise Strand physician preparation beat, then the normal Hushiro Floor 1 route. Akio has ordinary human combat abilities until first genuine death and awakening.

There is no compulsory opening Shogun fight or Shogun-caused exposure. A no-death mastery player cannot break a Heart Binding or skip the six-Binding campaign before awakening. `FIRST_ATTEMPT.md` owns the details.

# Returning Blood and the Strand

Returning Blood increasingly responds to Akio's conscious intention while he is alive. When he dies, conscious control disappears and the Blood falls back on his strongest survival instinct: return somewhere safe.

The Strand is the safest place Akio knows during the expedition. His first reconstruction occurs at one specific safe location there, and that successful return reinforces the same location as his subconscious destination for later deaths.

The Strand itself is **not** a magical resurrection anchor. The Keeper, Boat, Bloodwell, Order warding, seals, and oaths do not create the return point.

# Beast Blood and bearer identity

Beast Blood is a supernatural curse rather than a rigid biological infection model.

Some exposed people die. Some become beasts. Some retain more memory, intelligence, discipline, or identity. Some become unusually powerful or specialized forms.

The Blood appears to work with what it finds in the bearer. Resolve can support greater control, but willpower alone does not explain Akio. Greed, obsession, rage, lust, jealousy, fear, grief, loneliness, pride, hunger, devotion, and other strong drives may be magnified or physically expressed by the curse.

Akio and the Shogun are thematic parallels: both have exceptional resolve, but their identities and intentions shape very different relationships with the same Blood.

# The Shogun's experiments

The Shogun can direct ordinary Beast Blood through his exceptional Heart connection and may have experimented on selected **other** bearers. He did not infect Akio or produce his protective binding.

When he later encounters Akio's unusual degree of control, his curiosity grows into fascination, attempted recruitment, then fear and hatred as Akio opposes the Heart.

# Current gameplay shape

- Returning Blood awakens after the first genuine death following direct Hushiro exposure and begins the repeated-run progression loop.
- Shared combat uses **player Health + mobility + kit-specific/selective defense**.
- Standard enemies use **Health + hidden Poise/interruption**. Health is the normal defeat condition.
- Ronin retains its authored **guard / Reprisal** identity; the shared combat model does not assume every Aspect exposes the same timed defensive action.
- Bosses/minibosses may use bespoke stagger, vulnerability, armor, or phase-transition states when their encounter calls for them.
- Runtime combat authority remains planar 2D while presentation uses the approved high-angle/isometric-style Camera2D composition.
- Launch Blood Aspects: **Wolf, Wraith, Ronin**.
- Every post-awakening normal run begins at Aspect Tier 0; optional Shrine Resist/Embrace progression reaches Tier IV maximum.
- Blood/Blood Art becomes available only from Tier II onward.
- Techniques have **no inventory slots and no global inventory cap**. The active catalog currently contains **40 Techniques + 6 refinements** after reconciliation with Combat V2's supported shared triggers.
- The five Technique families remain **Echo, Rupture, Seal, Rift, and Crimson**.
- One equipped Prosthetic from an eight-tool roster with 19 permanent Forge upgrades.
- One equipped Relic from a 10-item persistent collection with **Base → Mastery I → Mastery II** use-based progression.
- Relic acquisition uses 4 campaign/Strand + 2 Blood Cavern/challenge + 4 run-discovered unlocks, with limited regional-transition swapping.
- No general launch consumable inventory or one-use item reward layer.

# Permanent progression shape

Permanent progression is intentionally compact and supports execution rather than replacing it.

- **Bloodwell:** 10 Akio nodes + 8 Run Infrastructure nodes. Akio nodes support Health, Spirit, recovery, and reliability.
- **Forge Bench:** 19 Prosthetic upgrades + 20 Relic mastery milestones across 10 Relics.
- **Blood Mirror:** 3 nodes per Aspect / 9 total, focused on Tier 0 Handling, Signature Reliability, and Blood Discipline.
- **Boss materials:** exactly six Bloodwell gates at launch—one Akio mastery node and one regional-passage Infrastructure node per regional boss material.

Unlock cadence:

- first return → Bloodwell foundation,
- first Keeper → second Bloodwell band + Blood Mirror Node 1,
- first Twin Maws → third band + Blood Mirror Node 2,
- first post-awakening Shogun / first Binding clear → final boss-material gates + Blood Mirror Node 3.

All foundational permanent progression systems are structurally available after the first Binding clear; later Binding clears emphasize completion, mastery, Relic collection, Prosthetic development, trials, and player consistency rather than introducing another meta tree.

# Persistent progression economy

Oathbound keeps the permanent resource model deliberately small:

- **Mist** — broad persistent meta progression,
- **Scrolls** — primarily Prosthetic Forge progression,
- **three regional boss materials** — one unique low-count material from Keeper, Twin Maws, and Eclipse Shogun, used on the six approved Bloodwell mastery gates,
- **Gold** — run-only Shop economy.

There is no generic Boss Emblem currency.

# Run structure

The approved post-awakening launch regional route contains **33 counted chambers**:

- **Hushiro Gate Village:** 12 chambers, Keeper of the Gate at 12, ~14–16 active minutes.
- **Yomori Grove:** 10 chambers, Twin Maws at 10, ~12–14 minutes.
- **Kagutsuchi Court:** 11 chambers, Eclipse Shogun at 11, ~15–17 minutes.

Each region offers one optional miniboss opportunity from two authored candidates. Branches preview room/reward information, normally offer one or two exits, and may reconverge without routine backtracking.

Standard Combat rooms use **deliberately authored encounter scripts**. When a Combat chamber is selected, the game chooses an eligible encounter from that region's authored pool rather than procedurally constructing an enemy mix from a threat budget.

Standard enemies are region-native by default. The approved launch cross-region lineage is **Blighted Hounds → Stalker Hound** in Yomori Grove; Kagutsuchi's standard enemies remain native Court units.

The first attempt begins on the normal Hushiro route; it has pre-awakening restrictions rather than a separate mandatory Shogun prologue.

# Campaign structure

The Heart was imprisoned by seven ancient Bindings. The Court destroyed the outermost before the game, leaving six intact.

After Returning Blood awakens, each of the first six successful Binding runs has Akio defeat the Eclipse Shogun, reach the Heart, use Returning Blood through the Court's extraction apparatus, break one remaining Binding, be destroyed by the Heart, and subconsciously reconstruct at the Strand.

The same ritual uses six escalating visual/campaign states rather than six different mechanisms or missions.

The Shogun relationship begins with **discovery** of Akio's unusual control and develops through fascination → recruitment → possessive anger → fear → hatred/desperation → final confrontation. Akio remains silent.

After all six remaining Bindings are destroyed, the final story run continues directly from the Shogun into the true-final Heart encounter with the same active build.

The first Heart victory does not erase existing Beast Blood. Akio destroys the Heart's manifested body and permanently removes its ability to produce, release, or spread new Beast Blood. Existing bearers—including Akio and the Shogun—retain their established Blood and reconstruction.

The main story ends because the curse can no longer expand to anyone new or threaten the mainland through propagation.

# Narrative production shape

The launch narrative package remains intentionally bounded:

- silent Akio with zero dialogue/choice/internal-monologue content,
- a physician fitting, direct early island exposure and first-death reconstruction sequence,
- a first Strand reconstruction/reaction sequence,
- recurring post-return Shogun confrontation states following fascination → recognition/recruitment → anger/fear/hatred,
- **6 visual states** of one reusable Binding ritual,
- approximately **30–36 major Strand conversations**,
- approximately **4–6 short reactive line sets per Strand NPC**,
- approximately **20–25 substantive Lore / Records entries** beyond normal gameplay-codex descriptions,
- one final pre-Heart conversation/state for each Strand NPC,
- one concise post-ending Heart-regrowth/suppression explanation,
- text-led dialogue with **no full spoken-dialogue VO requirement**.

Mandatory campaign information is communicated directly; the Discovery Board carries optional historical depth rather than required plot comprehension.

The physician researches the altered protective binding and oversees Bloodwell progression fiction. The Scribe independently records history, discoveries and the human implications of Returning Blood; neither provides a definitive scientific explanation.

# Canonical postgame

After Story Complete, Akio canonically continues containment work on the island.

The Boat offers:

- **Standard Expedition** — ends after the Shogun,
- **Heart Suppression** — continues from the Shogun into the Heart's regenerated manifestation.

Postgame uses existing progression/mastery systems rather than adding another currency/tree. Launch does not require Heat/Pact-style modifiers, New Game+, endless mode, daily challenges, a fourth Aspect, or another postgame progression layer.

# World structure

- **The Strand** — persistent hub, preparation, progression, and Akio's subconsciously selected return point.
- **Hushiro Gate Village / Rupture** — recent human/community collapse.
- **Yomori Grove / Adaptation** — long-term predator/spirit consequences; includes Stalker Hound as an evolved continuation of the earlier hound lineage.
- **Kagutsuchi Court / False Ascendancy** — disciplined elite mutation mistaken for mastery; uses its own Court roster.
- **Heart spaces** — specialized post-Shogun campaign/endgame content outside the 33 counted regional chambers.

# Current design focus

Oathbound's launch gameplay architecture is substantially defined. Current work is focused on convergence and production proof rather than reopening broad architecture.

Current priorities include Combat V2 reconciliation, player-facing stability/readability, Hushiro isometric 2D validation, Akio and representative-enemy rig-rendered directional proofs, playtest-driven tuning, final production replacement/polish, true-final Heart combat design, and release QA.

# Source links

- [Design pillars](DESIGN_PILLARS.md)
- [Combat V2 direction](V2_COMBAT_DIRECTION.md)
- [Isometric 2D presentation direction](ISOMETRIC_2D_PRESENTATION_DIRECTION.md)
- [Rig-rendered 2D pipeline](../art_production/RIG_RENDERED_2D_PIPELINE.md)
- [Full game scope](FULL_GAME_SCOPE.md)
- [Production roadmap](PRODUCTION_ROADMAP.md)
- [First attempt](../gameplay/FIRST_ATTEMPT.md)
- [Run structure](../gameplay/RUN_STRUCTURE.md)
- [Returning Blood](../lore/RETURNING_BLOOD.md)
- [Beast Blood](../lore/BEAST_BLOOD.md)
- [Narrative delivery](../narrative/NARRATIVE_DELIVERY.md)
