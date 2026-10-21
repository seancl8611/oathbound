"""
Akio Checkpoint B full directional runtime-frame exporter
Tested for the delivered Blender 5.2.x scene conventions.

What it does:
- Uses Hammer's active camera and CameraPivot.
- Preserves Hammer's camera angle and Orthographic Scale.
- Uses the verified direction mapping from the 8-view probe.
- Renders Idle, Run, and Quick Slash in all 8 directions.
- Follows Hammer's rule: render frame 0 through (last keyed frame - 1).
- Renders PNG RGBA at 512x512 for the temporary Godot playtest.
- Writes into the animation subfolders you created.
- Restores the Blender state it changes when finished.

Expected output structure:
akio_proof_a/
  runtime_frames/
    idle/
    move/
    attack_quick_slash/
"""

import bpy
import math
from pathlib import Path

PIVOT_NAME = "CameraPivot"
ARMATURE_NAME = "rig"
TEST_RESOLUTION = 512

# Verified from the uploaded direction probe.
# These are offsets from Hammer's delivered CameraPivot Z rotation.
DIRECTIONS = [
    ("e", 315.0),
    ("se", 0.0),
    ("s", 45.0),
    ("sw", 90.0),
    ("w", 135.0),
    ("nw", 180.0),
    ("n", 225.0),
    ("ne", 270.0),
]

# output folder name/base -> Hammer's Blender Action
ANIMATIONS = [
    ("idle", "idle"),
    ("move", "run"),
    ("attack_quick_slash", "quick_slash"),
]

scene = bpy.context.scene

pivot = bpy.data.objects.get(PIVOT_NAME)
if pivot is None:
    raise RuntimeError(f"Could not find Blender object '{PIVOT_NAME}'.")

armature = bpy.data.objects.get(ARMATURE_NAME)
if armature is None or armature.type != "ARMATURE":
    armatures = [obj.name for obj in bpy.data.objects if obj.type == "ARMATURE"]
    raise RuntimeError(
        f"Could not find ARMATURE '{ARMATURE_NAME}'. "
        f"Armatures found: {armatures}"
    )

if scene.camera is None:
    camera = bpy.data.objects.get("CameraIso")
    if camera is None or camera.type != "CAMERA":
        raise RuntimeError("No active scene camera and no CAMERA named 'CameraIso' found.")
    scene.camera = camera

for _, action_name in ANIMATIONS:
    if bpy.data.actions.get(action_name) is None:
        raise RuntimeError(f"Required Action '{action_name}' was not found.")

if armature.animation_data is None:
    armature.animation_data_create()

original = {
    "frame": scene.frame_current,
    "res_x": scene.render.resolution_x,
    "res_y": scene.render.resolution_y,
    "res_pct": scene.render.resolution_percentage,
    "film_transparent": scene.render.film_transparent,
    "file_format": scene.render.image_settings.file_format,
    "color_mode": scene.render.image_settings.color_mode,
    "color_depth": scene.render.image_settings.color_depth,
    "filepath": scene.render.filepath,
    "rotation_mode": pivot.rotation_mode,
    "rotation_euler": pivot.rotation_euler.copy(),
    "action": armature.animation_data.action,
}

blend_dir = Path(bpy.path.abspath("//"))
output_root = blend_dir / "akio_proof_a" / "runtime_frames"
output_root.mkdir(parents=True, exist_ok=True)

try:
    scene.render.resolution_x = TEST_RESOLUTION
    scene.render.resolution_y = TEST_RESOLUTION
    scene.render.resolution_percentage = 100
    scene.render.film_transparent = True
    scene.render.image_settings.file_format = "PNG"
    scene.render.image_settings.color_mode = "RGBA"
    scene.render.image_settings.color_depth = "8"

    pivot.rotation_mode = "XYZ"
    base_rotation = original["rotation_euler"].copy()
    base_z = base_rotation.z

    rendered = 0

    print(f"[AkioExport] Camera: {scene.camera.name}")
    print(f"[AkioExport] Pivot: {pivot.name}")
    print(f"[AkioExport] Armature: {armature.name}")
    print(f"[AkioExport] Resolution: {TEST_RESOLUTION}x{TEST_RESOLUTION}")
    print(f"[AkioExport] Output root: {output_root}")

    for output_base, action_name in ANIMATIONS:
        action = bpy.data.actions[action_name]
        armature.animation_data.action = action

        # Hammer's instruction:
        # render from frame 0 through last keyframe - 1.
        last_keyframe = int(round(float(action.frame_range[1])))
        frames = list(range(0, max(0, last_keyframe)))

        if not frames:
            raise RuntimeError(
                f"Action '{action_name}' produced no renderable frames. "
                f"Action frame range is {tuple(action.frame_range)}"
            )

        animation_dir = output_root / output_base
        animation_dir.mkdir(parents=True, exist_ok=True)

        print(
            f"[AkioExport] {output_base}: action='{action_name}', "
            f"source frames 0-{last_keyframe - 1} "
            f"({len(frames)} frames/direction)"
        )

        for direction_name, offset_deg in DIRECTIONS:
            pivot.rotation_euler.x = base_rotation.x
            pivot.rotation_euler.y = base_rotation.y
            pivot.rotation_euler.z = base_z + math.radians(offset_deg)

            for output_index, source_frame in enumerate(frames):
                scene.frame_set(source_frame)
                filename = f"{output_base}_{direction_name}_{output_index:03d}.png"
                scene.render.filepath = str(animation_dir / filename)
                bpy.ops.render.render(write_still=True)
                rendered += 1

            print(
                f"[AkioExport] Finished {output_base}_{direction_name}: "
                f"{len(frames)} PNGs"
            )

    print(f"[AkioExport] PASS - rendered {rendered} PNGs total.")
    print(f"[AkioExport] Files are in: {output_root}")

finally:
    scene.frame_set(original["frame"])
    scene.render.resolution_x = original["res_x"]
    scene.render.resolution_y = original["res_y"]
    scene.render.resolution_percentage = original["res_pct"]
    scene.render.film_transparent = original["film_transparent"]
    scene.render.image_settings.file_format = original["file_format"]
    scene.render.image_settings.color_mode = original["color_mode"]
    scene.render.image_settings.color_depth = original["color_depth"]
    scene.render.filepath = original["filepath"]

    pivot.rotation_mode = original["rotation_mode"]
    pivot.rotation_euler = original["rotation_euler"]

    armature.animation_data.action = original["action"]
