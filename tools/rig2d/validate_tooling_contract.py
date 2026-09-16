#!/usr/bin/env python3
"""Validate that Blender export templates and the rig2d manifest describe one contract."""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
MANIFEST_PATH = ROOT / "poc_manifest.json"
TEMPLATES = {
    "akio": ROOT / "blender" / "akio_export.template.json",
    "corrupted_swordsman": ROOT / "blender" / "corrupted_swordsman_export.template.json",
}
EXPECTED_DIRECTIONS = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]


def load_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as handle:
        value = json.load(handle)
    if not isinstance(value, dict):
        raise ValueError(f"{path}: root must be an object")
    return value


def fail(message: str, errors: list[str]) -> None:
    errors.append(message)


def main() -> int:
    errors: list[str] = []
    try:
        manifest = load_json(MANIFEST_PATH)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"[Rig2DToolingContract] FAIL {exc}", file=sys.stderr)
        return 1

    proof_scope = manifest.get("proof_scope", [])
    if proof_scope != list(TEMPLATES):
        fail(f"proof_scope must be {list(TEMPLATES)}, got {proof_scope}", errors)

    manifest_directions = manifest.get("directions", [])
    direction_names = [entry.get("name") for entry in manifest_directions if isinstance(entry, dict)]
    if direction_names != EXPECTED_DIRECTIONS:
        fail(f"manifest direction order mismatch: {direction_names}", errors)

    frame_contract = manifest.get("frame_contract", {})
    canvas = frame_contract.get("canvas_px") if isinstance(frame_contract, dict) else None
    if canvas != [128, 128]:
        fail(f"proof canvas must remain 128x128, got {canvas}", errors)
    if frame_contract.get("default_fps") != 12:
        fail(f"proof cadence must remain 12 fps, got {frame_contract.get('default_fps')}", errors)
    if frame_contract.get("crop_each_frame") is not False:
        fail("frame cropping must remain disabled", errors)
    if frame_contract.get("root_motion") is not False:
        fail("gameplay root motion must remain disabled", errors)

    for actor, template_path in TEMPLATES.items():
        try:
            template = load_json(template_path)
        except (OSError, ValueError, json.JSONDecodeError) as exc:
            fail(str(exc), errors)
            continue

        if template.get("actor_id") != actor:
            fail(f"{template_path.name}: actor_id must be {actor}", errors)
        if template.get("resolution_px") != canvas:
            fail(f"{template_path.name}: resolution_px must match manifest canvas {canvas}", errors)
        if template.get("transparent") is not True:
            fail(f"{template_path.name}: transparent output must be enabled", errors)
        if int(template.get("frame_step", 0)) <= 0:
            fail(f"{template_path.name}: frame_step must be positive", errors)

        template_directions = template.get("directions", [])
        template_direction_names = [entry.get("name") for entry in template_directions if isinstance(entry, dict)]
        if template_direction_names != direction_names:
            fail(f"{template_path.name}: direction order differs from manifest", errors)
        if len(template_directions) == len(manifest_directions):
            for render_direction, runtime_direction in zip(template_directions, manifest_directions):
                if float(render_direction.get("yaw_deg", -999.0)) != float(runtime_direction.get("screen_angle_deg", -998.0)):
                    fail(
                        f"{template_path.name}: yaw for {render_direction.get('name')} must match manifest screen angle",
                        errors,
                    )

        animation_entries = template.get("animations", [])
        template_bases = [entry.get("base") for entry in animation_entries if isinstance(entry, dict)]
        expected_bases = manifest.get(f"{actor}_animation_bases", [])
        if template_bases != expected_bases:
            fail(f"{template_path.name}: animation bases differ from manifest", errors)
        for entry in animation_entries:
            if not isinstance(entry, dict) or not str(entry.get("action", "")).strip():
                fail(f"{template_path.name}: every animation base needs a Blender action name", errors)
                break

    if errors:
        for error in errors:
            print(f"[Rig2DToolingContract] FAIL {error}", file=sys.stderr)
        return 1

    print("[Rig2DToolingContract] PASS - manifest and Akio/Swordsman Blender templates agree on the 8-way 128x128 proof contract")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
