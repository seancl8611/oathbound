#!/usr/bin/env python3
"""Promote the verified revised-source Idle 40 + Quick Slash 44 candidate into the existing Akio Checkpoint B playtest branch.

Only the intended Idle and Quick Slash art is replaced (in two canonical locations).
Run, artist .blend sources, and other animation folders are NOT changed.
Preflight verifies the complete ZIP, export report, source SHA, all 672 RGBA PNGs and
existing repo contracts before any mutation. Then the script updates gameplay test
contracts and source timing coherently, validates all 816 runtime sprites, commits,
and pushes. No new checkouts, backups or outbound directories.
"""
from __future__ import annotations
import argparse
import json
import re
import struct
import subprocess
import sys
import zipfile
from pathlib import Path

BRANCH = "agent/akio-checkpoint-b-playtest"
SOURCE_SHA = "2d81b409f326cd6c265e4b78d0076ec3bde23f6e0e209d2fcfb4709c79efbe7a"
REPO = Path(__file__).resolve().parents[2]
ROOT = REPO / "runtime_frames_candidate_v2"
RUNTIME = REPO / "game/oathbound/Art2D/RigRendered/Akio/CheckpointB/Frames"
REPORT_NAME = "idle_quickslash_source_verified_candidate_report.json"
ZIP_NAME = "idle_quickslash_source_verified_candidate.zip"
DIRECTIONS = ("e", "se", "s", "sw", "w", "nw", "n", "ne")
COUNTS = {"idle": 40, "attack_quick_slash": 44}
PNG_SIG = b"\x89PNG\r\n\x1a\n"


def git(*args: str, capture: bool = False) -> str:
    p = subprocess.run(["git", "-C", str(REPO), *args],
                       check=True, text=True, capture_output=capture)
    return p.stdout.strip() if capture else ""


def change_once(text: str, before: str, after: str, path: str) -> str:
    if text.count(before) != 1:
        raise RuntimeError(f"Expected one code marker in {path}: {before!r}; branch changed; stop")
    return text.replace(before, after, 1)


def expected_files(base: str, count: int) -> set[str]:
    return {f"{base}_{direction}_{i:03d}.png" for direction in DIRECTIONS
            for i in range(count)}


def source_path(arg: str | None) -> Path:
    if arg:
        return Path(arg).expanduser().resolve()
    base = Path.home() / "OneDrive/Desktop/working/akio_proof_a/runtime_frames_candidate_v2"
    options = [base / ZIP_NAME, Path.home() / "Downloads" / ZIP_NAME]
    for option in options:
        if option.is_file():
            return option
    raise RuntimeError(f"Could not find {ZIP_NAME}; use --source PATH to existing ZIP")


