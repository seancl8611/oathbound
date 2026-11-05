#!/usr/bin/env python3
"""Fetch immutable third-party Lua snapshots for PERSONAL RESEARCH, not redistribution.

Run from any directory:
    python docs/references/hades_ai/fetch_reference_sources.py --list
    python docs/references/hades_ai/fetch_reference_sources.py --game hades_2
    python docs/references/hades_ai/fetch_reference_sources.py --all
    python docs/references/hades_ai/fetch_reference_sources.py --verify

Only the original analysis, manifest and this helper are committed. The
downloaded proprietary scripts remain in the git-ignored .local folder.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import sys
import urllib.request
from urllib.error import URLError

ROOT = pathlib.Path(__file__).resolve().parent
MANIFEST = ROOT / "source_manifest.json"
CACHE = ROOT / ".local"


def git_blob_sha(content: bytes) -> str:
    return hashlib.sha1(b"blob " + str(len(content)).encode("ascii") + b"\\0" + content).hexdigest()


def sources():
    data = json.loads(MANIFEST.read_text(encoding="utf-8"))
    for game in data["games"]:
        for entry in game["files"]:
            yield game["id"], entry


def target_for(game: str, entry: dict) -> pathlib.Path:
    relative = pathlib.PurePosixPath(entry["path"])
    if relative.is_absolute() or ".." in relative.parts:
        raise ValueError(f"Unsafe manifest path: {entry['path']}")
    return CACHE / game / pathlib.Path(*relative.parts)


def check_file(path: pathlib.Path, entry: dict) -> bool:
    return path.is_file() and git_blob_sha(path.read_bytes()) == entry["git_blob_sha1"]


def fetch_one(game: str, entry: dict, force: bool) -> bool:
    path = target_for(game, entry)
    if not force and check_file(path, entry):
        print(f"[verified] {game}/{entry['path']}")
        return True
    url = entry["url"]
    if not url.startswith("https://raw.githubusercontent.com/"):
        raise ValueError(f"Refusing unknown source host: {url}")
    req = urllib.request.Request(url, headers={"User-Agent": "Oathbound-research-reference-fetcher/1.0"})
    with urllib.request.urlopen(req, timeout=40) as response:
        content = response.read()
    actual = git_blob_sha(content)
    expected = entry["git_blob_sha1"]
    if actual != expected:
        print(f"[FAILED HASH] {game}/{entry['path']}: {actual} != {expected}", file=sys.stderr)
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(content)
    print(f"[saved] {game}/{entry['path']} ({len(content)} bytes)")
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--list", action="store_true", help="List pinned sources without downloading")
    group.add_argument("--all", action="store_true", help="Download both games")
    group.add_argument("--game", choices=["hades_1", "hades_2"], help="Download one game")
    group.add_argument("--verify", action="store_true", help="Verify local source hashes without networking")
    parser.add_argument("--force", action="store_true", help="Refetch existing verified files")
    args = parser.parse_args()
    failed = 0
    for game, entry in sources():
        if args.list:
            print(f"{game:8} {entry['path']:38} {entry['git_blob_sha1']}")
            continue
        path = target_for(game, entry)
        if args.verify:
            good = check_file(path, entry)
            print(("[verified] " if good else "[MISSING/MISMATCH] ") + f"{game}/{entry['path']}")
            failed += not good
            continue
        if args.game and game != args.game:
            continue
        try:
            failed += not fetch_one(game, entry, args.force)
        except (OSError, URLError, ValueError) as exc:
            failed += 1
            print(f"[ERROR] {game}/{entry['path']}: {exc}", file=sys.stderr)
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
