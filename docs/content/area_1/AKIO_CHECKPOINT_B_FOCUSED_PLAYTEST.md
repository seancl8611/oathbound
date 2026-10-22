# Akio Checkpoint B — Focused Playtest

## Where to find it

In a Godot debug playtest, enter Hushiro and press the backtick key to open **Oathbound Playtest Lab**. Open the **Focused Tests** tab. The lab pauses gameplay while open.

### Mode A — Quick Slash-only gameplay

Select **Akio Checkpoint B - Quick Slash only** from the scenario dropdown, then close the lab with backtick. With the default base katana (no selected Blood Aspect), regular tap and hold releases produce only Quick Slash. Cross Cut/Heavy Cleave and their queued branches are bypassed for this debug scenario.

- Existing Quick Slash duration, startup, active hitbox, recovery, damage, aim and movement remain unchanged.
- The ordinary three-hit/six-hit combo system is not deleted or retuned. Select **Normal combat** to restore it.
- Switching scenarios resets only transient combo/queue state.
- The **Record focused animation frames in combat telemetry** checkbox records actual presentation-frame changes and authoritative hitbox edges into the existing combat JSONL capture. No per-frame hitbox scans.
- The scenario is session-only, defaults to Normal on the next launch, and does not operate in non-debug builds.
- Selecting a Blood Aspect leaves that aspect's gameplay untouched.

### Mode B — Original source animation (30 FPS; no combat)

Keep the lab open and enable **Play source animation at 30 FPS (while lab is open)**.

- Choose attack_quick_slash, move or idle and one of E, SE, S, SW, W, NW, N, NE.
- A cropped preview viewport plays the delivered PNG sequence at 30 FPS independently of player state, attack hitbox, CombatActionRunner and combos.
- The source preview runs with either gameplay scenario selected, but only while the lab is visible and the game is paused.
- Quick Slash loops 41 frames; Run loops 16 frames; Idle loops 40 frames. The preview does not alter assets or create copies.
- If frames are not ready, close the lab briefly after entering Hushiro to allow the 776-frame atlas to load, then reopen it.

## Recommended comparison

1. Preview all eight directional Quick Slash clips at original 30 FPS.
2. Select Quick Slash-only gameplay with frame diagnostics, then close the lab.
3. Attack in all eight directions, allowing each attack to complete.
4. Compare presented frame progression and hitbox edges from the existing combat JSONL against the source preview. Do not classify frame skipping or authored recovery as bugs without design context.
5. Switch to Normal combat when finished.

## Diagnostic event names

- focused_test_scenario_changed: scenario selection.
- akio_focus_attack_started: attack sequence number, authored timing and aim.
- akio_focus_hitbox_edge: actual hitbox enabled/disabled and attack elapsed time.
- akio_focus_visual_frame: displayed frame, direction, animation, phase/progress and hitbox state.
- akio_focus_visual_exit: attack presentation returned to a non-attack state.

Events share the existing t_ms and physics_frame fields. Source preview is independent and does not count as a combat attack.

## Architecture

The reusable scenario selector and paused preview extend the existing Playtest Lab autoload chain, not a separate application. The canonical player has a debug-only Quick Slash selection seam and the directional presenter adds gated frame-change telemetry. Existing attack definitions, timing and combo rules remain unchanged.

The first scenario ID is akio_checkpoint_b_quick_slash. The same Playtest Lab scenario pattern can support later enemy or animation checkpoints without permanent one-off controls.
