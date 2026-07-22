---
id: META-DOCUMENT-MAP
title: Document Review Map
category: meta
status: approved
authority: summary
last_reviewed: 2026-07-22
---

# Document Review Map

This file provides common dependency starting points. It is non-exhaustive and never replaces live repository search or the ownership registry in `SOURCE_OF_TRUTH.md`.

## Foundational story or lore change

Begin with the relevant authority under `docs/lore/` or `docs/characters/`.

Usually review:

- `overview/GAME_OVERVIEW.md`
- `overview/FULL_GAME_SCOPE.md`
- `lore/STORY_OVERVIEW.md`
- affected character and regional files
- `gameplay/RUN_STRUCTURE.md` when the campaign loop changes
- relevant UI, asset inventory, and milestone files when presentation scope changes
- terminology and current design questions

The core story and lore are currently approved. New questions should not reopen canon unless a genuine contradiction or missing campaign decision is found.

## Combat rule change

Authority:

- `gameplay/COMBAT.md`

Usually review:

- Akio
- affected Techniques and prosthetics
- affected enemies and bosses
- HUD and core VFX
- animation requirements
- technical standards
- asset inventory and assigned milestones

## Blood Aspect or Corruption change

Authorities:

- `gameplay/BLOOD_ASPECTS.md`
- `gameplay/CORRUPTION_AND_SHRINES.md`

Usually review:

- Returning Blood and Akio
- Techniques and shared combat verbs
- progression and run structure
- Shrine ownership and UI
- Blood Aspect VFX
- Blood Mirror and Blood Cavern
- Milestones 2–4

## Technique, prosthetic, Relic, or reward change

Authorities:

- `gameplay/TECHNIQUES.md`
- `gameplay/PROSTHETICS.md`
- `gameplay/ITEMS_AND_REWARDS.md`

Usually review:

- progression and persistence
- room types and route previews
- Technique reward and pause UI
- HUD feedback
- item, Technique, and prosthetic art
- asset inventory
- Milestone 4
- launch run-build content catalog

## Run structure or campaign change

Authorities:

- `gameplay/RUN_STRUCTURE.md`
- `lore/STORY_OVERVIEW.md` for narrative consequences

Usually review:

- game overview and full scope
- Returning Blood
- progression and rewards
- Boat, Keeper, results, and Strand return
- Heart Binding and postgame presentation
- asset inventory and Milestones 3, 6, and 7

The successful-run duration target is approved. Exact room counts, route topology, branch frequency, miniboss frequency, and authored layout counts remain prototype and playtest work unless they create a verified new production package.

## Character, enemy, miniboss, or boss change

Authority:

- recurring named character: `docs/characters/`
- combatant: relevant `docs/content/area_*` file

Usually review:

- lore relationships
- regional overview and roster
- encounter rules
- animation and VFX requirements
- UI nameplates or portraits
- asset inventory
- assigned milestone

Exact timing, tuning, and movesets should remain in the encounter file rather than being added to `OPEN_QUESTIONS.md` unless they change production scope.

## Area or room change

Authorities:

- relevant regional folder
- `content/ROOM_TYPES.md` for shared room functions

Usually review:

- full game scope
- run structure and reward cadence
- regional environment files
- route markers and interaction prompts
- asset inventory
- assigned milestone

Do not treat every possible room-layout or routing choice as a production-scope question. The top-level tracker is updated only when the decision changes required asset families, interfaces, or release content.

## Strand service or persistent-progression change

Authorities:

- `content/strand/INTERACTIBLES.md`
- relevant `content/strand/interactibles/*.md`
- `gameplay/PROGRESSION.md`

Usually review:

- currencies and reward ownership
- Blood Mirror and Blood Cavern
- NPC ownership
- hub UI and Strand HUD
- asset inventory
- Milestone 3
- persistent progression, onboarding, and trial package

## Narrative delivery change

Authorities:

- relevant lore and character files for canon
- relevant UI, content, or milestone file for presentation ownership

Usually review:

- first-death and Returning Blood presentation
- bloodline-confirmation delivery
- Shogun dialogue and reconstruction states
- NPC, codex, results, and Heart-chamber updates
- ending and credits
- portraits, voice, cinematics, and in-engine dialogue
- Milestones 6 and 7
- narrative delivery and authored-content package

Presentation changes should not silently redefine approved story facts.

## Postgame release change

Authorities:

- `gameplay/RUN_STRUCTURE.md`
- `content/area_3/TRUE_FINAL_HEART.md`
- relevant reward, Boat, results, and save-state UI files

Usually review:

- Heart-route access control
- repeat-clear rewards and records
- completed-save behavior
- canonical-versus-repeat presentation
- asset inventory
- Milestones 6 and 7
- postgame release package

Deferred modifiers, enemy variants, room variants, and challenge restrictions remain outside the initial release unless intentionally promoted.

## Art milestone change

Authority:

- relevant `art_production/milestones/MILESTONE_*.md`

Usually review:

- production roadmap
- asset inventory
- technical standards
- outsourcing workflow
- authoritative gameplay, lore, content, and UI files

Milestones summarize what must be produced. They do not own the underlying mechanic or fiction.

## New system, region, or major content family

Create one authoritative file and stable document ID, then update only applicable dependencies:

- `SOURCE_OF_TRUTH.md`
- game overview or full scope
- production roadmap
- asset inventory
- assigned milestone
- terminology
- current design questions when the new content creates a genuine production-scope decision

## Reliability rule

The presence of a file in this map does not mean it must be edited. The absence of a file does not mean it is unaffected. Current repository content and live search determine the actual review set.