# Oathbound Agent Engineering Guardrails

These instructions apply to every coding agent or assistant modifying this repository. Read them before changing Godot scripts, scenes, project settings, combat runtime, or playtest tooling.

## Canonical project

- The active Godot project is `game/oathbound/`.
- The pinned engine baseline is **Godot 4.7.2**. Do not assume behavior from older Godot 4.x releases is accepted by 4.7.2.
- Approved gameplay documentation is the design authority. Imported/legacy code is compatibility plumbing only when a current Oathbound layer still depends on it.
- Prefer coherent dependency-sized implementation batches and longer telemetry-backed playtests, but never trade compile/runtime correctness for change volume.

## Mandatory pre-handoff validation

Before asking Sean to pull/playtest a branch that changes Godot code:

1. The branch must pass `.github/workflows/godot-project-check.yml` on Godot 4.7.2.
2. The check must complete both a clean headless import and editor project load/compile.
3. Inspect the intended runtime ownership, not only whether files compile. If a new Player/controller/service is supposed to be active, add/verify a runtime marker or telemetry field proving that exact script/service is instantiated.
4. For combat changes, verify telemetry can distinguish the changed behavior (for example `block_success`, posture delta/break, Deathblow-ready entry, active Player script).
5. Do not tell Sean a branch is ready merely because GitHub reports it mergeable.

If CI is unavailable, say so explicitly and do not present static inspection as equivalent to a Godot runtime/compile check.

## GDScript 4.7.2 parser rules that have already broken playtests

- Treat `Cannot infer the type of ...` as a **hard parser error**. A warning setting cannot fix it.
- Explicitly type locals whose value originates from a `Variant`, `Dictionary.get()`, untyped inherited property/method, conditional expression, generic Array/Dictionary indexing, or other ambiguous expression. Examples: `var index: int = ...`, `var value: float = ...`, `var active: bool = ...`, `var profile: Dictionary = ...`.
- `debug/gdscript/warnings/inference_on_variant` may remain a warning, but do not use warning suppression to hide actual parser/type errors.
- When adding inheritance layers, compile the parent first. `Could not resolve class "res://..."` is commonly a downstream symptom of a parser error in the parent script; fix the first/root parser failure before rewriting the child.
- Avoid introducing a large new script with many untyped `:=` declarations and waiting for Sean's editor to discover them. Type risky values proactively and let CI parse the entire project.

## Godot physics/signal mutation rules

- Do not synchronously change `Area2D.monitoring`, `Area2D.monitorable`, collision-shape disabled state, or similar physics registration properties from `area_entered`, `area_exited`, body/contact callbacks, parry callbacks reached from them, or other active physics signal traversal.
- Use `set_deferred(...)`, `call_deferred(...)`, or another safe post-signal teardown path. The known failure text is `Function blocked during in/out signal. Use set_deferred(...)`.
- When freeing attack/hurt areas from a contact callback, mark them consumed immediately, defer monitoring/monitorable changes, then defer `queue_free()`.

## Runtime ownership / factory rules

- Never assume an autoload override owns a runtime object merely because the override compiled. Trace every creation path.
- There must be one canonical Player creation path. Run scenes must not silently hard-code `res://Player/player.tscn` while a newer factory/autoload intends to spawn another Player scene.
- After changing Player/controller ownership, verify telemetry/world samples report the intended script path. A successful compile with the old Player still instantiated is a failed integration.
- Apply the same rule to Technique, Aspect, Prosthetic, enemy, reward, and route authorities: validate the live caller path, not just the new file's existence.

## Combat contract guardrails

- Direct canonical sword contacts use the canonical AttackEvent fields (`health_damage`, `posture_damage`, `block_posture_damage`, etc.). Do not let an imported damage-type table apply a second independent posture/damage scaling pass to the same current contact.
- For a canonical contact, record/verify **authored posture**, **actual applied posture delta**, and whether the hit entered posture break. Recovery between contacts must not be confused with per-hit scaling.
- Enemy posture break is a real shared state, not merely a full posture bar. While broken, an enemy must stop ordinary offense and expose a Deathblow-ready query/cue for the approved duration.
- Do not hard-code an enemy family such as beasts to `is_deathblow_ready() == false` when the shared combat contract permits posture Deathblows.
- Child hurt/stagger reactions must not overwrite a shared posture-break/Deathblow-ready state with a shorter ordinary hurt reaction.
- Sustained block is directional but must use current defensive aim/facing, not stale movement facing. A playtest that enters BLOCKING but produces only `block_failed_outside_arc` is not a functioning block implementation.
- Parry, block, posture break, Deathblow readiness, and execution must remain shared across Wolf/Wraith/Ronin unless approved documentation explicitly says otherwise.

## Godot resource/import rules

- `.godot/` and `.import/` are generated local caches and stay untracked.
- Before concluding an asset is missing, verify the source file exists in Git and compare with a clean CI import. Invalid/stale UID warnings may fall back to the text path even when the PNG exists.
- Prefer repairing stale scene UID/resource references when practical, but do not delete source textures to silence import warnings.

## Playtest handoff standard

A playtest handoff should name:

- the exact branch;
- the expected current head SHA when useful;
- the expected active runtime marker/script (especially Player/controller changes);
- the meaningful systems the longer run should exercise;
- the telemetry/log file(s) to return.

When a playtest reports several defects, inspect the whole telemetry capture and group related fixes into the next coherent stabilization batch rather than returning to one-error-at-a-time trial and error.
