#!/usr/bin/env python3
"""Inspect binary glTF (.glb) structure without third-party Python dependencies.

This is intentionally small enough to run in GitHub Actions before Godot import. It
lets Oathbound distinguish a bad/stale source GLB from a Godot importer/runtime
problem when curated third-party assets do not expose the expected skeleton data.
"""

from __future__ import annotations

import argparse
import json
import pathlib
import struct
import sys
from typing import Any

GLB_MAGIC = 0x46546C67
JSON_CHUNK = 0x4E4F534A


def load_glb_json(path: pathlib.Path) -> dict[str, Any]:
    data = path.read_bytes()
    if len(data) < 20:
        raise ValueError("file is too small to be a GLB")
    magic, version, total_length = struct.unpack_from("<III", data, 0)
    if magic != GLB_MAGIC:
        raise ValueError(f"bad GLB magic 0x{magic:08x}")
    if version != 2:
        raise ValueError(f"unsupported GLB version {version}; expected 2")
    if total_length != len(data):
        raise ValueError(f"header length {total_length} does not match file length {len(data)}")

    offset = 12
    while offset + 8 <= len(data):
        chunk_length, chunk_type = struct.unpack_from("<II", data, offset)
        offset += 8
        chunk_end = offset + chunk_length
        if chunk_end > len(data):
            raise ValueError("GLB chunk extends beyond file length")
        if chunk_type == JSON_CHUNK:
            raw = data[offset:chunk_end].rstrip(b" \t\r\n\x00")
            return json.loads(raw.decode("utf-8"))
        offset = chunk_end
    raise ValueError("GLB contains no JSON chunk")


def named_nodes(document: dict[str, Any], indices: list[int]) -> list[str]:
    nodes = document.get("nodes", [])
    names: list[str] = []
    for index in indices:
        if 0 <= index < len(nodes):
            names.append(str(nodes[index].get("name") or f"node_{index}"))
        else:
            names.append(f"<invalid:{index}>")
    return names


def summarize(path: pathlib.Path, document: dict[str, Any]) -> dict[str, Any]:
    nodes = document.get("nodes", [])
    meshes = document.get("meshes", [])
    skins = document.get("skins", [])
    animations = document.get("animations", [])
    materials = document.get("materials", [])
    textures = document.get("textures", [])

    skin_summaries: list[dict[str, Any]] = []
    for index, skin in enumerate(skins):
        joints = list(skin.get("joints", []))
        skeleton_index = skin.get("skeleton")
        skeleton_name = None
        if isinstance(skeleton_index, int) and 0 <= skeleton_index < len(nodes):
            skeleton_name = nodes[skeleton_index].get("name")
        skin_summaries.append(
            {
                "index": index,
                "name": skin.get("name"),
                "joint_count": len(joints),
                "skeleton_index": skeleton_index,
                "skeleton_name": skeleton_name,
                "joint_names": named_nodes(document, joints),
            }
        )

    animation_summaries: list[dict[str, Any]] = []
    for index, animation in enumerate(animations):
        channels = animation.get("channels", [])
        targeted_nodes: list[int] = []
        targeted_paths: set[str] = set()
        for channel in channels:
            target = channel.get("target", {})
            node_index = target.get("node")
            if isinstance(node_index, int) and node_index not in targeted_nodes:
                targeted_nodes.append(node_index)
            target_path = target.get("path")
            if target_path:
                targeted_paths.add(str(target_path))
        animation_summaries.append(
            {
                "index": index,
                "name": animation.get("name") or f"<unnamed:{index}>",
                "channel_count": len(channels),
                "sampler_count": len(animation.get("samplers", [])),
                "targeted_node_count": len(targeted_nodes),
                "targeted_paths": sorted(targeted_paths),
                "targeted_node_preview": named_nodes(document, targeted_nodes[:12]),
            }
        )

    return {
        "path": str(path),
        "asset_generator": document.get("asset", {}).get("generator"),
        "scene_count": len(document.get("scenes", [])),
        "node_count": len(nodes),
        "mesh_count": len(meshes),
        "skin_count": len(skins),
        "material_count": len(materials),
        "texture_count": len(textures),
        "animation_count": len(animations),
        "node_name_preview": [str(node.get("name") or f"node_{i}") for i, node in enumerate(nodes[:24])],
        "skins": skin_summaries,
        "animations": animation_summaries,
    }


def validate(summary: dict[str, Any], min_joints: int, min_animations: int) -> list[str]:
    failures: list[str] = []
    joint_counts = [int(skin["joint_count"]) for skin in summary["skins"]]
    best_joint_count = max(joint_counts, default=0)
    if best_joint_count < min_joints:
        failures.append(f"largest skin has {best_joint_count} joints; expected at least {min_joints}")
    animation_count = int(summary["animation_count"])
    if animation_count < min_animations:
        failures.append(f"contains {animation_count} animations; expected at least {min_animations}")
    return failures


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("paths", nargs="+", type=pathlib.Path)
    parser.add_argument("--min-joints", type=int, default=0)
    parser.add_argument("--min-animations", type=int, default=0)
    parser.add_argument("--report", type=pathlib.Path)
    args = parser.parse_args()

    reports: list[dict[str, Any]] = []
    failures: list[str] = []
    for path in args.paths:
        try:
            document = load_glb_json(path)
            summary = summarize(path, document)
            reports.append(summary)
            file_failures = validate(summary, args.min_joints, args.min_animations)
            failures.extend(f"{path}: {message}" for message in file_failures)
            print(
                f"[GLBInspector] {path}: nodes={summary['node_count']} meshes={summary['mesh_count']} "
                f"skins={summary['skin_count']} animations={summary['animation_count']}"
            )
            for skin in summary["skins"]:
                preview = skin["joint_names"][:16]
                print(
                    f"[GLBInspector] skin#{skin['index']} name={skin['name']!r} "
                    f"joints={skin['joint_count']} skeleton={skin['skeleton_name']!r} preview={preview}"
                )
            for animation in summary["animations"][:24]:
                print(
                    f"[GLBInspector] animation#{animation['index']} name={animation['name']!r} "
                    f"channels={animation['channel_count']} targets={animation['targeted_node_count']} "
                    f"paths={animation['targeted_paths']}"
                )
        except Exception as exc:  # CI diagnostic: preserve all failures in one run.
            failures.append(f"{path}: {exc}")

    payload = {"files": reports, "failures": failures}
    if args.report:
        args.report.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    if failures:
        for failure in failures:
            print(f"[GLBInspector] FAIL: {failure}", file=sys.stderr)
        return 1
    print("[GLBInspector] PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
