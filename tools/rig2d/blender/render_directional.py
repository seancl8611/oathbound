#!/usr/bin/env python3
"""Blender background exporter for Oathbound's eight-direction rig-rendered 2D proof.

Run inside Blender:

    blender -b actor.blend -P tools/rig2d/blender/render_directional.py -- \
      --config tools/rig2d/blender/akio_export.template.json

The script is deliberately presentation-only. It never authors gameplay timing; it only
renders configured actions/directions into PNG sequences that follow the Godot naming
contract.
"""

from __future__ import annotations

import argparse
import json
import math
import sys
from pathlib import Path

try:
    import bpy  # type: ignore
except ImportError as exc:  # pragma: no cover - only importable inside Blender
    raise SystemExit("render_directional.py must be executed by Blender") from exc


REQUIRED_DIRECTIONS = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]


def _user_args() -> list[str]:
    if "--" not in sys.argv:
        return []
    return sys.argv[sys.argv.index("--") + 1 :]


def _load_config(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError("config root must be an object")
    return data


def _require_object(name: str, expected_type: str | None = None):
    obj = bpy.data.objects.get(name)
    if obj is None:
        raise ValueError(f"required Blender object not found: {name}")
    if expected_type is not None and obj.type != expected_type:
        raise ValueError(f"object '{name}' must be {expected_type}, got {obj.type}")
    return obj


def _require_action(name: str):
    action = bpy.data.actions.get(name)
    if action is None:
        raise ValueError(f"required Blender action not found: {name}")
    return action


def _direction_entries(config: dict) -> list[dict]:
    entries = config.get("directions", [])
    if not isinstance(entries, list):
        raise ValueError("directions must be an array")
    names = [str(entry.get("name", "")) for entry in entries if isinstance(entry, dict)]
    if names != REQUIRED_DIRECTIONS:
        raise ValueError(f"directions must be exactly {REQUIRED_DIRECTIONS}, got {names}")
    return entries


def _animation_entries(config: dict) -> list[dict]:
    entries = config.get("animations", [])
    if not isinstance(entries, list) or not entries:
        raise ValueError("animations must be a non-empty array")
    seen: set[str] = set()
    for entry in entries:
        if not isinstance(entry, dict):
            raise ValueError("each animation entry must be an object")
        base = str(entry.get("base", "")).strip()
        action = str(entry.get("action", "")).strip()
        if not base or not action:
            raise ValueError("each animation requires non-empty 'base' and 'action'")
        if base in seen:
            raise ValueError(f"duplicate animation base: {base}")
        seen.add(base)
    return entries


def _frame_range(action, entry: dict, default_step: int) -> list[int]:
    action_start = int(math.floor(float(action.frame_range[0])))
    action_end = int(math.ceil(float(action.frame_range[1])))
    start = int(entry.get("frame_start", action_start))
    end = int(entry.get("frame_end", action_end))
    step = max(1, int(entry.get("frame_step", default_step)))
    if end < start:
        raise ValueError(f"animation '{entry.get('base')}' has frame_end < frame_start")
    return list(range(start, end + 1, step))


def _resolve_output_dir(config_path: Path, config: dict) -> Path:
    raw = str(config.get("output_dir", "")).strip()
    if not raw:
        raise ValueError("output_dir is required")
    path = Path(raw)
    if not path.is_absolute():
        path = (config_path.parent / path).resolve()
    path.mkdir(parents=True, exist_ok=True)
    return path


def _configure_render(scene, config: dict) -> None:
    resolution = config.get("resolution_px", [128, 128])
    if not (isinstance(resolution, list) and len(resolution) == 2):
        raise ValueError("resolution_px must be [width, height]")
    width, height = int(resolution[0]), int(resolution[1])
    if width <= 0 or height <= 0:
        raise ValueError("resolution_px values must be positive")

    scene.render.resolution_x = width
    scene.render.resolution_y = height
    scene.render.resolution_percentage = 100
    scene.render.film_transparent = bool(config.get("transparent", True))
    scene.render.use_file_extension = True
    scene.render.image_settings.file_format = "PNG"
    scene.render.image_settings.color_mode = "RGBA"
    scene.render.image_settings.color_depth = "8"


class _RestoreState:
    def __init__(self, scene, armature, rotation_object):
        self.scene = scene
        self.armature = armature
        self.rotation_object = rotation_object
        self.camera = scene.camera
        self.frame = scene.frame_current
        self.resolution_x = scene.render.resolution_x
        self.resolution_y = scene.render.resolution_y
        self.resolution_percentage = scene.render.resolution_percentage
        self.film_transparent = scene.render.film_transparent
        self.file_format = scene.render.image_settings.file_format
        self.color_mode = scene.render.image_settings.color_mode
        self.color_depth = scene.render.image_settings.color_depth
        self.action = armature.animation_data.action if armature.animation_data else None
        self.rotation_mode = rotation_object.rotation_mode
        self.rotation_euler = rotation_object.rotation_euler.copy()

    def restore(self) -> None:
        self.scene.camera = self.camera
        self.scene.frame_set(self.frame)
        self.scene.render.resolution_x = self.resolution_x
        self.scene.render.resolution_y = self.resolution_y
        self.scene.render.resolution_percentage = self.resolution_percentage
        self.scene.render.film_transparent = self.film_transparent
        self.scene.render.image_settings.file_format = self.file_format
        self.scene.render.image_settings.color_mode = self.color_mode
        self.scene.render.image_settings.color_depth = self.color_depth
        self.rotation_object.rotation_mode = self.rotation_mode
        self.rotation_object.rotation_euler = self.rotation_euler
        if self.armature.animation_data is None:
            self.armature.animation_data_create()
        self.armature.animation_data.action = self.action


def export(config_path: Path) -> int:
    config = _load_config(config_path)
    actor_id = str(config.get("actor_id", "")).strip()
    if not actor_id:
        raise ValueError("actor_id is required")

    armature = _require_object(str(config.get("armature_object", "")), "ARMATURE")
    rotation_object = _require_object(str(config.get("rotation_object", "")))
    camera = _require_object(str(config.get("camera_object", "")), "CAMERA")
    directions = _direction_entries(config)
    animations = _animation_entries(config)
    output_dir = _resolve_output_dir(config_path, config)
    default_step = max(1, int(config.get("frame_step", 1)))

    scene = bpy.context.scene
    restore = _RestoreState(scene, armature, rotation_object)
    rendered = 0

    try:
        _configure_render(scene, config)
        scene.camera = camera
        rotation_object.rotation_mode = "XYZ"
        armature.animation_data_create()

        for animation in animations:
            base = str(animation["base"]).strip().lower()
            action = _require_action(str(animation["action"]).strip())
            armature.animation_data.action = action
            frames = _frame_range(action, animation, default_step)
            if not frames:
                raise ValueError(f"animation '{base}' resolved to no frames")

            for direction in directions:
                direction_name = str(direction["name"]).strip().lower()
                yaw_deg = float(direction.get("yaw_deg", 0.0))
                rotation_object.rotation_euler.z = math.radians(yaw_deg)

                for output_index, source_frame in enumerate(frames):
                    scene.frame_set(source_frame)
                    filename = f"{base}_{direction_name}_{output_index:03d}.png"
                    scene.render.filepath = str(output_dir / filename)
                    bpy.ops.render.render(write_still=True)
                    rendered += 1

        print(
            f"[Rig2DBlenderExporter] PASS actor={actor_id} "
            f"animations={len(animations) * len(directions)} frames={rendered} output={output_dir}"
        )
        return 0
    finally:
        restore.restore()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", type=Path, required=True)
    args = parser.parse_args(_user_args())

    try:
        return export(args.config.resolve())
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"[Rig2DBlenderExporter] FAIL {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
