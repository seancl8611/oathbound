# Hades-style Swordsman v1 — owner playtest log review (Nov 5, 2026)

**Status:** Diagnostics / proposed fixes only. **No gameplay change authorized by this review.**  
**Build in uploaded Godot log:** `911904a02aeb154bb94f58c85838b83e4e635c37`.  
**Evidence:** Owner's Godot log `godot(20261105-212116).log`; `combat_1793913464.jsonl` (36.594s, 751 events); `combat_1793913430.jsonl` (95ms session header/summary only, not meaningful gameplay).
**Privacy:** Only summarized metrics and source-code observations are stored here; raw user log files are not copied into this public repository.

## Confirmed improvements

- Owner reports much clearer, more telegraphed Hades-like enemy behavior than V2 scored movement. **Retain the authored movement/coordinator approach.**
- 80 world snapshots contained both Swordsmen; their centers were <35 world units apart in **2/80 (2.5%)** samples. Earlier baseline was ~45% of paired samples, but captures differ. This strongly supports reduced crowding and is **not** a reason to revert to orbit steering.
- 17 `hushiro_surround_role` transitions and 63 `swordsman_hades_state` transitions occurred; those are not all errors—attack/ready/recovery phases are expected.
- No GDScript error appears in the 128-line Godot log. Two warnings concern first-chamber encounter eligibility and fallback to the intended `H02_firing_line` test encounter, not the attack hitbox.

## Critical: Running Swing currently looks and feels unreliable

- **Seven admitted Running Swing attacks** (Swordsman only) at approximately 2.86, 5.14, 9.40, 12.11, 15.45, 19.17 and 23.42 seconds.
- Only **two contact events** identify `running_swing` (6.31 and 10.49 seconds). Some noncontacts are interruptions, and some occur after Akio moves out of reach. Do **not** interpret the 2/7 number as a pure hitbox-spawn failure or force all lunges to hit. Explicit `hitbox_spawned` telemetry does not currently exist.
- First Running Swing began at 2.862s, estimated impact 3.670s but entered actual `ACTIVE` phase only at 4.231s (**+561ms**); Akio had moved away so sampled center-to-center separation at 4.244s was ~87.9 world units. A miss there is geometrically plausible.
- Running Swing admitted→actual ACTIVE offset versus predicted impact on five completed active attacks: **+561, +200, +134, +527, +171 ms** (median ~200ms). Six comparable basic/cross/thrust actions showed about **-1 to +44ms** difference (median ~31ms). This implicates variable approach duration and duplicated assumptions about lunge timing.
- In **two of five** Running Swings with recorded ACTIVE phase, `CombatActionRunner.action_elapsed` had *already exceeded* its defined startup+active+recovery duration upon ACTIVE. The client presentation clamps `action_progress()` at 1.0; its borrowed Quick Slash could already be showing its last frame when the true sword hitbox activates.
- `CorruptedSwordsmanV2Pressure._v2_pressure_request_for_attack` predicts `impact_delay = _calculate_approach_time() + running_telegraph_time`. `CorruptedSwordsmanV2Motion._start_running_swing` starts a runner on the same estimate; however the legacy `_start_running_swing` coroutine approaches until threshold or 1.2s timeout, then waits a *randomized* telegraph duration, then executes. The planned and actual active windows can diverge significantly.
- `CorruptedSwordsmanLegacy._perform_running_swing` calls `_spawn_attack_hitbox` **before** `_lock_attack_facing_toward_player_or_snapshot`. Both the hitbox and the action lunge use separate frozen direction/target mechanisms; verify they share one commitment snapshot, even if the miss is intentional.
- The actual capsule is directional and relatively short (`running_range=65`, centered `0.55 * range` ahead), and player HurtBox has its own extent. Contact at larger center distance is possible, but visual blade tip cannot be inferred from center distance alone.

## Apparent delayed damage: upstream timing, not slow health subtraction

- **17 `contact_resolved` events**: 8 enemy→player and 9 player→enemy. All eight player-health events coincide with contact in the same recorded millisecond; enemy reactions/poise resolution occur within about 1ms of registered contact. The perception of “late damage” is overwhelmingly **before contact**, from attack presentation versus authoritative hitbox activation.
- Akio Quick Slash uses a 44-frame 30 FPS source animation (1.4667s), while the focused gameplay attack reports 0.7667s attack + 0.7s recovery. Keep the source/authoritative hit timeline explicit; don't “fix” delayed damage with damage-value changes or unverified hitbox enlargement.
- Existing `DirectionalActorPresentation._resolve_runtime_contract` reports `state='attack'` as soon as `CombatActionRunner` starts, and the enemy proxy maps **every enemy attack** to the same 44-frame Quick Slash. `_sync_atlas_animation` uses runner `action_progress`, which can clamp at frame 43 before real impact. This is the likely cause of a visual attack appearing before (or after) its actual damaging interval.
- The Swordsman's legacy `AnimationPlayer` still plays `run`, `walk` and optional `attack_windup`, but the actual 2D player-facing presentation hides the legacy body. A legacy telegraph animation is therefore **not automatically visible** on the red Akio proxy.

