---
id: META-DOCUMENT-MAP
title: Document Review Map
category: meta
status: approved
authority: summary
last_reviewed: 2026-08-17
topics:
  - dependency-map
  - repository-navigation
  - review-hints
---

# Document Review Map

This is a **non-exhaustive dependency map**. `SOURCE_OF_TRUTH.md` decides ownership. `TERMINOLOGY.md` supplies canonical/deprecated search anchors. Current repository content determines the final review set.

# Gameplay systems

## Combat rule change

**Authority:** `gameplay/COMBAT.md`

Likely dependencies:

- Aspect weapon-kit model + affected Aspect files,
- Akio,
- Techniques / Prosthetics,
- affected enemies/bosses,
- HUD / core VFX,
- animation/technical standards when production changes.

## Blood Aspect / Corruption change

**Authorities:**

- `gameplay/BLOOD_ASPECTS.md`
- `gameplay/ASPECT_WEAPON_KIT_MODEL.md`
- affected `WOLF_ASPECT.md`, `WRAITH_ASPECT.md`, `RONIN_ASPECT.md`
- `gameplay/CORRUPTION_AND_SHRINES.md`

Likely dependencies: Combat, Techniques, Progression, Run Structure, Shrine UI, Blood Mirror/Cavern, Aspect VFX.

## Technique change

**Authorities:**

- `gameplay/TECHNIQUES.md`
- `gameplay/TECHNIQUE_CATALOG.md`

Likely dependencies: Items/Rewards, Technique reward UI, pause/HUD, Technique VFX, affected Aspect/combat interactions.

## Prosthetic change

**Authority:** `gameplay/PROSTHETICS.md`

Likely dependencies: Progression, Items/Rewards for Scroll economy, Forge content/UI, Prosthetic VFX, Milestone 4.

## Relic change

**Authority:** `gameplay/RELICS.md`

Likely dependencies: Progression, Items/Rewards, Forge content/UI, pause/results, item art.

## Reward / currency / boss-material change

**Authorities:**

- `gameplay/ITEMS_AND_REWARDS.md` — payouts/economy/reward rules,
- `gameplay/PROGRESSION.md` — persistence/station/resource ownership.

Search anchors: Mist; Scroll / Scrolls; Gold; regional boss material; boss material / boss drop / boss resource; deprecated `Boss Emblem`.

Likely dependencies:

- affected regional `BOSS.md` files,
- `ui_ux/RUN_RESULTS.md`, HUD/pause if display behavior changes,
- `art_production/ITEM_REWARD_ART.md`,
- Full Game Scope / Roadmap when production shape changes,
- Bloodwell / Forge / Blood Mirror content when a resource becomes spendable there.

## Run structure change

**Authority:** `gameplay/RUN_STRUCTURE.md`

Likely dependencies: Items/Rewards, Room Types, regional overviews, Core Loop, results/Boat/transition presentation, production milestones if room content volume changes.

# Persistent progression / Strand

## Permanent progression ownership or upgrade-tree change

**Authorities:** `gameplay/PROGRESSION.md`, affected Strand interactible file, and the owning gameplay authority for the upgraded system.

Likely dependencies: Items/Rewards, hub UI, asset inventory, Milestone 3/4.

Current station split:

- Bloodwell → Akio + Run Infrastructure,
- Forge Bench → Prosthetics + Relics,
- Blood Mirror → Blood Aspects.

# Content

## Character / enemy / miniboss / boss change

**Authority:** relevant `characters/` or regional `content/area_*` file.

Likely dependencies: regional overview/roster, lore relationships, UI nameplates, VFX/animation requirements, asset inventory, assigned milestone.

## Area / room change

**Authorities:** relevant regional folder + `content/ROOM_TYPES.md` for shared room functions.

Likely dependencies: Run Structure, Items/Rewards, regional environment files, route markers, asset inventory, assigned milestone.

# Story and campaign

## Foundational lore/story change

**Authority:** affected file under `lore/` or `characters/`.

Likely dependencies: Game/Full Scope, Run Structure when campaign flow changes, affected regions/characters, presentation UI, milestones when authored content scope changes.

Approved canon should not be reopened by a dependent summary.

## Narrative delivery change

Lore authorities own facts; presentation files own delivery.

Likely dependencies: first-death/Returning Blood presentation, Shogun dialogue states, NPC/codex/results, ending/credits, Milestones 6–7.

# Release / production

## Postgame or release change

**Authorities:** `gameplay/RUN_STRUCTURE.md`, `content/area_3/TRUE_FINAL_HEART.md`, affected reward/UI files.

Likely dependencies: Heart access, repeat rewards/records, completed-save behavior, Milestones 6–7.

## Art milestone change

**Authority:** relevant `art_production/milestones/MILESTONE_*.md`.

Likely dependencies: Production Roadmap, Asset Inventory, technical standards, and the gameplay/content/UI authorities that created the production requirement.

# New major system or content family

Create one authority with a stable ID, then update only applicable dependencies:

- `SOURCE_OF_TRUTH.md`,
- `TERMINOLOGY.md` if a recurring search term is introduced,
- Full Game Scope / Roadmap if production shape changes,
- Asset Inventory / milestone if new production work is created,
- `OPEN_QUESTIONS.md` only if the new system creates a real unresolved launch decision.

# Reliability rule

The presence of a file here does not require editing it. The absence of a file does not prove it is unaffected. When code search is unavailable, follow the direct-read fallback in `ASSISTANT_WORKFLOW.md` and document that limitation in the PR audit.
