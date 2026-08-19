#!/usr/bin/env python3
"""Audit Godot text scenes for broken or orphaned external resources.

This is intentionally conservative:
- missing path: the ext_resource path does not exist in the project tree;
- orphaned id: an ext_resource is declared but never referenced by ExtResource("id").

It does not automatically remove logically stale resources that are still referenced by an
old copied AnimationPlayer. Those require a scene-specific reconciliation because the script
may still depend on animation names/timing even when the old art should be removed.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

EXT_RE = re.compile(
    r'^\[ext_resource\s+[^\]]*path="(?P<path>res://[^"]+)"[^\]]*id="(?P<id>[^"]+)"[^\]]*\]$',
    re.MULTILINE,
)


def main() -> int:
    project_root = Path(__file__).resolve().parents[1]
    missing: list[tuple[Path, str, str]] = []
    orphaned: list[tuple[Path, str, str]] = []

    scenes = sorted(project_root.rglob("*.tscn"))
    for scene in scenes:
        text = scene.read_text(encoding="utf-8")
        for match in EXT_RE.finditer(text):
            resource_path = match.group("path")
            resource_id = match.group("id")
            local_path = project_root / resource_path.removeprefix("res://")

            if not local_path.exists():
                missing.append((scene, resource_id, resource_path))

            usage_count = text.count(f'ExtResource("{resource_id}")')
            if usage_count == 0:
                orphaned.append((scene, resource_id, resource_path))

    print(f"Audited {len(scenes)} .tscn files under {project_root}")

    if missing:
        print("\nMISSING EXTERNAL RESOURCES")
        for scene, resource_id, resource_path in missing:
            print(f"- {scene.relative_to(project_root)} :: {resource_id} -> {resource_path}")
    else:
        print("\nNo missing ext_resource paths found.")

    if orphaned:
        print("\nORPHANED EXT_RESOURCE DECLARATIONS")
        for scene, resource_id, resource_path in orphaned:
            print(f"- {scene.relative_to(project_root)} :: {resource_id} -> {resource_path}")
    else:
        print("\nNo orphaned ext_resource declarations found.")

    return 1 if missing else 0


if __name__ == "__main__":
    sys.exit(main())
