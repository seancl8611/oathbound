#!/usr/bin/env python3
"""Promote verified Hammer Run 18 PNGs from Desktop/working into this existing Git checkout.

This script creates NO clones, backup folders, or new workspaces.
Source: Desktop/working/akio_proof_a/runtime_frames_candidate_v2 or its ZIP.
It changes only the two Run image directories and the verification report,
then creates ONE commit and pushes the existing playtest branch.
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
DIRECTIONS = ("e", "se", "s", "sw", "w", "nw", "n", "ne")
RUN_RE = re.compile(r"move_(?:e|se|s|sw|w|nw|n|ne)_\d{3}\.png\Z")
CANDIDATE = REPO / "runtime_frames_candidate_v2"
RUNTIME = REPO / "game/oathbound/Art2D/RigRendered/Akio/CheckpointB/Frames"


def git(*args: str, capture: bool = False) -> str:
    result = subprocess.run(["git", "-C", str(REPO), *args],
                            text=True, check=True, capture_output=capture)
    return result.stdout.strip() if capture else ""


def locate_source(explicit: str | None) -> Path:
    if explicit:
        return Path(explicit).expanduser().resolve()
    base = Path.home() / "OneDrive/Desktop/working"
    options = [
        base / "akio_proof_a/runtime_frames_candidate_v2",
        base / "runtime_frames_candidate_v2",
        base / "runtime_frames_candidate_v2.zip",
        base / "akio_proof_a/runtime_frames_candidate_v2.zip",
        Path.home() / "Downloads/runtime_frames_candidate_v2.zip",
    ]
    for item in options:
        if item.exists():
            return item
    raise RuntimeError("Cannot find verified Run frames in Desktop/working; pass --source PATH.")


def load_source(source: Path) -> tuple[dict[str, bytes], bytes]:
    if source.is_dir():
        move_dir = source / "move" if (source / "move").is_dir() else source
        report_path = move_dir.parent / "run_18_verified_export_report.json"
        if not report_path.is_file():
            raise RuntimeError("Verification report missing next to move folder")
        report_bytes = report_path.read_bytes()
        frames = {p.name: p.read_bytes() for p in move_dir.iterdir()
                  if p.is_file() and RUN_RE.fullmatch(p.name)}
    elif source.suffix.lower() == ".zip":
        with zipfile.ZipFile(source) as z:
            broken = z.testzip()
            if broken:
                raise RuntimeError("Bad ZIP entry: " + broken)
            reports = [s for s in z.namelist() if s.endswith("/run_18_verified_export_report.json")]
            if len(reports) != 1:
                raise RuntimeError("ZIP must contain one run_18_verified_export_report.json")
            report_bytes = z.read(reports[0])
            frames = {}
            for entry in z.namelist():
                if "/move/" not in entry:
                    continue
                name = entry.rsplit("/", 1)[-1]
                if RUN_RE.fullmatch(name):
                    if name in frames:
                        raise RuntimeError("Duplicate Run frame in ZIP: " + name)
                    frames[name] = z.read(entry)
    else:
        raise RuntimeError("Source must be a folder or ZIP: " + str(source))
    report = json.loads(report_bytes)
    if report.get("status") != "PASS" or report.get("source_sha256") != SOURCE_SHA:
        raise RuntimeError("Export report does not verify the approved Blender source")
    required = {f"move_{d}_{i:03d}.png" for d in DIRECTIONS for i in range(18)}
    if set(frames) != required:
        raise RuntimeError(f"Run inventory mismatch: {len(frames)} images, expected 144")
    for name, data in frames.items():
        if data[:8] != b"\x89PNG\r\n\x1a\n" or data[12:16] != b"IHDR":
            raise RuntimeError("Invalid PNG header: " + name)
        width, height, depth, color = struct.unpack(">IIBB", data[16:26])
        if (width, height, depth, color) != (512, 512, 8, 6):
            raise RuntimeError("Bad image format: " + name)
    for direction in DIRECTIONS:
        check = report.get("rendered_loop_checks", {}).get(direction, {})
        if not check or float(check.get("frame_0_vs_18", 1)) >= float(check.get("frame_0_vs_16", 0)):
            raise RuntimeError("Blender loop closure not verified: " + direction)
    return frames, report_bytes


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", help="explicit candidate directory or ZIP")
    args = parser.parse_args()
    if git("branch", "--show-current", capture=True) != BRANCH:
        raise RuntimeError("Switch to existing playtest branch first: git switch " + BRANCH)
    if git("status", "--porcelain", "--untracked-files=no", capture=True):
        raise RuntimeError("Uncommitted changes detected. Commit or restore them before running.")
    if not CANDIDATE.is_dir() or not RUNTIME.is_dir():
        raise RuntimeError("Expected canonical GitHub folders are missing")
    manifest = json.loads((REPO / "tools/rig2d/akio_checkpoint_b_manifest.json").read_text())
    if manifest["animation_frame_counts"].get("move") != 18:
        raise RuntimeError("Pull latest branch first; the Godot Run contract is not yet 18 frames.")
    source = locate_source(args.source)
    print("[Run18] Reading existing export:", source)
    frames, report_bytes = load_source(source)
    print("[Run18] Verified 144 PNGs, correct Blender source and all 8 loop closures")

    # Mutate only after complete validation; no source images are changed.
    for folder in (CANDIDATE / "move", RUNTIME):
        for prior in folder.glob("move_*.png"):
            if RUN_RE.fullmatch(prior.name):
                prior.unlink()
        for name, data in sorted(frames.items()):
            (folder / name).write_bytes(data)
    (CANDIDATE / "run_18_verified_export_report.json").write_bytes(report_bytes)
    git("add", "-A", "--",
        "runtime_frames_candidate_v2/move",
        "runtime_frames_candidate_v2/run_18_verified_export_report.json",
        "game/oathbound/Art2D/RigRendered/Akio/CheckpointB/Frames")
    git("commit", "-m", "Add complete verified Akio 18-frame Run assets")
    git("push", "origin", BRANCH)
    print("[Run18] SUCCESS: one commit pushed to", BRANCH)
    print("[Run18] Commit:", git("rev-parse", "HEAD", capture=True))


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, OSError, ValueError, KeyError, zipfile.BadZipFile,
            subprocess.CalledProcessError) as exc:
        print("[Run18] ERROR:", exc, file=sys.stderr)
        sys.exit(1)
