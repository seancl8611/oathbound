# Blender -> 8-direction PNG -> Godot: repeatable export procedure

**Canonical operating procedure for Akio and every future rig-rendered enemy/character.**
Read this BEFORE opening/exporting an artist's Blender delivery or changing SpriteFrames, timings, manifests, or commissioning acceptance. This is the hands-on companion to [the production authority](../../docs/art_production/RIG_RENDERED_2D_PIPELINE.md), not a replacement for it.

## Lessons from the October 2026 Akio Proof A failures

1. **Run was accidentally shortened.** The artist's revised Run Action had meaningful keyframes through **18**, but its saved manual range (and stashed NLA strip) still ended at **16**. Exporting 0..15 left out 16 and 17, causing a discontinuous loop. A rigorous render-level test established **0..17 at 30 FPS**, with **18 as the equivalent closing pose**, all eight directions; this fixed the visible stagger.
2. **Quick Slash may have suffered the non-loop equivalent.** An Action manual range of **0..40** coexists with keys through **43**. The verified revised-source candidate renders **0..43**, 44 images/direction. Frames 40–43 contain meaningful motion in every direction. Keep this **provisional until playtested**. A non-loop attack must not assume its final valid key is a duplicate of frame 0.
3. **Idle is different.** Frame **40 exactly closes 0** in all eight directions; **0..39** is the correct loop. A duplicated loop endpoint must be excluded, but only after image-level and evaluated-rig verification.
4. **Count checks alone are insufficient.** A 16-image Run can be internally contiguous and still omit artist-authored poses. Validate *source Action keys and evaluation* before choosing the expected count; then prove PNGs match the source.
5. **NLA can override Action evaluation.** Inspect slots, active Action, stashed NLA strips, and NLA enablement. Explicitly select the expected Action + correct slot (Blender 5.2 uses layered Actions) and disable interfering NLA for controlled exports, restoring state afterward.
6. **Godot timing must match the chosen images.** Update source-frame counts, preview thresholds, CI smoke checks, runtime playtest timing and docs **in the same asset promotion**. Do not leave a 44-image attack on a 40-frame test timeline or make a rendered frame authoritative for damage.
7. **One local working checkout only.** Use the existing \`~/OneDrive/Desktop/oathbound\` and the existing \`C:\OathboundPlaytest\` launcher. Do not create extra named clones/outbound/backup folders. Blender may use auto-cleaned OS temporary rendering storage while validating, but the canonical candidate folder is \`~/OneDrive/Desktop/working/akio_proof_a/runtime_frames_candidate_v2\`.

## Procedure for each delivery

### A. Source intake and Action audit (BEFORE rendering)

- Confirm the intended source revision and record the **SHA-256 of the exact .blend bytes**, Blender version, and declared artist change list. Never trust a filename alone; keep the artist-delivered .blend unmodified.
- Discover Actions, each **slot identifier**, F-curve and Bezier keyframe times, key extrema, manual Action range, cyclic modifiers and NLA tracks; investigate keys **outside** the saved range. Include negative/preroll keys in the audit, but do not blindly include them in gameplay.
- For **looping** Actions (Idle, Run, enemy move): find the *real* closing frame by evaluating the rig and **rendering** start/end at each camera direction. If frame K equals 0, export 0..K-1; if it doesn't close, do not silently drop the tail or fudge blending. Resolve the intended motion with the animator/source before acceptance.
- For **non-looping** Actions (attacks, hit, death): inspect all meaningful last keys, even those after manual playback end; render through the agreed final pose **inclusive**, and compare with the anticipated next state. Never apply the loop-end exclusion rule to a non-loop.
- Record unknown artist intent explicitly. Candidate tests do not become approval of final action length, impact window, weapon readiness or scope.

### B. Render deterministically

- Keep source camera, orthographic scale, lighting, scene FPS, fixed pixel canvas, pivot, character footprint, armature slot, and transparent RGBA 8-bit output consistent. Source frame number maps directly to zero-padded export index unless deliberately documented.
- Export **eight independent views**, never mirror handedness: **e, se, s, sw, w, nw, n, ne**. For the October 2026 Akio scene, \`CameraIso\`, \`CameraPivot\` and yaw offsets are calibrated; *other rigs must calibrate afresh* rather than copy offsets blindly.
- For this Akio Checkpoint B experiment: Blender 5.2.2, 30 FPS, 512x512 RGBA, 8 directions; Idle **0..39** (40), Run **0..17** (18), Quick Slash inspection **0..43** (44). Total after promotion: **816**.
- Preserve original rig/scene state, Action slot, manual range, NLA enablement, render configuration and camera rotation. **Never auto-save/rewrite the artist's .blend.**
- Render to temporary storage and validate there BEFORE replacing previously usable candidate PNGs. Outputs: existing \`runtime_frames_candidate_v2/<animation_base>\` subfolder, export report, and optionally a ZIP for handoff.

### C. Validate source -> PNGs BEFORE promotion

- Report must include source SHA, Action/slot, discovered keys, explicitly chosen source range, whether the endpoint is included/excluded and why, source FPS, camera/directions and any source versus evaluated-rig exceptions.
- Check exactly 8 directions with sequential 000..N-1 numbering and **no gaps, duplicates, trailing stale frames, or unexpected names**. Validate every PNG signature/IHDR for RGBA 8-bit, canvas dimensions and nonempty visual alpha where appropriate.
- Inspect first/middle/impact/recovery/last contact sheets and frame deltas **per direction**, plus Idle/Run loop closure; review N/S as carefully as E/W. In quick sword cuts, a one-frame hand/katana change can be decisive.
- Test directional naming/orientation (right vs left hand, katana sheath, face vs back), sword clipping/canvas margins, stable feet anchor, and source-to-Godot frame fidelity.
- **Fail closed** when source hash, slot, count, endpoint, report, directions, PNG format or closure disagrees. Do not suppress a failed validation by lowering the manifest count.

### D. Promote exactly one coherent asset + runtime revision

- Use \`tools/rig2d/validate_frame_set.py\` against the **correct character/checkpoint manifest**. Promote all frames to the canonical \`runtime_frames_candidate_v2\` and the applicable \`game/oathbound/Art2D/RigRendered/<Actor>/...\` runtime folder; only replace the intended animation bases.
- Keep the manifest, SpriteFrames atlas, smoke tests, developer preview, source-cadence timing and playtest notes consistent with the approved *test* range. Attack hitboxes remain gameplay-owned; changing frame count changes test recovery duration only if explicitly desired.
- On the present Akio test branch, use the safeguarded \`tools/rig2d/upload_verified_idle_quickslash44.py\` after running the Blender verifier. Do **not** use the legacy \`akio_checkpoint_b_hammer_export.py\` as authority for frame counts: it derives a count from the saved Action range, which caused the Run omission.
- Prefer one asset-promotion commit and ordinary branch push, not extra repositories, backups or unstaged unknown changes. Do not commit .blend masters or ZIPs into the runtime game.
- Launch the existing \`./oathbound-playtest.cmd agent/akio-checkpoint-b-playtest\`, verify Godot import and exact-head CI, and test all eight clips at intended source FPS. Check Idle->Run->Idle, attack->idle/run, recovery dash/parry, feet, weapon readiness, hitbox vs pose, and action-frame trace. Store observations in the appropriate playtest/artist tracker.

### E. Before advancing to a new artist or Milestone 2

Record: exact artist source SHA, approved or candidate animation action names, frame ranges and rules, direction calibration, dimensions and FPS, validation report location, runtime/CI commit, unresolved visual feedback and what was learned. Separate **render/integration defects** from **artistic revisions**. A smoke test proves programmatic coverage, not aesthetic acceptance.

## Single source of truth for current Akio test

- **Artist source SHA**: \`2d81b409f326cd6c265e4b78d0076ec3bde23f6e0e209d2fcfb4709c79efbe7a\`.
- **Run proof**: \`runtime_frames_candidate_v2/run_18_verified_export_report.json\`, 18 × 8, 30 FPS, loop at Blender frame 18.
- **Idle/Quick Slash proof**: \`runtime_frames_candidate_v2/idle_quickslash_source_verified_candidate_report.json\` (added by the guarded promoter); revised source candidate, Idle 40 × 8, Quick Slash 44 × 8.
- **Runtime contract**: \`tools/rig2d/akio_checkpoint_b_manifest.json\`.
- **Runtime tester**: \`docs/content/area_1/AKIO_CHECKPOINT_B_FOCUSED_PLAYTEST.md\`.
- **Owner/artist review**: \`docs/commissions/akio/HAMMER_PROOF_A_FEEDBACK_TRACKER.md\`.