## Telegraph solution: sprite poses, not an attack indicator

**Requirement:** The player should read the Swordsman's intent from the enemy's body and blade; no gameplay-dependent UI warning circle needed.

1. Keep `Run` during closing approach, not an entire `Quick Slash` played early.
2. For `WINDUP`, use a visually verified **early anticipation pose** or very short pose sequence from the existing eight-direction Akio Quick Slash (prototype only). Hold it for actual authoritative windup duration. It must clearly change sword posture and silhouette; inspect all eight source directions before choosing any frame indices.
3. On actual `ACTIVE`, play only the compatible strike portion of Quick Slash (or phase-sample it) from the beginning of the strike, not from global elapsed action duration; preserve contact readability and don't imply an uncommissioned new Hammer animation.
4. Enter `RECOVERY` with a brief follow-through and then `Idle/Run`, preserving committed facing.
5. Only after testing replace these temporary poses with the commissioned Swordsman's own anticipation/attack/recovery source Actions. Never mistake a borrowed player slash for finished enemy animation.

**Do not suppress the existing indicator automatically if it also carries accessibility/perilous-attack semantics:** first verify which indicator is currently visible and whether it is required for readability, then make the ordinary melee tell body-first.

## Priority engineering plan

**P0 — Instrument before adjusting hitboxes**
- Add `enemy_hitbox_spawned`, `enemy_hitbox_removed`, `enemy_hitbox_contact` or `hitbox_whiff` records with attack instance ID, spawn/despawn time, world origin/dir, center/capsule extents, target center/velocity/position and hitstop/interrupt reason. Use physics-frame timestamps and debug gating.
- For every lunge capture **requested/predicted impact → start actual approach → reach threshold/timeout → windup begin/end → runner ACTIVE → area physics enabled → contact/whiff → recovery**. Include per-direction visual animation/frame and runner progress. This distinguishes genuine missing hitboxes from dodges, facing errors and timing divergence.

**P1 — One timing authority for Running Swing**
- Refactor the running approach into explicit `APPROACH → TELEGRAPH → COMMIT → ACTIVE → RECOVER` phases; derive the pressure reservation/impact time from the actual planned approach and telegraph schedule, and reschedule/revalidate when the approach runs long, or delay pressure reservation until close enough. Do not allow an obsolete reservation to expire before the swing.
- Change `CombatActionRunner` timing updates to track actual phase transitions; don't allow `action_progress=1` while still telegraphing.
- Choose one frozen target vector for hitbox orientation, actor lunge displacement and displayed facing; preserve genuine dodgeable whiffs.

**P2 — Visual-phase contract**
- Add an enemy-proxy-only presentation mapping for `approach`, `windup`, `strike`, `recovery`. Explicitly record chosen 8-direction frame and fallback reason.
- Keep guard/hurt/death fallback to Idle **temporary and diagnostic**, not a sign of engine overload.

**P3 — Tests and real combat acceptance**
- Deterministic tests: stationary player at approach range, moving player/legitimate dodge, melee contact from each of eight directions, two Swordsmen+Archer, parry/interruption, action phase timestamps vs area lifespan, no double damage.
- In playtest, count started/activated/whiffed/interrupted lunges separately. Acceptance must establish **intentional misses** when Akio dodges and **reliable hits** when he remains in range through a clearly visible attack.
- Validate Akio hitbox timing separately from Swordsman, not by increasing damage or enlarging contact areas without geometric review.

## Performance and additional warnings

- 34 performance windows: median FPS **118.5**, minimum **81** in first loading windows. After t=4s, minimum recorded window FPS **104**, median **119**, and **no >33ms frame** in the measured windows.
- Initial loading had two `performance_hitch` entries near t=1.712s (78.31ms) and t=1.992s (58.75ms). Akio atlas import completed in 1395ms at t=3.196s. This does not support combat-specific overload as the main damage-delay cause.
- Second `combat_1793913430.jsonl` is a **95ms empty capture**, not a second combat comparison.

## Where the defects live

- `Regions/Hushiro/Enemies/Legacy/CorruptedSwordsmanLegacy.gd`: running approach/windup/active coroutine, hitbox spawn & origin, target snapshot.
- `Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanV2Motion.gd`: action runner startup and actual phase handoff.
- `Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanV2Pressure.gd`: predicted dangerous impact time and admission.
- `Core/Combat/CombatActionRunner.gd`: planned action progress and phase transitions.
- `Utility/DirectionalActorPresentation.gd` and `Presentation/AkioEnemyVisualProxyProfile.gd`: authoritative attack semantic state, cached animation source, and missing telegraph poses.

**No gameplay code has been changed by this diagnostic note.** The Hades-style movement prototype itself should remain intact while timing and presentation are corrected in a focused follow-up.
