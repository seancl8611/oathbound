# Hades / Hades II enemy AI — Oathbound research library

**Status:** Internal design research, source-pinned November 5, 2026. **Not** a code port, license grant or implementation approval.  
**Owner:** Oathbound enemy-combat design. **Current implementation branch:** `agent/akio-checkpoint-b-playtest`.

## Start here

| File | Use it for |
| --- | --- |
| [SOURCE_RESEARCH.md](SOURCE_RESEARCH.md) | Verified mechanisms in the external Lua mirrors, with pinned line references and original Oathbound takeaways |
| [OATHBOUND_CURRENT_VS_TARGET.md](OATHBOUND_CURRENT_VS_TARGET.md) | Current behavior inventory, keep/adapt/retire decisions, proposed design criteria and owners |
| [KRAKEN_INTEGRATION_PLAN.md](KRAKEN_INTEGRATION_PLAN.md) | Dependency graph, staged engineering migration, rollback and test gates |
| [source_manifest.json](source_manifest.json) | Pinned upstream repo commits, Git blob IDs, source locations and purpose for each of 17 Lua files |
| [fetch_reference_sources.py](fetch_reference_sources.py) | Optional local-only fetch/verify helper for the original scripts |

> **Name note:** The user referred to “Kraken” when describing the planned integration. No existing Kraken system was located in the Oathbound branch. The documents use **Kraken (working label)** for the proposed Hades-inspired enemy behavior cleanup. Do not register a new Godot singleton, plugin or third-party dependency under this name until its concrete scope is decided.

## Why the actual Lua files are not committed

These are third-party copies of Supergiant game scripts. The two discovered GitHub mirror repositories did not advertise an explicit license at the time of review; public GitHub visibility alone does not permit redistribution of the original game code. **Do not vendor the Lua files in this public Oathbound repo or add them to its history.**

This folder permanently stores original research, verified links and a manifest with reproducible commit+blob identities. If you want full source available beside your local Oathbound checkout **for your own reference**, fetch it into this folder's **git-ignored `.local/`** cache. Nothing in the gameplay imports or executes these scripts.

### Local reference commands (in the existing Oathbound checkout)

```sh
python docs/references/hades_ai/fetch_reference_sources.py --list
python docs/references/hades_ai/fetch_reference_sources.py --all
python docs/references/hades_ai/fetch_reference_sources.py --verify
```

Alternatively, fetch only one game with `--game hades_1` or `--game hades_2`. This does not create a second checkout, add backups, or modify Godot gameplay assets. No downloads occur automatically. Hash checks use **Git's blob SHA-1**, including the Git header and NUL separator, not the SHA-1 of raw file bytes.

**Source mirrors (snapshot, not guaranteed canonical or current):**
- **Hades I:** [superma58/HadesScripts at 073d079](https://github.com/superma58/HadesScripts/tree/073d0797663de6d303b1074925a3429937512d7a). Source `EnemyAI.lua`, `EnemyData.lua`, `EncounterData.lua`, `WeaponData.lua`, etc.
- **Hades II:** [syslies93/hades2-scripts-mod at 48db5c0](https://github.com/syslies93/hades2-scripts-mod/tree/48db5c0f05bcab35f40a6f438b32af33febb099e). Source `EnemyAILogic.lua`, per-Satyr data, wave logic, Typhon-related definitions, etc.
- **Supplementary community documentation:** [Hades II Mod Wiki](https://sgg-modding.github.io/Hades2ModWiki/docs/intro). A wiki or mod-loader license does **not** grant permission to relicense Supergiant's extracted scripts.

## How future engineering work should use this library

1. Read [SOURCE_RESEARCH.md](SOURCE_RESEARCH.md); open the **pinned upstream link**, not a floating `main`/`master` URL.
2. Distinguish **observed Lua structure**, **our interpretation**, and **proposed Oathbound rules**.
3. Use the [system inventory](OATHBOUND_CURRENT_VS_TARGET.md) to select one old owner and one replacement/adaptation.
4. Follow [migration gates](KRAKEN_INTEGRATION_PLAN.md); no simultaneous rival decision authorities.
5. Implement **new, original GDScript**. Do not transliterate the Lua, copy animations, exact enemy identity, authored tuning tables or script text.
6. Validate telemetry and visual gameplay; record measured findings in Oathbound's own test documents.

## Copyright, scope, and maintenance

Pinned sources are research snapshots, and mirrors can be incomplete or modified. Cite precise pinned source and line anchor when forming a claim. If a source disappears, the manifest retains its commit/blob identity but does not confer redistribution rights. Future source updates should create an **explicit new manifest revision and new research comparison**, never silently replace the current reference baseline.

This folder is documentation and a local-only research cache, **not a new art milestone, not a game engine module, and not a source of truth for production combat code**.
