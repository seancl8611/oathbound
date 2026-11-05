# Hades combat AI — verified source mechanisms and Oathbound lessons

**Evidence class:** Public mirrors of extracted game Lua; independent design interpretation. Not an official, exhaustive engine specification. Pinned to the commits in [source_manifest.json](source_manifest.json). **Do not copy third-party game code into Oathbound.**

## Hades I — original game

**[EnemyAI.lua, lines 1848–1970](https://github.com/superma58/HadesScripts/blob/073d0797663de6d303b1074925a3429937512d7a/EnemyAI.lua#L1848-L1970):** A shared surround-attacker registry is used with an optional `MaxAttackers` limit. `SurroundAI` checks target distance and the number of registered attackers before allowing another full attack cycle. This directly supports the broader idea of bounded attackers rather than unrestricted independent swings. It does **not** establish that the game uses literal fixed circle slots around every enemy.

**[EnemyAI.lua, lines 729–830](https://github.com/superma58/HadesScripts/blob/073d0797663de6d303b1074925a3429937512d7a/EnemyAI.lua#L729-L830):** `AttackerAI` dispatches to a repeated attacker loop and reads per-weapon behavior. The structure separates *a selected attack definition* from its execution, rather than asking a free-form tactical scorer to reinterpret the whole move during active frames.

**[EnemyAI.lua, lines 85–158](https://github.com/superma58/HadesScripts/blob/073d0797663de6d303b1074925a3429937512d7a/EnemyAI.lua#L85-L158):** Attack functions include a deliberate pre-attack warning and an explicit post-attack cooldown/animation. In Oathbound terms, **tell → committed active frames → recovery** should be a reliable, inspectable action contract.

**[EncounterData.lua](https://github.com/superma58/HadesScripts/blob/073d0797663de6d303b1074925a3429937512d7a/EncounterData.lua)** and **[EnemySets.lua](https://github.com/superma58/HadesScripts/blob/073d0797663de6d303b1074925a3429937512d7a/EnemySets.lua):** Encounter data and enemy group composition are explicitly authored. This is a different design axis from tactical AI. Oathbound already has its own authored Hushiro wave catalog, so changing it should be separate from stabilizing Swordsman movement.

For Wretched Thug, Exalted Longspear and Brightsword comparison, inspect `EnemyData.lua`, `WeaponData.lua` and Elysium room data **together**. Visual observations can suggest behavior, but enemy names and gameplay impressions alone cannot establish exact algorithmic logic. Identify the game's internal enemy/weapon identifiers before making per-archetype claims.

## Hades II — more explicit surround options

**[EnemyAILogic.lua, lines 3282–3379](https://github.com/syslies93/hades2-scripts-mod/blob/48db5c0f05bcab35f40a6f438b32af33febb099e/EnemyAILogic.lua#L3282-L3379):** `SurroundAI` uses a shared per-group attacker registry, an optional `MaxAttackers`, and optional `MaintainSurroundDistance` with `SurroundDistanceBuffer`. It can track an opponent, hold a range, and re-evaluate on a longer refresh interval. These are **configurable branches**, not proof all enemies use every feature.

**[EnemyAILogic.lua, lines 3175–3281](https://github.com/syslies93/hades2-scripts-mod/blob/48db5c0f05bcab35f40a6f438b32af33febb099e/EnemyAILogic.lua#L3175-L3281):** `OrbitAI` has an explicit optional timed orbit duration; “orbiting” need not be an unbounded default locomotion mode. Oathbound's current close circles should instead be limited, intentional flank moves with a destination/expiry.

**[EnemyAILogic.lua, lines 705–830](https://github.com/syslies93/hades2-scripts-mod/blob/48db5c0f05bcab35f40a6f438b32af33febb099e/EnemyAILogic.lua#L705-L830):** `DoAttackerAILoop` delegates to selected attack definitions with action-specific delays and target handling. The combat move has identity and a lifecycle; ordinary steering need not override a committed attack.

**[EnemyData_SatyrSapper.lua, lines 55–75](https://github.com/syslies93/hades2-scripts-mod/blob/48db5c0f05bcab35f40a6f438b32af33febb099e/EnemyData_SatyrSapper.lua#L55-L75):** One Satyr Sapper definition specifically sets `MaxAttackers = 2`. It demonstrates that per-archetype tuning can override global conventions, **not** that all Satyrs share that value.

**[EnemyData_SatyrLancer.lua](https://github.com/syslies93/hades2-scripts-mod/blob/48db5c0f05bcab35f40a6f438b32af33febb099e/EnemyData_SatyrLancer.lua), [SatyrCrossbow](https://github.com/syslies93/hades2-scripts-mod/blob/48db5c0f05bcab35f40a6f438b32af33febb099e/EnemyData_SatyrCrossbow.lua), [SatyrSapper](https://github.com/syslies93/hades2-scripts-mod/blob/48db5c0f05bcab35f40a6f438b32af33febb099e/EnemyData_SatyrSapper.lua):** Separate per-enemy data definitions reinforce **role-specific** combat (melee versus ranged versus area denial); avoid inferring that a single universal AI routine gives all three their identity.

**[EnemyData_TyphonHead.lua](https://github.com/syslies93/hades2-scripts-mod/blob/48db5c0f05bcab35f40a6f438b32af33febb099e/EnemyData_TyphonHead.lua), [TyphonHeadAdd](https://github.com/syslies93/hades2-scripts-mod/blob/48db5c0f05bcab35f40a6f438b32af33febb099e/EnemyData_TyphonHeadAdd.lua):** More elaborate encounter scripts are valuable references for distinctive committed attack phases but **not** an appropriate baseline for every ordinary Swordsman. Do not assume a file named for Typhon precisely identifies the user's described Summit entrance Spawn without additional in-game/source mapping.

**[EncounterData.lua, lines 1–45](https://github.com/syslies93/hades2-scripts-mod/blob/48db5c0f05bcab35f40a6f438b32af33febb099e/EncounterData.lua#L1-L45):** Wave difficulty patterns and spawn interval overrides are data, not emergent ML. Oathbound should retain curated waves and gate the next wave with clearly authored rules.

## Principles we derive — original Oathbound design, not a code port

- **Individually simple:** A Swordsman has a small authored set of eligible attacks with known range/telegraph/recovery.
- **Collectively coordinated:** An encounter chooses how many bodies may be close, while the pressure director controls dangerous simultaneous impact windows.
- **Minimal purposeless locomotion:** Reach a meaningful attack/support position, hold a tolerance band, then strike/recover. No endless circle generated by short-horizon decision scoring.
- **Risk after commitment:** A missed lunge may whiff and enter recovery; do not magnetically follow Akio.
- **Stable animation ownership:** Visual state comes from a single agreed combat/loco state with explicit temporary fallback, not a new AI deciding what sprite plays.
- **Wave design is independent:** Spawn density and pacing are authored encounter data, not a justification for complicated per-enemy tactics.

## Unproven assumptions to avoid

We have **not** established that Supergiant uses one universal melee slot allocator, a hard one-at-a-time policy, particular Godot-compatible coordinates, or identical parameters for the referenced enemy species. The source demonstrates mechanisms, while Oathbound's final behaviors and thresholds remain **our own design decisions**.
