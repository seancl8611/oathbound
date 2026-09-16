#!/usr/bin/env python3
"""Validate a rig-rendered 2D runtime frame set against poc_manifest.json.

Uses only the Python standard library so it can run before Godot import and without
Pillow. It validates file naming, required directional coverage, contiguous zero-based
frame numbering, and the PNG IHDR canvas/format contract.
"""

from __future__ import annotations

import argparse
import json
import re
import struct
import sys
from pathlib import Path

PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
FRAME_RE = re.compile(r"^(?P<base>.+)_(?P<direction>e|se|s|sw|w|nw|n|ne)_(?P<frame>\d{3})\.png$", re.IGNORECASE)


def _load_manifest(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError("manifest root must be an object")
    return data


def _png_header(path: Path) -> tuple[int, int, int, int]:
    with path.open("rb") as handle:
        if handle.read(8) != PNG_SIGNATURE:
            raise ValueError("invalid PNG signature")
        length_raw = handle.read(4)
        chunk_type = handle.read(4)
        if len(length_raw) != 4 or chunk_type != b"IHDR":
            raise ValueError("PNG is missing the initial IHDR chunk")
        length = struct.unpack(">I", length_raw)[0]
        if length != 13:
            raise ValueError(f"unexpected IHDR length {length}")
        payload = handle.read(13)
        if len(payload) != 13:
            raise ValueError("truncated IHDR payload")
        width, height, bit_depth, color_type, _compression, _filter, _interlace = struct.unpack(
            ">IIBBBBB", payload
        )
        return width, height, bit_depth, color_type


def validate(manifest_path: Path, actor: str, source: Path, allow_unexpected: bool) -> list[str]:
    errors: list[str] = []
    manifest = _load_manifest(manifest_path)

    proof_scope = manifest.get("proof_scope", [])
    if actor not in proof_scope:
        errors.append(f"actor '{actor}' is not present in manifest proof_scope={proof_scope}")
        return errors

    directions = [str(entry.get("name", "")) for entry in manifest.get("directions", []) if isinstance(entry, dict)]
    if directions != ["e", "se", "s", "sw", "w", "nw", "n", "ne"]:
        errors.append(f"manifest directions are not the expected eight-direction contract: {directions}")

    bases_key = f"{actor}_animation_bases"
    animation_bases = [str(value) for value in manifest.get(bases_key, [])]
    if not animation_bases:
        errors.append(f"manifest key '{bases_key}' is missing or empty")
        return errors

    frame_contract = manifest.get("frame_contract", {})
    canvas = frame_contract.get("canvas_px", []) if isinstance(frame_contract, dict) else []
    if not (isinstance(canvas, list) and len(canvas) == 2):
        errors.append("manifest frame_contract.canvas_px must contain width and height")
        return errors
    expected_width, expected_height = int(canvas[0]), int(canvas[1])

    if not source.exists() or not source.is_dir():
        errors.append(f"source directory does not exist: {source}")
        return errors

    expected_animations = {f"{base}_{direction}" for base in animation_bases for direction in directions}
    discovered: dict[str, list[tuple[int, Path]]] = {}

    png_paths = sorted(path for path in source.iterdir() if path.is_file() and path.suffix.lower() == ".png")
    if not png_paths:
        errors.append(f"no PNG frames found in {source}")
        return errors

    for path in png_paths:
        match = FRAME_RE.fullmatch(path.name)
        if match is None:
            errors.append(f"malformed frame filename: {path.name}")
            continue
        animation_name = f"{match.group('base').lower()}_{match.group('direction').lower()}"
        frame_index = int(match.group("frame"))
        if animation_name not in expected_animations:
            if not allow_unexpected:
                errors.append(f"unexpected animation frame: {path.name}")
            continue
        discovered.setdefault(animation_name, []).append((frame_index, path))

        try:
            width, height, bit_depth, color_type = _png_header(path)
        except ValueError as exc:
            errors.append(f"{path.name}: {exc}")
            continue
        if (width, height) != (expected_width, expected_height):
            errors.append(
                f"{path.name}: canvas {width}x{height} != expected {expected_width}x{expected_height}"
            )
        if bit_depth != 8 or color_type != 6:
            errors.append(
                f"{path.name}: PNG must be 8-bit RGBA (bit_depth=8 color_type=6), got "
                f"bit_depth={bit_depth} color_type={color_type}"
            )

    for animation_name in sorted(expected_animations):
        entries = discovered.get(animation_name, [])
        if not entries:
            errors.append(f"missing animation: {animation_name}")
            continue
        indices = sorted(index for index, _path in entries)
        if len(indices) != len(set(indices)):
            errors.append(f"duplicate frame index in animation {animation_name}: {indices}")
            continue
        expected_indices = list(range(indices[-1] + 1))
        if indices != expected_indices:
            errors.append(
                f"non-contiguous frames for {animation_name}: expected {expected_indices}, got {indices}"
            )

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--actor", required=True)
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument(
        "--allow-unexpected",
        action="store_true",
        help="ignore correctly named PNGs for animation bases outside the selected actor contract",
    )
    args = parser.parse_args()

    try:
        errors = validate(args.manifest, args.actor, args.source, args.allow_unexpected)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"[Rig2DFrameValidator] ERROR {exc}", file=sys.stderr)
        return 1

    if errors:
        for error in errors:
            print(f"[Rig2DFrameValidator] FAIL {error}", file=sys.stderr)
        print(f"[Rig2DFrameValidator] FAIL count={len(errors)}", file=sys.stderr)
        return 1

    manifest = _load_manifest(args.manifest)
    animation_count = len(manifest[f"{args.actor}_animation_bases"]) * len(manifest["directions"])
    frame_count = len([path for path in args.source.iterdir() if path.is_file() and path.suffix.lower() == ".png"])
    canvas = manifest["frame_contract"]["canvas_px"]
    print(
        f"[Rig2DFrameValidator] PASS actor={args.actor} animations={animation_count} "
        f"frames={frame_count} canvas={canvas[0]}x{canvas[1]}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