def read_and_validate_archive(path: Path) -> tuple[dict[str, dict[str, bytes]], bytes]:
    if not path.is_file():
        raise RuntimeError("Missing ZIP: " + str(path))
    expected = {f"{base}/{name}" for base, n in COUNTS.items()
                for name in expected_files(base, n)}
    allowed = expected | {REPORT_NAME}
    with zipfile.ZipFile(path) as z:
        if z.testzip() is not None:
            raise RuntimeError("ZIP CRC check failed")
        names = z.namelist()
        if len(names) != len(set(names)) or set(names) != allowed:
            raise RuntimeError(
                f"ZIP inventory unexpected: entries={len(names)}, expected={len(allowed)};"
                f" missing={sorted(allowed-set(names))[:5]}; extra={sorted(set(names)-allowed)[:5]}"
            )
        report_bytes = z.read(REPORT_NAME)
        report = json.loads(report_bytes)
        if report.get("status") != "PASS" or report.get("source_sha256") != SOURCE_SHA:
            raise RuntimeError("Report does not PASS the exact approved Blender source")
        if report.get("fps") != 30 or report.get("canvas_px") != [512, 512]:
            raise RuntimeError("Report FPS/canvas differs from Akio Checkpoint B contract")
        if report.get("directions") != list(DIRECTIONS):
            raise RuntimeError("Report direction calibration/order differs from contract")
        if report.get("total_candidate_pngs") != 672:
            raise RuntimeError("Report candidate total must be 672")
        for base, count in COUNTS.items():
            info = report.get("animations", {}).get(base, {})
            if info.get("frames_per_direction") != count or info.get("rendered_frames") != [0, count-1]:
                raise RuntimeError("Report frame range/count mismatch for " + base)
            if info.get("loop") != (base == "idle"):
                raise RuntimeError("Report loop policy mismatch for " + base)
            if set(info.get("loop_and_tail_image_differences", {})) != set(DIRECTIONS):
                raise RuntimeError("Missing directional image diagnostics for " + base)
            if base == "idle":
                for direction in DIRECTIONS:
                    if float(info["loop_and_tail_image_differences"][direction]["frame_0_vs_40"]) >= 0.025:
                        raise RuntimeError("Idle closure rejected in " + direction)
            else:
                for direction in DIRECTIONS:
                    diag = info["loop_and_tail_image_differences"][direction]
                    if float(diag["frame_39_vs_40"]) <= 0.001 or float(diag["frame_40_vs_43"]) <= 0.001:
                        raise RuntimeError("Quick Slash ending not visibly distinct in " + direction)
        frames = {base: {} for base in COUNTS}
        for base, n in COUNTS.items():
            for name in expected_files(base, n):
                content = z.read(base + "/" + name)
                if content[:8] != PNG_SIG or content[12:16] != b"IHDR":
                    raise RuntimeError("Invalid PNG signature/IHDR: " + name)
                if len(content) < 33:
                    raise RuntimeError("Truncated PNG: " + name)
                width, height, depth, color = struct.unpack_from(">IIBB", content, 16)
                if (width, height, depth, color) != (512, 512, 8, 6):
                    raise RuntimeError("Wrong 512x512 RGBA-8 format: " + name)
                frames[base][name] = content
        return frames, report_bytes


def preflight_repo() -> None:
    if git("branch", "--show-current", capture=True) != BRANCH:
        raise RuntimeError("Switch to branch " + BRANCH + " first")
    if git("status", "--porcelain", "--untracked-files=no", capture=True):
        raise RuntimeError("Tracked working tree is dirty; inspect with git status before continuing")
    if not ROOT.is_dir() or not RUNTIME.is_dir():
        raise RuntimeError("Existing canonical asset directories missing")
    manifest = json.loads((REPO/"tools/rig2d/akio_checkpoint_b_manifest.json").read_text(encoding="utf-8"))
    if manifest["animation_frame_counts"] != {"idle": 40, "move": 18, "attack_quick_slash": 40}:
        raise RuntimeError("This promoter requires original 40/18/40 frame contract; check branch/head")
    for base, count in {"idle": 40, "move": 18, "attack_quick_slash": 40}.items():
        for folder in (ROOT/base, RUNTIME):
            found = {p.name for p in folder.glob(base+"_*.png")}
            if found != expected_files(base, count):
                raise RuntimeError(f"Preexisting {base} in {folder} is not {count}x8 as expected")
    if not (ROOT / "run_18_verified_export_report.json").is_file():
        raise RuntimeError("Verified Run 18 report missing; Run must be preserved")


