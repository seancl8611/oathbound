# Hammer Akio V2 — direction correction and runtime handoff

Original candidate export filename labels were rotated relative to the existing Godot eight-direction convention. The uploaded frame data is valid; the final candidate and game names have been normalized by reusing the original PNG Git blobs, without re-encoding.

| Correct Godot direction | Original candidate label |
|---|---|
| e | sw |
| se | w |
| s | nw |
| sw | n |
| w | ne |
| nw | e |
| n | se |
| ne | s |

Confirmed real image inventory in GitHub: idle 320 (40x8), move 128 (16x8), Quick Slash 320 (40x8), total 768 PNGs. Source JSON audit and manifest reported 41 Quick Slash frames/776 total, but frame 040 was not present in the uploaded candidate. Those JSON files remain unmodified source records; the integration consistently uses 40 Quick Slash frames.

Quick Slash retains the sheathing tail; no arbitrary shortening or cropping was introduced. Visual in-game playtesting remains required.

## Verified Run 18 update (2026-10-27)

The verified source contains **18 Run frames per direction**, 144 total, exported from Blender source SHA-256 `2d81b409f326cd6c265e4b78d0076ec3bde23f6e0e209d2fcfb4709c79efbe7a`. The updated camera-calibrated sequence plays frames 0–17 at 30 FPS and closes visually at frame 18. The game now expects **784 total** (320 Idle + 144 Run + 320 Quick Slash). `run_18_verified_export_report.json` supersedes the old 16-frame Run audit, which remains here only as a historical record.
