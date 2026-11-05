# Temporary Akio visual proxy — Corrupted Swordsman pipeline test

**Scope:** Debug-only Hushiro art integration experiment. It does **not** authorize a new artist commission, change any enemy gameplay, or imply the Corrupted Swordsman has finished art.

## Goal

Reuse the accepted *candidate* Akio Proof A 2D prerenders to preview a rig-rendered humanoid enemy while Hammer's Proof A remains under review. This makes it possible to investigate 8-direction animation switching, contact registration, sprite depth, hit readability, relative player/enemy scale, texture loading under multiple actors, and future enemy replacement before receiving commissioned enemy source. **This is NOT a live 3D model rendered by Godot.** As with Akio, the 3D Blender source is rendered into 2D PNG frames offline.

## Implementation

- Existing Swordsman AI, state machine, hitboxes, damage, guard, pathing, collisions and combat timing remain unchanged.
- `game/oathbound/Regions/Hushiro/Presentation/HushiroIsometric2DPresentation.gd` has `debug_use_akio_swordsman_visual_proxy = true` (only takes effect in debug builds).
- The temporary profile `Presentation/Profiles/AkioEnemyVisualProxyProfile.tres` shares the **same** `SpriteFrames` object as Akio's `AkioCheckpointBProfile.tres`. There are no duplicate PNG files, generated copies or second atlas. Each actor keeps its own independent `AnimatedSprite2D` playback cursor.
- `Presentation/AkioEnemyVisualProxyProfile.gd` maps **all Swordsman attack IDs and generic attacks** to Akio `attack_quick_slash`; `idle` and `move` use Akio Idle and Run; `dash` borrows Move; `defend`, `hurt` and `death` temporarily fall back to Idle. No fake enemy attack logic is introduced.
- Enemy Akio proxy sprites receive a **red tint** to distinguish them from the real player.
- When actual Swordsman art is available, disable the debug flag; the untouched `CorruptedSwordsmanRigRendered2DProfile.tres` remains the proper destination for real art.
- The export pipeline remains `tools/rig2d/BLENDER_TO_GODOT_EXPORT_WORKFLOW.md`. No additional 3D Blender render is needed for this visual-skin test.

## November 5, 2026 first owner playtest — diagnosed and patched

**Evidence:** Windows Godot log for source build `49b017fc` plus a 587-event, ~27-second lightweight combat telemetry capture (the separate 2-event capture ended before gameplay). This is **owner-observed** and supported by telemetry, not a new final visual acceptance. The raw user log files are not checked into this public repo.

### Problem A — fresh Swordsmen glide before Run animations load

The startup loader assigned a single directional Idle pose to EVERY clip until each full clip was streamed. In this capture the 816-frame atlas began at ~2.852 s and completed at ~4.298 s, recording 1,509 ms total. The Swordsmen spawned and approached while their Move animations were still single Idle frames.

**Correction:** Each `move_<direction>` now receives six evenly sampled real Run frames at 10 FPS immediately during startup, preserving the source 18/30-second loop duration. Queue ordering streams all eight full Move clips before Idle/Quick Slash; promotion restores full 30 FPS. Player and all Akio visual proxy enemies share the SAME atlas and preview. No duplicate PNG assets, visual-only logic changes, and no opponent-movement freeze to conceal loading.

### Problem B — stationary swings from beyond melee hitbox reach

In the captured test, Swordsman attack starts were ~38–106 world units from Akio. Many stationary Basic/Cross attacks started at ~80–105, while normal melee hitboxes are authored for ~58–70 range. One verified Basic Swing contact was at ~52; a moving Running Swing contact occurred at ~84 (different ability), so *not every distant attack was incapable of hitting*. The archer's successful distant projectile hits are expected.

**Root cause 1:** Brain allowed generic attack intent up to `max(attack_start_max_range, running_min_distance+45)`, which is 125 units for the current Swordsman. Random attack selection could then choose Basic/Cross/Thrust instead of the running approach.

**Root cause 2:** Legacy physics checked `telegraphing` before `_in_running_approach`. A running attack intentionally sets both, so the telegraph branch overrode its approach velocity to zero. The approach then timed out and swung remotely.

