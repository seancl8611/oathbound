---
id: RELEASE-ATTRIBUTION-AUDIT
title: Release Attribution Audit
category: external
status: working
authority: secondary
last_reviewed: 2026-08-25
---

# Release Attribution Audit

This document is an evidence checklist for Oathbound's credits, legal notices, licensed assets, and third-party attribution. It is intentionally **not** a finished credits/legal document.

The release UI must not invent contributor names, asset ownership, license terms, or required notices. A release-facing credit or legal notice should only be promoted from this audit after its source/provenance is verified.

## Current verified repository evidence

### Font

Repository asset:

- `game/oathbound/Font/tenderness.otf`

The current `Font/` directory contains the font and its Godot import file, but no adjacent license, source record, author record, purchase receipt, attribution text, or redistribution terms were found in the repository during the 2026-08-24 audit.

**Release status:** BLOCKED pending provenance/license evidence.

Required evidence before shipping:

- font source / creator;
- exact license or purchase terms;
- confirmation that redistribution inside the game build is permitted;
- any required attribution wording;
- retained copy or durable reference to the license evidence.

### Music

Repository asset:

- `game/oathbound/Audio/Music/battleThemeA.mp3`

The current Music tree contains `battleThemeA.mp3`, its Godot import file, and `snd_Music.gd`; no license or attribution record was found alongside them during the 2026-08-24 audit.

**Release status:** BLOCKED pending provenance/license evidence.

Required evidence before shipping:

- track title/source/creator;
- ownership or exact license terms;
- permission for commercial game distribution where applicable;
- any required attribution wording;
- retained copy or durable reference to the license evidence.

### GUI audio inventory

The following non-import source files are currently present under `game/oathbound/Audio/GUI/`:

- `game/oathbound/Audio/GUI/click.wav`
- `game/oathbound/Audio/GUI/hover.wav`

Their adjacent `.import` files establish that they are Godot-imported assets but do not establish creator, source, ownership, license, commercial-use permission, redistribution permission, or required attribution.

**Release status:** BLOCKED pending provenance/license evidence for each source audio file.

### Sound-effect inventory

The repository inventory reviewed on 2026-08-25 includes at least the following non-import source files under `game/oathbound/Audio/SoundEffect/`:

- `game/oathbound/Audio/SoundEffect/Lose.ogg`
- `game/oathbound/Audio/SoundEffect/Victory.wav`
- `game/oathbound/Audio/SoundEffect/collectgem.mp3`
- `game/oathbound/Audio/SoundEffect/enemy_death.ogg`
- `game/oathbound/Audio/SoundEffect/enemy_hit.ogg`
- `game/oathbound/Audio/SoundEffect/ice.wav`

This list records the concrete files observed during the repository audit; it is not yet asserted to be the complete SoundEffect tree. Their Godot `.import` files are build metadata only and are not provenance/license evidence.

**Release status:** BLOCKED pending asset-by-asset provenance/license evidence.

For each listed GUI/SFX source file, verify:

- source asset/title and creator/vendor;
- source location or purchase record;
- exact license/version or ownership evidence;
- commercial-use permission;
- modification permission where relevant;
- redistribution permission in the game build;
- required attribution/notice text;
- retained evidence location and verification date.

## Remaining inventory work

The following repository areas still require additional asset-by-asset provenance review before credits/legal can be considered release-complete:

- the remainder of `game/oathbound/Audio/SoundEffect/` beyond the concrete files enumerated above;
- `game/oathbound/Textures/`;
- imported visual/UI assets outside `Textures/`;
- any external shaders, code snippets, plugins, or tools that are redistributed with the build;
- store/platform art and marketing assets when those are added.

For each externally sourced item, record:

1. repository path;
2. asset/source name;
3. creator/vendor;
4. source location or purchase record;
5. license type/version;
6. commercial-use permission;
7. modification permission if relevant;
8. redistribution permission;
9. required credit/notice text;
10. verification date and evidence location.

## Contributor credits

Repository history alone is not sufficient authority for final in-game contributor credits. Commit authorship can include tooling, automation, temporary contributors, imported history, or accounts whose preferred credit name is unknown.

Before final credits are authored, maintain a verified contributor roster containing:

- preferred credited name;
- contribution role/category;
- explicit inclusion/credit preference where needed;
- any studio/vendor relationship that changes how the credit should be presented.

## Engine and third-party notices

Before release packaging, verify the notices required by the exact Godot version and any redistributed third-party libraries/plugins actually present in the exported build. Do not copy generic notice text into Oathbound until the shipped dependency set is known.

## Exit condition

Credits/legal are ready to leave this audit state only when:

- every shipped externally sourced asset has provenance and license evidence;
- all required attribution/legal text is known verbatim from its authoritative source;
- the contributor roster is verified;
- the exported dependency set has been checked for required notices;
- the in-game Credits/legal surface consumes only verified entries;
- a release QA pass confirms required notices are present in the final package.

Until those conditions are met, the front-end Credits entry may exist as a release-shell navigation surface, but its final legal/attribution content remains intentionally incomplete.