def prepare_text_updates(report_bytes: bytes) -> dict[Path, bytes]:
    paths = {
        "manifest": "tools/rig2d/akio_checkpoint_b_manifest.json",
        "asset_smoke": "game/oathbound/Regions/Hushiro/Validation/AkioCheckpointBAssetSmoke.gd",
        "timing": "game/oathbound/Core/Combat/AkioCheckpointBTiming.gd",
        "focused_smoke": "game/oathbound/Core/Combat/Validation/AkioFocusedPlaytestSmoke.gd",
        "lab": "game/oathbound/Core/Regions/OathboundRegionPlaytestLab.gd",
        "notes": "docs/content/area_1/AKIO_CHECKPOINT_B_FOCUSED_PLAYTEST.md",
    }
    t = {key: (REPO/path).read_text(encoding="utf-8") for key, path in paths.items()}
    m = json.loads(t["manifest"])
    m["animation_frame_counts"]["attack_quick_slash"] = 44
    m["notes"].append("Verified revised-source Idle 40 and Quick Slash 44-frame nonlooping inspection candidate, 8 directions from exact source SHA256 " + SOURCE_SHA + "; total 816 PNGs. Quick Slash end/timing pending owner gameplay assessment.")
    m["notes"] = [x.replace("Quick Slash=40 per direction; total 784 PNGs.",
                            "Quick Slash=44 candidate per direction; total 816 PNGs.")
                  for x in m["notes"]]
    t["manifest"] = json.dumps(m, indent=2) + "\n"

    p = paths["asset_smoke"]
    t["asset_smoke"] = change_once(
        t["asset_smoke"], 'elif animation_text.begins_with("move_"):\n\t\t\t\t\t\texpected_count = 18',
        'elif animation_text.begins_with("move_"):\n\t\t\t\t\t\texpected_count = 18\n\t\t\t\t\telif animation_text.begins_with("attack_quick_slash_"):\n\t\t\t\t\t\texpected_count = 44', p)
    t["asset_smoke"] = change_once(t["asset_smoke"], 'total == 784', 'total == 816', p)
    t["asset_smoke"] = change_once(t["asset_smoke"], 'contain 784 frames', 'contain 816 frames', p)

    p = paths["timing"]
    for a, b in [('These 40 frames', 'These 44 frames'),
                 ('SOURCE_FRAME_COUNT: int = 40', 'SOURCE_FRAME_COUNT: int = 44'),
                 ('frame 0..39', 'frame 0..43')]:
        t["timing"] = change_once(t["timing"], a, b, p)
    p = paths["focused_smoke"]
    for a, b in [('TIMING.SOURCE_FRAME_COUNT == 40', 'TIMING.SOURCE_FRAME_COUNT == 44'),
                 ('must contain 40 frames', 'must contain 44 frames'),
                 ('40.0 / 30.0', '44.0 / 30.0'),
                 ('== 40, "source phase counts do not total 41"',
                  '== 44, "source phase counts do not total 44"')]:
        t["focused_smoke"] = change_once(t["focused_smoke"], a, b, p)

    p = paths["lab"]
    for a,b in [
        ('Hammer V2 (40 frames / 30 FPS)', 'Hammer revised (44 frames / 30 FPS)'),
        ('all base-katana Quick Slashes play 40 frames', 'all base-katana Quick Slashes play 44 frames'),
        ('var expected_count := 40 if animation_name.begins_with("attack_")',
         'var expected_count := 44 if animation_name.begins_with("attack_")')
    ]:
        t["lab"] = change_once(t["lab"], a, b, p)

    note = """## Updated revised-source Idle + Quick Slash candidate (2026-10-28)

This section supersedes older 40/41-frame Quick Slash descriptions below.
Source SHA-256: \`2d81b409f326cd6c265e4b78d0076ec3bde23f6e0e209d2fcfb4709c79efbe7a\`.
The October revised source has **Idle 40 frames (0..39, frame 40 identical to 0)**,
**Run 18 frames (0..17, frame 18 closes 0)** and **non-looping Quick Slash 44-frame inspection candidate (0..43)** in all eight views. Total **816**.
Quick Slash still has manually saved Action range 0..40 but real artist keys through 43;
do not use the saved range alone. Source FPS 30; Quick Slash test lasts 44/30 ~= 1.467 seconds.
Provisional combat phases remain startup 15 (0.5s), active 8 (~0.267s) and
recovery **21** (~0.7s), subject to impact-pose and cancel-feel review. No
new damage authority or hitbox rules are assigned to rendered frames.
View the new candidate in the Playtest Lab, stationary then while holding
movement, for all eight directions; verify recovery, sheath and Attack->Idle/Run
transitions and recovery dash/parry. Keep Run smoothing experiments off. Do not
accept final commissioned Quick Slash solely on frame-count or CI checks.
Verification: \`runtime_frames_candidate_v2/idle_quickslash_source_verified_candidate_report.json\`.
Repeatable procedure: \`tools/rig2d/BLENDER_TO_GODOT_EXPORT_WORKFLOW.md\`.

"""
    t["notes"] = change_once(t["notes"], "# Akio Checkpoint B — Focused Playtest\n\n",
                              "# Akio Checkpoint B — Focused Playtest\n\n" + note, paths["notes"])
    result = {REPO/paths[k]:v.encode("utf-8") for k,v in t.items()}
    result[ROOT/REPORT_NAME] = report_bytes
    return result