**Correction:** Ordinary melee is now gated against the shortest authored strike's reliable starting reach (currently ~54 units: min of 62/58/70 sword ranges, minus 4 safety units); the 55–79 gap prioritizes approach instead of orbiting; at 80–125 only Running Swing is selected. Running approach movement now takes precedence over telegraph suppression, and a timed-out approach too far beyond running blade reach aborts rather than swinging from afar. No art-scale or physics-hitbox enlargement was used.

### Regression coverage

- `AkioCheckpointBAssetSmoke.gd` checks six real 10 FPS Run preview frames per direction **before** streaming and verifies the complete original 816-frame atlas afterward.
- `EnemyBrainSmoke.gd` checks melee eligibility near 50, gap at 70, closing attack at 96 and exclusion at 140; tests that Swordsman selects Running Swing rather than Basic from 96; confirms physics actually advances a telegraphing running attack.
- Existing combat, player, camera, presentation, Hushiro pressure, 8-view source export and full-game checks are still responsible for broader regressions.

### Re-test before acceptance

Start a fresh Hushiro Firing Line encounter on the new branch build. Observe the FIRST enemy movement after spawn (no static gliding); confirm the visual proxy Run clip switches to the full 18-frame cycle smoothly. Stand still just outside sword range and verify a Swordsman either advances into reach before a basic/cross/thrust, or visibly runs in before Running Swing; it must not repeatedly swing from ~80–105 units without closing. Circle/dodge away to ensure whiffs remain possible and hits are not magnetic. Repeat with two Swordsmen plus an Archer, and check damage/contact events and enemy avoidance. Record actual after-fix Godot/telemetry logs and compare player↔enemy distance at each attack start. **CI passing is not a substitute for this owner playtest.**

## How to playtest

1. On the existing `agent/akio-checkpoint-b-playtest` branch in the **single canonical local checkout**, pull the latest changes and run the normal existing `oathbound-playtest.cmd` flow. Do not create extra source clones or folders.
2. Enter the Hushiro combat encounter with a **Corrupted Swordsman**. The enemy should have Akio's model silhouette **rendered as sprites**, tinted red; the player remains normal Akio.
3. Observe standing, pursuit/strafe, attacks, hit reactions, guard, defeat, facing changes, overlap/depth ordering and camera motion with both actors visible. Expect guard/hurt/death to show temporary Idle rather than genuine animations.
4. Verify attack animation selection as best possible and note visible mismatch between Swordsman's real gameplay strike/telegraph timing and the borrowed full-length Quick Slash. That mismatch is expected and is **not** grounds to alter enemy damage/hitboxes to match Akio's animation.
5. Repeat with several Swordsmen. Confirm shared atlas initialization, normal gameplay framerate and startup time; note that an earlier single-Akio capture took ~39 s to finish loading the 816-frame atlas.
6. To disable, set the bridge's `debug_use_akio_swordsman_visual_proxy` property to `false` in the playtest configuration/code. Release builds ignore it automatically.

## Pass criteria and limits

- The shared atlas has 24 directional clips and 816 current candidate frames (Idle 40, Run 18, Quick Slash 44 per view), at 512 × 512 and 30 FPS. Those counts are the October 2026 candidate and must not be frozen as a permanent final-art requirement.
- Player and Swordsman sprites use independent playback state while sharing image memory; both remain correctly anchored and oriented and do not display their hidden legacy body sprites.
- Enemy AI, collision, attack hitbox lifecycle, damage and health are unchanged from existing Corrupted Swordsman gameplay.
- The test reveals real visual pipeline issues without creating second-generation gameplay assumptions or changing Hammer's Proof A acceptance.
- Borrowed Akio's slash is **not** synchronized to authored Swordsman attack impact frames; no Guard/Hurt/Death source art exists in Proof A. This test cannot establish final combat-animation quality or final enemy timing.

## Automated checks

The existing **Akio Proof A Readiness Check** workflow validates 816 Akio frames and tests the proxy: exact shared `SpriteFrames` identity, unchanged three-action 8-view contract, enemy attack-name remapping and temporary fallback states in `AkioCheckpointBAssetSmoke.gd`. Existing Hushiro presentation and combat CI remain unchanged.

**Do not label this visual proxy as artist-approved final enemy art.** After a dedicated Swordsman source is commissioned, use the normal enemy profile and the same source-to-PNG integrity workflow rather than preserving this debug visual shortcut.
