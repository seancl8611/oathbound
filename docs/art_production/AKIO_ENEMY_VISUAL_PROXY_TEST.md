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
