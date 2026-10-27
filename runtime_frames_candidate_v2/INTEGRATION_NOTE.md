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