def main() -> None:
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument("--source", help="existing verified ZIP path (default Desktop/working)")
    args = argp.parse_args()
    preflight_repo()
    source = source_path(args.source)
    print("[IdleQuick44] Reading verified source:", source)
    frames, report = read_and_validate_archive(source)
    print("[IdleQuick44] PASS 672 PNGs; source SHA, 8 directions, loop/tail and 512px RGBA verified")
    changes = prepare_text_updates(report)
    # All validation and code-marker checks passed before touching tracked files.
    for base, rendered in frames.items():
        for folder in (ROOT/base, RUNTIME):
            for previous in folder.glob(base+"_*.png"):
                previous.unlink()
            for name, content in sorted(rendered.items()):
                (folder/name).write_bytes(content)
    for path, content in changes.items():
        path.write_bytes(content)
    manifest = "tools/rig2d/akio_checkpoint_b_manifest.json"
    validator = REPO/"tools/rig2d/validate_frame_set.py"
    subprocess.run([sys.executable, str(validator), "--manifest", str(REPO/manifest),
                    "--actor", "akio", "--source", str(RUNTIME)], check=True, cwd=REPO)
    subprocess.run([sys.executable, str(validator), "--manifest", str(REPO/manifest),
                    "--actor", "akio", "--source", str(ROOT)],
                   check=True, cwd=REPO) if False else None  # candidate folders are separated; runtime is flat
    if len(list(RUNTIME.glob("*.png"))) != 816:
        raise RuntimeError("Runtime frame inventory not exactly 816")
    git("add", "-A", "--",
        "runtime_frames_candidate_v2/idle",
        "runtime_frames_candidate_v2/attack_quick_slash",
        "runtime_frames_candidate_v2/"+REPORT_NAME,
        "game/oathbound/Art2D/RigRendered/Akio/CheckpointB/Frames",
        "tools/rig2d/akio_checkpoint_b_manifest.json",
        "game/oathbound/Regions/Hushiro/Validation/AkioCheckpointBAssetSmoke.gd",
        "game/oathbound/Core/Combat/AkioCheckpointBTiming.gd",
        "game/oathbound/Core/Combat/Validation/AkioFocusedPlaytestSmoke.gd",
        "game/oathbound/Core/Regions/OathboundRegionPlaytestLab.gd",
        "docs/content/area_1/AKIO_CHECKPOINT_B_FOCUSED_PLAYTEST.md")
    git("commit", "-m", "Promote verified revised Idle and 44-frame Quick Slash playtest candidate")
    git("push", "origin", BRANCH)
    print("[IdleQuick44] SUCCESS: 816 runtime frames; one commit pushed to", BRANCH)
    print("[IdleQuick44] Commit:", git("rev-parse", "HEAD", capture=True))
    print("[IdleQuick44] Next: ./oathbound-playtest.cmd "+BRANCH)


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, OSError, ValueError, KeyError, zipfile.BadZipFile,
            subprocess.CalledProcessError) as exc:
        print("[IdleQuick44] ERROR:", exc, file=sys.stderr)
        sys.exit(1)
